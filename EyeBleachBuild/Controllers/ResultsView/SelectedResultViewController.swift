//
//  SelectedResultViewController.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 10/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import UIKit

class SelectedResultViewController: UIViewController {
	
	//MARK:- Properties
	var result: ResultsObject?
	
	//MARK:- Outlets
	@IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
		setUp()
        // Do any additional setup after loading the view.
    }
	
	func setUp() {
		guard let data = result else {return}
		imageView.loadImageFrom(urlString: data.url)
	}
}
