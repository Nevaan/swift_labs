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

