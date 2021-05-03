//
//  AdsCollectionViewCell.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import UIKit

class AdsCollectionViewCell: UICollectionViewCell {

	var data: AdvertisementElement? {
		didSet {
			guard let data = data else {
				return
			}

			let urlString = data.imagesURL.thumb!

//			bg.downloadImageFromUrl(urlString)
			let url = NSURL(string: urlString)! as URL
			if let imageData: NSData = NSData(contentsOf: url) {

				bg.image = imageData.length != 0 ? UIImage(data: imageData as Data)
					:
					UIImage(named: "no_image")
			}
		}
	}

	// MARK: - Initialization
	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		setupUI()
	}

	lazy var bg: UIImageView = {
		let iv = UIImageView()
		iv.translatesAutoresizingMaskIntoConstraints = false
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.image = UIImage(named: "no_image")
		iv.layer.cornerRadius = 12
		return iv
	}()

	// MARK: - Properties
	lazy var roundedBackgroundView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 10
		view.layer.borderColor = UIColor.systemGray.cgColor
		view.layer.borderWidth = 1
		view.layer.backgroundColor = UIColor.red.cgColor
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 20)
		label.textColor = .systemBlue
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	lazy var productImage: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFit
		return image
	}()

}

// MARK: - UI Setup
extension AdsCollectionViewCell {
	private func setupUI() {
//		self.contentView.addSubview(roundedBackgroundView)
//		roundedBackgroundView.addSubview(titleLabel)
		self.contentView.addSubview(bg)

		bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		bg.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
		bg.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true


//		NSLayoutConstraint.activate([
//			roundedBackgroundView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
//			roundedBackgroundView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
//			roundedBackgroundView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5),
//			roundedBackgroundView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
//			titleLabel.centerXAnchor.constraint(equalTo: roundedBackgroundView.centerXAnchor),
//			titleLabel.centerYAnchor.constraint(equalTo: roundedBackgroundView.centerYAnchor),
//			productImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
//			productImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
//			productImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5),
//			productImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
//		])

	}
}
