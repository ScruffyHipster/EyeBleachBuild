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
	
	@IBOutlet weak var backgroundImage: UIImageView!
	@IBOutlet weak var backGroundView: UIView!
	
	
	var downloadTask: URLSessionDownloadTask?

    override func awakeFromNib() {
        super.awakeFromNib()
		backGroundView.layer.cornerRadius = 6
		backGroundView.clipsToBounds = true
		self.addShadow(radius: 8, offSet: CGSize(width: 3, height: 3), color: UIColor.black.cgColor, opacity: 0.8)
    }
	
	func configure(with data: ResultsObject) {
		backgroundImage.loadImageFrom(urlString: data.url)
	}
	
	func configureGeneric<T>(with data: T?) {
		if let resultData = data as? ResultsObject {
			backgroundImage.loadImageFrom(urlString: resultData.url)
		} else if let savedData = data as? SavedResult {
			guard let url = savedData.url else {print("failed")
				return
			}
			backgroundImage.loadImageFrom(urlString: url)
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		backgroundImage.image = nil
	}

}
