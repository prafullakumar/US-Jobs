//
//  CoreDataStack.swift
//  Jobs
//
//  Created by prafull kumar on 2/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    // MARK: Properties
    private let modelName: String
    lazy var backgroundContext = self.storeContainer.newBackgroundContext()
    lazy var mainContext: NSManagedObjectContext = {
      return self.storeContainer.viewContext
    }()
    
    lazy var storeContainer: NSPersistentContainer = {

      let container = NSPersistentContainer(name: self.modelName)
      container.loadPersistentStores { (storeDescription, error) in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      }
      return container
    }()
    
    // MARK: Initializers
    init(modelName: String) {
      self.modelName = modelName
    }
}

// MARK: Internal
extension CoreDataStack {

  func saveContext () {
    guard mainContext.hasChanges else { return }

    do {
      try mainContext.save()
    } catch let nserror as NSError {
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}


