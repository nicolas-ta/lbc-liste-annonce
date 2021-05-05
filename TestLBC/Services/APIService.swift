//
//  APIService.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import Foundation

enum APIError: String, Error {
		case decodeError = "Cannot decode JSON"
}

class APIService :  NSObject {

	private let BASE_URL = "https://raw.githubusercontent.com/leboncoin/paperclip/master"
	private let ADS_ENDPOINT = "/listing.json"
	private let CATEGORIES_ENDPOINT = "/categories.json"

	func getAdsData(completion : @escaping (Advertisements?, Error?) -> ()){
		URLSession.shared.dataTask(with: URL(string: BASE_URL + ADS_ENDPOINT)!) { (data, urlResponse, error) in
			guard let data = data else {
				completion(nil, error)
				return
			}

				let jsonDecoder = JSONDecoder()

			let adsData = try? jsonDecoder.decode(Advertisements.self, from: data)


			if let adsData = adsData {
				completion(adsData, nil)
			} else {
				completion(nil, APIError.decodeError)
			}
		}.resume()
	}

	func getCategoriesData(completion : @escaping (Categories?, Error?) -> ()){
		URLSession.shared.dataTask(with: URL(string: BASE_URL + CATEGORIES_ENDPOINT)!) { (data, urlResponse, error) in
			guard let data = data else {
				completion(nil, error)
				return
			}

				let jsonDecoder = JSONDecoder()

			let categories = try? jsonDecoder.decode(Categories.self, from: data)


			if let categories = categories {
				completion(categories, nil)
			} else {
				completion(nil, APIError.decodeError)
			}
		}.resume()
	}
}
