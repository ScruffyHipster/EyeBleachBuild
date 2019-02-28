//
//  HttpRequest.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 03/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import Foundation

class HTTPRequest: NSObject {
	
	//MARK:- Properties
	
	//Singleton Access
	static let shared = HTTPRequest()
	
	var state: JSONrequestState = .NotSearched
	var dataTask: URLSessionDataTask?
	var activeDownload: [URL: URLSessionDownloadTask] = [:]
	let headers = [
		"x-api-key" : "386f6edf-ec2b-4baf-91dd-686d132bf0b8"
	]
	lazy var decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		return decoder
	}()
	lazy var session: URLSession = {
		let config = URLSessionConfiguration.default
		return URLSession(configuration: config, delegate: self, delegateQueue: nil)
	}()
	
	//MARK:- Methods
	
	func createUrl(category: Int) -> URLRequest {
		let url = URL(string: "https://api.thecatapi.com/v1/images/search?category_ids=\(category)&limit=30")
		var request = URLRequest(url: url!)
		request.httpMethod = "GET"
		request.allHTTPHeaderFields = headers
		request.timeoutInterval = 300
		return request
	}
	
	func makeRequest<T: Codable>(url request: URLRequest, for dataStructure: T.Type, closure: @escaping (Bool, ([AnyObject])) -> (Void)) {
		var success = false
		print("Request made is as follows \(request)")
		dataTask?.cancel()
		dataTask = session.dataTask(with: request) { (data, response, error) in
			guard let response = response as? HTTPURLResponse else {
				success = false
				closure(success, [])
				return
			}
			if response.statusCode == 200 {
				guard let data = data else {return}
				do {
					let jsonData = try self.decoder.decode(dataStructure.self, from: data)
					success = true
					print("The json comes in like \(jsonData)")
					self.state = .Success
					closure(success, jsonData as! ([AnyObject]))
				} catch {
					success = false
					self.state = .Error
					print(error.localizedDescription)
					closure(success, [])
				}
			} else if response.statusCode == 1009 {
				guard let error = error as NSError? else {return}
				print(error.localizedDescription)
				self.state = .Error
				success = false
				closure(success, [])
			}
		}
		dataTask?.resume()
	}
	
	func downloadImage(_ imageUrl: String) {
		let imageUrl = URL(string: imageUrl)
		if let url = imageUrl {
			let download = session.downloadTask(with: url)
			download.resume()
			activeDownload[url] = download
		}
	}
}


extension HTTPRequest: URLSessionDownloadDelegate {
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		print("Downloaded image to \(location)")
		
		guard let sourceUrl = downloadTask.originalRequest?.url else {return}
		
		activeDownload[sourceUrl] = nil
		
		let fileManager = FileManager.default
		
		let destinationUrl = fileManager.localFileUrl(for: sourceUrl)
		print("Source url is \(sourceUrl)")
		print(destinationUrl)
		
		try? fileManager.removeItem(at: destinationUrl)
		do {
			try fileManager.copyItem(at: location, to: destinationUrl)
		} catch let error {
			print(error.localizedDescription)
		}
	}
	
	
}
