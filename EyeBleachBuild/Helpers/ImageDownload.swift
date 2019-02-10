//
//  ImageDownload.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 03/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import Foundation
import UIKit

var counter = 0

extension UIImageView {
	
	//This extention is used to download an image from the url passed in asyncronously
	func loadImageFrom(urlString: String) {
		guard let url = URL(string: urlString) else {return}
		
		guard let imageFromCache = imageCache.object(forKey: urlString as NSString) else {
			URLSession.shared.downloadTask(with: url) {
				[weak self] url, response, error in
				if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
					DispatchQueue.main.async {
						imageCache.setObject(image, forKey: (urlString as NSString))
						if let weakSelf = self {
							weakSelf.image = image
						}
					}
				}
				}.resume()
			return
		}
		print("here")
		self.image = imageFromCache
		return
	}
}
