//
//  AdsCollectionViewCell.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import UIKit

class AdsCollectionViewCell: UICollectionViewCell {

	var data: Advertisement? {
		didSet {
			guard let data = data else {
				return
			}

			if let urlString = data.imagesURL.thumb {
				bg.replaceImageFromUrl(urlString)
			} else {
				bg.image = UIImage(named: "no_image")
			}

			titleLabel.text = data.title
			priceLabel.text = " € " + String(data.price)
			isUrgentImageView.isHidden = !data.isUrgent
			contentView.layer.shadowColor = UIColor.black.cgColor
			//			}
		}
	}

	var category: String? {
		didSet {
			categoryLabel.text = "  " + category! + "  "
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

	lazy var isUrgentImageView: UIImageView = {
		let iv = UIImageView()
		iv.frame.size = CGSize(width: 20, height: 20)
		iv.translatesAutoresizingMaskIntoConstraints = false
		iv.image = UIImage(named: "urgent_icon")
		iv.contentMode = .scaleAspectFit
		return iv
	}()

	lazy var cellContainer: UIView = {

		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 12
		return view
	}()

	// MARK: - Properties
	lazy var bottomDescription: UIView = {
		let view = UIView()
		view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 200)
		view.layer.backgroundColor = UIColor.white.cgColor
		view.layer.cornerRadius = 12
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 12, weight: .light)
		label.textColor = .black
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	lazy var priceLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
		label.textColor = .black
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

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
}

// MARK: - UI Setup
extension AdsCollectionViewCell {
	private func setupUI() {
		self.contentView.layer.shadowRadius = 1
		self.contentView.layer.shadowOpacity = 0.2
		self.contentView.layer.shadowOffset = .zero
		self.contentView.layer.cornerRadius = 12

		self.contentView.addSubview(cellContainer)
		cellContainer.addSubview(bottomDescription)
		cellContainer.addSubview(bg)
		cellContainer.addSubview(isUrgentImageView)
		bottomDescription.addSubview(titleLabel)
		bottomDescription.addSubview(priceLabel)
		bottomDescription.addSubview(categoryLabel)
		NSLayoutConstraint.activate([

			// container
			cellContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
			cellContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			cellContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor),
			cellContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor),

			isUrgentImageView.topAnchor.constraint(equalTo: cellContainer.topAnchor, constant: 5),
			isUrgentImageView.rightAnchor.constraint(equalTo: cellContainer.rightAnchor, constant: -5),
			isUrgentImageView.heightAnchor.constraint(equalToConstant: 20),
			isUrgentImageView.widthAnchor.constraint(equalToConstant: 20),

			// bg
			bg.topAnchor.constraint(equalTo: cellContainer.topAnchor),
			bg.leftAnchor.constraint(equalTo: cellContainer.leftAnchor),
			bg.rightAnchor.constraint(equalTo: cellContainer.rightAnchor),
			bg.heightAnchor.constraint(equalToConstant: self.frame.height/5 * 4),

			// bottom description
			bottomDescription.heightAnchor.constraint(equalToConstant: self.frame.height/5 * 1 + 20),
			bottomDescription.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
			bottomDescription.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
			bottomDescription.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),

			// title label
			titleLabel.rightAnchor.constraint(equalTo: bottomDescription.rightAnchor, constant: -5),
			titleLabel.leftAnchor.constraint(equalTo: bottomDescription.leftAnchor, constant: 5),
			titleLabel.topAnchor.constraint(equalTo: bottomDescription.topAnchor, constant: 25),
			titleLabel.centerXAnchor.constraint(equalTo: bottomDescription.centerXAnchor),

			// price label
//			priceLabel.rightAnchor.constraint(equalTo: bottomDescription.rightAnchor, constant: -5),
			priceLabel.leftAnchor.constraint(equalTo: bottomDescription.leftAnchor, constant: 5),
			priceLabel.bottomAnchor.constraint(equalTo: bottomDescription.bottomAnchor, constant: -5),

			// category label
			categoryLabel.rightAnchor.constraint(equalTo: bottomDescription.rightAnchor, constant: -5),
			categoryLabel.bottomAnchor.constraint(equalTo: bottomDescription.bottomAnchor, constant: -5)
		])

	}
}
