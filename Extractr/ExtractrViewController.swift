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
	@IBOutlet weak var spinner: NSProgressIndicator!
	
	
	// MARK:- Properties
	var outputPipe: NSPipe!
	var task: NSTask!
	var isRunning: Bool = false

	// MARK:- viewDid
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Set default states for the spinner and Stop Extraction button
		self.spinner.hidden = true
		self.stopExtractionButton.enabled = false
		
		// Set default path for output to ~/Desktop
		let desktopPathURL = NSURL(fileURLWithPath: NSString(string:"~/Desktop").stringByExpandingTildeInPath)
		outputPath.URL = desktopPathURL
		
		// Customize the outputTextView NSTextView appearence
		outputTextView.font = NSFont(name: "SFMono-Regular", size: 12)
		// Sets the background color to navy blue
		// outputTextView.backgroundColor = NSColor(red:0.077, green:0.142, blue:0.212, alpha:1)
	}
	
	override func viewDidAppear() {
		// Disable window resizing
		self.view.window?.styleMask &= ~NSResizableWindowMask
	}
	
	// MARK:- Methods
	// Set the text color inside the outputTextView to white
	func setTextColor() {
		// let range = NSRange(location: 0, length: outputTextView.textStorage!.length)
		// outputTextView.setTextColor(NSColor.whiteColor(), range: range)
	}
	
	// Displays the standard output
	func displayStdout(from task: NSTask) {
		outputPipe = NSPipe()
		task.standardOutput = outputPipe
		
		outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
		
		// Notification observer
		NSNotificationCenter.defaultCenter().addObserverForName("NSFileHandleDataAvailableNotification", object: outputPipe.fileHandleForReading, queue: nil) { (notification) in
			let output = self.outputPipe.fileHandleForReading.availableData
			// If the created string is nil, use a blank string
			let outputString = String(data: output, encoding: NSUTF8StringEncoding) ?? ""
			
			dispatch_async(dispatch_get_main_queue(), {
				// If self.outputTextView.string is nil, use a blank string
				let previousOutput = self.outputTextView.string ?? ""
				let nextOutput = previousOutput + "\n" + outputString
				self.outputTextView.string = nextOutput
				
				let range = NSRange(location: nextOutput.characters.count, length: 0)
				self.setTextColor()
				self.outputTextView.scrollRangeToVisible(range)
			})
			
			self.outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
		}
		
	}
	
	func extractFileSystem(with arguments: [String]) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
			
			guard let path = NSBundle.mainBundle().pathForResource("ExtractFileSystem", ofType: "command") else {
				print("Unable to locate ExtractFileSystem.command")
				return
			}
			
			self.isRunning = true
			
			self.task = NSTask()
			self.task.launchPath = path
			self.task.arguments = arguments
			
			// Once the task session has finished
			self.task.terminationHandler = {
				task in
				dispatch_async(dispatch_get_main_queue(), {
					self.extractButton.enabled = true
					self.OTAPath.enabled = true
					self.outputPath.enabled = true
					self.stopExtractionButton.enabled = false
					self.spinner.stopAnimation(self)
					self.spinner.hidden = true
					self.isRunning = false
				})
			}
			
			self.displayStdout(from: self.task)
			
			self.task.launch()
			self.task.waitUntilExit()
		}
	}
	
	// MARK:- IBActions
	@IBAction func startExtraction(sender: NSButton) {
		// Zero-out the outputTextView
		outputTextView.string = ""
		
		if let OTAURL = OTAPath.URL, let outputURL = outputPath.URL {
			let OTALocation = OTAURL.path!
			let outputLocation = outputURL.path!
			/* The OTA zip file name without the .zip extension
			    Used to interact with the expanded directory */
			let OTAExpandedLoaction = NSString(string: OTAURL.lastPathComponent!).stringByDeletingPathExtension
			
			/* The following series of guard statements are used to get the path to included binaries
			    and make sure they're there */
			guard let unar = NSBundle.mainBundle().pathForResource("unar", ofType: nil) else {
				print("Unable to locate unar")
				return
			}
			
			guard let pbxz = NSBundle.mainBundle().pathForResource("pbzx", ofType: nil) else {
				print("Unable to locate pbzx")
				return
			}
			
			guard let otaa = NSBundle.mainBundle().pathForResource("otaa", ofType: nil) else {
				print("Unable to locate otaa")
				return
			}
			
			// Build an array of arguments for use in ExtractFileSystem.command
			var arguments: [String] = []
			arguments.append(outputLocation)
			arguments.append(OTALocation)
			arguments.append(unar)
			arguments.append(pbxz)
			arguments.append(OTAExpandedLoaction)
			arguments.append(otaa)
			
			// Set states of various UI elements before starting the task
			extractButton.enabled = false
			self.OTAPath.enabled = false
			self.outputPath.enabled = false
			self.stopExtractionButton.enabled = true
			self.spinner.hidden = false
			spinner.startAnimation(self)
			
			extractFileSystem(with: arguments)
		}
	}
	
	@IBAction func stopExtraction(sender: NSButton) {
		// Just in case...
		if isRunning {
			self.task.terminate()
		}
	}
}