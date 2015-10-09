//
//  PositionAverageViewController.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 08/01/15.
//  Copyright (c) 2015 Tommaso Frassetto. All rights reserved.
//

import UIKit
import CoreLocation
import AudioToolbox

private var dateFormatter = {() -> NSDateFormatter in
	var formatter = NSDateFormatter()
	formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
	formatter.dateFormat = "yyyy-MM-dd'T'HH.mm.ss"
	return formatter
	}()

private var lastx: String?
private var lasty: String?

class PositionRecordViewController: UIViewController, BeaconManagerDelegate {
	@IBOutlet var counterLabel: UILabel!
	@IBOutlet var positionLabel: UILabel!
	
	private var logFile: NSFileHandle!
	private var counter = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		counterLabel.text = "\(counter)"
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewDidAppear(animated)
		askRealPosition()
	}
	
	private func askRealPosition() {
		let alertController = UIAlertController(title: "Record position",
			message: "Insert real position and configuration id", preferredStyle: .Alert)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in self.end()}
		
		let recordAction = UIAlertAction(title: "Record", style: .Default) { (_) in
			let xTextField = alertController.textFields![0] as! UITextField
			let yTextField = alertController.textFields![1] as! UITextField
			let cTextField = alertController.textFields![2] as! UITextField
			lastx = xTextField.text
			lasty = yTextField.text
			let x = decimalFormatter.numberFromString(xTextField.text)! as Double
			let y = decimalFormatter.numberFromString(yTextField.text)! as Double
			
			self.prepareFiles(realPosition: (x: x, y: y), configuration: cTextField.text!)
		}
		recordAction.enabled = false
		
		var xok = false
		var yok = false
		var cok = false
		
		alertController.addTextFieldWithConfigurationHandler { (textField) in
			textField.placeholder = "x"
			textField.keyboardType = .DecimalPad
			textField.text = lastx
			NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
				xok = decimalFormatter.numberFromString(textField.text) != nil
				recordAction.enabled = xok && yok && cok
			}
		}
		
		alertController.addTextFieldWithConfigurationHandler { (textField) in
			textField.placeholder = "y"
			textField.keyboardType = .DecimalPad
			textField.text = lasty
			NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
				yok = decimalFormatter.numberFromString(textField.text) != nil
				recordAction.enabled = xok && yok && cok
			}
		}
		
		alertController.addTextFieldWithConfigurationHandler { (textField) in
			textField.placeholder = "configuration"
			NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
				cok = textField.text != nil
				recordAction.enabled = xok && yok && cok
			}
		}
		
		alertController.addAction(cancelAction)
		alertController.addAction(recordAction)
		
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	private func prepareFiles(#realPosition: (x: Double, y: Double), configuration: String) {
		var fileManager = NSFileManager.defaultManager()
		let now = dateFormatter.stringFromDate(NSDate())
		let dirn = "\(now)-x\(realPosition.x)-y\(realPosition.y)-\(configuration)"
		var error: NSError?
		
		let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
		let dir = documents.stringByAppendingPathComponent(dirn)
		fileManager.createDirectoryAtPath(dir, withIntermediateDirectories: false, attributes: nil, error: &error)
		if (error != nil) {end(); return}
		
		// real position
		("         x          y conf\n" +
			String(format: "%10.6f %10.6f ", realPosition.x, realPosition.y) + configuration)
			.writeToFile(dir.stringByAppendingPathComponent("position.txt"),
				atomically: false, encoding: NSUTF8StringEncoding, error: &error)
		if (error != nil) {end(); return}
		
		// beacons position
		("         x          y          z          α\n" +
			(SceneStorageManager.getInstance().currentScene.map({(bd: BeaconData) -> String in
				String(format: "%10.6f %10.6f %10.6f %10.6f\n", bd.position.x, bd.position.y, bd.position.z, bd.alpha)
			}).reduce("", combine: {$0 + $1})))
			.writeToFile(dir.stringByAppendingPathComponent("beacons.txt"),
				atomically: false, encoding: NSUTF8StringEncoding, error: &error)
		if (error != nil) {end(); return}
		
		// log
		let logFilePath = dir.stringByAppendingPathComponent("log.txt")
		fileManager.createFileAtPath(logFilePath, contents: nil, attributes: nil)
		logFile = NSFileHandle(forWritingAtPath: logFilePath)
		logFile.writeData(("         x          y          z           b00        b01        b02" +
			"        b03        b04        b05        b06        b07        b08        b09        b10        b11\n")
			.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)

		BeaconManager.getInstance().addDelegate(self)
	}
	
	func beaconManager(manager: BeaconManager, foundBeacons beacons: [CLBeacon?]) {
		func pos2str(pos: Position) -> String {
			return "x: \(decimalFormatter.stringFromNumber(pos.x)!) m\n" +
			"y: \(decimalFormatter.stringFromNumber(pos.y)!) m"
		}
		
		if let (devicePos, beaconData) = computePosition(beacons) {
			counter++
			counterLabel.text = "\(counter)"
			positionLabel.text = pos2str(devicePos)
			
			logFile.writeData((
			String(format: "%10.6f %10.6f %10.6f    ", devicePos.x, devicePos.y, devicePos.z) +
			(beaconData.map({bd -> String in
				if let d = bd.distance {
					return String(format: "%10.6f ", d)
				} else {
					return "       nil "
				}
			}).reduce("", combine: {$0 + $1})) +
				"\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
			
			if counter >= 30 {
				AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
				end()
			}
		}
	}
	
	@IBAction func end() {
		logFile?.closeFile()
		logFile = nil
		BeaconManager.getInstance().removeDelegate(self)
		presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
	}
}
