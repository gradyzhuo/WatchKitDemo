//
//  GZNotificationCenter.swift
//  MyWatch
//
//  Created by Grady Zhuo on 4/15/15.
//  Copyright (c) 2015 Grady Zhuo. All rights reserved.
//

import Foundation

enum GZNotificationCenterAgentType {
    /// Core Foundation
    case CFNotificationCenter
}

/// The encapsulated implementation of CFNotificationCenter by bridge to NSNotificationCenter.
public class GZNotificationCenter {
    
    static let singleton = GZNotificationCenter()
    
    public class func defaultCenter()->GZNotificationCenter {
        return singleton
    }
    
    init(){
        
        NSNotificationCenter.defaultCenter().addObserverForName(GZCFNotificationCallBackConvertorNotificationName, object: nil, queue: NSOperationQueue.mainQueue()) { (note:NSNotification!) -> Void in
            
            var name = (note.userInfo?[GZCFNotificationCallBackConvertorNotificationOriginalNameKey] as? String) ?? ""
            
            NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil)
            
        }
    }
    
    /// Add an observer for receive notifications from CFNotificationCenter.
    public func addObserver(observer: AnyObject, selector aSelector: Selector, name aName: String){
        self.addObserver(.CFNotificationCenter, observer: observer, selector: aSelector, name: aName)
    }
    
    func addObserver(agentType:GZNotificationCenterAgentType, observer: AnyObject, selector aSelector: Selector, name aName: String){

        switch agentType {
            
        case .CFNotificationCenter:
            
            let center = CFNotificationCenterGetDarwinNotifyCenter()
            CFNotificationCenterAddObserver(center, unsafeAddressOf(observer), GZCFNotificationCallBackBlock, aName, nil, CFNotificationSuspensionBehavior.DeliverImmediately)
            
            NSNotificationCenter.defaultCenter().addObserver(observer, selector: aSelector, name: aName, object: nil)
        }
        
    }
    
    /// Post an notification to observer that has been registered as an observer through CFNotificationCenter.
    public func postNotification(name aName: String){
        
        self.postNotification(.CFNotificationCenter, name: aName)
    }
    
    func postNotification(agentType:GZNotificationCenterAgentType, name aName: String){
        
        switch agentType {
            
        case .CFNotificationCenter:

            let center = CFNotificationCenterGetDarwinNotifyCenter()
            CFNotificationCenterPostNotification(center, aName, nil, nil, 1)
            
        }
        
    }
    
    public func removeObserver(observer: AnyObject, name aName:String){
        
        self.removeObserver(.CFNotificationCenter, observer: observer, name: aName)
        
    }
    
    func removeObserver(agentType:GZNotificationCenterAgentType, observer: AnyObject, name aName:String){
        
        switch agentType {
            
        case .CFNotificationCenter:
            
            let center = CFNotificationCenterGetDarwinNotifyCenter()
            CFNotificationCenterRemoveObserver(center, unsafeAddressOf(observer), aName, nil)
            
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
        
    }
    
}