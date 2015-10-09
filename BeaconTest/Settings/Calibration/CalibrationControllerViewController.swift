//
//  CalibrationControllerViewController.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 06/01/15.
//  Copyright (c) 2015 Tommaso Frassetto. All rights reserved.
//

import UIKit
import CoreLocation

@objc protocol CalibrationDelegate {
	optional func calibrationController(
		controller: CalibrationViewController,
		abortedCalibrationForCell: BeaconSettingsTableViewCell)
	func calibrationController(
		controller: CalibrationViewController,
		endedCalibrationForCell cell: BeaconSettingsTableViewCell,
		withAlpha alpha: Double)
}

class CalibrationViewController: UIViewController, BeaconManagerDelegate {
	var cell: BeaconSettingsTableViewCell!
	var delegate: CalibrationDelegate?
	
	@IBOutlet var idLabel: UILabel!
	@IBOutlet var counterLabel: UILabel!
	@IBOutlet var distanceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		idLabel.text = "scene: \(cell.scene)    minor: \(cell.minor)"
		counterLabel.text = "\(counter)"
		
		BeaconManager.getInstance().addDelegate(self)
    }

	private var counter = -15
	private var sum = 0.0

	func beaconManager(manager: BeaconManager, foundBeacons beacons: [CLBeacon?]) {
		if let b = beacons[cell.minor] {
			if b.accuracy > 0 {
				counter++
				counterLabel.text = "\(counter)"
				distanceLabel.text = decimalFormatter.stringFromNumber(b.accuracy)! + " m"
				
				if counter > 0 {
					sum += b.accuracy
				}
				
				if counter >= 30 {
					end(Double(counter) / sum) // 1 / average
				}
			}
		}
	}
	
	@IBAction func abort() {
		BeaconManager.getInstance().removeDelegate(self)
		presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
		delegate!.calibrationController?(self, abortedCalibrationForCell: cell)
	}
	
	private func end(alpha: Double) {
		BeaconManager.getInstance().removeDelegate(self)
		presentingViewController!.dismissViewControllerAnimated(true, completion:
			nil)
		delegate?.calibrationController(self, endedCalibrationForCell: cell, withAlpha: alpha)
	}
}
