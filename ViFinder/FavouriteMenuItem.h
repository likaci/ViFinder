//
//  FavouriteMenuItem.h
//  ViFinder
//
//  Created by liuwencai on 15/5/14.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Cocoa/Cocoa.h>


@interface FavouriteMenuItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * shortcut;

@property NSMenuItem *menuItem;

@end
