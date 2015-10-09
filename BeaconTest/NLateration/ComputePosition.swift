//
//  ComputePosition.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 12/03/15.
//  Copyright (c) 2015 Tommaso Frassetto. All rights reserved.
//

import Foundation
import CoreLocation

func computePosition(beacons: [CLBeacon?]) ->
	(devicePos: Position, beaconData: [(position: Position, distance: Double?)])?
{
	let scene = SceneStorageManager.getInstance().currentScene
	
	var positions = [Position]()
	var distances = [Double]()
	var weights = [Double]()
	var data = Array<((position: Position, distance: Double?))>()
	
	for i in 0..<scene.count {
		positions.append(scene[i].position)
		
		distances.append((beacons[i]?.accuracy ?? 0) * scene[i].alpha)
		
		if (beacons[i] == nil || beacons[i]!.accuracy < 0) {
			weights.append(0)
		} else {
			weights.append(1)
		}
	
		data.append((
			position: positions[i],
			distance: weights[i] == 0 ? nil : distances[i]))
	}
	
	if (weights.filter({$0 > 0}).reduce(0, combine: {(c: Int, _) in c + 1}) < 3) {
		return nil
	} else {
		return (devicePos: nlateration(positions, distances, weights), beaconData: data)
	}
}







