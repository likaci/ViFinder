//
//  OverwriteFileViewController.m
//  ViFinder
//
//  Created by liuwencai on 15/5/26.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import "OverwriteFileViewController.h"

@interface OverwriteFileViewController ()

@end

@implementation OverwriteFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.sourceName setStringValue:self.sourcePath.lastPathComponent];
    [self.targetName setStringValue:self.targetPath.lastPathComponent];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewController:self];
}

- (IBAction)overWrite:(id)sender {
    self.overWrite();
    [self dismissViewController:self];
}

- (IBAction)overWriteAll:(id)sender {
    self.overWriteAll();
    [self dismissViewController:self];
}

- (IBAction)skip:(id)sender {
    self.skip();
    [self dismissViewController:self];
}

- (IBAction)skipAll:(id)sender {
    self.skipAll();
    [self dismissViewController:self];
}

- (IBAction)rename:(id)sender {
    self.rename();
    [self dismissViewController:self];
}

@end
