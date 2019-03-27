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
	func loadImageFrom(urlString: String, closure: @escaping ((Bool) -> ())) {
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
					closure(true)
				}
				}.resume()
			return
		}
		print(url.absoluteURL)
		//check to see if the url has a .gif suffix. If not load as normal
		if url.pathExtension == "gif" {
			self.setGifImage(name: url.absoluteString)
			print("setting gif")
		} else {
			//load standard image instead of gif
			self.image = imageFromCache
			print("Not setting gif")
		}
	  return
	}

}

extension UIImageView {
	//Gif stuff
	func setGifImage(name: String, repeatCount: Int = 0) {
		DispatchQueue.global().async {
			if let gif = UIImage.makeGifFromCollection(name: name, repeatCount: repeatCount) {
				DispatchQueue.main.async {
					self.setImage(withGIF: gif)
					self.startAnimating()
				}
			}
		}
	}
	
	func setImage(withGIF gif: GIF) {
		animationImages = gif.images
		animationDuration = gif.durationInSecs
		animationRepeatCount = gif.repeatCount
	}
}



//Gif stuff
extension UIImage {
	class func makeGifFromCollection(name: String, repeatCount: Int = 0) -> GIF? {
		let data = try? Data(contentsOf: URL(string: name)!)
		guard let d = data else {
			print("Cannot turn image \(name) into a gif")
			return nil
		}
		return makeGifFromData(data: d, repeatCount: repeatCount)
 	}
	
	class func makeGifFromData(data: Data, repeatCount: Int = 0) -> GIF? {
		guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
			print("Source for the image does not exist")
			return nil
		}
		let count = CGImageSourceGetCount(source)
		var images = [UIImage]()
		var duration = 0.0
		
		for i in 0..<count {
			if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
				let image = UIImage(cgImage: cgImage)
				images.append(image)
				let delaySeconds = UIImage.delayForImageAt(Int(i), source: source)
				duration += delaySeconds
			}
		}
		return GIF(images: images, durationInSecs: duration, repeatCount: repeatCount)
	}
	
	class func delayForImageAt(_ index: Int, source: CGImageSource!) -> Double {
		var delay = 0.0
		
		//get dictionaries
		let cfProperites = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
		let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
		if CFDictionaryGetValueIfPresent(cfProperites, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
			return delay
		}
		let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
		
		//Get delay time
		var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
		if delayObject.doubleValue == 0 {
			delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
		}
		delay = delayObject as? Double ?? 0
		
		return delay
	}
}
