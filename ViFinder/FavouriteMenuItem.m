//
//  FavouriteMenuItem.m
//  ViFinder
//
//  Created by liuwencai on 15/5/14.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import "FavouriteMenuItem.h"


@implementation FavouriteMenuItem {
@private
    NSMenuItem *_menuItem;
}

@dynamic name;
@dynamic path;
@dynamic shortcut;


-(NSMenuItem *)menuItem {
    if (_menuItem == nil) {
        _menuItem = [[NSMenuItem alloc] initWithTitle:self.name action:@selector(favouriteMenuClick:) keyEquivalent:self.shortcut];
    }
    return _menuItem;
}

@end
