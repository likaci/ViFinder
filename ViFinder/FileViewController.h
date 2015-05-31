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

@class FileTableView;

@interface FileViewController : NSViewController <QLPreviewPanelDelegate, QLPreviewPanelDataSource>{
    NSMutableArray *fileItems;
}
@property (strong) IBOutlet FileTableView *fileTableView;
@property (strong) IBOutlet NSMenu *favouriteMenu;
@property (strong) IBOutlet NSButton *favouriteMenuButton;


@property (strong) IBOutlet NSArrayController *FileItemsArrayContoller;
-(void)setFileItems:(NSMutableArray *)items;

- (void)showFavouriteMenu;


@end

