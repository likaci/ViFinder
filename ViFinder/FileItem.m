//
//  FileItem.m
//  ViFinder
//
//  Created by liuwencai on 15/5/12.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import "FileItem.h"

@implementation FileItem

- (instancetype)initWithName:(NSString *)name icon:(NSString *)icon {
    self = [super init];
    if (self) {
        self.name = name;
        self.icon = icon;
    }

    return self;
}

+ (instancetype)itemWithName:(NSString *)name icon:(NSString *)icon {
    return [[self alloc] initWithName:name icon:icon];
}


@end
