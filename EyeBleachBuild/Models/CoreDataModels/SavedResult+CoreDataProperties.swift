//
//  SavedResult+CoreDataProperties.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 10/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedResult> {
        return NSFetchRequest<SavedResult>(entityName: "SavedResult")
    }

    @NSManaged public var url: String?

}
