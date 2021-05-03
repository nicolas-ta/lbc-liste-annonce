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
				bg.image = UIImage(named: "no_image")
				return
			}

			guard let urlString = data.imagesURL.small else {
				bg.image = UIImage(named: "no_image")
				return
			}
			bg.downloadImageFromUrl(urlString)

			titleLabel.text = data.title

//			}
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
	lazy var bottomDescription: UIView = {
		let view = UIView()
		view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 200)
		view.layer.backgroundColor = UIColor.white.cgColor
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 9, weight: .medium)
		label.textColor = .black
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
//
//	lazy var productImage: UIImageView = {
//		let image = UIImageView()
//		image.contentMode = .scaleAspectFit
//		return image
//	}()

}

// MARK: - UI Setup
extension AdsCollectionViewCell {
	private func setupUI() {
//		self.contentView.addSubview(roundedBackgroundView)
//		roundedBackgroundView.addSubview(titleLabel)
		self.contentView.addSubview(bg)
		bg.addSubview(bottomDescription)

//		bg.heightAnchor.constraint(equalToConstant: 300).isActive = true
		bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		bg.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
		bg.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
		bottomDescription.addSubview(titleLabel)

		NSLayoutConstraint.activate([
			bottomDescription.heightAnchor.constraint(equalToConstant: self.frame.height/5),
//			roundedBackgroundView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
			bottomDescription.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
			bottomDescription.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
			bottomDescription.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
			titleLabel.rightAnchor.constraint(equalTo: bottomDescription.rightAnchor, constant: -5),
			titleLabel.leftAnchor.constraint(equalTo: bottomDescription.leftAnchor, constant: 5),
			titleLabel.centerXAnchor.constraint(equalTo: bottomDescription.centerXAnchor),
			titleLabel.centerYAnchor.constraint(equalTo: bottomDescription.centerYAnchor)
		])

	}
}
