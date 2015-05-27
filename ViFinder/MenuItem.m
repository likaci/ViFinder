//
//  MenuItem.m
//  ViFinder
//
//  Created by liuwencai on 15/5/13.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem {
@private
    NSMenuItem *_item;
    NSString *_name;
    NSString *_path;
}

@synthesize item = _item;
@synthesize name = _name;
@synthesize path = _path;

- (instancetype)initWithItem:(NSMenuItem *)item name:(NSString *)name path:(NSString *)path {
    self = [super init];
    if (self) {
        self.item = item;
        self.name = name;
        self.path = path;
    }

    return self;
}

+ (instancetype)itemWithItem:(NSMenuItem *)item name:(NSString *)name path:(NSString *)path {
    return [[self alloc] initWithItem:item name:name path:path];
}


@end
