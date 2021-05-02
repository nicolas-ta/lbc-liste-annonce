//
//  ViewController.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

	private var adsViewModel: AdvertisementViewModel!
	var adsTableView: UITableView!

	private var dataSource: AdsTableViewDataSource<AdsTableViewCell,AdvertisementElement>!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		callToViewModelForUIUpdate()

		view.backgroundColor = .red

		adsTableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
//		adsTableView.dataSource = self
//		adsTableView.delegate = self
		adsTableView.backgroundColor = UIColor.white

		adsTableView.register(AdsTableViewCell.self, forCellReuseIdentifier: "adCellIdentifier")
		view.addSubview(adsTableView)
	}

	func callToViewModelForUIUpdate(){
		self.adsViewModel = AdvertisementViewModel()
		self.adsViewModel.bindAdvertisementViewModelToController = {
			self.updateDataSource()
		}
	}

	func updateDataSource(){
		self.dataSource = AdsTableViewDataSource(cellIdentifier: "adCellIdentifier", items: self.adsViewModel.adsData, configureCell: { (cell, evm) in
				cell.idLabel.text = String(describing: evm.id)
			cell.titleLabel.text = evm.title
		})

		DispatchQueue.main.async {
			self.adsTableView.dataSource = self.dataSource
			self.adsTableView.reloadData()
		}
	}


}

