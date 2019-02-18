//
//  ViewController.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 03/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
	
//MARK:- Properties
	var request = HTTPRequest.shared
	var category: Int?
	var managedObjectContext: NSManagedObjectContext?
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
			showButton.roundedTransparentButton()
		}
	}
	@IBOutlet weak var savedButton: UIButton! {
		didSet {
			savedButton.roundedTransparentButton()
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
		request.makeRequest(url: url, for: ResultsObjectDict.self, closure: { (success, data) in
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
	@IBAction func didTapSavedButton(_ sender: Any) {
		checkForSavedImages()
		performSegue(withIdentifier: SegueIdentifiers.SavedResultsViewController.identifier, sender: nil)
	}
	
	func checkForSavedImages() {
		let resultsSaved = UserDefaults.standard.object(forKey: "savedImage") as! Bool
		if resultsSaved == true {
			let fetchedRequest = NSFetchRequest<SavedResult>()
			let entity = SavedResult.entity()
			fetchedRequest.entity = entity
			do {
				let savedData = try managedObjectContext?.fetch(fetchedRequest)
				guard let data = savedData else {return}
				self.resultsData.populateData(with: data)
			} catch {
				print(error.localizedDescription)
			}
		}
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
	
//MARK:- Methods
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
			vc.managedObjectContext = managedObjectContext
		case SegueIdentifiers.SavedResultsViewController.identifier:
			let vc = segue.destination as! ResultsCollectionViewController
			vc.resultsData = resultsData
			vc.showingSaved = true
			vc.navigationItem.title = "Saved Doses"
			vc.managedObjectContext = managedObjectContext
		default:
			break
		}
	}
}

