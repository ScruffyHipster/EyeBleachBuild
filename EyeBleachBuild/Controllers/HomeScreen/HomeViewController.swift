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
	lazy var acitivtySpinner: UIActivityIndicatorView = {
		var spinner = UIActivityIndicatorView()
		spinner.style = .whiteLarge
		spinner.color = UsableColors.grey.colour
		spinner.startAnimating()
		return spinner
	}()
	
	//MARK:- Outlets
	@IBOutlet weak var categoryLabel: UILabel! {
		didSet {
			categoryLabel.text = "Space"
		}
	}
	@IBOutlet weak var showButton: UIButton! {
		didSet {
			
		}
	}
	@IBOutlet weak var savedButton: UIButton! {
		didSet {

		}
	}
	@IBOutlet weak var slider: UISlider! {
		didSet {
			slider.thumbTintColor = UsableColors.grey.colour
		}
	}
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var cancelButton: UIButton!
	
	//MARK:- Actions
	@IBAction func didTapShowMeButton(_ sender: Any) {
		addSpinner()
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
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let url = request.createUrl(category: category)
		request.makeRequest(url: url, for: ResultsObjectDict.self, closure: { (success, data) in
			if success == false {
				createAlert(vc: self, title: "Error", message: "Sorry, an error occured. Cannot retrive data from server", style: .alert)
				DispatchQueue.main.async {
					UIApplication.shared.isNetworkActivityIndicatorVisible = false
				}
			} else if success == true {
				self.resultsData.populateData(with: data)
//				print(data)
				DispatchQueue.main.async {
					self.performSegue(withIdentifier: SegueIdentifiers.ResultsCollectionViewController.identifier, sender: nil)
				}
			}
		})
	}
	
	@IBAction func didTapSavedButton(_ sender: Any) {
		performSegue(withIdentifier: SegueIdentifiers.SavedResultsViewController.identifier, sender: nil)
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
	
	@IBAction func didTapCancel() {
		request.cancel()
		acitivtySpinner.alpha = 0.0
		cancelButton.alpha = 0.0
		savedButton.alpha = 1.0
		showButton.alpha = 1.0
	}
	
	//MARK:- Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpView()
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//		checkForSavedImages()
//		animateLabelsRight([titleLabel.layer, instructionLabel.layer])
	}
	
	func setUpView() {
		slider.value = 1
		navigationController?.navigationBar.isHidden = true
	}
	
	func checkForSavedImages() {
		//CoreData
		let resultsSaved = UserDefaults.standard.object(forKey: "savedImage") as! Bool
		savedButton.isHidden = !resultsSaved
		if resultsSaved == true {
			print("true")
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
	
	func addSpinner() {
		showButton.alpha = 0.0
		savedButton.alpha = 0.0
		cancelButton.alpha = 1.0
		slider.isUserInteractionEnabled = false
		acitivtySpinner.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height - view.frame.size.height / 5)
		view.addSubview(acitivtySpinner)
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

//MARK:- Animations/ Delegate
extension HomeViewController: CAAnimationDelegate {
	
	func animateLabelsRight(_ labels: [CALayer]) {
		//Can only add two labels at the moment
		let labelGroup = CAAnimationGroup()
		labelGroup.delegate = self
		let flyRight = CABasicAnimation(keyPath: "position.x")
		flyRight.fromValue = -view.bounds.width / 2
		flyRight.toValue = view.bounds.width / 2
		
		let fadeIn = CABasicAnimation(keyPath: "opacity")
		fadeIn.fromValue = 0.0
		fadeIn.toValue = 1
		
		labelGroup.animations = [flyRight, fadeIn]
		labelGroup.duration = 1.0
		labelGroup.setValue("labelGroup", forKey: "name")
		
		for label in labels {
			guard let i = labels.firstIndex(of: label) else {return}
			labelGroup.setValue(label, forKey: "layer")
			if i == 0 {
				labelGroup.beginTime = CACurrentMediaTime() + 0.3
				label.add(labelGroup, forKey: nil)
			} else if i == 1 {
				labelGroup.beginTime = CACurrentMediaTime() + 0.6
				label.add(labelGroup, forKey: nil)
			}
		}
	}
	
	//Delegate methods
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		guard let name = anim.value(forKey: "name") as? String else {return}
		if name == "labelGroup" {
			let layer = anim.value(forKey: "layer") as? CALayer
			anim.setValue(nil, forKey: "layer")
			let pulse = CASpringAnimation(keyPath: "transform.scale")
			pulse.fromValue = 0.85
			pulse.toValue = 1.00
			pulse.damping = 7.5
			pulse.duration = 2.0
			layer?.add(pulse, forKey: nil)
		}
	}
}
