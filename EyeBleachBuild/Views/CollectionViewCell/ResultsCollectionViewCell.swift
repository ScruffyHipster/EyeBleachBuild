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
			backGroundView.backgroundColor = UIColor.gray
			backGroundView.addSubview(activityIndicator)
		}
	}
	
	
	var downloadTask: URLSessionDownloadTask?
	lazy var activityIndicator: UIActivityIndicatorView = {
		var av = UIActivityIndicatorView(style: .whiteLarge)
		av.startAnimating()
		av.alpha = 1
		return av
	}()
	
    override func awakeFromNib() {
        super.awakeFromNib()
		backGroundView.layer.cornerRadius = 8
		backGroundView.clipsToBounds = true
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
			backgroundImage.loadImageFrom(urlString: url, closure: {(success) in
				if success {
					DispatchQueue.main.async {
						self.activityIndicator.stopAnimating()
						self.activityIndicator.removeFromSuperview()
					}
				}
			})
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		backgroundImage.image = nil
	}

}
