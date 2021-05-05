//
//  APIService.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import Foundation

enum APIError: String, Error {
	case genericError = "Error in the API"
	case noAdsData = "No ads data found"
	case noCategoryData = "No category data dound"
	case getAdsData = "Couldn't fetch Ads Data"
	case getCategoryData = "Couldn't fetch category data"

	init?(newRawValue: String) {
		self = APIError(rawValue: newRawValue) ?? .genericError
	}
}

class APIService: NSObject {

	private let BASE_URL = "https://raw.githubusercontent.com/leboncoin/paperclip/master"
	private let ADS_ENDPOINT = "/listing.json"
	private let CATEGORIES_ENDPOINT = "/categories.json"

	// Fetch ads data
	func getAdsData(completion : @escaping (Advertisements?, APIError?) -> Void) {
		URLSession.shared.dataTask(with: URL(string: BASE_URL + ADS_ENDPOINT)!) { (data, _, _) in
			guard let data = data else {
				completion(nil, APIError.getAdsData)
				return
			}

			let jsonDecoder = JSONDecoder()

			let adsData = try? jsonDecoder.decode(Advertisements.self, from: data)

			if let adsData = adsData {
				completion(adsData, nil)
			} else {
				completion(nil, APIError.noAdsData)
			}
		}.resume()
	}

	// Fetch category ids and names
	func getCategoriesData(completion : @escaping (Categories?, APIError?) -> Void) {
		URLSession.shared.dataTask(with: URL(string: BASE_URL + CATEGORIES_ENDPOINT)!) { (data, _, error) in
			guard let data = data else {
				completion(nil, APIError(rawValue: error.debugDescription))
				return
			}

			let jsonDecoder = JSONDecoder()

			let categories = try? jsonDecoder.decode(Categories.self, from: data)

			if let categories = categories {
				completion(categories, nil)
			} else {
				completion(nil, APIError.noCategoryData)
			}
		}.resume()
	}
}
