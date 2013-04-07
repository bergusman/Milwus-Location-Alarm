//
//  UIView+VBDimensions.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/27/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "UIView+VBDimensions.h"

@implementation UIView (VBDimensions)

@dynamic vbX;
@dynamic vbY;
@dynamic vbWidth;
@dynamic vbHeight;

- (CGFloat)vbX
{
    return self.frame.origin.x;
}

- (CGFloat)vbY
{
    return self.frame.origin.y;
}

- (CGFloat)vbWidth
{
    return self.frame.size.width;
}

- (CGFloat)vbHeight
{
    return self.frame.size.height;
}

- (void)setVbX:(CGFloat)vbX
{
    CGRect frame = self.frame;
    frame.origin.x = vbX;
    self.frame = frame;
}

- (void)setVbY:(CGFloat)vbY
{
    CGRect frame = self.frame;
    frame.origin.y = vbY;
    self.frame = frame;
}

- (void)setVbWidth:(CGFloat)vbWidth
{
    CGRect frame = self.frame;
    frame.size.width = vbWidth;
    self.frame = frame;
}

- (void)setVbHeight:(CGFloat)vbHeight
{
    CGRect frame = self.frame;
    frame.size.height = vbHeight;
    self.frame = frame;
}

@end
