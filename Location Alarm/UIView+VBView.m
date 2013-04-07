//
//  UIView+VBView.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/13/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "UIView+VBView.h"
#import <objc/runtime.h>

#define VBPointInsideInsetsKey @"VBPointInsideInsetsKey"

@implementation UIView (VBView)

+ (void)load {
    [super load];
    [self vb_swizzle];
}

+ (void)vb_swizzle {
    SEL m = @selector(pointInside:withEvent:);
    SEL vbm = @selector(vb_pointInside:withEvent:);
    method_exchangeImplementations(class_getInstanceMethod(self, m), class_getInstanceMethod(self, vbm));
}

- (BOOL)vb_pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    NSValue *value = objc_getAssociatedObject(self, VBPointInsideInsetsKey);
    if (!value) {
        return [self vb_pointInside:point withEvent:event];
    } else {
        CGRect frame = self.bounds;
        UIEdgeInsets insets = self.pointInsideInsets;
        frame = CGRectMake(frame.origin.x - insets.left,
                           frame.origin.y - insets.top,
                           frame.size.width + insets.left + insets.right,
                           frame.size.height + insets.top + insets.bottom);
        return CGRectContainsPoint(frame, point);
    }
}

- (void)setPointInsideInsets:(UIEdgeInsets)pointInsideInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(pointInsideInsets, UIEdgeInsetsZero)) {
        objc_setAssociatedObject(self, VBPointInsideInsetsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, VBPointInsideInsetsKey, [NSValue valueWithUIEdgeInsets:pointInsideInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIEdgeInsets)pointInsideInsets
{
    NSValue *value = objc_getAssociatedObject(self, VBPointInsideInsetsKey);
    if (value) {
        return [value UIEdgeInsetsValue];
    } else {
        return UIEdgeInsetsZero;
    }
}

@end
