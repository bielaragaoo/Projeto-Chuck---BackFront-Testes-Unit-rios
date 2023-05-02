//
//  HomeServiceTests.swift
//  ChuckTests
//
//  Created by Gabriel Aragao on 27/04/23.
//

import XCTest
import OHHTTPStubs
@testable import Chuck

final class HomeServiceTests: XCTestCase {

    var homeService: HomeService!

    override func setUpWithError() throws {
        homeService = HomeService()
    }

    override func tearDownWithError() throws {
        homeService = nil
    }

    func testGetHomeSuccess() {
        let expectation = self.expectation(description: "fetch categories")
        homeService.getHome { result in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success, "Success não pode ser nil!!")
                XCTAssertGreaterThan(success.count, 0, "A categoria deveria ser igual ou maior que zero")
                expectation.fulfill()
            case .failure:
                XCTFail("A request não pode cair no caso de failure")
            }
        }
        waitForExpectations(timeout: 10)
    }

    func testGetHomeFailure() {

        let expectation = self.expectation(description: "fetch categories")
        HTTPStubs.stubRequests { request in
            request.url?.absoluteString.contains("https://api.chucknorris.io/jokes/categories") ?? false
        } withStubResponse: { _ in
            return HTTPStubsResponse(error: NSError(domain: "com.test.error", code: 404))
        }

        homeService.getHome { result in
            switch result {
            case .success:
                XCTFail("A request não pode cair no caso de failure")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()

            }
        }
        waitForExpectations(timeout: 10)
        HTTPStubs.removeAllStubs()
    }
}

