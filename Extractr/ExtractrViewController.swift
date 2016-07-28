//
//  ExtractrViewController.swift
//  Extractr
//
//  Created by Mark Malstrom on 7/28/16.
//  Copyright © 2016 Tangaroa. All rights reserved.
//

import Cocoa
import Automator

class ExtractrViewController: NSViewController {
	// MARK:- IBOutlets
	@IBOutlet weak var OTAPath: NSPathControl!
	@IBOutlet weak var outputPath: NSPathControl!
	@IBOutlet weak var extractButton: NSButton!
	@IBOutlet weak var stopExtractionButton: NSButton!
	@IBOutlet var outputTextView: NSTextView!
	
	
	// MARK:- Properties
	var outputPipe: NSPipe!
	var task: NSTask!
	var isRunning: Bool = false

	// MARK:- viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// MARK:- Methods
	func extractFileSystem(arguments: [String]) {
		isRunning = true
		
		let taskQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
		
		dispatch_async(taskQueue) {
			
			guard let path = NSBundle.mainBundle().pathForResource("ExtractFileSystem", ofType: "command") else {
				print("Unable to locate ExtractFileSystem.command")
				return
			}
			
			self.task = NSTask()
			self.task.launchPath = path
			self.task.arguments = arguments
			
			// Once the task session has finished
			dispatch_async(dispatch_get_main_queue(), {
				self.extractButton.enabled = true
				// self.spinner.stopAnimation(self)
				self.isRunning = false
			})
			
			self.task.launch()
			self.task.waitUntilExit()
		}
	}
	
	// MARK:- IBActions
	@IBAction func startExtraction(sender: NSButton) {
		outputTextView.string = ""
		
		if let OTAURL = OTAPath.URL, let outputURL = outputPath.URL {
			let OTALocation = OTAURL.path!
			let outputLocation = outputURL.path!
			
			guard let unar = NSBundle.mainBundle().pathForResource("unar", ofType: nil) else {
				print("Unable to locate unar")
				return
			}
			
			guard let pbxz = NSBundle.mainBundle().pathForResource("pbxz", ofType: nil) else {
				print("Unable to locate pbxz")
				return
			}
			
			var arguments: [String] = []
			arguments.append(outputLocation)
			arguments.append(OTALocation)
			arguments.append(unar)
			arguments.append(pbxz)
		}
		
		extractButton.enabled = false
	}
	
	@IBAction func stopExtraction(sender: NSButton) {
		
	}
}

