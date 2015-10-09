//
//  NLateration.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 11/03/15.
//  Copyright (c) 2015 Tommaso Frassetto. All rights reserved.
//

import Foundation

func nlateration(positions: [Position], distances: [Double], weights: [Double]) -> Position {
	let count = positions.count
	assert(count == distances.count && count == weights.count)

	let pos : [(Double, Double, Double)] = positions.map{($0.x, $0.y, $0.z)}
	var out = [CDouble](count: 3, repeatedValue: 0.0)
	
	NLcompute(CInt(count), pos, distances, weights, &out)
	
	return Position(x: out[0], y: out[1], z: out[2])
}