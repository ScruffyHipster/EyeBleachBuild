//
//  ResultsCollectionViewController.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 03/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import UIKit
import CoreData

class ResultsCollectionViewController: UIViewController {
	
	//MARK: Properties
	
	lazy var collectionViewDataSource: ResultsCollectionViewDataSource = {
		let data = ResultsCollectionViewDataSource()
		data.resultsData = resultsData
		return data
	}()
	var resultsData: ResultsObjectData?
	var managedObjectContext: NSManagedObjectContext?
	
	//MARK:- Outlets
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	//MARK:- Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		guard resultsData != nil else {
			print("error on loading data")
			return
		}
		setUpCollectionView()
	}
	
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
	
	//MARK:- Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == SegueIdentifiers.ResultViewerViewController.identifier {
			guard let data = collectionViewDataSource.resultsData?.objectDataArray else {return}
			let vc = segue.destination as! SelectedResultViewController
			let indexPath = sender as! IndexPath
			let result = data[indexPath.row]
			vc.result = result as? ResultsObject
			vc.delegate = self
		}
	}
	
	//MARK:- Deinit
	deinit {
		//General housekeeping
		imageCache.removeAllObjects()
	}
	
}

extension ResultsCollectionViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		performSegue(withIdentifier: SegueIdentifiers.ResultViewerViewController.identifier, sender: indexPath)
		//TODO:- Model card pop up from bottom. Best to have it pop out of frame into view rather than having a card view from the outset
	}
}

extension ResultsCollectionViewController: SelectedResultsViewControllerDelegate {
	func didTapSaveButton(item: String, sender: SelectedResultViewController) {
		//TODO:- add in save function here to coredata
		guard let managedObjectContext = managedObjectContext else {return}
		let saveResult = SavedResult(context: managedObjectContext)
		saveResult.url = item
		do {
			try managedObjectContext.save()
			UserDefaults.standard.set(true, forKey: "savedImage")
		} catch {
			print("Error occured when trying to save \(error.localizedDescription)")
		}
		dismiss(animated: true, completion: nil)
	}
}
