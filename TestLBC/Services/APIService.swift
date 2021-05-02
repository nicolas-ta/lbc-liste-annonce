//
//  APIService.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import Foundation

class APIService :  NSObject {

	private let sourcesURL = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json")!

	func apiToGetAdData(completion : @escaping (Advertisement) -> ()){
		URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
			if let data = data {

				let jsonDecoder = JSONDecoder()

				let adsData = try! jsonDecoder.decode(Advertisement.self, from: data)
				completion(adsData)
			}
		}.resume()
	}
}
