//
//  HttpRequest.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 03/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import Foundation

class HTTPRequest {
	
	//MARK:- Properties
	
	//Singleton Access
	static let shared = HTTPRequest()
	
	var state: JSONrequestState = .NotSearched
	let headers = [
		"x-api-key" : "386f6edf-ec2b-4baf-91dd-686d132bf0b8"
	]
	lazy var decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		return decoder
	}()
	
	//MARK:- Methods
	
	func createUrl(category: Int) -> URLRequest {
		let url = URL(string: "https://api.thecatapi.com/v1/images/search?category_ids=\(category)&limit=30")
		var request = URLRequest(url: url!)
		request.httpMethod = "GET"
		request.allHTTPHeaderFields = headers
		return request
	}
	
	func makeRequest(url request: URLRequest, closure: @escaping (Bool, ([ResultsObject])) -> (Void)) {
		var success = false
		print("Request made is as follows \(request)")
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard let response = response as? HTTPURLResponse else {return}
			if response.statusCode == 200 {
				guard let data = data else {return}
				do {
					let jsonData = try self.decoder.decode(ResultsObjectDict.self, from: data)
					success = true
					print("THe json comes in like \(jsonData)")
					self.state = .Success
					closure(success, jsonData)
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
		} .resume()
	}
}
