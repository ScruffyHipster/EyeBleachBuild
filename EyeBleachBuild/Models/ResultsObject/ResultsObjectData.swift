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
	
	var objectDataArray: [AnyObject]?
	
	func populateData<T>(with data: [T]) {
		objectDataArray = data as [AnyObject]
	}
	
	func returnObjects<T>() -> [T] {
		guard let data = objectDataArray else {return []}
		return data as! [T]
	}
	
}
