//
//  BeaconSettingsTableViewCell.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 11/12/14.
//  Copyright (c) 2014 Tommaso Frassetto. All rights reserved.
//

import UIKit

@objc protocol AccessoryViewAddable {
	func addAccessoryView()
}

@objc protocol CellChild {
	var cell: BeaconSettingsTableViewCell! {get}
}

private class FormatterWrapper {
	let formatter = NSNumberFormatter()
	
	init () {
		formatter.numberStyle = .DecimalStyle
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 2
	}
}

private let fw = FormatterWrapper()
let decimalFormatter = fw.formatter

class BeaconSettingsTableViewCell: UITableViewCell {
	@IBOutlet var minorLabel : UILabel!
	@IBOutlet var xField : CoordinateTextField!
	@IBOutlet var yField : CoordinateTextField!
	@IBOutlet var aField : AlphaTextField!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		xField.cell = self
		yField.cell = self
		aField.cell = self
	}

	var scene: Int = 9
	
	var minor: Int = 9 {
		didSet {
			minorLabel.text = "#\(minor)"
		}
	}
	
	var position: Position {
		get {
			return Position(
				x: (decimalFormatter.numberFromString(xField.text!)?.doubleValue ?? 0.0),
				y: (decimalFormatter.numberFromString(yField.text!)?.doubleValue ?? 0.0))
		}
		set {
			xField.text = decimalFormatter.stringFromNumber(newValue.x)
			yField.text = decimalFormatter.stringFromNumber(newValue.y)
		}
	}
	
	var α: Double {
		get {
			return decimalFormatter.numberFromString(aField.text!)?.doubleValue ?? 1.0
		}
		set {
			aField.text = decimalFormatter.stringFromNumber(newValue)
		}
	}
}
