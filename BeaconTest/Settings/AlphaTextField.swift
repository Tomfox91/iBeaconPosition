//
//  CoordinateTextField.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 06/01/15.
//  Copyright (c) 2015 Tommaso Frassetto. All rights reserved.
//

import UIKit

@objc protocol AlphaTextFieldDelegate {
	func alphaTextFieldNeedsCalibration(alphaTextField: AlphaTextField)
}

class AlphaTextField: UITextField, AccessoryViewAddable, CellChild {
	var cell: BeaconSettingsTableViewCell!

	func addAccessoryView() {
		if (inputAccessoryView == nil) {
			var accView = UIToolbar()
			accView.items = [
				UIBarButtonItem(title: "Auto Calibration", style: .Plain, target: self, action: "calibration"),
				UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
				UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneEditing")
			]
			accView.sizeToFit()
			inputAccessoryView = accView
		}
	}
	
	func doneEditing() {
		self.resignFirstResponder()
	}
	
	func calibration() {
		self.resignFirstResponder()
		(delegate as! AlphaTextFieldDelegate).alphaTextFieldNeedsCalibration(self)
	}
}