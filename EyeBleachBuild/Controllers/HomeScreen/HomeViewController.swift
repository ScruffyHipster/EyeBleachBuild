//
//  ViewController.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 03/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
	
	//Properties
	
	var request = HTTPRequest.shared
	
	//MARK:- Outlets
	@IBOutlet weak var categoryLabel: UILabel! {
		didSet {
			categoryLabel.text = ""
		}
	}
	@IBOutlet weak var showButton: UIButton! {
		didSet {
			showButton.layer.cornerRadius = 8
		}
	}
	@IBOutlet weak var savedButton: UIButton! {
		didSet {
			savedButton.isHidden = true
			savedButton.layer.cornerRadius = 8
		}
	}
	@IBOutlet weak var slider: UISlider!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var instructionLabel: UILabel!

	
	//MARK:- Actions
	
	

	@IBAction func categorySldierChanged(_ sender: UISlider) {
		slider.value = roundf(slider.value)
		switch sender.value {
		case 0.0:
			categoryLabel.text = "Cats"
		case 1.0:
			categoryLabel.text = "Sunglasses"
		case 2.0:
			categoryLabel.text = "Hats"
		case 3.0:
			categoryLabel.text = "Suprise!"
		default:
			break
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpView()
	}

	func setUpView() {
		slider.value = 1
		navigationController?.navigationBar.prefersLargeTitles = true
	}

	
}

