//
//  JobsInfoStore.swift
//  Jobs
//
//  Created by prafull kumar on 1/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import Foundation
import Combine
import UIKit
import CoreData
struct RequestModel: APIRequestModel {
    var parameters: [String : String] {
        return ["pagesize": String(pageSize), "page": String(page)]
    }
    
    let page: Int
    let pageSize: Int
    
}

typealias JobsInformationResult = Result<[Job]>
typealias JobsInformationResultCompletion = (JobsInformationResult) -> Void
typealias DataBaseResultCompletion = JobsInformationResultCompletion

final class JobsInfoStore {
    
    let coreDataStack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack
    let networking: Networking
    let defaultPageSize = 20
    var currentPage = 1
    var sub : AnyCancellable?
    
    init(networking: Networking) { // to allow XCTest, making most of the variable injectable
        self.networking = networking
    }
    
    func fetchlatestData(isForceFetch: Bool, completion: @escaping JobsInformationResultCompletion) {
        if isForceFetch {
            self.fetchDataFromNetwork(page: 1, pageSize: defaultPageSize, resultCompletion: completion)
        } else {
            fetchDataFromDataBase(page: currentPage, pageSize: defaultPageSize) { [weak self] (result) in
                 guard let self = self else { return } //if store not avaialable MVVM is out of scop i.e. controller removed
                 switch result {
                 case .success(let data):
                    if data.count != 0 {
                        completion(.success(data)) //read cache success
                    }
                    self.fetchDataFromNetwork(page: 1, pageSize: self.defaultPageSize, resultCompletion: completion) //get latest data and update is hasChange
                 case .failure:
                     //log error if needed
                     self.fetchDataFromNetwork(page: 1,
                                               pageSize: self.defaultPageSize,
                                               resultCompletion: completion)
                 }
            }
        }
    }
    
    
    func fetchNextPage(completion: @escaping JobsInformationResultCompletion) {
        currentPage += 1
        
        fetchDataFromDataBase(page: currentPage, pageSize: defaultPageSize) { [weak self] (result) in
            guard let self = self else { return } //if store not avaialable MVVM is out of scop i.e. controller removed
            switch result {
            case .success(let data):
                if data.count != 0 {
                    completion(.success(data)) //read cache success
                } else {
                    self.fetchNextPageFromNetwork(completion: completion)
                }
            case .failure:
                //log error if needed
                self.fetchNextPageFromNetwork(completion: completion)
            }
        }
     }
        
     private func fetchNextPageFromNetwork(completion: @escaping JobsInformationResultCompletion) {
            self.fetchDataFromNetwork(page: self.currentPage, pageSize: self.defaultPageSize) { [weak self] (result) in
                guard let self = self else { return } //if store not avaialable MVVM is out of scop i.e. controller removed
                switch result {
                case .success(let data):
                    if data.count == 0 { //data filtered out from cache fetch more data
                        self.currentPage += 1
                        self.fetchNextPageFromNetwork(completion: completion)
                    } else {
                        completion(.success(data)) //read cache success
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
      }
        
    
    private func fetchDataFromDataBase(page: Int, pageSize: Int, completion: @escaping DataBaseResultCompletion) {
        guard let stack = coreDataStack else {
            completion(.failure(APIError.apiError(reason: "coreDataStack == NULL")))
            return
        }
        
        
        stack.backgroundContext.perform {
            var result: [Job] = []
            do {
              result = try stack.backgroundContext.fetch(self.getFetchRequest(page: page, pageSize: pageSize, stack: stack))
              DispatchQueue.main.async {
                  completion(.success(result))
              }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    completion(.failure(APIError.apiError(reason: error.localizedDescription)))
                }
            }
        }
    }
    
    private func getFetchRequest(page: Int, pageSize: Int, stack: CoreDataStack) -> NSFetchRequest<Job> {
        let fetchRequest: NSFetchRequest<Job> = Job.fetchRequest()
        let offset = (page - 1) * pageSize
        fetchRequest.fetchBatchSize = pageSize
        fetchRequest.fetchOffset = offset
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Job.changed), ascending: false)]
        return fetchRequest
    }
    
    private func fetchDataFromNetwork(page: Int, pageSize: Int, resultCompletion: @escaping JobsInformationResultCompletion) {
        do {
              sub = try networking.fetch(api: JobsAPI.detail(request: RequestModel(page: page, pageSize: pageSize)).api)
                  .sink(receiveCompletion: { completion in
                      switch completion {
                      case .finished:
                          break
                      case .failure(let error):
                          resultCompletion(Result.failure(APIError.apiError(reason: error.localizedDescription)))
                      }
              }, receiveValue: { [weak self] data in
                guard let self = self else { return }
                if let baseModel = try? JSONDecoder().decode(BaseModel.self, from: data)  {
                    resultCompletion(.success(self.getDataModel(data: baseModel)))
                } else {
                    resultCompletion(Result.failure(APIError.apiError(reason: "Parsing Error")))
                }
              })
       } catch  {
          resultCompletion(Result.failure(APIError.apiError(reason: error.localizedDescription)))
       }
        
    }
    
    private func getDataModel(data: BaseModel) ->  [Job] {
        guard let stack = coreDataStack else {
            fatalError("coreDataStack should not be nil")
        }
        
        var objectArray: [Job] = []
        for item in data.results ?? [] {
            if  let uuid = item.uuid, !entityExists(stack: stack, uuid: uuid) {
                objectArray.append(createNewEntry(stack: stack ,item: item))
            }
        }
        
        if objectArray.count != 0 {
            stack.saveContext()
            objectArray.sort { (item1, item2) -> Bool in
                return item1.changed > item2.changed
            }
        }
        
        return objectArray
    }
    
    private func createNewEntry(stack: CoreDataStack, item: BaseModel.Results) -> Job {
        let newJob = Job(context: stack.mainContext)
        newJob.about = item.aboutOffice
        newJob.title = item.title?.trimmingCharacters(in: .whitespacesAndNewlines)
        newJob.salary = item.salary
        newJob.qualifications = item.qualifications
        newJob.detailURL = item.url
        newJob.location = item.location?.locationString
        newJob.created = Double(item.created ?? "0") ?? 0
        newJob.changed = Double(item.changed ?? "0") ?? 0
        newJob.process = item.applicationProcess
        newJob.details = item.body
        newJob.hiringOffice = item.hiringOffice
        newJob.uuid = item.uuid
        newJob.positions = Int64(item.numPositions ?? "0") ?? 0
        return newJob
    }
    
    
    private func entityExists(stack: CoreDataStack, uuid: String) -> Bool {
        let fetchRequest: NSFetchRequest<Job> = Job.fetchRequest()
        let entityDesc = NSEntityDescription.entity(forEntityName: "Job", in: stack.mainContext)
        fetchRequest.fetchLimit =  1
        fetchRequest.entity = entityDesc
        fetchRequest.predicate = NSPredicate(format: "uuid == %@" ,uuid)
        do {
            let count = try stack.mainContext.count(for: fetchRequest)
            return count > 0
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
            
    }
}


