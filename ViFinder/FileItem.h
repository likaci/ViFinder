//
//  FileItem.h
//  ViFinder
//
//  Created by liuwencai on 15/5/12.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileItem : NSObject
@property NSString *name;
@property BOOL isDirectiory;
@property NSString *ext;

+ (instancetype)itemWithFileAttribute:(NSDictionary *)aFileAttribute name:(NSString *)name;

@end
