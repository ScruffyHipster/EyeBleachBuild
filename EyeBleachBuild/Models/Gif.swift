//
//  Gif.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 22/03/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import Foundation
import UIKit

class GIF: NSObject {
	
	let images: [UIImage]
	let durationInSecs: Double
	let repeatCount: Int
	
	init(images: [UIImage], durationInSecs: Double, repeatCount: Int = 0) {
		self.images = images
		self.durationInSecs = durationInSecs
		self.repeatCount = repeatCount
	}
	
}
