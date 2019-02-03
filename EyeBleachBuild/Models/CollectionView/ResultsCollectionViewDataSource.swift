//
//  CollectionViewDataSource.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 03/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import Foundation
import UIKit


class ResultsCollectionViewDataSource: NSObject {
	
	var resultsDataArray: [ResultsObject]?
	
}


extension ResultsCollectionViewDataSource: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let data = resultsDataArray?.count else {return 1}
		return data
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.ResultsCollectionViewCell.identifier, for: indexPath) as! ResultsCollectionViewCell
		return cell
	}
	
	
}
