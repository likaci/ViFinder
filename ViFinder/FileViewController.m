//
//  FileViewController.m
//  ViFinder
//
//  Created by liuwencai on 15/5/11.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import "FileViewController.h"

@implementation FileViewController {
@private
    NSTableView *_fileTableView;
    NSFileManager *_fileManager;
    NSMutableArray *fileArray;
}

@synthesize fileTableView = _fileTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_fileTableView setDataSource:self];
    if (_fileManager == nil) {
        _fileManager = [[NSFileManager alloc] init];
    }
    fileArray = [[NSMutableArray alloc] init];
    [self showPath:@"/"];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return fileArray.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return fileArray[row];
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

- (void)keyDown:(NSEvent *)theEvent {
    if (theEvent.keyCode == 38) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:_fileTableView.selectedRow + 1];
        [_fileTableView selectRowIndexes:indexSet byExtendingSelection:false];
    }
    if (theEvent.keyCode == 40) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:_fileTableView.selectedRow - 1];
        [_fileTableView selectRowIndexes:indexSet byExtendingSelection:false];
    }
    if (theEvent.keyCode == 36) {
        NSString * path = fileArray[(NSUInteger) _fileTableView.selectedRow];
        [self showPath:path];
    }
}

-(void)showPath:(NSString*)path {
    fileArray = [[self getFileListAtPath:path] mutableCopy];
    [_fileTableView reloadData];
}

- (NSArray *)getFileListAtPath:(NSString *)path {
    return [_fileManager contentsOfDirectoryAtPath:path error:nil];
}

@end
