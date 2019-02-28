//
//  FileManager.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 21/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import Foundation

let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

extension FileManager {
	
	func localFileUrl(for url: URL) -> URL {
		return filePath.appendingPathComponent(url.lastPathComponent)
	}
}

func removeFile(from url: String) {
	do {
		let manager = FileManager.default
		let path = try manager.contentsOfDirectory(at: filePath, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
		let image = manager.localFileUrl(for: URL(string: url)!)
		for item in path {
			if item.absoluteString == image.absoluteString {
				do {
					try manager.removeItem(at: item)
					print("removed item \(item)")
				} catch {
					print(error.localizedDescription)
				}
			}
		}
	} catch {
		print("error \(error.localizedDescription)")
	}
}
