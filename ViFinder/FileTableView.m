//
//  FileTableView.m
//  ViFinder
//
//  Created by liuwencai on 15/5/12.
//  Copyright (c) 2015年 likaci. All rights reserved.
//

#import "FileTableView.h"
#import "FileItem.h"
#import "FileViewController.h"

@implementation FileTableView {
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
    }

    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    // Drawing code here.
}

- (void)keyDown:(NSEvent *)theEvent {
    [[self parentViewController] keyDown:theEvent];
}

- (void)drawRow:(NSInteger)row clipRect:(NSRect)clipRect {
    if (self.parentViewController.activeRow == self.parentViewController.fileItemsArrayContoller.arrangedObjects[row]
            && [[self window] firstResponder] == self) {
        NSColor *color = [NSColor redColor];
        [color setFill];
        NSFrameRect([self rectOfRow:row]);
    }
    [super drawRow:row clipRect:clipRect];
}

- (FileViewController *)parentViewController {
    NSResponder *responder = self;
    while ([responder isKindOfClass:[NSView class]])
        responder = [responder nextResponder];
    return (FileViewController *) responder;
}

- (BOOL)becomeFirstResponder {
    [self reloadData];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    self.parentViewController.activeRow = nil;
    [self reloadData];
    return [super resignFirstResponder];
}

@end
