//
//  ViewModelTests.swift
//  ChuckTests
//
//  Created by Gabriel Aragao on 02/05/23.
//

import XCTest
@testable import Chuck

final class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!
    var mockService: MockHomeService!

    override func setUpWithError() throws {
        mockService =  MockHomeService()
        viewModel = HomeViewModel(service: mockService)
    }

    override func tearDownWithError() throws {
        mockService = nil
        viewModel = nil
    }

    func testFetchRequestSuccess() throws {

        let list: [String] = ["category1, category2"]
        mockService?.result = .success(list)

        viewModel?.fetchRequest()

        XCTAssertEqual(viewModel?.numberOfRowsInSection, list.count)
        XCTAssertEqual(viewModel?.loadCurrentCategory(indexPath: IndexPath(row: 0, section: 0)), list[0])
    }

    func testFetchRequestFailure() throws {

        mockService.result = .failure(NSError(domain: "com.test.error", code: 0))
        viewModel?.fetchRequest()

        XCTAssertEqual(viewModel?.numberOfRowsInSection, 0)
    }
}

class MockHomeViewModelDelegate: HomeViewModelProtocol {

    var successCalled = false
    var errorCalled = false

    func success() {
        successCalled = true
    }

    func error(message: String) {
        errorCalled = true
    }
}

class MockHomeService: HomeServiceDelegate {
    var result: Result<[String], Error> = .success([])
    func getHome(completion: @escaping (Result<[String], Error>) -> Void) {
        completion(result)
    }

}
