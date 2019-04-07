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
	var request = HTTPRequest.shared
	var showingSaved: Bool = false
	var usableAnimations: UsableAnimations?
	var managedObjectContext: NSManagedObjectContext?
	
	//MARK:- Outlets
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var infoLabel: UILabel!
	
	//MARK:- Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		guard usableAnimations != nil else {return}
		guard resultsData != nil else {
			print("error on loading data")
			return
		}
		setUpCollectionView()
		setupNavigationBarView()
		setUpForSaved(showingSaved)
	}
	
	
	func setupNavigationBarView() {
		guard let navBar = navigationController?.navigationBar else {return}
		navBar.isHidden = false
		navBar.prefersLargeTitles = true
//		navigationController?.navigationBar.backgroundColor = UIColor.clear
//		navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key("foregroundColor") : UIColor(red: 121/255, green: 121/255, blue: 121/255, alpha: 0)]
		navBar.addShadow(radius: 2.0, offSet: CGSize(width: 1.0, height: 1.0), color: UIColor.black.cgColor, opacity: 0.4)
	}
	

	func setUpForSaved(_ saved: Bool) {
		if saved {
			navigationItem.rightBarButtonItem = editButtonItem
			isEditing = false
		}
	}
	
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: true)
		collectionView.allowsMultipleSelection = editing
		navigationItem.leftBarButtonItem = editing ? UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteItems)) : nil
		let indexs = collectionView.indexPathsForVisibleItems
		for index in indexs {
			let cell = collectionView.cellForItem(at: index) as? ResultsCollectionViewCell
			cell?.isEditing = editing
		}
	}
	
	@objc func deleteItems() {
		let selectedCells = collectionView.indexPathsForSelectedItems
		let deleteAlert = UIAlertController(title: "Delete", message: "Do you want to delete these items?", preferredStyle: .actionSheet)
		deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
			guard let selected = selectedCells else {return}
			let items = selected.map({$0}).sorted().reversed()
			for item in items {
				guard let data = self.resultsData?.objectDataArray?[item.row] as? SavedResult else {return}
				self.resultsData?.objectDataArray?.remove(at: item.row)
				removeFile(from: (data.url!))
				self.managedObjectContext?.delete(data)
				do {
					try self.managedObjectContext?.save()
				} catch {
					print("Error \(error.localizedDescription)")
					let alert = UIAlertController(title: "Error", message: "Had an issue trying to delete the item. If issue persists please contact the developer. Sorry for any annoyance caused!!", preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				}
				if (self.resultsData?.objectDataArray?.count)! <= 0 {
					UserDefaults.standard.set(false, forKey: "savedImage")
					self.isEditing = false
					self.navigationItem.rightBarButtonItem?.isEnabled = false
					UIView.animate(withDuration: 0.5, animations: {
						self.infoLabel.alpha = 1.0
					})
				}
				self.collectionView.reloadData()
			}
		}))
		deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
			print("Cancelled")
		}))
		present(deleteAlert, animated: true)
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
		let width = (self.view.frame.width - 30) / 2
		let height = (self.view.frame.height / 3) - 10
		let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		flow.itemSize = CGSize(width: width, height: height)
		flow.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		flow.minimumLineSpacing = 20.0
		flow.minimumInteritemSpacing = 5.0
	}
	
	//MARK:- Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case SegueIdentifiers.ResultViewerViewController.identifier:
			guard let data = self.collectionViewDataSource.resultsData?.objectDataArray else {return}
			let vc = segue.destination as! SelectedResultViewController
			let indexPath = sender as! IndexPath
			let result = data[indexPath.row]
			vc.result = result as? ResultsObject
			vc.usableAnimations = usableAnimations
			vc.delegate = self
		case SegueIdentifiers.SavedResultsViewerViewController.identifier:
			print("showing saved cats")
			guard let data = self.collectionViewDataSource.resultsData?.objectDataArray else {return}
			let vc = segue.destination as! SelectedResultViewController
			let indexPath = sender as! IndexPath
			let result = data[indexPath.row]
			vc.showSaved = true
			vc.savedResult = result as? SavedResult
			vc.delegate = self
		default:
			break
		}
	}
	
	//MARK:- Deinit
	deinit {
		//General housekeeping
		imageCache.removeAllObjects()
	}
}

//MARK:- Collection view delegate
extension ResultsCollectionViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if !isEditing {
			showingSaved ? performSegue(withIdentifier: SegueIdentifiers.SavedResultsViewerViewController.identifier, sender: indexPath) : performSegue(withIdentifier: SegueIdentifiers.ResultViewerViewController.identifier, sender: indexPath)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		let lastIndex = collectionViewDataSource.resultsDataArray!.count - 1
		if indexPath.row == lastIndex {
			print("at end")
		}
	}
}

//MARK:- SelectedResultsControllerDelegate
extension ResultsCollectionViewController: SelectedResultsViewControllerDelegate {
	func didTapSaveButton(item: String, sender: SelectedResultViewController) {
		guard let managedObjectContext = managedObjectContext else {return}
		let saveResult = SavedResult(context: managedObjectContext)
		saveResult.url = item
		do {
			try managedObjectContext.save()
			UserDefaults.standard.set(true, forKey: "savedImage")
		} catch {
			print("Error occured when trying to save \(error.localizedDescription)")
		}
		UserDefaults.standard.set(true, forKey: "savedImage")
		dismiss(animated: true, completion: nil)
	}
}
