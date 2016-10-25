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
    
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
         currentRating.text = Int(sender.value).description
    }
	
	@IBAction func nextButtonAction(sender: UIButton) {
		currentRecord += 1
		updateFields()
		if (currentRecord + 1 >= albums?.count) {
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
		if(currentRecord < albums?.count) {
			nextButton.enabled = true
		}
        updateRecordCounter()
        saveButton.enabled = false
	}
    
    var currentRecord = 0
    var albums = NSArray?()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        let plistCatPath = NSBundle.mainBundle().pathForResource("albums", ofType: "plist");
		
        albums = NSArray(contentsOfFile: plistCatPath!)
      
		updateFields()
		updateRecordCounter()
        ratingStepper.maximumValue = 5
        ratingStepper.wraps = true
        ratingStepper.autorepeat = true
        
        
        prevButton.enabled = false
        saveButton.enabled = false
        
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func updateFields() {
		currentArtist.text = albums?[currentRecord]["artist"] as? String
		currentTitle.text = albums?[currentRecord]["title"] as? String
		currentGenre.text = albums?[currentRecord]["genre"] as? String
		currentYear.text =  String((albums?[currentRecord]["date"]!)!)
		currentRating.text = String((albums?[currentRecord]["rating"]!)!)
	}
    
    func updateRecordCounter() {
        recordCount.text = "Record \(currentRecord + 1) of \((albums?.count)!)"
    }
    
    func albumDataChanged() {
        saveButton.enabled = true
    }
	
}

