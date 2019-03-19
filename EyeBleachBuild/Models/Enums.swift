//
//  Enums.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 03/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import Foundation
import UIKit


enum JSONrequestState {
	case NotSearched
	case Loading
	case Error
	case Success
}

enum CollectionViewCellIdentifier {
	case ResultsCollectionViewCell
	var identifier: String {
		switch self {
		case .ResultsCollectionViewCell:
			return "ResultsCollectionViewCell"
		}
	}
}

enum NibIdentifiers {
	case ResultsCollectionViewCellNib
	var identifiers: String {
		switch self {
		case .ResultsCollectionViewCellNib:
			return "ResultsCollectionViewCell"

		}
	}
}

enum SegueIdentifiers {
	case ResultsCollectionViewController
	case ResultViewerViewController
	case SavedResultsViewController
	case SavedResultsViewerViewController
	var identifier: String {
		switch self {
		case .ResultsCollectionViewController:
			return "ResultsCollectionViewController"
		case .ResultViewerViewController:
			return "ResultViewerViewController"
		case .SavedResultsViewController:
			return "SavedResultsViewController"
		case .SavedResultsViewerViewController:
			return "SavedResultsViewerViewController"
		}
	}
}

enum UsableColors {
	case orange
	case grey
	case black
	
	var colour: UIColor {
		switch self {
		case .grey:
			return UIColor(red: 121/255, green: 121/255, blue: 121/255, alpha: 1)
		case .black:
			return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
		case .orange:
			return UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
		}
	}
}
