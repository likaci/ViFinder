//
//  AddFavouriteViewController.h
//  ViFinder
//
//  Created by liuwencai on 15/5/15.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AddFavouriteViewController : NSViewController
@property NSString *path;
@property NSString *name;
@property NSString *shortcut;
@property (nonatomic, copy) void (^addFav)(NSString *path,NSString *name,NSString *shortcut);

@end
