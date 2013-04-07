//
//  UIView+FCAdditions.m
//  Firefighters Calendar
//
//  Created by Vitaliy Berg on 9/6/12.
//  Copyright (c) 2012 iPeak International. All rights reserved.
//

#import "UIView+VBFirstResponder.h"


@implementation UIView (VBFirstResponder)

- (UIView *)vbFindFirstResponder
{
    if ([self isFirstResponder]) return self;
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView vbFindFirstResponder];
        if (firstResponder) {
            return firstResponder;
        }
    }
    
    return nil;
}

@end
