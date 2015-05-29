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
    NSString *_shortcut;
}

@dynamic name;
@dynamic path;


- (NSString *)shortcut {
    if(_shortcut==nil)
        _shortcut =@"";
    return _shortcut;
}

- (void)setShortcut:(NSString *)shortcut {
    _shortcut = shortcut;
}

-(NSMenuItem *)menuItem {
    if (_menuItem == nil) {
        _menuItem = [[NSMenuItem alloc] initWithTitle:self.name action:@selector(favouriteMenuClick:) keyEquivalent:self.shortcut];
        [_menuItem setKeyEquivalentModifierMask:0];
    }
    return _menuItem;
}

- (void)setMenuItem:(NSMenuItem *)menuItem {
    _menuItem = menuItem;
}


@end
