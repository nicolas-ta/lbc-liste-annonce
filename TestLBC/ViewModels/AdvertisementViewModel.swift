//
//  AdvertisementViewModel.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import Foundation

class AdvertisementViewModel: NSObject {
	private var apiService: APIService!

	private(set) var adsData : Advertisement! {
			didSet {
					self.bindAdsViewModelToController()
			}
	}

	var bindAdsViewModelToController : (() -> ()) = {}

	override init() {
		super.init()
		self.apiService = APIService()
		callFuncToGetAdsData()
	}

	func callFuncToGetAdsData() {
		self.apiService.apiToGetAdData{ (ads, error) in
			
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
}
