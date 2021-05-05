//
//  Advertisement.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import Foundation

// MARK: - Advertisement
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

// MARK: Advertisement convenience initializers and mutators

extension Advertisement {
		init(data: Data) throws {
				self = try newJSONDecoder().decode(Advertisement.self, from: data)
		}

		init(_ json: String, using encoding: String.Encoding = .utf8) throws {
				guard let data = json.data(using: encoding) else {
						throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
				}
				try self.init(data: data)
		}

		init(fromURL url: URL) throws {
				try self.init(data: try Data(contentsOf: url))
		}

		func with(
				id: Int? = nil,
				categoryID: Int? = nil,
				title: String? = nil,
				advertisementDescription: String? = nil,
				price: Int? = nil,
				imagesURL: ImagesURL? = nil,
				creationDate: String? = nil,
				isUrgent: Bool? = nil,
				siret: String?? = nil
		) -> Advertisement {
				return Advertisement(
						id: id ?? self.id,
						categoryID: categoryID ?? self.categoryID,
						title: title ?? self.title,
						advertisementDescription: advertisementDescription ?? self.advertisementDescription,
						price: price ?? self.price,
						imagesURL: imagesURL ?? self.imagesURL,
						creationDate: creationDate ?? self.creationDate,
						isUrgent: isUrgent ?? self.isUrgent,
						siret: siret ?? self.siret
				)
		}

		func jsonData() throws -> Data {
				return try newJSONEncoder().encode(self)
		}

		func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
				return String(data: try self.jsonData(), encoding: encoding)
		}
}

// MARK: - ImagesURL
struct ImagesURL: Codable {
		let small, thumb: String?
}

// MARK: ImagesURL convenience initializers and mutators

extension ImagesURL {
		init(data: Data) throws {
				self = try newJSONDecoder().decode(ImagesURL.self, from: data)
		}

		init(_ json: String, using encoding: String.Encoding = .utf8) throws {
				guard let data = json.data(using: encoding) else {
						throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
				}
				try self.init(data: data)
		}

		init(fromURL url: URL) throws {
				try self.init(data: try Data(contentsOf: url))
		}

		func with(
				small: String?? = nil,
				thumb: String?? = nil
		) -> ImagesURL {
				return ImagesURL(
						small: small ?? self.small,
						thumb: thumb ?? self.thumb
				)
		}

		func jsonData() throws -> Data {
				return try newJSONEncoder().encode(self)
		}

		func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
				return String(data: try self.jsonData(), encoding: encoding)
		}
}

typealias Advertisements = [Advertisement]

extension Array where Element == Advertisements.Element {
		init(data: Data) throws {
				self = try newJSONDecoder().decode(Advertisements.self, from: data)
		}

		init(_ json: String, using encoding: String.Encoding = .utf8) throws {
				guard let data = json.data(using: encoding) else {
						throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
				}
				try self.init(data: data)
		}

		init(fromURL url: URL) throws {
				try self.init(data: try Data(contentsOf: url))
		}

		func jsonData() throws -> Data {
				return try newJSONEncoder().encode(self)
		}

		func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
				return String(data: try self.jsonData(), encoding: encoding)
		}
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
		let decoder = JSONDecoder()
		if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
				decoder.dateDecodingStrategy = .iso8601
		}
		return decoder
}

func newJSONEncoder() -> JSONEncoder {
		let encoder = JSONEncoder()
		if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
				encoder.dateEncodingStrategy = .iso8601
		}
		return encoder
}
