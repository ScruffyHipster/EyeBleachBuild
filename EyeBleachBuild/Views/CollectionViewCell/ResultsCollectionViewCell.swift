//
//  ResultsCollectionViewCollectionViewCell.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 03/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import UIKit

class ResultsCollectionViewCell: UICollectionViewCell {
	
	//MARK:- Properties
	
	//MARK:- Outlets
	
	@IBOutlet weak var backgroundImage: UIImageView! {
		didSet {
			backgroundImage.layer.cornerRadius = 8
			backgroundImage.clipsToBounds = true
		}
	}
	@IBOutlet weak var backGroundView: UIView! {
		didSet {
			backGroundView.backgroundColor = UsableColors.grey.colour
			activityIndicator.center = backGroundView.center
			backGroundView.addSubview(activityIndicator)
		}
	}
	@IBOutlet weak var selectionImage: UIImageView! {
		didSet {
			selectionImage.isHidden = true
		}
	}
	
	var downloadTask: URLSessionDownloadTask?
	lazy var activityIndicator: UIActivityIndicatorView = {
		var av = UIActivityIndicatorView(style: .whiteLarge)
		av.startAnimating()
		av.alpha = 1
		return av
	}()
	var isEditing: Bool = false {
		didSet {
			return selectionImage.isHidden = !isEditing
		}
	}
	override var isSelected: Bool {
		didSet {
			if isEditing {
				return selectionImage.image = isSelected ? UIImage(named: "tick") : UIImage(named: "empty")
			}
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
		backGroundView.layer.cornerRadius = 8
		backGroundView.clipsToBounds = true
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 2, height: 4)
		layer.shadowRadius = 3.0
		layer.shadowOpacity = 0.4
		layer.masksToBounds = false
    }
	
	override func draw(_ rect: CGRect) {
		activityIndicator.center = CGPoint(x: round(self.backGroundView.frame.width / 2), y: self.backGroundView.frame.width / 2)
	}
	
	func configureGeneric<T>(with data: T?) {
		if let resultData = data as? ResultsObject {
			backgroundImage.loadImageFrom(urlString: resultData.url, closure: {(success) in
				if success {
					DispatchQueue.main.async {
						self.activityIndicator.stopAnimating()
self.activityIndicator.removeFromSuperview()
					}
				}
			})
		} else if let savedData = data as? SavedResult {
			guard let url = savedData.url else {
				print("failed")
				return
			}
			//retrives from disk
			let savedImage = retriveImages(url: url)
			backgroundImage.loadImageFrom(urlString: savedImage, closure: {(success) in
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
	
	override func prepareForReuse() {
		super.prepareForReuse()
		backgroundImage.image = nil
	}

}
