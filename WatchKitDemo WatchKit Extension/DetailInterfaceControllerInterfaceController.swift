//
//  InterfaceController.swift
//  WatchKitDemo WatchKit Extension
//
//  Created by Grady Zhuo on 4/24/15.
//  Copyright (c) 2015 Grady Zhuo. All rights reserved.
//

import WatchKit
import Foundation
import GZNotificationCenter

class DetailInterfaceController: WKInterfaceController {

    @IBOutlet var titleLabel:WKInterfaceLabel!
    @IBOutlet var descriptionLabel:WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        if let note = context as? Note {
            self.showNote(note)
        }
        
        
    }

    
    func didReceiveNotification(notification:NSNotification){
        let userDefaults = NSUserDefaults.sharedGroupUserDefaults()
        let dataDict = userDefaults.objectForKey(notification.name) as! [String:AnyObject]
        
        let note = Note(dataDict: dataDict)
        self.showNote(note)
    }
    
    func showNote(note:Note){

        self.titleLabel.setText(note.title)
        self.descriptionLabel.setText(note.description)
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        GZNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveNotification:", name: "ShowToWatch")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()

        
        GZNotificationCenter.defaultCenter().removeObserver(self, name: "ShowToWatch")
    }
    

}
