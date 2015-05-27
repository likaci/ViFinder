//
//  FileViewController.h
//  ViFinder
//
//  Created by liuwencai on 15/5/11.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MyTableView;

@interface FileViewController : NSViewController <NSTableViewDataSource>
@property (strong) IBOutlet MyTableView *fileTableView;
@property (strong) IBOutlet NSMenu *favouriteMenu;
@property (strong) IBOutlet NSButton *favouriteMenuButton;


- (void)showFavouriteMenu;


@end

