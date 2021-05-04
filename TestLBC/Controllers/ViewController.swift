//
//  ViewController.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import UIKit

class ViewController: UIViewController {

	let grayBackgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1.00)

	// MARK: - Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		callToViewModelForUIUpdate()
		self.navigationController?.setNavigationBarHidden(true, animated: true)

		setupUI()
	}

	override func viewDidAppear(_ animated: Bool) {
				super.viewDidAppear(animated)

				DispatchQueue.main.asyncAfter(deadline: (.now() + .milliseconds(500))) {
					self.categoryCollectionView!.flashScrollIndicators()
				}
		}

	// MARK: - Properties
	private var adsViewModel : AdvertisementViewModel!

	lazy var adsCollectionView: UICollectionView? = {

		let layout = UICollectionViewFlowLayout()
		layout.estimatedItemSize = .zero
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.minimumInteritemSpacing = 3
		layout.minimumLineSpacing = 3

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(AdsCollectionViewCell.self, forCellWithReuseIdentifier: "AdsCollectionViewCell")
		collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		collectionView.backgroundColor = .white
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.tag = 0
		return collectionView
	}()

	lazy var categoryCollectionView: UICollectionView? = {
		let layout = UICollectionViewFlowLayout()
		layout.estimatedItemSize = .zero
//		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 3
		layout.scrollDirection = .horizontal

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
//		collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		collectionView.backgroundColor = .white
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = grayBackgroundColor
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.tag = 1
		return collectionView
	}()

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

		super.viewWillTransition(to: size, with: coordinator)
		guard let adsCollectionView = adsCollectionView else {
			return
		}

		adsCollectionView.collectionViewLayout.invalidateLayout()

	}

	func callToViewModelForUIUpdate(){

		self.adsViewModel =  AdvertisementViewModel()
		self.adsViewModel.bindAdsViewModelToController = {
			self.updateDataSource()
		}
	}

	func updateDataSource(){
		DispatchQueue.main.async {
			self.adsCollectionView?.reloadData()
			self.categoryCollectionView?.reloadData()
		}
	}
}

// MARK: - UI Setup
extension ViewController {
	private func setupUI() {

		guard let adsCollectionView = adsCollectionView else {
			return
		}

		guard let categoryCollectionView = categoryCollectionView else {
			return
		}

		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
		self.view.backgroundColor = .white

		self.view.addSubview(adsCollectionView)
		self.view.addSubview(categoryCollectionView)


		NSLayoutConstraint.activate([
			categoryCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
			categoryCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5),
			categoryCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5),
			categoryCollectionView.heightAnchor.constraint(equalToConstant: 40),

			adsCollectionView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 10),
			adsCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
			adsCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
			adsCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),


		])
	}
}

// MARK: - UICollectionViewDelegate & Data Source
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		guard self.adsViewModel != nil && self.adsViewModel.filteredAdsData != nil && self.adsViewModel.categories != nil else {
			return 0
		}

		if (collectionView.tag == 0) {
			return self.adsViewModel.filteredAdsData.count
		} else {
			return self.adsViewModel.categories.count
		}
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width: CGFloat

		if (collectionView.tag == 0) {

		if UIDevice.current.orientation.isLandscape {
			width = UIScreen.main.bounds.width/3 - 9
			return CGSize(width: width, height: 300)

		} else {
			width = UIScreen.main.bounds.width/2 - 6
			return CGSize(width: width - 6, height: 300)

		}
		} else {
			return CGSize(width: 120, height: 30)
		}
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		guard let data = self.adsViewModel else {
			return
		}

		if collectionView.tag == 0 {
			let selected: Advertisement = data.filteredAdsData[indexPath.item]
			let vc = DetailViewController()
			vc.currentAd = selected
			vc.categoryName = data.category[selected.categoryID]
			navigationController?.pushViewController(vc, animated: true)

		} else if collectionView.tag == 1 {
			let indexPath = IndexPath(item: indexPath.item, section: 0)
			let oldIndexPath = IndexPath(item: data.selectedCategoryIndex, section: 0)
			if (oldIndexPath == indexPath) {
				adsCollectionView?.setContentOffset(CGPoint(x: -10, y: 5), animated: true)
				return
			}
			data.select(categoryIndex: indexPath.item)
			collectionView.reloadItems(at: [oldIndexPath, indexPath])
			adsCollectionView?.setContentOffset(CGPoint(x: -10, y: 5), animated: true)

			adsCollectionView?.reloadData()
			}


	}

	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		if collectionView.tag == 1 {
			if let cell = collectionView.cellForItem(at: indexPath) {
				cell.backgroundColor = .white
			}
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		if (collectionView.tag == 0) {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCollectionViewCell", for: indexPath) as! AdsCollectionViewCell

			guard let data = self.adsViewModel else {
				return cell
			}

			let currentAd = data.filteredAdsData[indexPath.item]

			cell.data = currentAd
			cell.category = data.category[currentAd.categoryID]
			return cell
		} else {
			let catCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as UICollectionViewCell

			guard let data = self.adsViewModel else {
				return catCell
			}

			let isSelected = data.selectedCategoryIndex == indexPath.item
			catCell.backgroundColor = .white
			let title = UILabel(frame: CGRect(x: 0, y: 0, width: catCell.bounds.size.width, height: 30))
			title.textColor = isSelected ? .white : .darkGray
			title.layer.cornerRadius = 5
			title.layer.masksToBounds = true
			title.backgroundColor = isSelected ? .orangeLBC: grayBackgroundColor
			title.text = String(data.categories[indexPath.item].name)
			title.textAlignment = .center
			catCell.contentView.addSubview(title)

			return catCell
		}
	}

}
