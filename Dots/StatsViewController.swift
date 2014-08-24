//
//  StatsViewController.swift
//  Dots
//
//  Created by Riley Williams on 8/23/14.
//  Copyright (c) 2014 Riley Williams. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
	var points: Int?
	@IBOutlet weak var pointsLabel: UILabel!
	
	override func viewDidLoad() {
		if points != nil {
			pointsLabel.text = "\(points!)"
		}
	}
	
}
