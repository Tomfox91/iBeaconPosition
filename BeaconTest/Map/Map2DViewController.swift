//
//  Map2DViewController.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 11/12/14.
//  Copyright (c) 2014 Tommaso Frassetto. All rights reserved.
//

import UIKit
import CoreLocation

class Map2DViewController: UIViewController {
	@IBOutlet var positionLabel : UILabel!
	@IBOutlet var mapView: Map2DView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension Map2DViewController: BeaconManagerDelegate {
	override func viewDidAppear(animated: Bool) {
		BeaconManager.getInstance().addDelegate(self)
	}
	
	override func viewDidDisappear(animated: Bool) {
		BeaconManager.getInstance().removeDelegate(self)
	}
	
	func beaconManager(manager: BeaconManager, foundBeacons beacons: [CLBeacon?]) {
		if let (devicePos, beaconData) = computePosition(beacons) {
			mapView.beacons = beaconData
			mapView.device = devicePos
			
			positionLabel.text = "x: \(decimalFormatter.stringFromNumber(devicePos.x)!)" +
			"    y: \(decimalFormatter.stringFromNumber(devicePos.y)!)"
		}
	}
}
