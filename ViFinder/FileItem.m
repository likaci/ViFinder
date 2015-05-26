//
//  FileItem.m
//  ViFinder
//
//  Created by liuwencai on 15/5/12.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import "FileItem.h"

@implementation FileItem {
    NSDictionary *fileAttribute;
}

- (instancetype)initWithFileAttribute:(NSDictionary *)aFileAttribute name:(NSString *)name {
    self = [super init];
    if (self) {
        fileAttribute = aFileAttribute;
        self.name = name;
        self.isDirectiory = [[aFileAttribute valueForKey:@"NSFileType"] isEqualToString:NSFileTypeDirectory];
        self.ext = self.isDirectiory ? @"Dir" : [name pathExtension];
    }

    return self;
}

+ (instancetype)itemWithFileAttribute:(NSDictionary *)aFileAttribute name:(NSString *)name {
    return [[self alloc] initWithFileAttribute:aFileAttribute name:name];
}


@end
