//
//  SceneManager.swift
//  BeaconTest
//
//  Created by Tommaso Frassetto on 15/12/14.
//  Copyright (c) 2014 Tommaso Frassetto. All rights reserved.
//

import UIKit

typealias BeaconData = (position: Position, alpha: Double)
typealias Scene = [BeaconData]

protocol SceneStorageDataSource {
	var selectedScene: Int {get set}
	var scenes: [Scene] {get}
	func setPosition(position: Position, forMinor minor: Int, inScene scene: Int)
	func setAlpha(alpha: Double, forMinor minor: Int, inScene scene: Int)
	func addScene()
	func removeScene(scene: Int)
}

private var _SSMInstance = SceneStorageManager()

class SceneStorageManager: SceneStorageDataSource {
	private init() {
		readPreferences()
	}
	
	class func getInstance() -> SceneStorageManager {
		return _SSMInstance
	}
	
	class func getDataSource() -> SceneStorageDataSource {
		return _SSMInstance
	}

	
	var selectedScene: Int = 0
	var scenes = [Scene]()
	var currentScene: Scene {
		get {
			return scenes[selectedScene]
		}
	}
	
	func setPosition(position: Position, forMinor minor: Int, inScene scene: Int) {
		scenes[scene][minor].position = position
	}
	
	func setAlpha(alpha: Double, forMinor minor: Int, inScene scene: Int) {
		scenes[scene][minor].alpha = alpha
	}
	
	func addScene() {
		var scene = Scene(count: Global.numberOfBeacons, repeatedValue: (position: Position(x: 0, y: 0), alpha: 1))
		scenes.append(scene)
	}
	
	func removeScene(scene: Int) {
		if selectedScene == scene {
			selectedScene = 0
		} else if selectedScene > scene {
			selectedScene--
		}
		
		scenes.removeAtIndex(scene)
		
		if scenes.isEmpty {
			addScene()
		}
	}
	
	func readPreferences() {
		scenes = []
		let oapscenes: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("scenes")
		if let apscenes: AnyObject = oapscenes {
			let pscenes = apscenes as! [[String : [String : Double]]]
			scenes.reserveCapacity(pscenes.count)
			for pscene in pscenes {
				var scene = Scene(count: Global.numberOfBeacons, repeatedValue: (position: Position(x: 0, y: 0), alpha: 1))
				for (sminor, propdict) in pscene {
					scene[sminor.toInt()!] = (
						position: Position(x: propdict["x"] ?? 0, y: propdict["y"] ?? 0),
						alpha: propdict["alpha"] ?? 1)
				}
				scenes.append(scene)
			}
		}
		if scenes.isEmpty {
			addScene()
		}
		selectedScene = NSUserDefaults.standardUserDefaults().integerForKey("selectedScene")
	}
	
	func writePreferences() {
		let pscenes = scenes.map({scene -> [String: [String: Double]] in
			var pscene = [String: [String: Double]]()
			for (minor, data) in enumerate(scene) {
				pscene[String(minor)] = ["x": data.position.x, "y": data.position.y, "alpha": data.alpha]
			}
			return pscene
		})
		NSUserDefaults.standardUserDefaults().setObject(pscenes, forKey: "scenes")
		NSUserDefaults.standardUserDefaults().setInteger(selectedScene, forKey: "selectedScene")
		NSUserDefaults.standardUserDefaults().synchronize()
	}
	
}
