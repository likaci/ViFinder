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
@property NSString *icon;

- (instancetype)initWithName:(NSString *)name icon:(NSString *)icon;

+ (instancetype)itemWithName:(NSString *)name icon:(NSString *)icon;


@end
