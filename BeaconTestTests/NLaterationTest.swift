//
//  TrilaterationTest.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 03/01/15.
//  Copyright (c) 2015 Tommaso Frassetto. All rights reserved.
//

import UIKit
import XCTest

class NLaterationTest: XCTestCase {
	func test0() {
		self.measureBlock { // .002s on iPhone 5
			let res = nlateration([
				Position(x:  0, y: 0),
				Position(x: -5, y: 5),
				Position(x:  5, y: 5)],
				[5, 5, 5], [1, 1, 1])
			XCTAssertEqualWithAccuracy(res.x, 0, 0.01, "NL t0 x")
			XCTAssertEqualWithAccuracy(res.y, 5, 0.01, "NL t0 y")
			XCTAssertEqualWithAccuracy(res.z, 0, 0.01, "NL t0 z")
		}
	}
	
	func test0w() {
		self.measureBlock { // .002s on iPhone 5
			let res = nlateration([
				Position(x:  0, y: 0),
				Position(x: -5, y: 5),
				Position(x:  5, y: 5),
				Position(x: 99, y: 9)],
				[5, 5, 5, 9], [1, 1, 1, 0])
			XCTAssertEqualWithAccuracy(res.x, 0, 0.01, "NL t0w x")
			XCTAssertEqualWithAccuracy(res.y, 5, 0.01, "NL t0w y")
			XCTAssertEqualWithAccuracy(res.z, 0, 0.01, "NL t0w z")
		}
	}
	
	func test1() {
		self.measureBlock { // .002s on iPhone 5
			let res = nlateration([
				Position(x: 0,  y: 1),
				Position(x: 5,  y: 6),
				Position(x: 10, y: 1)],
				[5, 5, 5], [1, 1, 1])
			XCTAssertEqualWithAccuracy(res.x, 5, 0.01, "NL t1 x")
			XCTAssertEqualWithAccuracy(res.y, 1, 0.01, "NL t1 y")
			XCTAssertEqualWithAccuracy(res.z, 0, 0.01, "NL t1 z")
		}
	}
	
	func test2() {
		self.measureBlock { // .002s on iPhone 5
			let res = nlateration([
				Position(x: 0,  y: 1),
				Position(x: 5,  y: 6),
				Position(x: 11, y: 1)],
				[5, 5, 5], [1, 1, 1])
			XCTAssertEqualWithAccuracy(res.x, 5.5, 0.1, "NL t2 x")
			XCTAssertEqualWithAccuracy(res.y, 1.0, 0.1, "NL t2 y")
			XCTAssertEqualWithAccuracy(res.z, 0.0, 0.1, "NL t2 z")
		}
	}

	func test3() {
		self.measureBlock { // .003 on iPhone 5
			let res = nlateration([
				Position(x: 5  , y: 5  ),
				Position(x: 5  , y: -5 ),
				Position(x: 7  , y: 2  ),
				Position(x: -4 , y: -8 ),
				Position(x: 8  , y: -73),
				Position(x: 14 , y: -1 ),
				Position(x: -10, y: 5  ),
				Position(x: -7 , y: -6 ),
				Position(x: 2  , y: -2 ),
				Position(x: 3  , y: -6 )],
				[7.07106781186547524400,
				7.07106781186547524400 ,
				7.28010988928051827109 ,
				8.94427190999915878563 ,
				73.43704787094862516359,
				14.03566884761819963051,
				11.18033988749894848204,
				9.21954445729288731000 ,
				2.82842712474619009760 ,
				6.70820393249936908922 ],
				[1, 1, 1, 1, 1, 1, 1, 1, 1, 1])
			XCTAssertEqualWithAccuracy(res.x, 0, 0.001, "NL t3 x")
			XCTAssertEqualWithAccuracy(res.y, 0, 0.001, "NL t3 y")
			XCTAssertEqualWithAccuracy(res.z, 0, 0.01, "NL t3 z")
		}
	}
}
