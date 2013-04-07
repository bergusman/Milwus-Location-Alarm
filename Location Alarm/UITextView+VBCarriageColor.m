//
//  UITextView+VBCarriageColor.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/27/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "UITextView+VBCarriageColor.h"

@implementation UITextView (VBCarriageColor)

- (void)vbChangeCarriageColorTo:(UIColor *)color
{
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UITextSelectionView")]) {
            if ([subview.subviews count] > 0) {
                UIView *carriage = subview.subviews[0];
                carriage.backgroundColor = color;
            }
        }
    }
}

@end
