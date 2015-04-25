//
//  DetailInterfaceController.swift
//  WatchKitDemo
//
//  Created by Grady Zhuo on 4/25/15.
//  Copyright (c) 2015 Grady Zhuo. All rights reserved.
//

import WatchKit
import Foundation
import GZNotificationCenter

class MasterInterfaceController: WKInterfaceController {

    @IBOutlet var table:WKInterfaceTable!
    
    
    var notes = [Note]()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        let userDefaults = NSUserDefaults.sharedGroupUserDefaults()
        if let noteDataDicts = userDefaults.objectForKey("Notes") as? [[String:AnyObject]] {
            
            var notes:[Note] = noteDataDicts.map{ return Note(dataDict: $0) }
            self.notes = notes
            
            self.table.setNumberOfRows(self.notes.count, withRowType: "NoteRowController")
            
            for (index, note) in enumerate(self.notes) {

                var rowController = self.table.rowControllerAtIndex(index) as? NoteRowController
                rowController?.label.setText(note.title)
                
            }
            
            
        }
        
    }
    
    func didReceiveNotification(notification:NSNotification){
        
        println("name:\(notification.name)")
        
        let userDefaults = NSUserDefaults.sharedGroupUserDefaults()
        let dataDict = userDefaults.objectForKey(notification.name) as! [String:AnyObject]
        
        let note = Note(dataDict: dataDict)
        self.showNote(note)
    }
    
    func showNote(note:Note){
        self.pushControllerWithName("DetailPage", context: note)
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

    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        
        var note = self.notes[rowIndex]
        self.showNote(note)
        
        
    }
    
}
