//
//  DetailModalViewController.swift
//  TestLBC
//
//  Created by Nicolas Ta on 04/05/2021.
//

import UIKit

class DetailViewController: UIViewController {

	// MARK: - Properties
	var currentAd: Advertisement! {
		didSet {
			setupData()
		}
	}

	var categoryName: String! {
		didSet {
			categoryLabel.text = String(format: "  %@  ", categoryName)
		}
	}

	// MARK: - Lifecycle Methods

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setupNavigationBar()
		setupUI()
	}

	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden(true, animated: true)
	}

// MARK: - Layout properties

	// The vertical scrollview containing all the details
	lazy var scrollView: UIScrollView = {
		let scroll = UIScrollView()
		scroll.translatesAutoresizingMaskIntoConstraints = false
		scroll.delegate = self
		scroll.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
		return scroll
	}()

	// The imageview displayed in the fullscreen mode. Zoomable.
	private lazy var productImageFullscreen = UIImageView()

	// The imageview showing the product and can be displayed in fullscreen
	private lazy var productImage: UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.layer.masksToBounds = true
		iv.image = UIImage(named: "no_image") // Default image
		iv.translatesAutoresizingMaskIntoConstraints = false

		// Add tap gesture to display the fullscreen image
		iv.isUserInteractionEnabled = true
		iv.isMultipleTouchEnabled = true
		var tapgesture = UITapGestureRecognizer(target: self, action: #selector(fullScreenImage))
		tapgesture.numberOfTapsRequired = 1
		iv.addGestureRecognizer(tapgesture)

		return iv
	}()

	// Small icon reflecting "is_urgent" field. Hidden if not urgent.
	private lazy var isUrgentImageView: UIImageView = {
		let iv = UIImageView()
		iv.frame.size = CGSize(width: 20, height: 20)
		iv.translatesAutoresizingMaskIntoConstraints = false
		iv.image = UIImage(named: "urgent_icon")
		iv.contentMode = .scaleAspectFit
		return iv
	}()

	// Title label without a limit to its number of lines.
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		label.textColor = .darkGray
		label.text = "Placeholder"
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// Date label that will contain the time the ad was published.
	private lazy var dateLabel: UILabel = {
		let label = UILabel()
		label.backgroundColor = .white
		label.font = UIFont.systemFont(ofSize: 12)
		label.text = "Offre postée le 12 :"
		label.numberOfLines = 0
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// The description label at the bottom of the view
	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.backgroundColor = .white
		label.font = UIFont.systemFont(ofSize: 17, weight: .light)
		label.numberOfLines = 0
		label.textColor = .darkGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// The Price label displayed on the right side of the title
	lazy var priceLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
		label.textColor = .darkGray
		label.numberOfLines = 1
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// The category label displayed below the title
	lazy var categoryLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14)
		label.textColor = .white
		label.backgroundColor = .orangeLBC
		label.layer.cornerRadius = 5
		label.layer.masksToBounds = true
		label.numberOfLines = 1
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// If the ad has a Siret code, display it on the right of the category label
	lazy var siretLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14)
		label.textColor = .white
		label.backgroundColor = .gray
		label.layer.cornerRadius = 5
		label.layer.masksToBounds = true
		label.numberOfLines = 1
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
}
// MARK: - Setup methods
extension DetailViewController {
	// Hide the navigation bar but keep the previous button
	private func setupNavigationBar() {
		self.navigationController?.setNavigationBarHidden(false, animated: true)
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.view.backgroundColor = .clear
	}

	// Setup the UI elements without any data
	private func setupUI() {
		view.addSubview(scrollView)
		scrollView.addSubview(productImage)
		productImage.addSubview(isUrgentImageView)
		scrollView.addSubview(titleLabel)
		scrollView.addSubview(priceLabel)
		scrollView.addSubview(categoryLabel)
		scrollView.addSubview(siretLabel)
		scrollView.addSubview(dateLabel)
		scrollView.addSubview(descriptionLabel)
		setupConstraints()
	}

	// Setup the constraints of the UI Element
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			// product image
			productImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
			productImage.leftAnchor.constraint(equalTo: view.leftAnchor),
			productImage.rightAnchor.constraint(equalTo: view.rightAnchor),

			// isUrgent icon
			isUrgentImageView.topAnchor.constraint(equalTo: productImage.topAnchor, constant: 15),
			isUrgentImageView.rightAnchor.constraint(equalTo: productImage.rightAnchor, constant: -5),
			isUrgentImageView.heightAnchor.constraint(equalToConstant: 20),
			isUrgentImageView.widthAnchor.constraint(equalToConstant: 20),

			// title label
			titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
			titleLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 10),
			titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.frame.width/4),

			// price label
			priceLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 10),
			priceLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),

			// category label
			categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
			categoryLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),

			// siret label
			siretLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
			siretLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),

			// Date label
			dateLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10),
			dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
			dateLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),

			// description label
			descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2),
			descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
			descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
			descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30)
		])
	}

	// Once we have data, complete all the UI elements with data
	private func setupData() {

		// Fill all the text label with the ad data
		titleLabel.text = currentAd.title
		isUrgentImageView.isHidden = currentAd.isUrgent ? false : true
		priceLabel.text = " € " + String(currentAd.price)
		descriptionLabel.text = currentAd.advertisementDescription
		siretLabel.text = currentAd.siret != nil ? String(format: " siret: %@ ", currentAd.siret!)  : ""

		// Download the image again if it exists
		guard let urlString = currentAd.imagesURL.thumb else {
			productImage.image = UIImage(named: "no_image")
			return
		}
		productImage.replaceImageFromUrl(urlString)

		// Format the entire ad creation date introduction
		let dateFormatterGet = DateFormatter()
		dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

		let dateFormatterPrint = DateFormatter()
		dateFormatterPrint.dateFormat = "'Annonce publiée le 'dd MMM yyyy', à' HH:mm:"

		if let date = dateFormatterGet.date(from: currentAd.creationDate) {
			dateLabel.text = dateFormatterPrint.string(from: date)
		} else {
			print("There was an error decoding the string")
		}
	}
}

// MARK: - Private methods
extension DetailViewController {
	// Display the product image in full screen, zoomable, when the image is tapped
	@objc private func fullScreenImage(_ sender: UITapGestureRecognizer) {
		let imageView = sender.view as! UIImageView
		productImageFullscreen = UIImageView(image: imageView.image)
		productImageFullscreen.frame = UIScreen.main.bounds
		productImageFullscreen.contentMode = .scaleAspectFit
		productImageFullscreen.isUserInteractionEnabled = true
		self.navigationController?.isNavigationBarHidden = true
		self.tabBarController?.tabBar.isHidden = true

		let scrollView = UIScrollView()
		scrollView.frame = UIScreen.main.bounds
		scrollView.backgroundColor = .black
		scrollView.frame = UIScreen.main.bounds
		scrollView.maximumZoomScale = 4
		scrollView.minimumZoomScale = 1.0
		scrollView.bounces = true
		scrollView.bouncesZoom = true
		scrollView.showsHorizontalScrollIndicator = true
		scrollView.showsVerticalScrollIndicator = true
		scrollView.delegate = self
		let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
		scrollView.addGestureRecognizer(tap)
		scrollView.addSubview(productImageFullscreen)
		productImage.center = scrollView.center
		view.addSubview(scrollView)
	}

	// Dismiss the fullscreen image to get back at the detail page
	@objc private func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
		self.navigationController?.isNavigationBarHidden = false
		self.tabBarController?.tabBar.isHidden = false
		sender.view?.removeFromSuperview()
	}
}

// MARK: - Extensions
extension DetailViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return productImageFullscreen
	}
}
