//
//  APIService.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import Foundation

class APIService :  NSObject {

	private let sourcesURL = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json")!

	func apiToGetAdData(completion : @escaping (Advertisement?, Error?) -> ()){
		URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
			guard let data = data else {
				completion(nil, error)
				return
			}

				let jsonDecoder = JSONDecoder()

			let adsData = try? jsonDecoder.decode(Advertisement.self, from: data)


			if let adsData = adsData {
				completion(adsData, nil)
			} else {
				completion(nil, nil)
			}
		}.resume()
	}
}
