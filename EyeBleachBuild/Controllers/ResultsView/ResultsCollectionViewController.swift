//
//  ResultsCollectionViewController.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 03/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import UIKit

class ResultsCollectionViewController: UIViewController {
	
	//MARK: Properties
	
	lazy var collectionViewDataSource: ResultsCollectionViewDataSource = {
		let data = ResultsCollectionViewDataSource()
		data.resultsData = resultsData
		return data
	}()
	var resultsData: ResultsObjectData?
	
	//MARK:- Outlets
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		guard resultsData != nil else {
			print("error on loading data")
			return
		}
		setUpCollectionView()
	}
	
	//MARK:- Methods
	
	func setUpCollectionView() {
		collectionView.dataSource = collectionViewDataSource
		collectionView.delegate = self
		setUpCollectionViewCells()
		setUpCollecitonViewFlow()
	}
	
	func setUpCollectionViewCells() {
		let nib = UINib(nibName: NibIdentifiers.ResultsCollectionViewCellNib.identifiers, bundle: nil)
		collectionView.register(nib, forCellWithReuseIdentifier: CollectionViewCellIdentifier.ResultsCollectionViewCell.identifier)
	}
	
	func setUpCollecitonViewFlow() {
		//Set up instagram like colleciton view layout
		let width = (self.view.frame.width - 40) / 3
		let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		flow.itemSize = CGSize(width: width, height: width)
		flow.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		flow.minimumLineSpacing = 5.0
		flow.minimumInteritemSpacing = 5.0
	}
	
}

extension ResultsCollectionViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		//TODO:- Model card pop up from bottom. Best to have it pop out of frame into view rather than having a card view from the outset
	}
}
