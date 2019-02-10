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
	var category: Int?
	lazy var resultsData: ResultsObjectData = {
		let data = ResultsObjectData()
		return data
	}()
	//MARK:- Outlets
	@IBOutlet weak var categoryLabel: UILabel! {
		didSet {
			categoryLabel.text = "Space"
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
	@IBAction func didTapShowMeButton(_ sender: Any) {
		switch slider.value {
		case 0.0:
			category = 1
		case 1.0:
			category = 2
		case 2.0:
			category = 3
		case 3.0:
			category = 4
		default:
			break
		}
		
		guard let category = category else {return}
		let url = request.createUrl(category: category)
		request.makeRequest(url: url, closure: { (success, data) in
			if success == false {
				createAlert(vc: self, title: "Error", message: "Sorry, an error occured. Cannot retrive data from server", style: .alert)
			} else if success == true {
				self.resultsData.populateData(with: data)
				print(data)
				DispatchQueue.main.async {
					self.performSegue(withIdentifier: SegueIdentifiers.ResultsCollectionViewController.identifier, sender: nil)
				}
			}
		})
	}
	

	@IBAction func categorySldierChanged(_ sender: UISlider) {
		slider.value = roundf(slider.value)
		switch sender.value {
		case 0.0:
			categoryLabel.text = "Hats"
		case 1.0:
			categoryLabel.text = "Space"
		case 2.0:
			categoryLabel.text = "Funny"
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

//MARK:- Navigation
extension HomeViewController {
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case SegueIdentifiers.ResultsCollectionViewController.identifier:
			let vc = segue.destination as! ResultsCollectionViewController
			vc.resultsData = resultsData
			vc.navigationItem.title = categoryLabel.text
		default:
			break
		}
	}
}

