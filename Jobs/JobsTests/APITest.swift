//
//  APITest.swift
//  JobsTests
//
//  Created by prafull kumar on 2/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import XCTest
import Combine
@testable import Jobs

class APITest: XCTestCase {
    var sub : AnyCancellable?
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAPISuccess() {
        let networking = Networking()
        let expectation1 = self.expectation(description: "Api should pass")
        do {
                 sub = try networking.fetch(api: JobsAPI.detail(request: RequestModel(page: 1, pageSize: 1)).api)
                      .sink(receiveCompletion: { completion in
                          switch completion {
                          case .finished:
                              XCTAssert(true)
                          case .failure:
                              XCTAssert(false)
                          }
                          expectation1.fulfill()
                  }, receiveValue: {  _ in
                    // dsn matter
                  })
                  print(sub)
           } catch  {
              XCTAssert(false)
           }
           waitForExpectations(timeout: 60, handler: nil)
        
    }
    
    func testAPIFail() {
        let networking = Networking()
        let expectation1 = self.expectation(description: "Api should fail")
        do {
              sub = try networking.fetch(api: JobsAPI.detail(request: RequestModel(page: 1000, pageSize: 1000)).api)
                   .sink(receiveCompletion: { completion in
                       switch completion {
                       case .finished:
                           XCTAssert(false)
                       case .failure:
                           XCTAssert(true)
                       }
                       expectation1.fulfill()
               }, receiveValue: {  _ in
                 // dsn matter
               })
        } catch  {
           XCTAssert(false)
        }
        waitForExpectations(timeout: 60, handler: nil)
        
    }

}
