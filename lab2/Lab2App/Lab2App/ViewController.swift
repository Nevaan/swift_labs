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
		updateFields()
		if (currentRecord + 1 >= albums.count) {
			nextButton.enabled = false
		} else {
			nextButton.enabled = true
		}
		if (currentRecord > 0) {
			prevButton.enabled = true
		}
		updateRecordCounter()
		saveButton.enabled = false
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
	}
	
	
	@IBAction func newButtonAction(sender: UIButton) {
		clearFields()
		recordCount.text = "New record"
		currentRecord = albums.count + 1
		saveButton.enabled = true
	}
	
	@IBAction func saveButtonAction(sender: UIButton) {
		if(currentRecord > albums.count) {
			let newRecord = NSDictionary(dictionary:
			[
				"artist": currentArtist.text!,
				"date": currentYear.text!,
				"genre": currentGenre.text!,
				"rating": currentRating.text!,
				"title": currentTitle.text!
			]
			)
			albums.addObject(newRecord)
			recordCount.text = "Record \(currentRecord) of \((albums.count))"
		}
		
		saveButton.enabled = false
	}
	

	/* Listeners */
	
    @IBAction func stepperValueChanged(sender: UIStepper) {
         currentRating.text = Int(sender.value).description
    }
	
	
    @IBAction func artistFIeldChanged(sender: UITextField) {
        albumDataChanged()
    }

    @IBAction func titleFieldChanged(sender: UITextField) {
        albumDataChanged()
    }
    
    @IBAction func genreFieldChanged(sender: UITextField) {
        albumDataChanged()
    }
    
    @IBAction func yearFieldChanged(sender: UITextField) {
        albumDataChanged()
    }
    
    @IBAction func ratingFieldChanged(sender: UIStepper) {
        albumDataChanged()
    }
	
	/* Utils */
	
	func updateFields() {
		currentArtist.text = albums[currentRecord]["artist"] as? String
		currentTitle.text = albums[currentRecord]["title"] as? String
		currentGenre.text = albums[currentRecord]["genre"] as? String
		currentYear.text =  String((albums[currentRecord]["date"]!)!)
		currentRating.text = String((albums[currentRecord]["rating"]!)!)
	}
	
	func clearFields() {
		currentArtist.text = ""
		currentTitle.text = ""
		currentGenre.text = ""
		currentYear.text = ""
		currentRating.text = "0"
	}
    
    func updateRecordCounter() {
        recordCount.text = "Record \(currentRecord + 1) of \((albums.count))"
    }
    
    func albumDataChanged() {
        saveButton.enabled = true
    }
	
	func saveDataToFile(){
		print("O matko bosko co to się staneło!")
		print(albumsDocPath)
		albums.writeToFile(albumsDocPath, atomically: true)
		
	}
	
	func loadDataFromFile() {
		print("Hahaha skurwysyny, i co teraz?")
		albumsDocPath = documentsPath.stringByAppendingString("/albums.plist")
		
		if !fileManager.fileExistsAtPath(albumsDocPath) {
			try? fileManager.copyItemAtPath(plistCatPath!, toPath: albumsDocPath)
		}
		
		albums = NSMutableArray(contentsOfFile: albumsDocPath)!
		
		print(albums)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

