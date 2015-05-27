//
//  FileViewController.m
//  ViFinder
//
//  Created by liuwencai on 15/5/11.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import "FileViewController.h"
#import "FileTableView.h"
#import "FileItem.h"

@implementation FileViewController {
@private
    NSFileManager *fileManager;
    FileTableView *_fileTableView;
    NSMutableArray *fileArray;
    NSString *currentPath;
}

@synthesize fileTableView = _fileTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (fileManager == nil) {
        fileManager = [[NSFileManager alloc] init];
    }
    fileArray = [[NSMutableArray alloc] init];
    _fileTableView.dataSource = self;
    currentPath = @"/";
    [self showPath:currentPath];

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

}


#pragma mark - keyboard

- (void)keyDown:(NSEvent *)theEvent {
    if (theEvent.keyCode == kVK_ANSI_J) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:_fileTableView.selectedRow + 1];
        [_fileTableView selectRowIndexes:indexSet byExtendingSelection:false];
    }
    if (theEvent.keyCode == kVK_ANSI_K) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:_fileTableView.selectedRow - 1];
        [_fileTableView selectRowIndexes:indexSet byExtendingSelection:false];
    }
    if (theEvent.keyCode == kVK_Return) {
        NSString *dir = [fileArray[(NSUInteger) _fileTableView.selectedRow] valueForKey:@"name"];
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
    if (theEvent.keyCode == kVK_ANSI_Q) {
        if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
            [[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
        }
        else {
            [[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
        }
    }

    if (theEvent.keyCode == kVK_ANSI_D) {
        [self showFavouriteMenu];
    }

    if (theEvent.keyCode == kVK_Tab) {
        for (FileViewController *controller in self.parentViewController.childViewControllers) {
            if (controller != self) {
                [controller.view.window makeFirstResponder:controller.fileTableView];
            }
        }
        return;
    }


}

#pragma mark - FileTableView

- (void)showPath:(NSString *)path {
    fileArray = [[self getFileListAtPath:path] mutableCopy];
    [_fileTableView reloadData];
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

- (void)showFavouriteMenu {
    //to window
    NSPoint p = [self.view convertPoint:_favouriteMenuButton.frame.origin toView:nil];
    //to screen
    p = [self.view.window convertBaseToScreen:p];
    [_favouriteMenu popUpMenuPositioningItem:nil atLocation:p inView:nil];
}


#pragma mark - TableViewDataSource

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


#pragma mark - QLPreviewPanel protocol

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel {
    return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel {
    panel.dataSource = self;
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel {
}


#pragma mark - QLPreviewItem

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel {
    return 1;
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
    return fileArray[_fileTableView.selectedRow];
}

@end
