//
//  MyTableView.m
//  ViFinder
//
//  Created by liuwencai on 15/5/12.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import "MyTableView.h"

@implementation MyTableView{
    NSFileManager *fileManager;
    NSMutableArray *fileArray;
    NSString *currentPath;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setDataSource:self];
        [self reloadData];
        if (fileManager == nil) {
            fileManager = [[NSFileManager alloc] init];
        }
        fileArray = [[NSMutableArray alloc] init];
        currentPath = @"/";
        [self showPath:currentPath];

    }

    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return YES;
}

- (BOOL)resignFirstResponder {
    return YES;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return fileArray.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return fileArray[row];
}

- (void)keyDown:(NSEvent *)theEvent {
    if (theEvent.keyCode == 38) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:self.selectedRow + 1];
        [self selectRowIndexes:indexSet byExtendingSelection:false];
    }
    if (theEvent.keyCode == 40) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:self.selectedRow - 1];
        [self selectRowIndexes:indexSet byExtendingSelection:false];
    }
    if (theEvent.keyCode == 36) {
        NSString *dir = fileArray[(NSUInteger) self.selectedRow];
        if ([currentPath isEqualToString:@"/"]) {
            currentPath = @"";
        }
        currentPath = [currentPath stringByAppendingFormat:@"/%@", dir];
        [self showPath:currentPath];
    }
}

-(void)showPath:(NSString*)path {
    fileArray = [[self getFileListAtPath:path] mutableCopy];
    [self reloadData];
}

- (NSArray *)getFileListAtPath:(NSString *)path {
    return [fileManager contentsOfDirectoryAtPath:path error:nil];
}

@end
