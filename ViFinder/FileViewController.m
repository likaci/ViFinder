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
#import "AppDelegate.h"
#import "AddFavouriteViewController.h"
#import "OverwriteFileViewController.h"


@implementation FileViewController {
@private
    NSFileManager *fileManager;
    FileTableView *_fileTableView;
    NSMutableArray *favouriteMenuArray;
    NSManagedObjectContext *_favouriteMenuCoreDataContext;
    VDKQueue *vdkQueue;
    FileItem *_activeRow;
    NSString *_currentPath;
}

@synthesize fileTableView = _fileTableView;

@synthesize currentPath = _currentPath;

- (FileItem *)activeRow {
    if (_activeRow == nil || ![self.fileItemsArrayContoller.arrangedObjects containsObject:_activeRow]) {
        _activeRow = [self.fileItemsArrayContoller.arrangedObjects firstObject];
    }
    return _activeRow;
}

- (void)setActiveRow:(FileItem *)activeRow {
    _activeRow = activeRow;
    [self.fileTableView reloadData];
    [self.fileTableView scrollRowToVisible:[self.fileItemsArrayContoller.arrangedObjects indexOfObject:self.activeRow]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (fileManager == nil) {
        fileManager = [[NSFileManager alloc] init];
        fileItems = [[NSMutableArray alloc] init];
    }
    vdkQueue = [[VDKQueue alloc] init];
    [self showPath:@"/"];

    favouriteMenuArray = [[NSMutableArray alloc] init];

    self.searchField.delegate = self;

    self.mode = NORMAL;
    self.prefix = @"";

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

}


- (FileViewController *)getOtherPanel {
    FileViewController *controller;
    for (FileViewController *c in self.parentViewController.childViewControllers) {
        if (c != self) {
            controller = c;
        }
    }
    return controller;
}

- (NSString *)getOtherPanelPath {
    FileViewController *controller;
    for (FileViewController *c in self.parentViewController.childViewControllers) {
        if (c != self) {
            controller = c;
        }
    }
    return controller.currentPath;
}

#pragma mark - keyboard

- (void)keyDown:(NSEvent *)theEvent {
    if (self.mode == NORMAL) {
        if ([self.prefix isEqualToString:@""]) {
            //prefix == ""
            if (theEvent.keyCode == kVK_ANSI_Equal) {
                [self setOtherPanelPathToCurrent];
                return;
            }

            if (theEvent.keyCode == kVK_ANSI_J) {
                [self nextRow];
            }
            if (theEvent.keyCode == kVK_ANSI_K) {
                [self preRow];
            }
            if (theEvent.keyCode == kVK_Return) {
                [self openActiveRow];
            }
            if (theEvent.keyCode == kVK_Delete) {
                [self openParentDir];
            }
            if (theEvent.keyCode == kVK_ANSI_Q) {
                [self preview];
            }
            if (theEvent.keyCode == kVK_ANSI_E) {
                [self terminalHere];
            }
            if (theEvent.keyCode == kVK_ANSI_G) {
                if ([theEvent modifierFlags] & NSShiftKeyMask) {
                    //Shift
                    [self gotoEnd];
                } else {
                    self.prefix = @"g";
                }
                return;
            }
            if (theEvent.keyCode == kVK_ANSI_Y) {
                [self copyFileName];
            }
            if (theEvent.keyCode == kVK_ANSI_S) {
                self.prefix = @"s";
            }
            if (theEvent.keyCode == kVK_ANSI_D) {
                [self showFavouriteMenu];
            }
            if (theEvent.keyCode == kVK_ANSI_X) {
                [self trashSeleted];
            }
            if (theEvent.keyCode == kVK_ANSI_F) {
                self.prefix = @"f";
            }
            if (theEvent.keyCode == kVK_Tab) {
                [self activeAnotherPanel];
            }
            if (theEvent.keyCode == kVK_Space) {
                [self toggleItemSelection];
            }
            if (theEvent.keyCode == kVK_ANSI_Slash) {
                [self filterList];
            }
            if (theEvent.keyCode == kVK_ANSI_LeftBracket) {
                [self selectSameNameItems];
            }
            if (theEvent.keyCode == kVK_ANSI_RightBracket) {
                [self selectSameExtItems];
            }
            if (theEvent.keyCode == kVK_ANSI_Backslash) {
                if (theEvent.modifierFlags & NSShiftKeyMask) {
                    [self clearSelection];
                } else {
                    [self toggleSelection];
                }
            }
        }

        else {
            //prefix != ""
            if ([self.prefix isEqualToString:@"g"]) {
                if (theEvent.keyCode == kVK_ANSI_G) {
                    [self gotoTop];
                    self.prefix = @"";
                }
            }
            if ([self.prefix isEqualToString:@"s"]) {
                if (theEvent.keyCode == kVK_ANSI_N) {
                    [self toggleSortColumn:@"name"];
                    self.prefix = @"";
                }
                if (theEvent.keyCode == kVK_ANSI_S) {
                    [self toggleSortColumn:@"size"];
                    self.prefix = @"";
                }
                if (theEvent.keyCode == kVK_ANSI_E) {
                    [self toggleSortColumn:@"ext"];
                    self.prefix = @"";
                }
                if (theEvent.keyCode == kVK_ANSI_D) {
                    [self toggleSortColumn:@"date"];
                    self.prefix = @"";
                }
            }
            if ([self.prefix isEqualToString:@"f"]) {
                if (theEvent.keyCode == kVK_ANSI_F) {
                    [self copyToClipBoard];
                    self.prefix = @"";
                }
                if (theEvent.keyCode == kVK_ANSI_V) {
                    [self pasteFromClipboard];
                    self.prefix = @"";
                }
                if (theEvent.keyCode == kVK_ANSI_C) {
                    [self copyToOtherPanel];
                    self.prefix = @"";
                }
                if (theEvent.keyCode == kVK_ANSI_X) {
                    [self moveToOtherPanel];
                    self.prefix = @"";
                }
            }
            self.prefix = @"";
        }
    }

}

- (void)setOtherPanelPathToCurrent {
    [self.getOtherPanel showPath:self.currentPath];
}

- (void)nextRow {
    NSUInteger index = [_fileItemsArrayContoller.arrangedObjects indexOfObject:self.activeRow];
    if (index != ((NSArray *) _fileItemsArrayContoller.arrangedObjects).count - 1) {
        self.activeRow = _fileItemsArrayContoller.arrangedObjects[index + 1];
    }
}

- (void)preRow {
    NSUInteger index = [_fileItemsArrayContoller.arrangedObjects indexOfObject:self.activeRow];
    if (index != 0) {
        self.activeRow = _fileItemsArrayContoller.arrangedObjects[index - 1];
    }
}

- (void)openActiveRow {
    NSString *path = [self.currentPath stringByAppendingPathComponent:self.activeRow.name];
    if (self.activeRow.isDirectiory) {
        [self showPath:path];
    } else {
        NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
        [workspace openFile:path];
    }
}

- (void)openParentDir {
    NSString *path = [self.currentPath stringByDeletingLastPathComponent];
    [self showPath:path];
}

- (void)preview {
    if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
        [[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
    }
    else {
        [[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
    }
}

- (void)terminalHere {
    NSString *iTermNewTab = [NSString stringWithFormat:
            @"if application \"iTerm\" is running then\n"
                    "\ttell application \"iTerm\"\n"
                    "\t\ttry\n"
                    "\t\t\ttell the first terminal\n"
                    "\t\t\t\tlaunch session \"Default Session\"\n"
                    "\t\t\t\ttell the last session\n"
                    "\t\t\t\t\twrite text \"cd %@\"\n"
                    "\t\t\t\tend tell\n"
                    "\t\t\tend tell\n"
                    "\t\ton error\n"
                    "\t\t\tset myterm to (make new terminal)\n"
                    "\t\t\ttell myterm\n"
                    "\t\t\t\tlaunch session \"Default Session\"\n"
                    "\t\t\t\ttell the last session\n"
                    "\t\t\t\t\twrite text \"cd %@\"\n"
                    "\t\t\t\tend tell\n"
                    "\t\t\tend tell\n"
                    "\t\tend try\n"
                    "\t\tactivate\n"
                    "\tend tell\n"
                    "else\n"
                    "\ttell application \"iTerm\"\n"
                    "\t\tactivate\n"
                    "\t\ttell the first terminal\n"
                    "\t\t\ttell the first session\n"
                    "\t\t\t\twrite text \"cd %@\"\n"
                    "\t\t\tend tell\n"
                    "\t\tend tell\n"
                    "\tend tell\n"
                    "end if", self.currentPath, self.currentPath, self.currentPath];

    NSString *iTermNewWindow = [NSString stringWithFormat:
            @"if application \"iTerm\" is running then\n"
                    "\ttell application \"iTerm\"\n"
                    "\t\ttry\n"
                    "\t\t\tset myterm to (make new terminal)\n"
                    "\t\t\ttell myterm\n"
                    "\t\t\t\tlaunch session \"Default Session\"\n"
                    "\t\t\t\ttell the last session\n"
                    "\t\t\t\t\twrite text \"cd %@\"\n"
                    "\t\t\t\tend tell\n"
                    "\t\t\tend tell\n"
                    "\t\ton error\n"
                    "\t\t\tset myterm to (make new terminal)\n"
                    "\t\t\ttell myterm\n"
                    "\t\t\t\tlaunch session \"Default Session\"\n"
                    "\t\t\t\ttell the last session\n"
                    "\t\t\t\t\twrite text \"cd %@\"\n"
                    "\t\t\t\tend tell\n"
                    "\t\t\tend tell\n"
                    "\t\tend try\n"
                    "\t\tactivate\n"
                    "\tend tell\n"
                    "else\n"
                    "\ttell application \"iTerm\"\n"
                    "\t\tactivate\n"
                    "\t\ttell the first terminal\n"
                    "\t\t\ttell the first session\n"
                    "\t\t\t\twrite text \"cd %@\"\n"
                    "\t\t\tend tell\n"
                    "\t\tend tell\n"
                    "\tend tell\n"
                    "end if", self.currentPath, self.currentPath, self.currentPath];

    NSString *terminalNewWindow = [NSString stringWithFormat:
            @"tell application \"Terminal\"\n"
                    "\tdo script \"cd %@\"\n"
                    "\tactivate\n"
                    "end tell", self.currentPath];

    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:terminalNewWindow];
    [script executeAndReturnError:nil];
}

- (void)copyFileName {
    NSString *name = self.activeRow.name;
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [[NSPasteboard generalPasteboard] declareTypes:@[NSPasteboardTypeString] owner:nil];
    [pasteboard setString:[self.currentPath stringByAppendingPathComponent:name] forType:NSPasteboardTypeString];
}

- (void)trashSeleted {
    if (self.fileItemsArrayContoller.selectedObjects.count == 0) {
        [self.activeRow trashSelf];
    } else {
        for (FileItem *f in _fileItemsArrayContoller.selectedObjects) {
            [f trashSelf];
        }
    }
}

- (void)gotoTop {
    self.activeRow = [self.fileItemsArrayContoller.arrangedObjects firstObject];
}

- (void)gotoEnd {
    self.activeRow = [self.fileItemsArrayContoller.arrangedObjects lastObject];
}

- (void)toggleItemSelection {
    if ([self.fileItemsArrayContoller.selectedObjects containsObject:self.activeRow]) {
        [self.fileItemsArrayContoller removeSelectedObjects:@[self.activeRow]];
    } else {
        [self.fileItemsArrayContoller addSelectedObjects:@[self.activeRow]];
    }
}

- (void)activeAnotherPanel {
    for (FileViewController *controller in self.parentViewController.childViewControllers) {
        if (controller != self) {
            [controller.view.window makeFirstResponder:controller.fileTableView];
        }
    }
}

- (void)selectSameNameItems {
    for (FileItem *item in self.fileItemsArrayContoller.arrangedObjects) {
        if ([[item.name stringByDeletingPathExtension] isEqualToString:[self.activeRow.name stringByDeletingPathExtension]]) {
            [self.fileItemsArrayContoller addSelectedObjects:@[item]];
        }
    }
}

- (void)selectSameExtItems {
    for (FileItem *item in self.fileItemsArrayContoller.arrangedObjects) {
        if ([item.ext isEqualToString:self.activeRow.ext]) {
            [self.fileItemsArrayContoller addSelectedObjects:@[item]];
        }
    }
}

- (void)toggleSelection {
    NSArray *selection = self.fileItemsArrayContoller.selectedObjects;
    NSMutableOrderedSet *all = [NSMutableOrderedSet orderedSetWithArray:self.fileItemsArrayContoller.arrangedObjects];
    [all minusSet:[NSSet setWithArray:selection]];
    [self.fileItemsArrayContoller setSelectedObjects:all.set.allObjects];
    return;
}

- (void)clearSelection {
    [self.fileItemsArrayContoller setSelectedObjects:nil];
}

- (void)filterList {
    [self.view.window makeFirstResponder:self.searchField];
}

- (void)toggleSortColumn:(NSString *)name {
    NSSortDescriptor *descriptor = [self.fileItemsArrayContoller.sortDescriptors firstObject];
    if ([descriptor.key isEqualToString:name] && descriptor.ascending) {
        descriptor = [NSSortDescriptor sortDescriptorWithKey:name
                                                   ascending:NO
                                                    selector:@selector(compare:)];
    } else {
        descriptor = [NSSortDescriptor sortDescriptorWithKey:name
                                                   ascending:YES
                                                    selector:@selector(compare:)];
    }
    [self.fileItemsArrayContoller setSortDescriptors:@[descriptor]];
}

- (void)copyToClipBoard {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    if (self.fileItemsArrayContoller.selectedObjects.count == 0) {
        NSURL *url = [[NSURL alloc] initFileURLWithPath:[self.currentPath stringByAppendingPathComponent:self.activeRow.name]];
        [items addObject:url];
    } else {
        for (FileItem *item in self.fileItemsArrayContoller.selectedObjects) {
            NSURL *url = [[NSURL alloc] initFileURLWithPath:[self.currentPath stringByAppendingPathComponent:item.name]];
            [items addObject:url];
        }
    }
    [pasteboard writeObjects:items];
}

- (void)pasteFromClipboard {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *classes = [NSArray arrayWithObject:[NSURL class]];
    NSDictionary *options;
    options = @{NSPasteboardURLReadingFileURLsOnlyKey : @YES};
    NSArray *urls = [pasteboard readObjectsForClasses:classes options:options];
    __block BOOL isOverWriteAll = FALSE;
    __block BOOL isSkipAll = FALSE;
    NSMutableArray *sheets = [[NSMutableArray alloc] init];
    for (NSURL *url in urls) {
        NSString *fileName = url.lastPathComponent;
        NSString *newPath = [self.currentPath stringByAppendingPathComponent:fileName];
        if (!isSkipAll) {
            if ([fileManager fileExistsAtPath:newPath] && !isOverWriteAll) {
                OverwriteFileViewController *ofvc = [self.storyboard instantiateControllerWithIdentifier:@"OverwriteFileViewController"];
                [sheets addObject:ofvc];
                ofvc.sourcePath = url.path;
                ofvc.targetPath = newPath;

                ofvc.overWrite = ^() {
                    [fileManager removeItemAtPath:newPath error:nil];
                    [fileManager copyItemAtPath:url.path toPath:newPath error:nil];
                };

                ofvc.overWriteAll = ^() {
                    [fileManager removeItemAtPath:newPath error:nil];
                    [fileManager copyItemAtPath:url.path toPath:newPath error:nil];
                    isOverWriteAll = TRUE;
                };

                ofvc.skip = ^() {
                };

                ofvc.skipAll = ^() {
                    isSkipAll = TRUE;
                };

                ofvc.rename = ^() {
                };
                [self presentViewControllerAsModalWindow:ofvc];
                CFRunLoopRun();
            } else {
                [fileManager copyItemAtPath:url.path toPath:newPath error:nil];
            }
        }
    }
}

- (void)copyToOtherPanel {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    if (self.fileItemsArrayContoller.selectedObjects.count == 0) {
        [items addObject:self.activeRow];
    } else {
        items = [self.fileItemsArrayContoller.selectedObjects mutableCopy];
    }

    NSString *otherPanelPath = self.getOtherPanelPath;
    __block BOOL isOverWriteAll = FALSE;
    __block BOOL isSkipAll = FALSE;
    for (FileItem *item in items) {
        NSString *newPath = [otherPanelPath stringByAppendingPathComponent:item.name];
        if (!isSkipAll) {
            if ([fileManager fileExistsAtPath:newPath] && !isOverWriteAll) {
                OverwriteFileViewController *ofvc = [self.storyboard instantiateControllerWithIdentifier:@"OverwriteFileViewController"];
                ofvc.sourcePath = item.path;
                ofvc.targetPath = newPath;

                ofvc.overWrite = ^() {
                    [fileManager removeItemAtPath:newPath error:nil];
                    [fileManager copyItemAtPath:item.path toPath:newPath error:nil];
                };

                ofvc.overWriteAll = ^() {
                    [fileManager removeItemAtPath:newPath error:nil];
                    [fileManager copyItemAtPath:item.path toPath:newPath error:nil];
                    isOverWriteAll = TRUE;
                };

                ofvc.skip = ^() {
                };

                ofvc.skipAll = ^() {
                    isSkipAll = TRUE;
                };

                ofvc.rename = ^() {
                };
                [self presentViewControllerAsModalWindow:ofvc];
                CFRunLoopRun();
            } else {
                [fileManager copyItemAtPath:item.path toPath:newPath error:nil];
            }
        }

    }
}

- (void)moveToOtherPanel {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    if (self.fileItemsArrayContoller.selectedObjects.count == 0) {
        [items addObject:self.activeRow];
    } else {
        items = [self.fileItemsArrayContoller.selectedObjects mutableCopy];
    }

    NSString *otherPanelPath = self.getOtherPanelPath;
    __block BOOL isOverWriteAll = FALSE;
    __block BOOL isSkipAll = FALSE;
    for (FileItem *item in items) {
        NSString *newPath = [otherPanelPath stringByAppendingPathComponent:item.name];
        if (!isSkipAll) {
            if ([fileManager fileExistsAtPath:newPath] && !isOverWriteAll) {
                OverwriteFileViewController *ofvc = [self.storyboard instantiateControllerWithIdentifier:@"OverwriteFileViewController"];
                ofvc.sourcePath = item.path;
                ofvc.targetPath = newPath;

                ofvc.overWrite = ^() {
                    [fileManager removeItemAtPath:newPath error:nil];
                    [fileManager copyItemAtPath:item.path toPath:newPath error:nil];
                    [fileManager removeItemAtPath:item.path error:nil];
                };

                ofvc.overWriteAll = ^() {
                    [fileManager removeItemAtPath:newPath error:nil];
                    [fileManager copyItemAtPath:item.path toPath:newPath error:nil];
                    [fileManager removeItemAtPath:item.path error:nil];
                    isOverWriteAll = TRUE;
                };

                ofvc.skip = ^() {
                };

                ofvc.skipAll = ^() {
                    isSkipAll = TRUE;
                };

                ofvc.rename = ^() {
                };
                [self presentViewControllerAsModalWindow:ofvc];
                CFRunLoopRun();
            } else {
                [fileManager copyItemAtPath:item.path toPath:newPath error:nil];
                [fileManager removeItemAtPath:item.path error:nil];
            }
        }

    }
}

#pragma mark - FavouriteMenu

- (NSManagedObjectContext *)coreDataContext {
    AppDelegate *appDelegate = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    return appDelegate.coreDataContext;
}

- (NSMutableArray *)fileItems {
    return fileItems;
}

- (void)setFileItems:(NSMutableArray *)items {
    if (fileItems == items)
        return;
    fileItems = items;
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
    request.entity = [NSEntityDescription entityForName:@"FavouriteMenuItem" inManagedObjectContext:self.coreDataContext];
    NSArray *objs = [self.coreDataContext executeFetchRequest:request error:nil];
    favouriteMenuArray = [objs mutableCopy];
    for (FavouriteMenuItem *menuItem in favouriteMenuArray) {
        menuItem.menuItem.menu = nil;
        [_favouriteMenu addItem:menuItem.menuItem];
    }
    for (FavouriteMenuItem *menuItem in favouriteMenuArray) {
        if ([menuItem.path isEqualToString:self.currentPath]) {
            [_favouriteMenu addItem:[NSMenuItem separatorItem]];
            [_favouriteMenu addItemWithTitle:@"Remove Here" action:@selector(removeFavouriteHere:) keyEquivalent:@"d"];
            break;
        }
    }
    [_favouriteMenu popUpMenuPositioningItem:nil atLocation:p inView:nil];
}

- (void)addFavouriteHere:(id)sender {
    AddFavouriteViewController *addFavouriteViewController = [self.storyboard instantiateControllerWithIdentifier:@"AddFavouriteViewController"];
    addFavouriteViewController.path = self.currentPath;
    addFavouriteViewController.addFav = ^(NSString *path, NSString *name, NSString *shortcut) {
        FavouriteMenuItem *favouriteMenuItem = [NSEntityDescription insertNewObjectForEntityForName:@"FavouriteMenuItem" inManagedObjectContext:self.coreDataContext];
        favouriteMenuItem.name = name;
        favouriteMenuItem.path = path;
        favouriteMenuItem.shortcut = shortcut;
        [self.coreDataContext save:nil];
    };
    [self presentViewControllerAsSheet:addFavouriteViewController];
}

- (void)removeFavouriteHere:(id)sender {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"FavouriteMenuItem" inManagedObjectContext:self.coreDataContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path = %@", self.currentPath];
    request.predicate = predicate;
    NSArray *objs = [self.coreDataContext executeFetchRequest:request error:nil];
    for (NSManagedObject *obj in objs) {
        [self.coreDataContext deleteObject:obj];
    }
    [self.coreDataContext save:nil];
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
    if ([path isEqualToString:self.currentPath]) {
        [self refreshCurrentPath];
    } else {
        self.currentPath = path;
        _fileItemsArrayContoller.filterPredicate = nil;
        [self setFileItems:[[self getFileListAtPath:path] mutableCopy]];
        [vdkQueue removeAllPaths];
        [vdkQueue addPath:self.currentPath];
        [vdkQueue setDelegate:self];
    }
}

- (void)refreshCurrentPath {
    NSInteger preActiveRowIndex = [self.fileItemsArrayContoller.arrangedObjects indexOfObject:self.activeRow];
    [self setFileItems:[[self getFileListAtPath:self.currentPath] mutableCopy]];
    if (preActiveRowIndex > [self.fileItemsArrayContoller.arrangedObjects count] - 1 || [self.fileItemsArrayContoller.arrangedObjects count] == 0) {
        self.activeRow = [self.fileItemsArrayContoller.arrangedObjects lastObject];
    } else {
        self.activeRow = [[self.fileItemsArrayContoller arrangedObjects] objectAtIndex:(NSUInteger) preActiveRowIndex];
    }
}

- (NSArray *)getFileListAtPath:(NSString *)path {
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:path];
    NSMutableArray *fileList = [[NSMutableArray alloc] init];
    NSString *name;
    while ((name = enumerator.nextObject) != nil) {
        [enumerator skipDescendants];
        FileItem *item = [FileItem itemWithName:name fileAttribute:enumerator.fileAttributes path:self.currentPath];
        [fileList addObject:item];
    }
    return fileList;
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
    return self.fileItemsArrayContoller.selectedObjects.count == 0 ? 1 : self.fileItemsArrayContoller.selectedObjects.count;
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel
                previewItemAtIndex:
                        (NSInteger)index {
    if (self.fileItemsArrayContoller.selectedObjects.count == 0) {
        return self.activeRow;
    } else {
        return _fileItemsArrayContoller.selectedObjects[(NSUInteger) index];
    }
}

- (void)    VDKQueue:(VDKQueue *)queue
receivedNotification:
        (NSString *)noteName
             forPath:
                     (NSString *)fpath {
    [self refreshCurrentPath];
}

#pragma mark - SearchField

- (BOOL)control:(NSControl *)control
           textView:
                   (NSTextView *)textView
doCommandBySelector:
        (SEL)commandSelector {
    if (commandSelector == @selector(cancelOperation:) || commandSelector == @selector(insertNewline:)) {
        NSEvent *theEvent = [NSApp currentEvent];
        if (theEvent.keyCode == kVK_Escape || theEvent.keyCode == kVK_Return) {
            [self.view.window makeFirstResponder:self.fileTableView];
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}


@end
