//
//  LinearDistanceController.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 05/12/14.
//  Copyright (c) 2014 Tommaso Frassetto. All rights reserved.
//

import UIKit
import CoreLocation

class LinearDistanceController: UIViewController {
	@IBOutlet var statusLabel : UILabel!
	@IBOutlet var distanceLabel : UILabel!
	@IBOutlet var rssiLabel : UILabel!
	private var currentBeacon: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

extension LinearDistanceController: BeaconManagerDelegate {
	override func viewDidAppear(animated: Bool) {
		BeaconManager.getInstance().addDelegate(self)
	}
	
	override func viewDidDisappear(animated: Bool) {
		BeaconManager.getInstance().removeDelegate(self)
	}
	
	func beaconManager(manager: BeaconManager, foundBeacons beacons: [CLBeacon?]) {
		if let b = beacons[currentBeacon] {
			switch (b.proximity) {
			case .Immediate: statusLabel.text = "IMMEDIATE"
			case .Near: statusLabel.text = "NEAR"
			case .Far: statusLabel.text = "FAR"
			case .Unknown: statusLabel.text = "UNKNOWN"
			}
			distanceLabel.text = decimalFormatter.stringFromNumber(b.accuracy)! + " m"
			rssiLabel.text = "\(b.rssi) dB"
		}
	}
}

extension LinearDistanceController : UIPickerViewDataSource, UIPickerViewDelegate {
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return Global.numberOfBeacons
	}

	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
		return "Beacon #\(row)"
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		currentBeacon = row
	}
}