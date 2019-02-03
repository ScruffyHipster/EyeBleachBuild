//
//  ResultsObjectData.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 03/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import Foundation
import UIKit

class ResultsObjectData {
	
	var objectDataArray: [ResultsObject]?
	
	func populateData(with data: [ResultsObject]) {
		objectDataArray = data
	}
	
	func returnObjects() -> [ResultsObject] {
		guard let data = objectDataArray else {return []}
		return data
	}
	
}
