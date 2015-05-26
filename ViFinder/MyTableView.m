//
//  MyTableView.m
//  ViFinder
//
//  Created by liuwencai on 15/5/12.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import "MyTableView.h"
#import "FileItem.h"

@implementation MyTableView {
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
    FileItem *item = fileArray[row];
    if ([[tableColumn identifier] isEqualToString:@"icon"]) {
        NSImage *folderIcon = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)];
        return folderIcon;
    } else {
        return [item valueForKey:[tableColumn identifier]];
    }
}

- (void)keyDown:(NSEvent *)theEvent {
    if (theEvent.keyCode == kVK_ANSI_J) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:self.selectedRow + 1];
        [self selectRowIndexes:indexSet byExtendingSelection:false];
    }
    if (theEvent.keyCode == kVK_ANSI_K) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:self.selectedRow - 1];
        [self selectRowIndexes:indexSet byExtendingSelection:false];
    }
    if (theEvent.keyCode == kVK_Return) {
        NSString *dir = fileArray[(NSUInteger) self.selectedRow];
        if ([currentPath isEqualToString:@"/"]) {
            currentPath = @"";
        }
        currentPath = [currentPath stringByAppendingFormat:@"/%@", dir];
        [self showPath:currentPath];
    }
    if (theEvent.keyCode == kVK_Delete) {
        currentPath = [currentPath stringByDeletingLastPathComponent];
        [self showPath:currentPath];
    }
}

- (void)showPath:(NSString *)path {
    [fileArray removeAllObjects];
    for (NSString *name in [self getFileListAtPath:path]) {
        [fileArray addObject:[FileItem itemWithName:name icon:@"123"]];
    }
    //fileArray = [[self getFileListAtPath:path] mutableCopy];
    [self reloadData];
}

- (NSArray *)getFileListAtPath:(NSString *)path {
    return [fileManager contentsOfDirectoryAtPath:path error:nil];
}

- (void)drawRow:(NSInteger)row clipRect:(NSRect)clipRect {
    NSColor *color = (row % 2) ? [NSColor colorWithCalibratedRed:0.957 green:0.953 blue:0.957 alpha:1.0] : [NSColor whiteColor];
    [color setFill];
    NSRectFill([self rectOfRow:row]);
    [super drawRow:row clipRect:clipRect];
}

@end
