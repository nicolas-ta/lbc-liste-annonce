//
//  AdvertisementViewModel.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import Foundation

class AdvertisementViewModel: NSObject {

	// MARK: - Properties
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
			self.bindAdsViewModelToController()
		}
	}

	var category: [Int: String]!
	var selectedCategoryIndex: Int = 0
	var selectedAd: Advertisement?
	var bindAdsViewModelToController : (() -> ()) = {}


	// MARK: - Lifetime
	override init() {
		super.init()
		self.apiService = APIService()
		getCategoryData()
		getAdsData()
	}


	// MARK: - Public methods
	func select(categoryIndex: Int) {
		selectedCategoryIndex = categoryIndex
		updateListData()
	}

	// MARK: - Private methods

	// Use the api service to get ads data
	private func getAdsData() {
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

	// Update the list with correct order and filter
	private func updateListData() {
		guard var tempAdsData = adsData else { return }
		tempAdsData = filteredAdsData(tempAdsData)
		tempAdsData = sortedAdsData(tempAdsData)
		self.filteredAdsData = tempAdsData
	}

	// Filter the list
	private func filteredAdsData(_ adsData: Advertisements) -> Advertisements {
		var filteredAdsData = adsData

		if selectedCategoryIndex == 0 {
			return filteredAdsData
		} else {
			let categoryID = categories[selectedCategoryIndex].id
			filteredAdsData = filteredAdsData.filter({$0.categoryID == categoryID})
			return filteredAdsData
		}
	}

	// Sort the list by date, and "isUrgent"
	private func sortedAdsData(_ adsData: Advertisements) -> Advertisements {
		var sortedAdsData = adsData

		sortedAdsData = sortedAdsData.sorted(by: {$0.creationDate.compare($1.creationDate, options: .numeric) == .orderedDescending})
		sortedAdsData = sortedAdsData.sorted(by: {$0.isUrgent && !$1.isUrgent})

		return sortedAdsData
	}

	// Use api service to get the categories
	private func getCategoryData() {
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

	// Populate the category dictionnary used to find correspondances easier
	private func populateCategories() {
		category = categories.reduce([Int: String]()) { (dict, item) -> [Int: String] in
			var dict = dict
			dict[item.id] = item.name
			return dict
		}
	}


}
