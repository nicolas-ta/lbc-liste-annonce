//
//  Advertisement.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import Foundation

/** To init a list of advertisement, use:
* let advertisement = try? newJSONDecoder().decode(Advertisement.self, from: jsonData)
*/

// MARK: - AdvertisementElement
struct Advertisement: Codable {
		let id, categoryID: Int
		let title, advertisementDescription: String
		let price: Int
		let imagesURL: ImagesURL
		let creationDate: String
		let isUrgent: Bool
		let siret: String?

		enum CodingKeys: String, CodingKey {
				case id
				case categoryID = "category_id"
				case title
				case advertisementDescription = "description"
				case price
				case imagesURL = "images_url"
				case creationDate = "creation_date"
				case isUrgent = "is_urgent"
				case siret
		}
}

// MARK: - ImagesURL
struct ImagesURL: Codable {
		let small, thumb: String?
}

typealias Advertisements = [Advertisement]
