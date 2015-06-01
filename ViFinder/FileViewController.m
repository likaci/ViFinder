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

@implementation FileViewController {
@private
    NSFileManager *fileManager;
    FileTableView *_fileTableView;
    NSString *currentPath;
    NSMutableArray *favouriteMenuArray;
    NSManagedObjectContext *_favouriteMenuCoreDataContext;

}

@synthesize fileTableView = _fileTableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    if (fileManager == nil) {
        fileManager = [[NSFileManager alloc] init];
        fileItems = [[NSMutableArray alloc] init];
    }
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
        [_FileItemsArrayContoller selectNext:nil];
    }
    if (theEvent.keyCode == kVK_ANSI_K) {
        [_FileItemsArrayContoller selectPrevious:nil];
    }
    if (theEvent.keyCode == kVK_Return) {
        NSString *dir =  [self.FileItemsArrayContoller.selection valueForKeyPath:@"name"];
        dir = [currentPath stringByAppendingPathComponent:dir];
        [self showPath:dir];
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

    if (theEvent.keyCode == kVK_ANSI_E) {
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
                        "end if", currentPath, currentPath, currentPath];

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
                        "end if", currentPath, currentPath, currentPath];

        NSString *terminalNewWindow = [NSString stringWithFormat:
                @"tell application \"Terminal\"\n"
                        "\tdo script \"cd %@\"\n"
                        "\tactivate\n"
                        "end tell", currentPath];

        NSAppleScript *script = [[NSAppleScript alloc] initWithSource:terminalNewWindow];
        [script executeAndReturnError:nil];
    }
    if (theEvent.keyCode == kVK_ANSI_D) {
        [self showFavouriteMenu];
    }
    if (theEvent.keyCode == kVK_ANSI_X) {
        for (FileItem *f in _FileItemsArrayContoller.selectedObjects) {
            [f trashSelf];
        }
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
        if ([menuItem.path isEqualToString:currentPath]) {
            [_favouriteMenu addItem:[NSMenuItem separatorItem]];
            [_favouriteMenu addItemWithTitle:@"Remove Here" action:@selector(removeFavouriteHere:) keyEquivalent:@"d"];
            break;
        }
    }
    [_favouriteMenu popUpMenuPositioningItem:nil atLocation:p inView:nil];
}

- (void)addFavouriteHere:(id)sender {
    AddFavouriteViewController *addFavouriteViewController = [self.storyboard instantiateControllerWithIdentifier:@"AddFavouriteViewController"];
    addFavouriteViewController.path = currentPath;
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path = %@", currentPath];
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
    currentPath = path;
    _FileItemsArrayContoller.filterPredicate = nil;
    [self setFileItems: [[self getFileListAtPath:path] mutableCopy]];
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
    return _FileItemsArrayContoller.selectedObjects.count;
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
    return _FileItemsArrayContoller.selectedObjects[(NSUInteger) index];
}

@end
