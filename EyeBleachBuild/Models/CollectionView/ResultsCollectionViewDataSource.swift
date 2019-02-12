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
	
	var resultsDataArray: [AnyObject]? {
		get {
			return resultsData?.returnObjects()
		}
	}
	var resultsData: ResultsObjectData?
}


extension ResultsCollectionViewDataSource: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let data = resultsDataArray else {return 0}
		print(data.count)
		return data.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.ResultsCollectionViewCell.identifier, for: indexPath) as! ResultsCollectionViewCell
		guard let data = resultsDataArray else {return cell}
		cell.configureGeneric(with: data[indexPath.row])
		return cell
	}
	
	
}
