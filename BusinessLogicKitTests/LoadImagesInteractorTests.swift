//
//  Created by Constantine Fry on 12.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//
import Foundation

import XCTest
@testable import BusinessLogicKit

class LoadImagesInteractorTests: XCTestCase {

    private var repository: MockImagesRepository!
    private var decoder: MockImageDecoder!

    private let photo1 = Photo(identifier: "1", url: URL(string: "https://uber.com")!, title: "ola")

    override func setUp() {
        self.repository = MockImagesRepository()
        self.decoder = MockImageDecoder()
    }

    func testThatRepositoryAndDecoderAreCalled() {
        let interactor = LoadImagesInteractor(repository: self.repository!,
                                               decoder: self.decoder!,
                                               cacheLimit: 1 * 1024*1024)
        let expectation = XCTestExpectation()
        interactor.loadImage(for: self.photo1) { (image) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        XCTAssert(self.repository.tasks.first!.didResume)
        XCTAssert(self.decoder.decodeCount == 1)
    }

    func testThatImageIsCached() {
        let interactor = LoadImagesInteractor(repository: self.repository!,
                                               decoder: self.decoder!,
                                               cacheLimit: 1 * 1024*1024)
        let expectation = XCTestExpectation()
        interactor.loadImage(for: self.photo1) { (image) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        XCTAssert(interactor.cachedImage(for: self.photo1) != nil)
    }

    func testThatImageIsNotPutInCachIfItExceedsTheLimit() {
        let interactor = LoadImagesInteractor(repository: self.repository!,
                                              decoder: self.decoder!,
                                              cacheLimit: 1)
        let expectation = XCTestExpectation()
        interactor.loadImage(for: self.photo1) { (image) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        XCTAssert(interactor.cachedImage(for: self.photo1) == nil)
    }

    func testThatCallingLoadMultipleTimesWillCreateOnlyOneTask() {
        let interactor = LoadImagesInteractor(repository: self.repository!,
                                              decoder: self.decoder!,
                                              cacheLimit: 1 * 1024*1024)
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        interactor.loadImage(for: self.photo1) { (image) in
            expectation1.fulfill()
        }
        interactor.loadImage(for: self.photo1) { (image) in
            expectation2.fulfill()
        }
        wait(for: [expectation1, expectation2], timeout: 2.0)
        XCTAssert(self.repository.tasks.count == 1)
        XCTAssert(self.decoder.decodeCount == 1)
    }

    func testCancellingTask() {
        let interactor = LoadImagesInteractor(repository: self.repository!,
                                              decoder: self.decoder!,
                                              cacheLimit: 1 * 1024*1024)
        let expectation1 = XCTestExpectation()
        interactor.loadImage(for: self.photo1) { (image) in
            XCTAssert(false)
        }
        interactor.stopLoadImage(for: self.photo1)
        interactor.loadImage(for: self.photo1) { (image) in
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 2.0)
        XCTAssert(self.repository.tasks.count == 2)
        XCTAssert(self.decoder.decodeCount == 1)
    }

}
