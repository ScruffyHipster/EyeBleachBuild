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
		opacity(layer: activitySpinner.layer, from: 1.0, to: 0.0, duration: 0.4)
		opacity(layer: cancelButton.layer, from: 1.0, to: 0.0, duration: 0.4)
		scaleAndTransform(layer: showButton.layer, from: showButton.layer.position.y, to: showButton.layer.position.y - 30, duration: 0.6)
		opacity(layer: showButton.layer, from: 0.0, to: 1.0, duration: 0.4)
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
		scaleAndTransform(layer: cancelButton.layer, from: cancelButton.layer.position.y + 30, to: cancelButton.layer.position.y, duration: 0.6)
		view.addSubview(activitySpinner)
		scaleAndTransform(layer: activitySpinner.layer, from: cancelButton.layer.position.y, to: cancelButton.layer.position.y - 50, duration: 0.6)
		opacity(layer: showButton.layer, from: 1.0, to: 0.0, duration: 0.1)
		opacity(layer: cancelButton.layer, from: 0.0, to: 1.0, duration: 0.4)
		opacity(layer: activitySpinner.layer, from: 0.0, to: 1.0, duration: 0.4)
		slider.isUserInteractionEnabled = false
	}
	
	@objc func fadeText() {
		slider.setValue(roundf(slider.value), animated: true)
		fade(layer: self.categoryLabel.layer, from: 0.0, to: 1.0, duration: 0.2)
		UIView.animate(withDuration: 0.5) {
			switch self.slider.value {
			case 0:
				self.categoryLabel.text = "Funny"
			case 1:
				self.categoryLabel.text = "Space"
			case 2:
				self.categoryLabel.text = "Hats"
			case 3:
				self.categoryLabel.text = "Suprise"
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

extension HomeViewController {
	//MARK:- Animations
	
	func scaleAndTransform(layer: CALayer, from: CGFloat, to: CGFloat, duration: Double) {
		let scaleAndTransform = CABasicAnimation(keyPath: "position.y")
		scaleAndTransform.fromValue = from
		scaleAndTransform.toValue = to
		scaleAndTransform.duration = duration
		layer.add(scaleAndTransform, forKey: nil)
		layer.position.y = to
	}
	
	func opacity(layer: CALayer, from: Float, to: Float, duration: Double) {
		let opacityAnimation = CABasicAnimation(keyPath: "opacity")
		opacityAnimation.fromValue = from
		opacityAnimation.toValue = to
		opacityAnimation.duration = duration
		opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
		layer.add(opacityAnimation, forKey: nil)
		layer.opacity = to
	}
}

//MARK:- Animations/ Delegate
extension HomeViewController: CAAnimationDelegate {
	
	func startAnimation() {
		let fadeAnimation = CABasicAnimation(keyPath: "opacity")
		fadeAnimation.delegate = self
		fadeAnimation.fromValue = 0.0
		fadeAnimation.toValue = 1.0
		fadeAnimation.duration = 1.0
		titleLabel.layer.add(fadeAnimation, forKey: nil)
		fadeAnimation.beginTime = CACurrentMediaTime() + 0.1
		categoryLabel.layer.add(fadeAnimation, forKey: nil)
		fadeAnimation.beginTime = CACurrentMediaTime() + 0.1
		slider.layer.add(fadeAnimation, forKey: nil)
		let springPulse = CASpringAnimation(keyPath: "transform.scale")
		springPulse.duration = 0.5
		springPulse.initialVelocity = -10.0
		springPulse.mass = 1
		springPulse.damping = 10
		springPulse.stiffness = 100
		springPulse.duration = 1.0
		springPulse.fromValue = 1.4
		springPulse.toValue = 1.0
		titleLabel.layer.add(springPulse, forKey: nil)
	}
	
	
	func fade(layer: CALayer, from: Float, to: Float, duration: Double) {
		let fade = CABasicAnimation(keyPath: "opacity")
		fade.fromValue = from
		fade.toValue = to
		fade.duration = duration
		layer.add(fade, forKey: nil)
	}
	
	
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
	
	//MARK:- Animation Delegate methods
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
