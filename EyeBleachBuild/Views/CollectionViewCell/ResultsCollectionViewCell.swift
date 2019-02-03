//
//  ResultsCollectionViewCollectionViewCell.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 03/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import UIKit

class ResultsCollectionViewCell: UICollectionViewCell {
	
	//MARK:- Outlets
	
	@IBOutlet weak var backgroundImage: UIImageView!
	
	var downloadTask: URLSessionDownloadTask?

    override func awakeFromNib() {
        super.awakeFromNib()
		self.layer.cornerRadius = 8
    }
	
	func configure(with data: ResultsObject) {
		let urlString = URL(string: data.url)
		guard let url = urlString else {return}
		downloadTask = backgroundImage.loadImageFrom(url: url)
	}

}
