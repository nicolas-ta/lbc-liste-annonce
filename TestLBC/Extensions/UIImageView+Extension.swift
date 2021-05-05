//
//  UIImageView+Extension.swift
//  TestLBC
//
//  Created by Nicolas Ta on 03/05/2021.
//

import UIKit

extension UIImageView {

	// Get and replace image by URL in a different thread for performance 
	func replaceImageFromUrl(_ url: String, defaultImage: UIImage? = UIImage(named: "no_image")) {
		 guard let url = URL(string: url) else { return }
		 URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) -> Void in
			guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
						 let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
						 let data = data, error == nil,
						 let image = UIImage(data: data)
				 else {
				DispatchQueue.main.async {
				self?.image = defaultImage
				}
						 return
				 }
			DispatchQueue.main.async {
			self?.image = image
			}
		 }).resume()
 }
}
