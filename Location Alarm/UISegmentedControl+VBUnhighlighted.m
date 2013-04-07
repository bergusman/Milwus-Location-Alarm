//
//  UISegmentedControl+VBUnhighlighted.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/18/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "UISegmentedControl+VBUnhighlighted.h"

@implementation UISegmentedControl (VBUnhighlighted)

// Durty implementation
- (void)vbUnhighlighted
{
    for (id segment in self.subviews) {
        if ([segment respondsToSelector:@selector(setHighlighted:)]) {
            [segment setHighlighted:NO];
        }
    }
}

@end
