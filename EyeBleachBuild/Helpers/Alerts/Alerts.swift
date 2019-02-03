//
//  Alerts.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 03/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import Foundation
import UIKit


func createAlert(vc: UIViewController, title: String, message: String, style: UIAlertController.Style) {
	let alert = UIAlertController(title: title, message: message, preferredStyle: style)
	alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
	vc.present(alert, animated: true)
}
