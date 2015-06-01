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

- (NSImage *)icon {
    NSImage *icon;
    if (self.isDirectiory) {
        icon = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)];
    } else {
        icon = [[NSWorkspace sharedWorkspace] iconForFileType:self.ext];
    }
    return icon;
}

- (unsigned long long int)size {
    return fileAttribute.fileSize;
}

- (NSDate *)date {
    return fileAttribute.fileModificationDate;
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

- (void)trashSelf {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [fileManager trashItemAtURL:[[NSURL alloc] initFileURLWithPath:self.path] resultingItemURL:nil error:nil];
}


@end
