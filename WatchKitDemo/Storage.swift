//
//  GYStorage.swift
//  Flingy
//
//  Created by Grady Zhuo on 3/22/15.
//  Copyright (c) 2015 Skytiger Studio. All rights reserved.
//

import Foundation

//MARK: - Defination

protocol Identifierable{
    var id:String { set get }
}

typealias Dictionariable = protocol<Equatable, Identifierable>

enum StorageFetchType {
    case All
    case Part(fetchRange:Range<Int>)
    case Optional(IDs:[String])
}

//MARK: -

enum StorageExtendObjectsPosition{
    case Leading
    case Tail
}

class Storage <T:AnyObject where T : Dictionariable> {
    
    
    private var leadingObjects:[T] = []
    private var tailObjects:[T] = []
    
    private var objects:[T]{
        
        var objects:[T] = [] + self.leadingObjects
        
        for id in self.privatedObjectCache.objectIDs {
            if let obj = self.privatedObjectCache.cache[id] {
                objects.append(obj)
            }
        }
        
        objects.extend(self.tailObjects)
        
        return objects
    }
    
    private var privatedObjectCache = StorageCache<T>()
    
    
    func addObject(object:T){
        
        self.privatedObjectCache.addObject(object)
        
    }
    
    func insertObjectsAtFront(objects:[T]){
        self.insertObjects(objects, inRange: 0..<objects.count)
    }
    
    func insertObjects(objects:[T], inRange range:Range<Int>){
        
        var generator = range.generate()
        for (index, object) in enumerate(objects) {
            var i = generator.next() ?? 0
            self.privatedObjectCache.insertObject(object, atIndex: i)
        }
        
    }
    
    
    func insertObject(object:T, atIndex index:Int){
        self.privatedObjectCache.insertObject(object, atIndex: index)
    }
    
    
    func getExtendObjects(atPosition position:StorageExtendObjectsPosition, completionHandler:(objs:[T])->Void){
        
        switch position {
            
        case .Leading:
            completionHandler(objs: self.leadingObjects)
        case .Tail:
            completionHandler(objs: self.tailObjects)
        }
        
            
    }
    
    
    func addExtendObjects(objects:[T], atPosition position:StorageExtendObjectsPosition){
        switch position {
            
        case .Leading:
            self.leadingObjects.extend(objects)
        case .Tail:
            self.tailObjects.extend(objects)
        }
        
    }
    
    
    func removeAllExtendObjects(atPosition position:StorageExtendObjectsPosition){
        
        switch position {
        
            case .Leading:
                self.removeExtendObjects(self.leadingObjects, atPosition: position)
            case .Tail:
                self.removeExtendObjects(self.tailObjects, atPosition: position)
            
        }
        
    }
    
    func removeExtendObjects(objects:[T], atPosition position:StorageExtendObjectsPosition){
        
        var ids:[String] = objects.map{ return $0.id }
        self.removeExtendObjects(by: ids, atPosition: position)
        
    }
    
    func removeExtendObjects(by objectIDs:[String], atPosition position:StorageExtendObjectsPosition){
        
        switch position {
            
        case .Leading:
            self.leadingObjects = self.leadingObjects.filter({ obj -> Bool in
                return !contains(objectIDs, obj.id)
            })
        case .Tail:
            self.tailObjects = self.tailObjects.filter({ obj -> Bool in
                return !contains(objectIDs, obj.id)
            })
        }
        
        
    }
    
    func addObjects(objects:[T]){
        
        for object  in objects {
            
            self.privatedObjectCache.addObject(object)
        }
        
    }
    
    func removeObjects(byObjectIDs objectIds:[String]){
        self.privatedObjectCache.removeObjects(byIDs: objectIds)
    }
    
    func removeObject(object:T){
        
        self.privatedObjectCache.removeObject(byID: object.id)
        
    }
    
    func removeObjects(objects:[T]){
        
        for object in objects {
            self.removeObject(object)
        }
        
    }
    
    func removeAll(keepCapacity: Bool = false){
        self.privatedObjectCache.removeAllObjects()
    }
    
    
    func getObjects(completionHandler:(objects:[T])->Void){
        self.getObjects(byFetchType: .All, completionHandler: completionHandler)
    }
    
    
    func getObjects(byFetchType fetchType:StorageFetchType, completionHandler:(objects:[T])->Void){
        
        var objects = self.objects
        
        switch fetchType {
        case .All :
            completionHandler(objects: objects)
        case let .Part(fetchRange):
            var sliceObjects = objects[fetchRange]
            completionHandler(objects: [T](sliceObjects))
            
        case let .Optional(objectIDs):
            var filtedObjects:[T] = objects.filter { (object:T) -> Bool in
                return find(objectIDs, object.id) != nil
            }
            completionHandler(objects: filtedObjects)
        }

    }
    
}


private struct StorageCache<T:AnyObject where T : Dictionariable> {
    
    var objectIDs:[String] = []
    
    var cache = [String:T]()
    
    mutating func addObject(object:T){
        
        if !contains(self.objectIDs, object.id) {
            self.objectIDs.append(object.id)
        }
        self.cache[object.id] = object
        
    }
    
    mutating func insertObject(object:T, atIndex index:Int){
        
        if !contains(self.objectIDs, object.id) {
            
            if contains(self.objectIDs.startIndex..<self.objectIDs.endIndex, index){
                self.objectIDs.insert(object.id, atIndex: index)
            }else{
                self.objectIDs.append(object.id)
            }
            
            
        }
        
        self.cache[object.id] = object
        
    }
    
    mutating func removeAllObjects() {
        
        self.objectIDs.removeAll(keepCapacity: false)
        self.cache.removeAll(keepCapacity: false)
        
    }
    
    mutating func removeObject(byID id:String){
        self.objectIDs = self.objectIDs.filter({ (item) -> Bool in
            return item != id
        })
        
        self.cache.removeValueForKey(id)
        
    }
    
    mutating func removeObjects(byIDs ids:[String]) {
        
        for id in ids {
            self.removeObject(byID: id)
        }
        
    }
    
}