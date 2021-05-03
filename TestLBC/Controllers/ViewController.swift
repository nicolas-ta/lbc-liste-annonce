//
//  ViewController.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import UIKit

class ViewController: UIViewController {

	// MARK:- UI properties
	// Adjust this as you need
	fileprivate var offset: CGFloat = 50

	//    Properties for configuring the layout: the number of columns and the cell padding.
	fileprivate var numberOfColumns = 2
	fileprivate var cellPadding: CGFloat = 10

	//    Cache the calculated attributes. When you call prepare(), you’ll calculate the attributes for all items and add them to the cache. You can be efficient and
	fileprivate var cache = [UICollectionViewLayoutAttributes]()

	//    Properties to store the content size.
	fileprivate var contentHeight: CGFloat = 0
	fileprivate var contentWidth: CGFloat {
		guard let collectionView = adsCollectionView, adsCollectionView != nil else {
			return 0
		}
		let insets = collectionView.contentInset
		return collectionView.bounds.width - (insets.left + insets.right)
	}

	// MARK: - Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		callToViewModelForUIUpdate()
		setupUI()
	}

	// MARK: - Properties
	private var adsViewModel : AdvertisementViewModel!
	var titles: [String] = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight"]

	lazy var adsCollectionView: UICollectionView? = {

		let itemSize = UIScreen.main.bounds.width/2 - 3
		//
		let layout = UICollectionViewFlowLayout()
		layout.estimatedItemSize = .zero
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.minimumInteritemSpacing = 3
		layout.minimumLineSpacing = 3
		layout.itemSize = CGSize(width: itemSize, height: itemSize)

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(AdsCollectionViewCell.self, forCellWithReuseIdentifier: "AdsCollectionViewCell")

		collectionView.backgroundColor = .white
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

		super.viewWillTransition(to: size, with: coordinator)
		guard let adsCollectionView = adsCollectionView else {
			return
		}

		if UIDevice.current.orientation.isLandscape,
			 let layout = adsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			let width = UIScreen.main.bounds.width/2 - 3
			layout.estimatedItemSize = .zero
			layout.itemSize = CGSize(width: width - 16, height: 300)
			layout.invalidateLayout()
		} else if UIDevice.current.orientation.isPortrait,
							let layout = adsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			let width = UIScreen.main.bounds.width/2 - 3
			layout.estimatedItemSize = .zero
			layout.itemSize = CGSize(width: width - 16, height: 300)
			layout.invalidateLayout()
		}

	}

	func callToViewModelForUIUpdate(){

		self.adsViewModel =  AdvertisementViewModel()
		self.adsViewModel.bindAdsViewModelToController = {
			self.updateDataSource()
		}
	}

	func updateDataSource(){
		DispatchQueue.main.async {
			print("Update Data Source")
			print("count:", self.adsViewModel.adsData.count)
			self.adsCollectionView?.reloadData()
		}
	}
}

// MARK: - UI Setup
extension ViewController {
	private func setupUI() {

		guard let adsCollectionView = adsCollectionView else {
			return
		}

		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
		self.view.backgroundColor = .white

		self.view.addSubview(adsCollectionView)

		NSLayoutConstraint.activate([
			adsCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//			adsCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
			adsCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -3),
			adsCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			adsCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 3)
		])
	}
}

// MARK: - UICollectionViewDelegate & Data Source
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		guard self.adsViewModel != nil && self.adsViewModel.adsData != nil else {
			return 0
		}
		return self.adsViewModel.adsData.count
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width: CGFloat


		if UIDevice.current.orientation.isLandscape {
			width = UIScreen.main.bounds.width/2 - 6
			return CGSize(width: width, height: 300)

		} else {
			width = UIScreen.main.bounds.width/2 - 6
			return CGSize(width: width, height: 300)

		}

		//		let itemSize = UIScreen.main.bounds.width/2 - 3
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCollectionViewCell", for: indexPath) as! AdsCollectionViewCell

		guard (self.adsViewModel != nil) else {
			return cell
		}

		guard let data = self.adsViewModel else {
			return cell
		}

		//		if let gridCell = cell as? GridCollectionViewCell {
		//						// TODO: configure cell
		//				}
//		cell.titleLabel.text = String(describing: indexPath.item)
//		cell.titleLabel.text = String(describing: data.adsData[indexPath.item].imagesURL.thumb)

		cell.data = data.adsData[indexPath.item]
//		let urlString = data.adsData[indexPath.item].imagesURL.thumb!
//
//		let url = NSURL(string: urlString)! as URL
//		if let imageData: NSData = NSData(contentsOf: url) {
//			cell.bg.image = UIImage(data: imageData as Data)
//		}
		return cell
	}

}
