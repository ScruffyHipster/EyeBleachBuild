//
//  ResultsData.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 03/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import Foundation

//Type alias is used to help parse dictionary JSON
typealias ResultsObjectDict = [ResultsObject]

struct ResultsObject: Codable {
	let id: String
	let url: String
	let categories: [Category]?
}

struct Category: Codable {
	let id: Int
	let name: String
}




