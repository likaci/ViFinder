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
    FileViewController *_parentViewController;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setDelegate:self];
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
    if (_parentViewController == nil) {
        NSResponder *responder = self;
        while ([responder isKindOfClass:[NSView class]])
            responder = [responder nextResponder];
        _parentViewController = (FileViewController *) responder;
    }
    return _parentViewController;
}

- (BOOL)becomeFirstResponder {
    [self reloadData];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [self reloadData];
    return [super resignFirstResponder];
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint downPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSInteger mouseDownRow = [self rowAtPoint:downPoint];
    NSPoint upPoint;
    NSInteger mouseUpRow;
    theEvent = [[self window] nextEventMatchingMask:NSLeftMouseUpMask | NSLeftMouseDraggedMask];
    switch ([theEvent type]) {
        case NSLeftMouseDragged:
            [super mouseDown:theEvent];
            upPoint = [NSEvent mouseLocation];
            upPoint = [self.window convertScreenToBase:upPoint];
            upPoint = [self convertPoint:upPoint fromView:nil];
            mouseUpRow = [self rowAtPoint:upPoint];
            if (mouseUpRow != mouseDownRow) {
                self.parentViewController.activeRow = self.parentViewController.fileItemsArrayContoller.arrangedObjects[(NSUInteger) mouseUpRow];
                [self reloadData];
            }
            break;
        case NSLeftMouseUp:
            upPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
            mouseUpRow = [self rowAtPoint:upPoint];
            if (mouseUpRow != mouseDownRow) {
                [super mouseDown:theEvent];
            } else {
                self.parentViewController.activeRow = self.parentViewController.fileItemsArrayContoller.arrangedObjects[(NSUInteger) mouseDownRow];
                [self reloadData];
            }
            break;
        default:
            break;
    }
    return;
}

@end
