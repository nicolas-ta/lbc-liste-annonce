//
//  UIImageView+Extension.swift
//  TestLBC
//
//  Created by Nicolas Ta on 03/05/2021.
//

import Foundation
import UIKit

extension UIImageView {
		func load(url: URL) {
				DispatchQueue.global().async { [weak self] in
						if let data = try? Data(contentsOf: url) {
								if let image = UIImage(data: data) {
										DispatchQueue.main.async {
												self?.image = image
										}
								}
						}
				}
		}

	func downloadImageFromUrl(_ url: String, defaultImage: UIImage? = UIImage(named: "no_image")) {
		 guard let url = URL(string: url) else { return }
		 URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) -> Void in
			guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
						 let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
						 let data = data, error == nil,
						 let image = UIImage(data: data)
				 else {
						 return
				 }
		 }).resume()
 }
}
