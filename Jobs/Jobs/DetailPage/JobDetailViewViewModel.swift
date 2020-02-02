//
//  JobDetailViewViewModel.swift
//  Jobs
//
//  Created by prafull kumar on 2/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import UIKit

class JobDetailViewViewModel {
    private let jobDetail: Job
    
    init(jobDetail: Job) {
        self.jobDetail = jobDetail
    }
    
    var title: String {
        return jobDetail.title ?? "NA"
    }
    
    var salary: String {
        return jobDetail.salary ?? "NA"
    }
    
    var qualifications: String {
        return jobDetail.qualifications ?? "NA"
    }
    
    var address: String {
        return jobDetail.location ?? "NA"
    }
    
    var about: String {
        return jobDetail.about ?? "NA"
    }
    
    var process: String {
        return jobDetail.process ?? "NA"
    }
    
    var detail: String {
        return jobDetail.details ?? "NA"
    }
    
    var officeName: String {
        return jobDetail.hiringOffice ?? "NA"
    }
    
    var numberOfVac: String {
        return String(jobDetail.positions)
    }
    
    var pageURL: String? {
        return jobDetail.detailURL
    }
}
