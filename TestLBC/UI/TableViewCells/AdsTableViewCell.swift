//
//  AdsTableViewCell.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import UIKit

class AdsTableViewCell: UITableViewCell {


	var idLabel: UILabel!
	var titleLabel: UILabel!

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {

		super.init(style: style, reuseIdentifier: reuseIdentifier)
		idLabel = UILabel()
		titleLabel = UILabel()

		contentView.addSubview(idLabel)
		contentView.addSubview(titleLabel)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}



	var ad : AdvertisementElement? {
		didSet {

			idLabel.text = String(describing: ad?.id)
			titleLabel.text = ad?.title
		}
	}

	override func layoutSubviews() {
			super.layoutSubviews()

		self.idLabel.frame = CGRect(x: 15,y: 10,width: 200,height: 30)
		self.idLabel.adjustsFontSizeToFitWidth = true
		self.idLabel.textColor = UIColor.green

		self.titleLabel.frame = CGRect(x: 100,y: 10,width: 200,height: 30)
		self.titleLabel.adjustsFontSizeToFitWidth = true


	}

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}

}
