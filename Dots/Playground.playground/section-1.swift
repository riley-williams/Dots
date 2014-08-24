import UIKit

class DotsView: UIView {
	override func drawRect(rect: CGRect) {
		var path = UIBezierPath(rect: CGRect(x: 100, y: 100, width: 100, height: 100))
		
		path.lineWidth = 5
		UIColor.greenColor().set()
		//path.moveToPoint(CGPoint(x: 0, y: 0))
		//path.addLineToPoint(CGPoint(x: 100, y: 100))
		
		
		//path.moveToPoint(CGPoint(x: 100, y: 100))
		path.stroke()
	}
}


var view = DotsView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)

let x1 = 38
let y1 = 150
let xSpace = 45
let ySpace = 45


let colors = [UIColor.greenColor(), UIColor.purpleColor(), UIColor.redColor(), UIColor.blueColor(), UIColor.yellowColor()]

let num: UInt32 = 5

for i in 0...5 {
	for j in 0...5 {
		var v = UIView(frame: CGRect(x: x1 + i * xSpace, y: y1 + j * ySpace, width: 20, height: 20))
		v.backgroundColor = UIColor.greenColor()
		view.addSubview(v)
		view
	}
}


view
