//
//  CoordinateTextField.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 17/12/14.
//  Copyright (c) 2014 Tommaso Frassetto. All rights reserved.
//

import UIKit

class CoordinateTextField: UITextField, AccessoryViewAddable, CellChild {
	var cell: BeaconSettingsTableViewCell!
	
	func addAccessoryView() {
		if (inputAccessoryView == nil) {
			var accView = UIToolbar()
			accView.items = [
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
}