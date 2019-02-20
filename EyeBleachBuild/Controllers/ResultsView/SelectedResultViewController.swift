//
//  SelectedResultViewController.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 10/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import UIKit
import CoreData

protocol SelectedResultsViewControllerDelegate: class {
	func didTapSaveButton(item: String, sender: SelectedResultViewController)
}

class SelectedResultViewController: UIViewController {
	
	//MARK:- Properties
	var result: ResultsObject?
	var savedResult: SavedResult?
	var showSaved: Bool = false
	weak var delegate: SelectedResultsViewControllerDelegate?
	var shouldBeSaved: Bool = false
	lazy var activityIndicator: UIActivityIndicatorView = {
		var av = UIActivityIndicatorView()
		av.style = .gray
		av.startAnimating()
		return av
	}()
	
	//MARK:- Outlets
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var saveButton: UIButton! {
		didSet {
			saveButton.roundedTransparentButton()
		}
	}
	@IBOutlet weak var doneButton: UIButton! {
		didSet {
			saveButton.roundedTransparentButton()
		}
	}
	
	//MARK:- Actions
	@IBAction func didTapSaveButton(_ sender: Any) {
		save()
	}
	
	@IBAction func didTapDoneButton(_ sender: Any) {
		shouldBeSaved ? delegate?.didTapSaveButton(item: result!.url, sender: self) : dismiss(animated: true, completion: {
			self.shouldBeSaved ? print("saved item") : print("nothing saved")
		})
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.addSubview(activityIndicator)
		setUp()
    }
	
	func setUp() {
		if showSaved {
			print("showing saved")
			guard let data = savedResult else {return}
			guard let url = data.url else {return}
			imageView.loadImageFrom(urlString: url, closure: { (success) in
				if success {
					DispatchQueue.main.async {
						self.activityIndicator.stopAnimating()
						self.activityIndicator.removeFromSuperview()
					}
				}
			})
		} else {
			guard let data = result else {return}
			imageView.loadImageFrom(urlString: data.url, closure: {(success) in
				if success {
					DispatchQueue.main.async {
						self.activityIndicator.stopAnimating()
						self.activityIndicator.removeFromSuperview()
					}
				}
			})
		}
	}
	
	func save() {
		shouldBeSaved = !shouldBeSaved
	}
}
