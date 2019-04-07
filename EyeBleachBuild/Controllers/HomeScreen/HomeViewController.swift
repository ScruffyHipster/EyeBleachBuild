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
	var slideGesture: UIPanGestureRecognizer?
	
	lazy var resultsData: ResultsObjectData = {
		let data = ResultsObjectData()
		return data
	}()
	lazy var activitySpinner: UIActivityIndicatorView = {
		var spinner = UIActivityIndicatorView()
		spinner.style = .whiteLarge
		spinner.color = UsableColors.grey.colour
		spinner.startAnimating()
		spinner.center.x = view.center.x
		return spinner
	}()
	lazy var usableAnimations: UsableAnimations = {
		return UsableAnimations()
	}()
	
	//MARK:- Outlets
	@IBOutlet weak var categoryLabel: UILabel! {
		didSet {
			categoryLabel.text = "Space"
		}
	}
	@IBOutlet weak var showButton: UIButton!
	@IBOutlet weak var savedButton: UIButton!
	@IBOutlet weak var slider: UISlider! {
		didSet {
			slider.thumbTintColor = UsableColors.grey.colour
			slider.isContinuous = false
			slider.addTarget(self, action: #selector(fadeText), for: .touchDragInside)
		}
	}
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var cancelButton: UIButton!
	
	//MARK:- Actions
	@IBAction func didTapShowMeButton(_ sender: Any) {
		moveButtons()
		switch slider.value {
		case 0.0:
			category = nil
		case 1.0:
			category = 2
		case 2.0:
			category = 14
		case 3.0:
			category = 4
		default:
			break
		}
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
				DispatchQueue.main.async {
					self.performSegue(withIdentifier: SegueIdentifiers.ResultsCollectionViewController.identifier, sender: nil)
				}
			}
		})
	}
	
	@IBAction func didTapSavedButton(_ sender: Any) {
		performSegue(withIdentifier: SegueIdentifiers.SavedResultsViewController.identifier, sender: nil)
	}
	
	@IBAction func didTapCancel() {
		request.cancel()
		slider.isUserInteractionEnabled = true
		usableAnimations.opacity(layer: activitySpinner.layer, from: 1.0, to: 0.0, duration: 0.4)
		usableAnimations.opacity(layer: cancelButton.layer, from: 1.0, to: 0.0, duration: 0.4)
		usableAnimations.scaleAndTransform(layer: showButton.layer, from: showButton.layer.position.y, to: showButton.layer.position.y - 30, duration: 0.6)
		usableAnimations.opacity(layer: showButton.layer, from: 0.0, to: 1.0, duration: 0.4)
	}
	
	//MARK:- Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpView()
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = true
		slider.isUserInteractionEnabled = true
		checkForSavedImages()
		self.showButton.alpha = 1.0
		self.showButton.transform = .identity
		self.savedButton.alpha = 1.0
		self.cancelButton.alpha = 0.0
		self.activitySpinner.removeFromSuperview()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.navigationBar.isHidden = false
	}
	
	func setUpView() {
		slider.value = 1
		navigationController?.navigationBar.isHidden = true
		startAnimation()
	}
	
	func checkForSavedImages() {
		//CoreData
		guard let resultsSaved = UserDefaults.standard.object(forKey: "savedImage") as? Bool else {return}
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
	
	func moveButtons() {
		if !savedButton.isHidden {
			UIView.animate(withDuration: 0.2) {
				self.savedButton.alpha = 0.0
			}
		}
		usableAnimations.scaleAndTransform(layer: cancelButton.layer, from: cancelButton.layer.position.y + 30, to: cancelButton.layer.position.y, duration: 0.6)
		view.addSubview(activitySpinner)
		usableAnimations.scaleAndTransform(layer: activitySpinner.layer, from: cancelButton.layer.position.y, to: cancelButton.layer.position.y - 50, duration: 0.6)
		usableAnimations.opacity(layer: showButton.layer, from: 1.0, to: 0.0, duration: 0.1)
		usableAnimations.opacity(layer: cancelButton.layer, from: 0.0, to: 1.0, duration: 0.4)
		usableAnimations.opacity(layer: activitySpinner.layer, from: 0.0, to: 1.0, duration: 0.4)
		slider.isUserInteractionEnabled = false
	}
	
	@objc func fadeText() {
		slider.setValue(roundf(slider.value), animated: true)
		usableAnimations.fade(layer: self.categoryLabel.layer, from: 0.0, to: 1.0, duration: 0.2)
		UIView.animate(withDuration: 0.5) {
			switch self.slider.value {
			case 0:
				self.categoryLabel.text = "some cats"
			case 1:
				self.categoryLabel.text = "some cats in space"
			case 2:
				self.categoryLabel.text = "some cats in sinks"
			case 3:
				self.categoryLabel.text = "some random cats"
			default:
				break
			}
		}
	}
	
}

//MARK:- Navigation
extension HomeViewController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case SegueIdentifiers.ResultsCollectionViewController.identifier:
			let vc = segue.destination as! ResultsCollectionViewController
			vc.resultsData = resultsData
			vc.usableAnimations = usableAnimations
			vc.navigationItem.title = categoryLabel.text
			vc.managedObjectContext = managedObjectContext
		case SegueIdentifiers.SavedResultsViewController.identifier:
			let vc = segue.destination as! ResultsCollectionViewController
			vc.resultsData = resultsData
			vc.usableAnimations = usableAnimations
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
	
	func startAnimation() {
		let fadeAnimation = usableAnimations.fadeAnimation
		fadeAnimation.delegate = self
		titleLabel.layer.add(fadeAnimation, forKey: nil)
		fadeAnimation.beginTime = CACurrentMediaTime() + 0.1
		categoryLabel.layer.add(fadeAnimation, forKey: nil)
		fadeAnimation.beginTime = CACurrentMediaTime() + 0.1
		slider.layer.add(fadeAnimation, forKey: nil)
		titleLabel.layer.add(usableAnimations.springPulse, forKey: nil)
	}
	
	
	
	func animateLabelsRight(_ labels: [CALayer]) {
		//Can only add two labels at the moment
		let labelGroup = CAAnimationGroup()
		labelGroup.delegate = self
		
		let flyRight = usableAnimations.flyRight
		flyRight.fromValue = -view.bounds.width / 2
		flyRight.toValue = view.bounds.width / 2
		
		labelGroup.animations = [flyRight, usableAnimations.fadeIn]
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
	
	//MARK:- Animation Delegate methods
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		guard let name = anim.value(forKey: "name") as? String else {return}
		if name == "labelGroup" {
			let layer = anim.value(forKey: "layer") as? CALayer
			anim.setValue(nil, forKey: "layer")
			layer?.add(usableAnimations.pulse, forKey: nil)
		}
	}
}
