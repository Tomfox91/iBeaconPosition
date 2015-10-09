//
//  BeaconManager.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 28/12/14.
//  Copyright (c) 2014 Tommaso Frassetto. All rights reserved.
//

import UIKit
import CoreLocation

protocol BeaconManagerDelegate: NSObjectProtocol {
	func beaconManager(manager: BeaconManager, foundBeacons beacons: [CLBeacon?])
}

private var _BMInstance = BeaconManager()

class BeaconManager: NSObject, CLLocationManagerDelegate {
	private var locationManager: CLLocationManager
	private var beaconRegion: CLBeaconRegion
	
	// MARK: Singleton
	private override init() {
		locationManager = CLLocationManager()
		if CLLocationManager.authorizationStatus() == .NotDetermined {
			locationManager.requestWhenInUseAuthorization()
		}
		
		beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: Global.UUID),
			major: UInt16(Global.major), identifier: "r")
		super.init()
		locationManager.delegate = self
		locationManager.startRangingBeaconsInRegion(beaconRegion)
	}
	
	class func getInstance() -> BeaconManager {
		return _BMInstance
	}
	
	// MARK: Delegates
	private var orderDelegates: [BeaconManagerDelegate] = []
	private var rawDelegates: [BeaconManagerDelegate] = []
	
	func addDelegate(delegate: BeaconManagerDelegate, raw: Bool = false) {
		if raw {
			rawDelegates.append(delegate)
		} else {
			orderDelegates.append(delegate)
		}
	}
	
	func removeDelegate(delegate: BeaconManagerDelegate) {
		orderDelegates = orderDelegates.filter {$0 !== delegate}
		rawDelegates   = rawDelegates.filter   {$0 !== delegate}
	}
	
	// MARK: CLLocationManagerDelegate
	func locationManager(manager: CLLocationManager!, didRangeBeacons nbeacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
		let beacons = (nbeacons as! [CLBeacon])
		var raw = [CLBeacon]()
		var ord = [CLBeacon?](count: Global.numberOfBeacons, repeatedValue: nil)
		for b in beacons {
			if (Int(b.minor) < Global.numberOfBeacons) {
				raw.append(b)
				ord[Int(b.minor)] = b
			}
		}
		
		for delegate in orderDelegates {
			(delegate as BeaconManagerDelegate).beaconManager(self, foundBeacons: ord)
		}
		
		for delegate in rawDelegates {
			(delegate as BeaconManagerDelegate).beaconManager(self, foundBeacons: raw)
		}
	}
	
	
}













