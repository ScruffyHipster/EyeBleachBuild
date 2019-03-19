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
	let request = HTTPRequest.shared
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
	@IBOutlet weak var imageView: UIImageView! {
		didSet {
			imageView.layer.cornerRadius = 8.0
			imageView.clipsToBounds = true
		}
	}
	@IBOutlet weak var shadowView: UIView! {
		didSet {
			shadowView.layer.cornerRadius = 8
			shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
			shadowView.layer.shadowColor = UIColor.black.cgColor
			shadowView.layer.shadowOpacity = 0.4
			shadowView.layer.shadowRadius = 3.0
			shadowView.layer.masksToBounds = false
		}
	}
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var doneButton: UIBarButtonItem!
	
	//MARK:- Actions
	@IBAction func didTapSaveButton(_ sender: Any) {
		save()
		if let url = result?.url {
			print("Saving image")
			request.downloadImage(url)
		}
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
		navigationController?.navigationBar.prefersLargeTitles = false
    }
	
	func setUp() {
		saveButton.isHidden = showSaved
		if showSaved {
			print("showing saved")
			guard let data = savedResult else {return}
			guard let url = data.url else {return}
			let savedImage = retriveImages(url: url)
			imageView.loadImageFrom(urlString: savedImage, closure: { (success) in
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
	
	func retriveImages(url: String) -> String {
		//FileManager
		let fileManager = FileManager.default
		var urlToReturn = ""
		do {
			//Gets path to the folder in the documents directory using global constant --
			//TODO:- needs to change
			let path = try fileManager.contentsOfDirectory(at: filePath, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
			//retrives the image from the document directory
			let image = fileManager.localFileUrl(for: URL(string: url)!).absoluteString
			urlToReturn = image
			print(image)
			print(path)
		} catch {
			print("Error: \(error.localizedDescription)")
		}
		return urlToReturn
	}
	
	
	func save() {
		shouldBeSaved = !shouldBeSaved
		saveButton.isSelected = shouldBeSaved
	}
}
