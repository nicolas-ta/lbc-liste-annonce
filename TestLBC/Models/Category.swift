//
//  Category.swift
//  TestLBC
//
//  Created by Nicolas Ta on 03/05/2021.
//

import Foundation

// MARK: - Category
struct Category: Codable {
		let id: Int
		let name: String
}

typealias Categories = [Category]
