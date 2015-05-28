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
#import "FavouriteMenuItem.h"

@implementation FileViewController {
@private
    NSFileManager *fileManager;
    FileTableView *_fileTableView;
    NSMutableArray *fileArray;
    NSString *currentPath;
    NSMutableArray *favouriteMenuArray;
    NSManagedObjectContext *_favouriteMenuCoreDataContext;

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

    favouriteMenuArray = [[NSMutableArray alloc] init];



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

#pragma mark - FavouriteMenu

- (NSManagedObjectContext *)favouriteMenuCoreDataContext {
    if (_favouriteMenuCoreDataContext == nil) {
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"person.xml"]];
        NSError *error = nil;
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error];
        if (store == nil) {
            [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
        }
        _favouriteMenuCoreDataContext = [[NSManagedObjectContext alloc] init];
        _favouriteMenuCoreDataContext.persistentStoreCoordinator = psc;
    }
    return _favouriteMenuCoreDataContext;
}

- (void)showFavouriteMenu {
    //to window
    NSPoint p = [self.view convertPoint:_favouriteMenuButton.frame.origin toView:nil];
    //to screen
    p = [self.view.window convertBaseToScreen:p];

    [_favouriteMenu removeAllItems];

    [[_favouriteMenu addItemWithTitle:@"Add Here" action:@selector(addFavouriteHere:) keyEquivalent:@"a"] setKeyEquivalentModifierMask:0];
    [_favouriteMenu addItem:[NSMenuItem separatorItem]];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"FavouriteMenuItem" inManagedObjectContext:self.favouriteMenuCoreDataContext];
    NSArray *objs = [self.favouriteMenuCoreDataContext executeFetchRequest:request error:nil];
    favouriteMenuArray = [objs mutableCopy];
    for (FavouriteMenuItem *menuItem in favouriteMenuArray) {
        [_favouriteMenu addItem:menuItem.menuItem];
    }
    [_favouriteMenu popUpMenuPositioningItem:nil atLocation:p inView:nil];
}

- (void)addFavouriteHere:(id)sender {
    FavouriteMenuItem *favouriteMenuItem = [NSEntityDescription insertNewObjectForEntityForName:@"FavouriteMenuItem" inManagedObjectContext:self.favouriteMenuCoreDataContext];
    favouriteMenuItem.name = currentPath;
    favouriteMenuItem.path = currentPath;
    favouriteMenuItem.shortcut = @"";
    [self.favouriteMenuCoreDataContext save:nil];
}

- (void)favouriteMenuClick:(id)sender {
    for (FavouriteMenuItem *item in favouriteMenuArray) {
        if (sender == item.menuItem) {
            [self showPath:item.path];
        }
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
