//
//  Job+CoreDataProperties.swift
//  Jobs
//
//  Created by prafull kumar on 1/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//
//

import Foundation
import CoreData


extension Job {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Job> {
        return NSFetchRequest<Job>(entityName: "Job")
    }

    @NSManaged public var title: String?
    @NSManaged public var salary: String?
    @NSManaged public var detailURL: String?
    @NSManaged public var qualifications: String?
    @NSManaged public var location: String?
    @NSManaged public var created: Double
    @NSManaged public var changed: Double
    @NSManaged public var about: String?
    @NSManaged public var process: String?
    @NSManaged public var details: String?
    @NSManaged public var hiringOffice: String?
    @NSManaged public var uuid: String?
    @NSManaged public var positions: Int64

}
