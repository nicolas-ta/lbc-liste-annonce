//
//  AdsViewModelTest.swift
//  TestLBCTests
//
//  Created by Nicolas Ta on 05/05/2021.
//

import XCTest

@testable import TestLBC

class AdsViewModelTest: XCTestCase {
	var mockData: Advertisements!

	func testInitAdvertisement() {
		let adv = Advertisement(
			id: 0,
			categoryID: 0,
			title: "Test0",
			advertisementDescription: "Test 0 0",
			price: 120,
			imagesURL: ImagesURL(small: nil, thumb: nil),
			creationDate: "2019-10-16T17:10:20+0000",
			isUrgent: false, siret: nil)

		XCTAssertEqual(0, adv.id)
		XCTAssertEqual(0, adv.categoryID)
		XCTAssertEqual("Test0", adv.title)
		XCTAssertEqual(120, adv.price)
		XCTAssertEqual(nil, adv.imagesURL.small)
		XCTAssertEqual(nil, adv.imagesURL.thumb)
		XCTAssertEqual("Test 0 0", adv.advertisementDescription)
		XCTAssertEqual("2019-10-16T17:10:20+0000", adv.creationDate)
		XCTAssertEqual(false, adv.isUrgent)
		XCTAssertEqual(nil, adv.siret)
	}

	func testSortAdvertisement() {
		let vm = AdvertisementViewModel()
		let sortedAd = vm.sortedAdsData(mockData)

		XCTAssertEqual(true, sortedAd[0].creationDate.compare(sortedAd[1].creationDate, options: .numeric) == .orderedDescending)
	}

	override func setUpWithError() throws {
		mockData = [
			Advertisement(id: 0,
										categoryID: 0,
										title: "Test0",
										advertisementDescription: "Test 0 0",
										price: 120, imagesURL: ImagesURL(small: nil, thumb: nil), creationDate: "2019-10-16T17:10:20+0000",
										isUrgent: false, siret: nil),
			Advertisement(id: 1,
										categoryID: 1,
										title: "Test1",
										advertisementDescription: "Test 0 0",
										price: 300,
										imagesURL: ImagesURL(small: nil, thumb: nil), creationDate: "2019-11-05T15:56:55+0000",
										isUrgent: true,
										siret: "123 323 002")]
		// Put setup code here. This method is called before the invocation of each test method in the class.

	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
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

}
