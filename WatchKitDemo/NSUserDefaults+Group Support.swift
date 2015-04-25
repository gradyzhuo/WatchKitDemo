//
//  NSUserDefaults+Group Support.swift
//  WatchKitDemo
//
//  Created by Grady Zhuo on 4/25/15.
//  Copyright (c) 2015 Grady Zhuo. All rights reserved.
//

import Foundation

extension NSUserDefaults {
    
    private static let groupDefaults:NSUserDefaults = NSUserDefaults(suiteName: "group.com.ofsky.mywatch")!
    
    class func sharedGroupUserDefaults()->NSUserDefaults{
        return groupDefaults
    }
    
}