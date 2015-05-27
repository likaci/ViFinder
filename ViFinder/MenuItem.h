//
//  MenuItem.h
//  ViFinder
//
//  Created by liuwencai on 15/5/13.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MenuItem : NSObject
@property NSString *name;
@property NSMenuItem *item;
@property NSString *path;

- (instancetype)initWithItem:(NSMenuItem *)item name:(NSString *)name path:(NSString *)path;

+ (instancetype)itemWithItem:(NSMenuItem *)item name:(NSString *)name path:(NSString *)path;


@end
