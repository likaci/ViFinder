//
//  MyTableView.m
//  ViFinder
//
//  Created by liuwencai on 15/5/12.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import "MyTableView.h"
#import "FileItem.h"
#import "FileViewController.h"

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

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return fileArray.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    FileItem *item = fileArray[row];
    if ([[tableColumn identifier] isEqualToString:@"icon"]) {
        NSImage *icon;
        if (item.isDirectiory) {
            icon = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)];
        } else {
            icon = [[NSWorkspace sharedWorkspace] iconForFileType:item.ext];
        }
        return icon;
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
        NSString *dir = [fileArray[(NSUInteger) self.selectedRow] valueForKey:@"name"];
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
    if (theEvent.keyCode == kVK_Space) {
        if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
            [[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
        }
        else {
            [[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
        }
    }
    if (theEvent.keyCode == kVK_ANSI_Q) {
        [self.parentViewController showFavouriteMenu];
    }
}

- (void)showPath:(NSString *)path {
    fileArray = [[self getFileListAtPath:path] mutableCopy];
    [self reloadData];
}

- (NSArray *)getFileListAtPath:(NSString *)path {
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:path];
    NSMutableArray *fileList = [[NSMutableArray alloc] init];
    NSString *name;
    while ((name = enumerator.nextObject) != nil) {
        [enumerator skipDescendants];
        FileItem *item = [FileItem itemWithName:name fileAttribute:enumerator.fileAttributes path:currentPath];
        [fileList addObject:item];
    }
    return fileList;
}

- (void)drawRow:(NSInteger)row clipRect:(NSRect)clipRect {
    NSColor *color = (row % 2) ? [NSColor colorWithCalibratedRed:0.957 green:0.953 blue:0.957 alpha:1.0] : [NSColor whiteColor];
    [color setFill];
    NSRectFill([self rectOfRow:row]);
    [super drawRow:row clipRect:clipRect];
}

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel {
    return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel {
    panel.dataSource = self;
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel {
}

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel {
    return 1;
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
    return fileArray[self.selectedRow];
}

- (FileViewController *)parentViewController {
    NSResponder *responder = self;
    while ([responder isKindOfClass:[NSView class]])
        responder = [responder nextResponder];
    return responder;
}

@end
