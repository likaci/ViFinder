//
//  FileViewController.h
//  ViFinder
//
//  Created by liuwencai on 15/5/11.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FileViewController : NSViewController <NSTableViewDataSource>
@property (strong) IBOutlet NSTableView *fileTableView;


@end

