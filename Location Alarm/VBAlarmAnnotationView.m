//
//  VBAlarmAnnotationView.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/27/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBAlarmAnnotationView.h"

@implementation VBAlarmAnnotationView
{
    UIImageView *_cover;
    UIImageView *_segment;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *shadow = [[UIImageView alloc] init];
        shadow.image = [UIImage imageNamed:@"alarm.marker.shadow.png"];
        shadow.frame = CGRectMake(0, 0, 50, 70);
        [self addSubview:shadow];
        
        UIImageView *progress = [[UIImageView alloc] init];
        progress.image = [UIImage imageNamed:@"alarm.marker.progress.png"];
        progress.frame = CGRectMake(0, 0, 36, 46);
        [self addSubview:progress];
        
        _segment = [[UIImageView alloc] init];
        _segment.frame = CGRectMake(0, 0, 36, 46);
        [self addSubview:_segment];
        
        _cover = [[UIImageView alloc] init];
        _cover.image = [UIImage imageNamed:@"alarm.marker.on.cover.png"];
        _cover.frame = CGRectMake(0, 0, 36, 46);
        [self addSubview:_cover];
        
        self.centerOffset = CGPointMake(0, -21);
        
        self.frame = CGRectMake(0, 0, 36, 46);
    }
    return self;
}

- (void)setOn:(BOOL)on
{
    _on = on;
    if (on) {
        _cover.image = [UIImage imageNamed:@"alarm.marker.on.cover.png"];
    } else {
        _cover.image = [UIImage imageNamed:@"alarm.marker.off.cover.png"];
    }
}

- (void)setProgress:(double)progress
{
    _progress = progress;
    _segment.image = [self emptySegmentWithProgress:progress];
}

- (UIImage *)emptySegmentWithProgress:(CGFloat)progress
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 46), NO, [UIScreen mainScreen].scale);
    
    if (progress < 0.999999)
    {
        CGFloat angleOffset = 74.0 * M_PI / 180.0;
        CGFloat startAngle = angleOffset;
        CGFloat endAngle = angleOffset + progress * (2.0 * M_PI);
        CGPoint center = CGPointMake(18, 17);
        CGFloat radius = 16;
        
        UIBezierPath *path = nil;
        
        if (progress > 0.0001) {
            path = [UIBezierPath bezierPathWithArcCenter:center
                                                  radius:radius
                                              startAngle:startAngle
                                                endAngle:endAngle clockwise:NO];
            [path addLineToPoint:center];
        } else {
            CGRect rect = CGRectMake(center.x - radius, center.y - radius, 2 * radius, 2 * radius);
            path = [UIBezierPath bezierPathWithOvalInRect:rect];
        }
        
        [VB_WHITE(208, 1.0) setFill];
        [path fill];
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
