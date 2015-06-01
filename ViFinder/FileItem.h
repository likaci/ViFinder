//
//  FileItem.h
//  ViFinder
//
//  Created by liuwencai on 15/5/12.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface FileItem : NSObject <QLPreviewItem>
@property NSString *name;
@property BOOL isDirectiory;
@property NSString *ext;
@property NSURL *previewItemURL;
@property NSString *path;
@property NSImage *icon;
@property unsigned long long int *size;
@property NSDate *date;

- (instancetype)initWithName:(NSString *)name fileAttribute:(NSDictionary *)aFileAttribute path:(NSString *)path;

+ (instancetype)itemWithName:(NSString *)name fileAttribute:(NSDictionary *)aFileAttribute path:(NSString *)path;


@end
