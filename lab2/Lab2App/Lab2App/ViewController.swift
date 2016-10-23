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
    
    var currentRecord = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let plistCatPath = Bundle.main.path(forResource: "albums", ofType: "plist");
        var albums = NSArray?()
        albums = NSArray(contentsOfFile: plistCatPath!)
      
        currentArtist.text = albums?[currentRecord]["artist"] as! String
        currentTitle.text = albums?[currentRecord]["title"] as! String
        currentGenre.text = albums?[currentRecord]["genre"] as! String
        
      
        ratingStepper.maximumValue = 5
        ratingStepper.wraps = true
        ratingStepper.autorepeat = true
        
        
        
        print(albums)
        
    }

    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        currentRating.text = Int(sender.value).description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

