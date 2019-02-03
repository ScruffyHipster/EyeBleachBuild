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
	

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	func configure(with data: ResultsData) {
		
	}

}
