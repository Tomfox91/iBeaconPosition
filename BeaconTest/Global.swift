//
//  Global.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 05/12/14.
//  Copyright (c) 2014 Tommaso Frassetto. All rights reserved.
//

let Global = (
	UUID: "A7AE2EB7-1F00-4168-B99B-A749BAC1CA64",
	major: 42,
	numberOfBeacons: 12
)

struct Position: Printable, Equatable {
	let x: Double
	let y: Double
	let z: Double
	
	var description: String {
		return "Pos(\(x), \(y), \(z))"
	}
	
	init(x: Double, y: Double) {
		self.x = x
		self.y = y
		self.z = 0.0
	}

	init(x: Double, y: Double, z: Double) {
		self.x = x
		self.y = y
		self.z = z
	}
}

func ==(lhs: Position, rhs: Position) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y
}


