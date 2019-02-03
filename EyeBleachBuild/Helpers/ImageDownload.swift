//
//  ImageDownload.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 03/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
	
	//This extention is used to download an image from the url passed in asyncronously
	func loadImageFrom(url: URL) -> URLSessionDownloadTask {
		let session = URLSession.shared
		let downloadTask = session.downloadTask(with: url) {
			[weak self] url, response, error in
			if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
				DispatchQueue.main.async {
					if let weakSelf = self {
						weakSelf.image = image
					}
				}
			}
		}
		downloadTask.resume()
		return downloadTask
	}
}
