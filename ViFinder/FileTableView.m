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
    NSColor *color = (row % 2) ? [NSColor colorWithCalibratedRed:0.957 green:0.953 blue:0.957 alpha:1.0] : [NSColor whiteColor];
    [color setFill];
    NSRectFill([self rectOfRow:row]);
    [super drawRow:row clipRect:clipRect];
}

- (FileViewController *)parentViewController {
    NSResponder *responder = self;
    while ([responder isKindOfClass:[NSView class]])
        responder = [responder nextResponder];
    return (FileViewController *) responder;
}

@end
