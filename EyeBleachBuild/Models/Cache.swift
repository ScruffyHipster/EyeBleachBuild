//
//  Cache.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 10/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import Foundation
import UIKit

//Creates a cache to store images in. 
var imageCache = NSCache<NSString, UIImage>()
var savedImageCache = NSCache<NSString, UIImage>()
