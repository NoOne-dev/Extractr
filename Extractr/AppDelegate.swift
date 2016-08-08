//
//  AppDelegate.swift
//  Extractr
//
//  Created by Mark Malstrom on 7/28/16.
//  Copyright © 2016 Tangaroa. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
		return true
	}
}