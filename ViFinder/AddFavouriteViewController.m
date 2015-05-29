//
//  AddFavouriteViewController.m
//  ViFinder
//
//  Created by liuwencai on 15/5/15.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import "AddFavouriteViewController.h"

@interface AddFavouriteViewController ()

@end

@implementation AddFavouriteViewController {
@private
    NSString *_path;
    NSString *_name;
    NSString *_shortcut;
}


@synthesize name = _name;
@synthesize shortcut = _shortcut;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (NSString *)path {
    return _path;
}

- (void)setPath:(NSString *)path {
    _path = path;
    _name = path.lastPathComponent;
}

- (IBAction)add:(id)sender {
    self.addFav(_path,_name,_shortcut);
    [self dismissViewController:self];
}

@end
