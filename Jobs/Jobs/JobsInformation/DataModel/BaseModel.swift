//
//
//  Jobs
//
//  Created by prafull kumar on 1/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//


import Foundation
struct BaseModel : Codable {
	let metadata : Metadata?
	let results : [Results]?

	enum CodingKeys: String, CodingKey {

		case metadata = "metadata"
		case results = "results"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		metadata = try values.decodeIfPresent(Metadata.self, forKey: .metadata)
		results = try values.decodeIfPresent([Results].self, forKey: .results)
	}

    struct Results : Codable {
        let aboutOffice : String?
        let applicationProcess : String?
        let body : String?
        let changed : String?
        let created : String?
        let deadline : String?
        let hiringOffice : String?
        let hiringOrg : HiringOrg?
        let jobId : String?
        let language : String?
        let location : Location?
        let numPositions : String?
        let position : String?
        let practiceArea : String?
        let qualifications : String?
        let relocationExpenses : String?
        let salary : String?
        let title : String?
        let travel : String?
        let url : String?
        let uuid : String?
        let vuuid : String?

        enum CodingKeys: String, CodingKey {

            case aboutOffice = "about_office"
            case applicationProcess = "application_process"
            case body = "body"
            case changed = "changed"
            case created = "created"
            case deadline = "deadline"
            case hiringOffice = "hiring_office"
            case hiringOrg = "hiring_org"
            case jobId = "job_id"
            case language = "language"
            case location = "location"
            case numPositions = "num_positions"
            case position = "position"
            case practiceArea = "practice_area"
            case qualifications = "qualifications"
            case relocationExpenses = "relocation_expenses"
            case salary = "salary"
            case title = "title"
            case travel = "travel"
            case url = "url"
            case uuid = "uuid"
            case vuuid = "vuuid"
        }
        

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            aboutOffice = try? values.decodeIfPresent(String.self, forKey: .aboutOffice)
            applicationProcess = try? values.decodeIfPresent(String.self, forKey: .applicationProcess)
            body = try? values.decodeIfPresent(String.self, forKey: .body)
            changed = try? values.decodeIfPresent(String.self, forKey: .changed)
            created = try? values.decodeIfPresent(String.self, forKey: .created)
            deadline = try? values.decodeIfPresent(String.self, forKey: .deadline)
            hiringOffice = try? values.decodeIfPresent(String.self, forKey: .hiringOffice)
            hiringOrg = try? values.decodeIfPresent(HiringOrg.self, forKey: .hiringOrg)
            jobId = try? values.decodeIfPresent(String.self, forKey: .jobId)
            language = try? values.decodeIfPresent(String.self, forKey: .language)
            location = try? values.decodeIfPresent(Location.self, forKey: .location)
            numPositions = try? values.decodeIfPresent(String.self, forKey: .numPositions)
            position = try? values.decodeIfPresent(String.self, forKey: .position)
            practiceArea = try? values.decodeIfPresent(String.self, forKey: .practiceArea)
            qualifications = try? values.decodeIfPresent(String.self, forKey: .qualifications)
            relocationExpenses = try? values.decodeIfPresent(String.self, forKey: .relocationExpenses)
            salary = try? values.decodeIfPresent(String.self, forKey: .salary)
            title = try? values.decodeIfPresent(String.self, forKey: .title)
            travel = try? values.decodeIfPresent(String.self, forKey: .travel)
            url = try? values.decodeIfPresent(String.self, forKey: .url)
            uuid = try? values.decodeIfPresent(String.self, forKey: .uuid)
            vuuid = try? values.decodeIfPresent(String.self, forKey: .vuuid)
        }

    }
    
    struct Resultset : Codable {
        let count : Int?
        let pagesize : Int?
        let page : Int?

        enum CodingKeys: String, CodingKey {

            case count = "count"
            case pagesize = "pagesize"
            case page = "page"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            count = try values.decodeIfPresent(Int.self, forKey: .count)
            pagesize = try values.decodeIfPresent(Int.self, forKey: .pagesize)
            page = try values.decodeIfPresent(Int.self, forKey: .page)
        }
        

    }
    
    struct ResponseInfo : Codable {
        let status : Int?
        let developerMessage : String?

        enum CodingKeys: String, CodingKey {

            case status = "status"
            case developerMessage = "developerMessage"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            status = try values.decodeIfPresent(Int.self, forKey: .status)
            developerMessage = try values.decodeIfPresent(String.self, forKey: .developerMessage)
        }

    }
    
    struct Metadata : Codable {
        let responseInfo : ResponseInfo?
        let resultset : Resultset?
        let executionTime : Double?

        enum CodingKeys: String, CodingKey {

            case responseInfo = "responseInfo"
            case resultset = "resultset"
            case executionTime = "executionTime"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            responseInfo = try values.decodeIfPresent(ResponseInfo.self, forKey: .responseInfo)
            resultset = try values.decodeIfPresent(Resultset.self, forKey: .resultset)
            executionTime = try values.decodeIfPresent(Double.self, forKey: .executionTime)
        }

    }

    struct Location : Codable {
        let country : String?
        let administrativeArea : String?
        let locality : String?
        let postalCode : String?
        let thoroughfare : String?
        let subPremise : String?
        let phoneNumber : String?
        let phoneNumberExtension : String?
        let mobileNumber : String?
        let faxNumber : String?

        enum CodingKeys: String, CodingKey {
            case country = "country"
            case administrativeArea = "administrative_area"
            case locality = "locality"
            case postalCode = "postal_code"
            case thoroughfare = "thoroughfare"
            case subPremise = "sub_premise"
            case phoneNumber = "phone_number"
            case phoneNumberExtension = "phone_number_extension"
            case mobileNumber = "mobile_number"
            case faxNumber = "fax_number"
        }

        var locationString: String  {
            var addressArray: [String] = []
            if let locality = locality {
                addressArray.append(locality)
            }
            if let area = administrativeArea {
                addressArray.append(area)
            }
            if let subPremise = subPremise {
                addressArray.append(subPremise)
            }
            if let thoroughfare = thoroughfare {
                addressArray.append(thoroughfare)
            }
            if let country = country {
                addressArray.append(country)
            }
            if let postalCode = postalCode {
                addressArray.append(postalCode)
            }
            
            return addressArray.joined(separator: ", ")
        }
    }

    struct HiringOrg : Codable {
        let uuid : String?
        let name : String?

        enum CodingKeys: String, CodingKey {

            case uuid = "uuid"
            case name = "name"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
            name = try values.decodeIfPresent(String.self, forKey: .name)
        }

    }
}
