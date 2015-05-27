//
//  FileViewController.m
//  ViFinder
//
//  Created by liuwencai on 15/5/11.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import "FileViewController.h"
#import "FileTableView.h"
#import "AppDelegate.h"

@implementation FileViewController {
@private
    FileTableView *_fileTableView;
}

@synthesize fileTableView = _fileTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

}

- (void)showFavouriteMenu {
    //to window
    NSPoint p = [self.view convertPoint: _favouriteMenuButton.frame.origin toView:nil];
    //to screen
    p = [self.view.window convertBaseToScreen:p];
    [_favouriteMenu popUpMenuPositioningItem:nil atLocation:p inView:nil];
}

@end
