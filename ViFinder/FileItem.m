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

- (instancetype)initWithName:(NSString *)name fileAttribute:(NSDictionary *)aFileAttribute path:(NSString *)path {
    self = [super init];
    if (self) {
        self.name = name;
        fileAttribute = aFileAttribute;
        self.path = [path stringByAppendingFormat:@"/%@", name];
        self.isDirectiory = [[aFileAttribute valueForKey:@"NSFileType"] isEqualToString:NSFileTypeDirectory];
        self.ext = self.isDirectiory ? @"Dir" : [name pathExtension];
        self.previewItemURL = [NSURL fileURLWithPath:self.path];
    }

    return self;
}

+ (instancetype)itemWithName:(NSString *)name fileAttribute:(NSDictionary *)aFileAttribute path:(NSString *)path {
    return [[self alloc] initWithName:name fileAttribute:aFileAttribute path:path];
}


@end
