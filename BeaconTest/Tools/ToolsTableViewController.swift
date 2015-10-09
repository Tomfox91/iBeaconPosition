//
//  ToolsTableViewController.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 12/03/15.
//  Copyright (c) 2015 Tommaso Frassetto. All rights reserved.
//

import UIKit

class ToolsTableViewController: UITableViewController {
	@IBAction func recordPosition() {
		var recordController = storyboard!.instantiateViewControllerWithIdentifier("PositionRecord") as! PositionRecordViewController
		presentViewController(recordController, animated: true, completion: nil)
	}
	
	@IBAction func nearestBeacon() {
		var nearestBeaconController = storyboard!.instantiateViewControllerWithIdentifier("NearestBeacon") as! NearestBeaconViewController
		presentViewController(nearestBeaconController, animated: true, completion: nil)
	}
}
