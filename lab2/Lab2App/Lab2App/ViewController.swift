//
//  ViewController.swift
//  Lab2App
//
//  Created by Użytkownik Gość on 13.10.2016.
//  Copyright (c) 2016 Nevaan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Properties
    
    @IBOutlet weak var currentArtist: UITextField!
    
    @IBOutlet weak var currentTitle: UITextField!
	
    @IBOutlet weak var currentGenre: UITextField!
    
    @IBOutlet weak var currentYear: UITextField!
    
    @IBOutlet weak var currentRating: UILabel!
    
    @IBOutlet weak var ratingStepper: UIStepper!
    
    @IBOutlet weak var prevButton: UIButton!
    
	@IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var recordCount: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
	
	@IBOutlet weak var deleteButton: UIButton!
	
	@IBOutlet weak var newButton: UIButton!
	
	var currentRecord = 0
	var albums: NSMutableArray = []
	var albumsDocPath: String = ""
	let fileManager = NSFileManager.defaultManager()
	let plistCatPath = NSBundle.mainBundle().pathForResource("albums", ofType: "plist");
	let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loadDataFromFile()
		
		/* Observing application state to save/load data */
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.saveDataToFile), name: UIApplicationWillResignActiveNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.loadDataFromFile), name: UIApplicationDidBecomeActiveNotification, object: nil)
		
		updateFields()
		updateRecordCounter()
		ratingStepper.maximumValue = 5
		ratingStepper.wraps = true
		ratingStepper.autorepeat = true
		
		prevButton.enabled = false
		saveButton.enabled = false
	}
	
	/* Button actions */
	
	@IBAction func nextButtonAction(sender: UIButton) {
		
		
		currentRecord += 1
		
		if (currentRecord + 1 == albums.count) {
			updateFields()
			//nextButton.enabled = false
		} else if (currentRecord + 1 > albums.count){
			clearFields()
			recordCount.text = "New record"
			//currentRecord = albums.count + 1
			saveButton.enabled = false
			nextButton.enabled = false
			
		} else {
			updateFields()
			nextButton.enabled = true
		}
		if (currentRecord > 0) {
			prevButton.enabled = true
		}
		
		if (currentRecord < albums.count) {
			updateRecordCounter()
			saveButton.enabled = false
		}
		ratingStepper.value = 0
		
	}
	
	@IBAction func prevButtonAction(sender: UIButton) {
		currentRecord -= 1
		updateFields()
		if(currentRecord < 1) {
			prevButton.enabled = false
		} else {
			prevButton.enabled = true
		}
		if(currentRecord < albums.count) {
			nextButton.enabled = true
		}
		updateRecordCounter()
		saveButton.enabled = false
		ratingStepper.value = 0
	}
	
	
	@IBAction func newButtonAction(sender: UIButton) {
		clearFields()
		recordCount.text = "New record"
		currentRecord = albums.count
		saveButton.enabled = false
		newButton.enabled = false
		prevButton.enabled = false
		nextButton.enabled = false
	}
	
	@IBAction func saveButtonAction(sender: UIButton) {
		if(currentRecord >= albums.count) {
			let newRecord = NSMutableDictionary(dictionary:
			[
				"artist": currentArtist.text!,
				"date": currentYear.text!,
				"genre": currentGenre.text!,
				"rating": currentRating.text!,
				"title": currentTitle.text!
			]
			)
			albums.addObject(newRecord)
			recordCount.text = "Record \(currentRecord + 1) of \((albums.count))"

			
		} else {
			let updatedRecord:NSMutableDictionary = albums[currentRecord] as! NSMutableDictionary
			updatedRecord.setValue(currentArtist.text!, forKey: "artist")
			updatedRecord.setValue(currentYear.text, forKey: "date")
			updatedRecord.setValue(currentGenre.text, forKey: "genre")
			updatedRecord.setValue(currentRating.text, forKey: "rating")
			updatedRecord.setValue(currentTitle.text, forKey: "title")
		}
		
		saveButton.enabled = false
		nextButton.enabled = true
		deleteButton.enabled = true
		newButton.enabled = true
		if (currentRecord > 0) {
			prevButton.enabled = true
		}
	}
	
	
	@IBAction func deleteButtonAction(sender: UIButton) {
		
		if (albums.count == 1 && currentRecord == 0) {
			albums.removeObjectAtIndex(currentRecord)
			clearFields()
			nextButton.enabled = false
			prevButton.enabled = false
			deleteButton.enabled = false
			newButton.enabled = false
			recordCount.text = "New record"
			
		} else {
			if(currentRecord < albums.count) {
				albums.removeObjectAtIndex(currentRecord)
			}
			updateFields()
			recordCount.text = "Record \(currentRecord + 1) of \((albums.count))"
			nextButton.enabled = true
		}
		
		if(currentRecord > 0) {
			prevButton.enabled = true
		}
		saveButton.enabled = false
	}

	/* Listeners */
	
    @IBAction func stepperValueChanged(sender: UIStepper) {
         currentRating.text = Int(sender.value).description
    }
		
    @IBAction func albumDataChangeListener(_ sender: AnyObject) {
        albumDataChanged()
    }
	
	/* Utils */
	
	func updateFields() {
		if(currentRecord < albums.count) {
		currentArtist.text = albums[currentRecord]["artist"] as? String
		currentTitle.text = albums[currentRecord]["title"] as? String
		currentGenre.text = albums[currentRecord]["genre"] as? String
		currentYear.text =  String((albums[currentRecord]["date"]!)!)
		currentRating.text = String((albums[currentRecord]["rating"]!)!)
		}
		else {
			currentRecord = currentRecord - 1
			updateFields()			
		}
		
	}
	
	func clearFields() {
		currentArtist.text = ""
		currentTitle.text = ""
		currentGenre.text = ""
		currentYear.text = ""
		ratingStepper.value = 0
		currentRating.text = "0"
	}
    
    func updateRecordCounter() {
        recordCount.text = "Record \(currentRecord + 1) of \((albums.count))"
    }
    
    func albumDataChanged() {
        saveButton.enabled = true
    }
	
	func saveDataToFile(){
		albums.writeToFile(albumsDocPath, atomically: true)
	}
	
	func loadDataFromFile() {
		albumsDocPath = documentsPath.stringByAppendingString("/albums.plist")
		
		if !fileManager.fileExistsAtPath(albumsDocPath) {
			try? fileManager.copyItemAtPath(plistCatPath!, toPath: albumsDocPath)
		}
		
		albums = NSMutableArray(contentsOfFile: albumsDocPath)!
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

