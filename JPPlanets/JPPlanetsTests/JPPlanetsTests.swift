//
//  JPPlanetsTests.swift
//  JPPlanetsTests
//
//  Created by Sanjay Chauhan on 27/04/2021.
//

import XCTest
@testable import JPPlanets

class JPPlanetsTests: XCTestCase, PayLoadFormat {

    var router: TestPlanetsRouter!
    var service: APIManagerProtocol!
    var view: PlanetsViewProtocol!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        router = TestPlanetsRouter()
        service = APIManager()
        view = PlanetsViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        router = nil
        service = nil
        view = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    /**
     Test case to check if the Module gas been added and the view has been configured to show
     */
    func testThatItShowsPlanetsViewScreen() {
           router.assembleModule(view: view)
           XCTAssertTrue(router.showPlanetsViewCalled)
       }
    
    /**
        Test case to check API response
     */
    func testFetchPlanets() {
        let payload = formatGetPayload(url: .planetsUrl, type: .requestMethodGET)
        let expect = expectation(description: "API response completion")
        service.getPlanetsInfo(payload: payload){ result in
            expect.fulfill()
            switch result {
            case .success(let data):
                XCTAssertTrue( data.results!.count > 0, "Contacts Data should not be empty" );
            case .failure(_):
                XCTFail()
            }
        }
        waitForExpectations(timeout: 7, handler: nil)
    }
    
}


extension JPPlanetsTests {
    class TestPlanetsRouter: PlanetsRouterProtocol {
        var showPlanetsViewCalled = false
        func assembleModule(view: PlanetsViewProtocol) {
            self.showPlanetsViewCalled = true
        }
    }
}
