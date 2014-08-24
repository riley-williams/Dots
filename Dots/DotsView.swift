//
//  DotsView.swift
//  Dots
//
//  Created by Riley Williams on 8/23/14.
//  Copyright (c) 2014 Riley Williams. All rights reserved.
//

import UIKit

class DotsView: UIView {
	var linePoints: Array<CGPoint>?
	var lineColor: UIColor?
	var dataSource: DotsViewDataSource?
	
	let x1 = 38
	let y1 = 150
	let xSpace = 45
	let ySpace = 45
	let diameter = 22
	
	override func drawRect(rect: CGRect) {
		
		for i in 0...5 {
			for j in 0...5 {
				if dataSource != nil {
					let color = dataSource!.dotColor(x: i, y: j)
					if color != nil {
						color!.set()
					} else {
						UIColor.grayColor().set()
					}
				} else {
					UIColor.grayColor().set()
				}
				
				var dot = UIBezierPath(ovalInRect: CGRect(x: x1 + i * xSpace, y: y1 + j * ySpace, width: diameter, height: diameter))
				dot.fill()
				
			}
		}
		
		if (linePoints != nil && lineColor != nil && linePoints!.count > 1) {
			var path = UIBezierPath()
			path.lineWidth = 5
			lineColor!.set()
			
			path.moveToPoint(linePoints![0])
			
			for i in 1...linePoints!.count-1 {
				path.addLineToPoint(linePoints![i])
			}
			path.stroke()
		}
	}
}

protocol DotsViewDataSource {
	func dotColor(#x: Int, y: Int) -> UIColor?
}