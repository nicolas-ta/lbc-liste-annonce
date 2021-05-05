//
//  AdvertisementViewModel.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import Foundation

class AdvertisementViewModel: NSObject {
	private var apiService: APIService!

	private(set) var adsData : Advertisements! {
		didSet {
			self.updateListData()
		}
	}

	private(set) var categories : Categories! {
		didSet {
			populateCategories()
		}
	}

	private(set) var filteredAdsData: Advertisements! {
		didSet {
			self.bindAdsViewModelToController(error)
		}
	}

	var error: Error?
	var category: [Int: String]!
	var selectedCategoryIndex: Int = 0
	var selectedAd: Advertisement?
	var bindAdsViewModelToController : ((Error?) -> ()) = {error in }

	override init() {
		super.init()
		self.apiService = APIService()
		getCategoryData()
		getAdsData()

	}

	func getAdsData() {
		self.apiService.getAdsData{ (ads, error) in
			
			if let error = error {
				print("error:", error)
				return
			}
			if let ads = ads {
				self.adsData = ads

			} else {
				print("error: no data")
			}
		}
	}

	func updateListData() {
		guard var tempAdsData = adsData else { return }
		tempAdsData = filteredAdsData(tempAdsData)
		tempAdsData = sortedAdsData(tempAdsData)
		self.filteredAdsData = tempAdsData
	}

	func filteredAdsData(_ adsData: Advertisements) -> Advertisements {
		var filteredAdsData = adsData

		if selectedCategoryIndex == 0 {
			return filteredAdsData
		} else {
			let categoryID = categories[selectedCategoryIndex].id
			filteredAdsData = filteredAdsData.filter({$0.categoryID == categoryID})
			return filteredAdsData
		}

	}

	func sortedAdsData(_ adsData: Advertisements) -> Advertisements {
		var sortedAdsData = adsData

		sortedAdsData = sortedAdsData.sorted(by: {$0.creationDate.compare($1.creationDate, options: .numeric) == .orderedDescending})
		sortedAdsData = sortedAdsData.sorted(by: {$0.isUrgent && !$1.isUrgent})

		return sortedAdsData
	}

	func getCategoryData() {
		self.apiService.getCategoriesData { (categories, error) in

			if let error = error {

				print("error:", error)
				return
			}
			if let categories = categories {
				var catArray = [Category(id: 0, name: "Tout")]
				catArray.append(contentsOf: categories)
				self.categories = catArray
			} else {
				print("error: no data")
			}
		}
	}

	func populateCategories() {
		category = categories.reduce([Int: String]()) { (dict, item) -> [Int: String] in
			var dict = dict
			dict[item.id] = item.name
			return dict
		}
	}

	func select(categoryIndex: Int) {
		selectedCategoryIndex = categoryIndex
		updateListData()
	}
}
