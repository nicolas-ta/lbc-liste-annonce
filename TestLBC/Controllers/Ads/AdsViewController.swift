//
//  ViewController.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import UIKit

class AdsViewController: UIViewController {

	// MARK: - Properties
	private let ADS_CELL_IDENTIFIER = "AdsCollectionViewCell"
	private let CAT_CELL_IDENTIFIER = "CategoryCollectionViewCell"


	private var adsViewModel : AdvertisementViewModel!

	// MARK: - Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		callToViewModelForUIUpdate()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		showScrollableIndicator()
	}

	// MARK: - Layout Properties

	// Setup adsCollectionView
	private lazy var adsCollectionView: UICollectionView? = {
		let layout = UICollectionViewFlowLayout()
		layout.estimatedItemSize = .zero
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.minimumInteritemSpacing = 3
		layout.minimumLineSpacing = 3

		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.register(AdsCollectionViewCell.self, forCellWithReuseIdentifier: ADS_CELL_IDENTIFIER)
		cv.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		cv.backgroundColor = .white
		cv.delegate = self
		cv.dataSource = self
		cv.translatesAutoresizingMaskIntoConstraints = false
		cv.tag = 0
		return cv
	}()

	// Setup categoriesCollectionView
	lazy var categoriesCollectionView: UICollectionView? = {
		let layout = UICollectionViewFlowLayout()
		layout.estimatedItemSize = .zero
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 3
		layout.scrollDirection = .horizontal

		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CAT_CELL_IDENTIFIER)
		cv.backgroundColor = .white
		cv.delegate = self
		cv.dataSource = self
		cv.backgroundColor = .grayBackground
		cv.translatesAutoresizingMaskIntoConstraints = false
		cv.tag = 1
		return cv
	}()

	// MARK: - UI Life cycle methods

	// Fix rotation issues in the ads collection view
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

		super.viewWillTransition(to: size, with: coordinator)
		guard let adsCollectionView = adsCollectionView else {
			return
		}
		adsCollectionView.collectionViewLayout.invalidateLayout()
	}

	// MARK: - Private methods

	// Momentarily show the scroll indicator to show  that it's scrollable
	private func showScrollableIndicator() {
		DispatchQueue.main.asyncAfter(deadline: (.now() + .milliseconds(500))) {
			self.categoriesCollectionView!.flashScrollIndicators()
		}
	}

	// Init the AdvertisementViewModel, which will set the ads data
	private func callToViewModelForUIUpdate(){
		self.adsViewModel =  AdvertisementViewModel()
		self.adsViewModel.bindAdsViewModelToController = { error in
			// In case the viewModel return an error
			if let error = error {
				let alert = UIAlertController(title: error.localizedDescription, message: "", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .default))

				self.present(alert, animated: true)

			} else {
				self.updateDataSource()
			}
		}
	}

	// Once the data is established, reload the collectionviews
	private func updateDataSource(){
		DispatchQueue.main.async {
			self.adsCollectionView?.reloadData()
			self.categoriesCollectionView?.reloadData()
		}
	}
}

// MARK: - UI Setup
extension AdsViewController {
	private func setupUI() {

		// Hide navigation bar
		self.navigationController?.setNavigationBarHidden(true, animated: true)

		guard let adsCollectionView = adsCollectionView, let categoriesCollectionView = categoriesCollectionView else {
			return
		}

		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
		view.backgroundColor = .white

		// Add both collection views
		view.addSubview(adsCollectionView)
		view.addSubview(categoriesCollectionView)

		setupConstraintsFor(adsCollectionView, and: categoriesCollectionView)
	}

	// Setup constraints for adsCollectionView and categoriesCollectionView
	private func setupConstraintsFor(_ adsCollectionView: UICollectionView, and categoriesCollectionView: UICollectionView) {
		NSLayoutConstraint.activate([
			categoriesCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
			categoriesCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5),
			categoriesCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5),
			categoriesCollectionView.heightAnchor.constraint(equalToConstant: 40),
			adsCollectionView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 10),
			adsCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
			adsCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
			adsCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
		])
	}
}

// MARK: - UICollectionViewDelegate & Data Source
extension AdsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		guard self.adsViewModel != nil && self.adsViewModel.filteredAdsData != nil && self.adsViewModel.categories != nil else {
			return 0
		}

		// nb: adsCollectionView.tag = 0 and categoriesCollectionView.tag = 1
		if (collectionView.tag == 0) {
			return self.adsViewModel.filteredAdsData.count
		} else {
			return self.adsViewModel.categories.count
		}
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width: CGFloat

		// Cell size of adsCollectionView for portrait and landscape
		if (collectionView.tag == 0) {
			if UIDevice.current.orientation.isLandscape {
				width = UIScreen.main.bounds.width/3 - 9
				return CGSize(width: width, height: 300)

			} else {
				width = UIScreen.main.bounds.width/2 - 6
				return CGSize(width: width - 6, height: 300)
			}

			// Cell size for categoriesCollectionView
		} else {
			return CGSize(width: 120, height: 30)
		}
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		guard let data = self.adsViewModel else {
			return
		}

		// Go the the detail view
		if collectionView.tag == 0 {
			let selected: Advertisement = data.filteredAdsData[indexPath.item]
			let vc = DetailViewController()
			vc.currentAd = selected
			vc.categoryName = data.category[selected.categoryID]
			navigationController?.pushViewController(vc, animated: true)
			
		}
		// Select a category and filter the ads collection view
		else if collectionView.tag == 1 {
			let indexPath = IndexPath(item: indexPath.item, section: 0)
			let oldIndexPath = IndexPath(item: data.selectedCategoryIndex, section: 0)

			// Scroll at the top whenever a category is tapped
			adsCollectionView?.setContentOffset(CGPoint(x: -10, y: 5), animated: true)

			// If the category already selected, do nothing
			if (oldIndexPath == indexPath) {
				return
			}

			// Else, reload the view with updated filter
			data.select(categoryIndex: indexPath.item)
			collectionView.reloadItems(at: [oldIndexPath, indexPath])
			adsCollectionView?.reloadData()
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		guard let data = self.adsViewModel else {
			return UICollectionViewCell()
		}

		if (collectionView.tag == 0) {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ADS_CELL_IDENTIFIER, for: indexPath) as! AdsCollectionViewCell

			let currentAd = data.filteredAdsData[indexPath.item]
			cell.data = currentAd
			cell.category = data.category[currentAd.categoryID]
			return cell
		} else {
			let catCell = collectionView.dequeueReusableCell(withReuseIdentifier: CAT_CELL_IDENTIFIER, for: indexPath) as UICollectionViewCell

			let isSelected = data.selectedCategoryIndex == indexPath.item
			catCell.backgroundColor = .white
			let title = UILabel(frame: CGRect(x: 0, y: 0, width: catCell.bounds.size.width, height: 30))
			title.textColor = isSelected ? .white : .darkGray
			title.layer.cornerRadius = 5
			title.layer.masksToBounds = true
			title.backgroundColor = isSelected ? .orangeLBC: .grayBackground
			title.text = String(data.categories[indexPath.item].name)
			title.textAlignment = .center
			catCell.contentView.addSubview(title)

			return catCell
		}
	}

}
