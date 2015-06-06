//
//  FileViewController.h
//  ViFinder
//
//  Created by liuwencai on 15/5/11.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <Quartz/Quartz.h>
#import "VDKQueue.h"

@class FileTableView;
@class FileItem;

@interface FileViewController : NSViewController <QLPreviewPanelDelegate, QLPreviewPanelDataSource, VDKQueueDelegate, NSTextFieldDelegate> {
    NSMutableArray *fileItems;
}
@property(strong) IBOutlet FileTableView *fileTableView;
@property(strong) IBOutlet NSMenu *favouriteMenu;
@property(strong) IBOutlet NSButton *favouriteMenuButton;
@property(strong) IBOutlet NSArrayController *fileItemsArrayContoller;
@property(strong) IBOutlet NSSearchField *searchField;
@property int mode;
@property NSString *prefix;

@property FileItem *activeRow;

- (void)setFileItems:(NSMutableArray *)items;

- (void)showFavouriteMenu;

@end

enum {
    NORMAL = 1,
    INSERT = 2,
    VISUAL = 3,
};

