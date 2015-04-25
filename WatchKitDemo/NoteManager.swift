//
//  NoteManager.swift
//  WatchKitDemo
//
//  Created by Grady Zhuo on 4/25/15.
//  Copyright (c) 2015 Grady Zhuo. All rights reserved.
//

import UIKit


class Note : Dictionariable {
    var id:String
    var title:String
    var description:String
    
    init(title atitle:String, description aDescription:String, id oldID:String? = nil){
        title = atitle
        description = aDescription
        id = oldID ?? toString(NSDate().timeIntervalSince1970)
    }
    
    convenience init(dataDict:[String:AnyObject]){
        let title:String = (dataDict["title"] ?? "") as! String
        let description:String = (dataDict["description"] ?? "") as! String
        let id = (dataDict["id"] ?? "") as! String
        
        self.init(title:title, description:description, id:id)
        
    }
    
    func convertToDataDict()->[String:AnyObject]{
        return ["title":self.title, "description":self.description, "id":self.id]
    }
    
}

func ==(lhs:Note, rhs:Note)->Bool{
    return lhs.id == rhs.id
}

class NoteManager {
    
    private let storage = Storage<Note>()
    
    private static let singleton = NoteManager()
    
    class func defaultManager()->NoteManager{
        return singleton
    }
    
    
    init() {
        
        let userDefaults = NSUserDefaults.sharedGroupUserDefaults()
        if let noteDataDicts = userDefaults.objectForKey("Notes") as? [[String:AnyObject]] {
            let notes:[Note] = noteDataDicts.map{ return Note(dataDict: $0) }
            self.storage.addObjects(notes)
        }

        
        
        
        
    }
    
    func createNote(title:String, description:String)->Note{
        
        var newNote = Note(title: title, description: description)
        self.storage.addObject(newNote)
        
        self.saveToUserDefaults()
        
        return newNote
    }
    
    
    func fetchNotes(completionHandler:(notes:[Note])->Void){
        storage.getObjects(completionHandler)
    }
    
    func saveToUserDefaults(){
        
        
        var userDefaults = NSUserDefaults.sharedGroupUserDefaults()
        
        storage.getObjects { (objects) -> Void in
            
            var dataDicts:[[String:AnyObject]] = objects.map{ return $0.convertToDataDict() }
            userDefaults.setObject(dataDicts, forKey: "Notes")
            
            userDefaults.synchronize()
        }

        
    }
    
}
