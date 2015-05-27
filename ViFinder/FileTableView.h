//
//  FileTableView.h
//  ViFinder
//
//  Created by liuwencai on 15/5/12.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <Quartz/Quartz.h>

@interface FileTableView : NSTableView <NSTableViewDataSource, QLPreviewPanelDelegate, QLPreviewPanelDataSource>

@end
