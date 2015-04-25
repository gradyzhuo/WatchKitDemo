//
//  GZNotificationCallBackClass.m
//  MyWatch
//
//  Created by Grady Zhuo on 4/16/15.
//  Copyright (c) 2015 Grady Zhuo. All rights reserved.
//

#import "GZNotificationCallBack.h"

#pragma mark -

void callback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo);

#pragma mark -

NSString *GZCFNotificationCallBackConvertorNotificationName = @"GZCFNotificationCallBackConvertorNotificationName";
NSString *GZCFNotificationCallBackConvertorNotificationOriginalNameKey = @"original_name";
CFNotificationCallback GZCFNotificationCallBackBlock = callback;

void callback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
    
    NSString *originalName = (__bridge NSString *)(name);
    [[NSNotificationCenter defaultCenter] postNotificationName:GZCFNotificationCallBackConvertorNotificationName object:nil userInfo:@{GZCFNotificationCallBackConvertorNotificationOriginalNameKey:originalName}];
    
}