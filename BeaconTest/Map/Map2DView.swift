//
//  Map2D.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 07/12/14.
//  Copyright (c) 2014 Tommaso Frassetto. All rights reserved.
//

import UIKit

class Map2DView: UIView {
	var beacons : [(position: Position, distance: Double?)] = []
	var device: Position? = nil {
		didSet {
			setNeedsDisplay()
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		contentMode = .Redraw
	}
	
	private var range = (x: (min: 0.0, max: 0.0), y: (min: 0.0, max: 0.0))
	private var scale = CGFloat(1.0)
	private var origin = CGPoint(x: 0.0, y: 0.0)
	
	private let margin = CGFloat(8)
	private let gridStep = 1.0
	
	private func positions() -> [Position] {
		return beacons.map({$0.position}) + (device != nil ? [device!] : [])
	}
	
	private func setScale() {
		let xs = positions().map{$0.x}
		let ys = positions().map{$0.y}
		range.x = (min: minElement(xs), max: maxElement(xs))
		range.y = (min: minElement(ys), max: maxElement(ys))
		origin = CGPoint(x: range.x.min, y: range.y.min)
		
		let dx = CGFloat(range.x.max - range.x.min)
		let dy = CGFloat(range.y.max - range.y.min)
		let w = bounds.width  - 2 * margin
		let h = bounds.height - 2 * margin
		scale = min(w/dx, h/dy)
	}
	
	private func scalePoint(p: Position) -> CGPoint {
		return CGPoint(x: (CGFloat(p.x) - origin.x) * scale + margin, y: (CGFloat(p.y) - origin.y) * scale + margin)
	}
	
	
	private func drawGrid() {
		func line(from: CGPoint, to: CGPoint, color: UIColor) {
			var path = UIBezierPath()
			path.moveToPoint(from)
			path.addLineToPoint(to)
			color.set()
			
			path.stroke()
		}
		
		func color(i: Double) -> UIColor {
			if i == 0 {
				return UIColor(white: 0.4, alpha: 1)
			} else if floor(i/10) == i/10 {
				return UIColor(white: 0.8, alpha: 1)
			} else {
				return UIColor(white: 0.9, alpha: 1)
			}
		}
		
		func hline(y: Double) {
			let ys = scalePoint(Position(x: range.x.min, y: y)).y
			line(CGPoint(x: bounds.minX, y: ys), CGPoint(x: bounds.maxX, y: ys), color(y))
		}
		
		func vline(x: Double) {
			let xs = scalePoint(Position(x: x, y: range.y.min)).x
			line(CGPoint(x: xs, y: bounds.minY), CGPoint(x: xs, y: bounds.maxY), color(x))
		}
		
		for (var x = -gridStep; x >= range.x.min; x -= gridStep) {vline(x)}
		for (var x =  gridStep; x <= range.x.max; x += gridStep) {vline(x)}
		for (var y = -gridStep; y >= range.y.min; y -= gridStep) {hline(y)}
		for (var y =  gridStep; y <= range.y.max; y += gridStep) {hline(y)}
		vline(0)
		hline(0)
	}
	
	private func drawBeacon(position: Position, _ distance: Double?) {
		var center = scalePoint(position)
		var path = UIBezierPath(arcCenter: center, radius: CGFloat(5), startAngle: CGFloat(0), endAngle: CGFloat(2*M_PI), clockwise: true)
		path.lineWidth = 2.0
		UIColor.blueColor().set()
		path.stroke()
		
		if let distance = distance {
			path = UIBezierPath(arcCenter: center, radius: CGFloat(distance)*scale, startAngle: CGFloat(0), endAngle: CGFloat(2*M_PI), clockwise: true)
			path.lineWidth = 0.75
			path.stroke()
		}
	}
	
	private func drawDevice(position: Position) {
		var center = scalePoint(position)
		var path = UIBezierPath(rect: CGRect(x: center.x - 4, y: center.y - 4, width: 8, height: 8))
		UIColor.redColor().set()
		path.fill()
	}
	
	override func drawRect(rect: CGRect) {
		if beacons.count >= 3 && beacons[0].position != beacons[1].position {
			setScale()
			drawGrid()
			for b in beacons {
				drawBeacon(b.position, b.distance)
			}
			if let d = device {drawDevice(d)}
		}
	}
}
