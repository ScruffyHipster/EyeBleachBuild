//
//  RoundedButton.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 11/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import UIKit

extension UIButton {

	func roundedTransparentButton() {
		self.layer.cornerRadius = 8
		self.clipsToBounds = true
		self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
	}
}
