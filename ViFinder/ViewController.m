//
//  ViewController.m
//  ViFinder
//
//  Created by liuwencai on 15/5/11.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController {
@private
    NSTableView *_fileTableView;
}

@synthesize fileTableView = _fileTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_fileTableView setDataSource:self];

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 10;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return @(row);
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
}


@end
