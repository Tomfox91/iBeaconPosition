//
//  NearestBeaconViewController.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 20/03/15.
//  Copyright (c) 2015 Tommaso Frassetto. All rights reserved.
//

import UIKit
import CoreLocation
import AudioToolbox

class NearestBeaconViewController: UIViewController, BeaconManagerDelegate {
	@IBOutlet var nearestBeaconLabel: UILabel!
	private var oldNearest = -1
	
	override func viewDidLoad() {
		super.viewDidLoad()
		nearestBeaconLabel.text = ""
		BeaconManager.getInstance().addDelegate(self, raw: true)
	}
	
	func beaconManager(manager: BeaconManager, foundBeacons beacons: [CLBeacon?]) {
		if (!beacons.isEmpty) {
			let nearest = beacons.first!!.minor.integerValue
			nearestBeaconLabel.text = "\(nearest)"
			if (oldNearest != nearest) {
				AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
				oldNearest = nearest
			}
		}
	}
	
	@IBAction func end() {
		BeaconManager.getInstance().removeDelegate(self)
		presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
	}
}
