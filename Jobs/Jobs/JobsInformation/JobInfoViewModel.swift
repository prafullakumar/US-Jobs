//
//  JobInfoViewModel.swift
//  Jobs
//
//  Created by prafull kumar on 1/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import Foundation

enum ViewModelState {
    case loading
    case loadSuccess
    case loadFail(APIError)
    case unknown
}

//Can use combine here also, this is just to demonstrate Protocol delegates use case
protocol  JobsViewControllerUpdateDelegate: class {
    func viewModel(didUpdateState state: ViewModelState)
}


struct CellViewModel {
    let job: String
    let salary: String
}

final class JobsInfoViewModel {
    var state: ViewModelState = .unknown {
        didSet {
            self.delegate?.viewModel(didUpdateState: state)
        }
    }
    private let store = JobsInfoStore(networking: Networking.shared)
    weak var delegate: JobsViewControllerUpdateDelegate?
    var dataModel: [Job] = []
    
    var cellCount: Int {
        return dataModel.count
    }
    
    var hasData: Bool {
        return !(dataModel.count == 0)
    }

    func cellViewModel(row: Int) -> CellViewModel {
        let object = dataModel[row]
        return CellViewModel(job: object.title ?? "", salary: object.salary ?? "")
    }
    
    func jobDataObject(row: Int) -> Job {
        return dataModel[row]
    }
    
    func refreshData(isForceFetch: Bool) {
        state = .loading
        store.fetchlatestData(isForceFetch: isForceFetch) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.dataModel.insert(contentsOf: data, at: 0)
                self.state = .loadSuccess
            case .failure(let error):
                self.state = .loadFail(error)
            }
        }
    }
    
    func fetchPagination() {
        switch state {
        case .loading:
            return
        default:
            state = .loading
            store.fetchNextPage { (result) in
                switch result {
                case .success(let data):
                    self.dataModel.append(contentsOf: data)
                    self.state = .loadSuccess
                case .failure(let error):
                    self.state = .loadFail(error)
                }
            }
        }
    }
    
    
}
