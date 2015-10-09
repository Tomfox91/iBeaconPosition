//
//  BeaconSettingsTableViewController.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 11/12/14.
//  Copyright (c) 2014 Tommaso Frassetto. All rights reserved.
//

import UIKit

class BeaconSettingsViewController: UIViewController {
	
	@IBOutlet var tableView: UITableView!
	var activeField: UITextField? = nil
	
	var dataSource = SceneStorageManager.getDataSource()

	override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWasShown:",
			name:UIKeyboardDidShowNotification,  object:nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillBeHidden:",
			name:UIKeyboardWillHideNotification, object:nil)
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
}

extension BeaconSettingsViewController: UITableViewDataSource, UITableViewDelegate {
	// MARK: Sections & cells
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return dataSource.scenes.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Global.numberOfBeacons
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("beaconRow", forIndexPath: indexPath) as! BeaconSettingsTableViewCell
		cell.scene = indexPath.section
		cell.minor = indexPath.item
		let scene = dataSource.scenes[indexPath.section][indexPath.item]
		cell.position = scene.position
		cell.α = scene.alpha
		
		return cell
	}
	
	// MARK: Headers & footers
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Scene \(section)"
	}

	func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		var headerToolbar = UIToolbar()
		var flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil,  action: nil)
		var selButton = UIBarButtonItem(title: "Select", style: .Plain,      target: self, action: "selectScene:")
		var fixSpace  = UIBarButtonItem(barButtonSystemItem: .FixedSpace,    target: nil,  action: nil)
		var remButton = UIBarButtonItem(barButtonSystemItem: .Trash,         target: self, action: "removeScene:")
		fixSpace.width = 20
		remButton.tag = section
		selButton.tag = section
		if dataSource.selectedScene == section {
			selButton.title = "Selected"
			selButton.enabled = false
		}
		headerToolbar.items = [flexSpace, selButton, fixSpace, remButton]
		headerToolbar.barTintColor = .groupTableViewBackgroundColor()
		headerToolbar.sizeToFit()
		return headerToolbar
	}

	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 44
	}
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		switch(section) {
		case 0: return UITableViewAutomaticDimension
		default: return 21
		}
	}
}

extension BeaconSettingsViewController {
	// MARK: Keyboard offset
	// https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html#//apple_ref/doc/uid/TP40009542-CH5-SW7
	
	func keyboardWasShown(notification: NSNotification) {
		let info = notification.userInfo!
		let kbSize = info[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue().size
	 
		let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
		tableView.contentInset = contentInsets
		tableView.scrollIndicatorInsets = contentInsets
	 
		var aRect = self.view.frame;
		aRect.size.height -= kbSize.height;
		if !aRect.contains(activeField!.frame.origin) {
			tableView.scrollRectToVisible(activeField!.frame, animated: true)
		}
	}
	
	func keyboardWillBeHidden(notification: NSNotification) {
		let contentInsets = UIEdgeInsetsZero;
		tableView.contentInset = contentInsets;
		tableView.scrollIndicatorInsets = contentInsets;
	}
}

extension BeaconSettingsViewController {
	// MARK: Add/remove/select scene
	@IBAction func addScene() {
		dataSource.addScene()
		tableView.reloadData()
	}
	
	func removeScene(sender: UIBarButtonItem) {
		dataSource.removeScene(sender.tag)
		tableView.reloadData()
	}
	
	func selectScene(sender: UIBarButtonItem) {
		dataSource.selectedScene = sender.tag
		tableView.reloadData()
	}
}

extension BeaconSettingsViewController: UITextFieldDelegate {
	// MARK: UITextField delegate
	func textFieldDidBeginEditing(textField: UITextField) {
		activeField = textField
		(textField as! AccessoryViewAddable).addAccessoryView()
		textField.selectAll(nil)
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		activeField = nil
		var cell = (textField as! CellChild).cell
		
		if textField is CoordinateTextField {
			let pos = cell.position
			dataSource.setPosition(pos, forMinor: cell.minor, inScene: cell.scene)
			cell.position = pos
		}
		
		if textField is AlphaTextField {
			let alpha = cell.α
			dataSource.setAlpha(alpha, forMinor: cell.minor, inScene: cell.scene)
			cell.α = alpha
		}
	}
}

// MARK: Calibration
extension BeaconSettingsViewController: AlphaTextFieldDelegate {
	func alphaTextFieldNeedsCalibration(alphaTextField: AlphaTextField) {
		var calibrationController = storyboard!.instantiateViewControllerWithIdentifier("Calibration") as! CalibrationViewController
		calibrationController.cell = alphaTextField.cell
		calibrationController.delegate = self
		presentViewController(calibrationController, animated: true, completion: nil)
	}
}

extension BeaconSettingsViewController: CalibrationDelegate {
	func calibrationController(controller: CalibrationViewController, endedCalibrationForCell cell:BeaconSettingsTableViewCell, withAlpha alpha: Double) {
		dataSource.setAlpha(alpha, forMinor: cell.minor, inScene: cell.scene)
		cell.α = alpha
	}
}


























