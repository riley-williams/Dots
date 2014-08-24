//
//  ViewController.swift
//  Dots
//
//  Created by Riley Williams on 8/23/14.
//  Copyright (c) 2014 Riley Williams. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DotsViewDataSource {
	var dots: Array<Array<UIColor>>!
	var selected: Array<Array<Bool>>!
	var timeRemaining: Int = 60
	var points: Int = 0
	
	@IBOutlet weak var time: UILabel!
	@IBOutlet weak var score: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let timer = NSTimer(timeInterval: 1, target: self, selector: Selector("countdown"), userInfo: nil, repeats: true)
		NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
		
		initBoard(dots: &dots, selected: &selected)
		
		let v = view as DotsView
		v.dataSource = self
		view.setNeedsDisplay()
	}
	
	func dotForTouchCoordinate(point: CGPoint) -> (x: Int, y: Int) {
		let v = view as DotsView
		
		let x = (Int(point.x) - v.x1)/v.xSpace
		let y = (Int(point.y) - v.y1)/v.ySpace
		
		return (x,y)
	}
	
	func snapToDot(point: CGPoint) -> CGPoint {
		let v = view as DotsView
		var (x, y) = dotForTouchCoordinate(point)
		
		x = x*v.xSpace + v.x1 + v.diameter/2
		y = y*v.ySpace + v.y1 + v.diameter/2
		
		return CGPoint(x: x, y: y)
	}
	
	override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
		let v = view as DotsView
		if v.linePoints == nil {
			v.linePoints = Array<CGPoint>()
		}
		var touch = touches.anyObject().locationInView(self.view)
		
		let (x, y) = dotForTouchCoordinate(touch)
		
		touch = snapToDot(touch)
		v.linePoints!.append(touch)
		v.linePoints!.append(touch)
		let color = dotColor(x: x, y: y)
		if color != nil {
			v.lineColor = color
		} else {
			v.lineColor = UIColor.grayColor()
		}
	}
	
	override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
		let v = view as DotsView
		var point = touches.anyObject().locationInView(self.view)
		var lastDot = dotForTouchCoordinate(v.linePoints![v.linePoints!.count - 2])
		var thisDot = dotForTouchCoordinate(point)
		
		if isAdjacent(thisDot, b: lastDot) && dotColor(x: thisDot.x, y: thisDot.y) == dotColor(x: lastDot.x, y: lastDot.y) {
			point = snapToDot(point)
			v.linePoints![v.linePoints!.count - 1] = point
			v.linePoints!.append(point)
		}
		v.linePoints![v.linePoints!.count - 1] = point
		
		view.setNeedsDisplay()
	}
	
	override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
		let v = view as DotsView
		if v.linePoints!.count > 2 {
			for i in 0...v.linePoints!.count-2 {
				let dot = dotForTouchCoordinate(v.linePoints![i])
				dots[dot.x][dot.y] = UIColor.grayColor()
				addToScore(1)
			}
		}
		for i in 0...5 {
			dropCol(index: i)
		}
		v.linePoints = nil
		view.setNeedsDisplay()
	}
	
	func isAdjacent(a : (Int, Int), b: (Int, Int)) -> Bool {
		if a.0 == b.0 {
			if abs(a.1 - b.1) == 1 {
				return true
			}
		}
		if a.1 == b.1 {
			if abs(a.0 - b.0) == 1 {
				return true
			}
		}
		return false
	}
	
	func countdown() {
		time.text = "\(--timeRemaining)"
		if timeRemaining < 0 {
			performSegueWithIdentifier("show score", sender: self)
		}
	}
	
	func dotColor(#x: Int, y: Int) -> UIColor? {
		if x >= 0 && x <= 5 && y >= 0 && y <= 5 {
			return dots[x][y]
		} else {
			return nil
		}
	}
	
	func addToScore(i: Int) {
		points+=i
		score.text = "\(points)"
	}
	
	func initBoard(inout #dots: Array<Array<UIColor>>!, inout selected: Array<Array<Bool>>!) {
		dots = Array<Array<UIColor>>()
		selected = Array<Array<Bool>>()
		for i in 0...5 {
			dots.append(Array<UIColor>())
			selected.append(Array<Bool>())
			for j in 0...5 {
				dots[i].append(randomDotColor())
				selected[i].append(false)
			}
		}
	}
	
	func randomDotColor() -> UIColor {
		let colors = [UIColor.greenColor(), UIColor.purpleColor(), UIColor.redColor(), UIColor.blueColor(), UIColor.yellowColor()]
		return colors[Int(arc4random_uniform(5))]
	}
	
	func dropCol(#index: Int) {
		for y in 0...4 {
			for k in 0...4 {
				if (dots[index][k] == UIColor.grayColor()) {
					if (k == 4) {
						dots[index][5] = randomDotColor()
					} else {
						dots[index][5-k] = dots[index][6-k]
					}
				}
			}
		}
		
	}
	
	@IBAction func reset() {
		initBoard(dots: &dots, selected: &selected)
		view.setNeedsDisplay()
		timeRemaining = 60
		points = 0
		time.text = "60"
		score.text = "0"
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
		let dest = segue.destinationViewController as StatsViewController
		dest.points = points
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

