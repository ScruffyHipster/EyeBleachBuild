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
			return "resultsCollectionViewCell"
		}
	}
}

enum NibIdentifiers {
	case ResultsCollectionViewCellNib
	
	var identifiers: String {
		switch self {
		case .ResultsCollectionViewCellNib:
			return "ResultsCollectionViewCellNib"

		}
	}
}
