//
//  AddShadows.swift
//  EyeBleach
//
//  Created by Tom Murray on 23/01/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
	
	func addShadow(radius: CGFloat, offSet: CGSize, color: CGColor, opacity: Float) {
		layer.shadowRadius = radius
		layer.shadowOffset = offSet
		layer.shadowOpacity = opacity
		layer.shadowColor = color
		layer.masksToBounds = false
	}
	
}
