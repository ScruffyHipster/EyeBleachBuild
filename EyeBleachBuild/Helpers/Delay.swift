//
//  Delay.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 28/03/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import Foundation

func delay(seconds: Double, completion: @escaping ()-> Void) {
	DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}
