//
//  OverwriteFileViewController.h
//  ViFinder
//
//  Created by liuwencai on 15/5/26.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OverwriteFileViewController : NSViewController
@property NSString *sourcePath;
@property NSString *targetPath;
@property(strong) IBOutlet NSTextField *sourceName;
@property(strong) IBOutlet NSTextField *targetName;
@property(nonatomic, copy) void (^overWrite)();
@property(nonatomic, copy) void (^overWriteAll)();
@property(nonatomic, copy) void (^skip)();
@property(nonatomic, copy) void (^skipAll)();
@property(nonatomic, copy) void (^rename)();


@end
