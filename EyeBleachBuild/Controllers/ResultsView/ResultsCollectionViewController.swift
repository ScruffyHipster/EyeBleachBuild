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
		return data
	}()
	
	//MARK:- Outlets
	
	@IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
		setUpCollectionView()
        // Do any additional setup after loading the view.
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
		collectionView.register(nib, forCellWithReuseIdentifier: NibIdentifiers.ResultsCollectionViewCellNib.identifiers)
	}
	
	func setUpCollecitonViewFlow() {
		//Set up instagram like colleciton view layout
		let width = (self.view.frame.width - 40) / 3
		let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		flow.collectionView?.contentSize = CGSize(width: width, height: width)
		flow.collectionView?.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
		flow.minimumLineSpacing = 10.0
		flow.minimumInteritemSpacing = 10.0
	}

}

extension ResultsCollectionViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		//TODO:- Model card pop up from bottom. Best to have it pop out of frame into view rather than having a card view from the outset
	}
}
