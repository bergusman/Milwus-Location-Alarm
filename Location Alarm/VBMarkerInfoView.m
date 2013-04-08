//
//  VBMarkerInfoView.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/30/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBMarkerInfoView.h"

@implementation VBMarkerInfoView
{
    UILabel *_textLabel;
    UIButton *_button;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:_textLabel];
        
        _button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [self addSubview:_button];
    }
    return self;
}

- (void)sizeToFit
{
    CGSize size = [_textLabel sizeThatFits:CGSizeMake(260, 40)];
    self.frame = CGRectMake(0, 0, MAX(MIN(260, size.width), 30) + (8 + 4 + 2 + 29), 35 + 8 + 4);
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    _textLabel.frame = CGRectMake(8, 0, size.width - 4 - (2 + 29) - 4, 35);
    _button.frame = CGRectMake(size.width - 2 - 29, 2, 29, 31);
 
    //NSLog(@"%@", self.gestureRecognizers);
}

- (void)drawRect:(CGRect)rect
{
    CGSize size = self.frame.size;
    CGFloat h = 35;
    CGFloat s = 8;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShadowWithColor(context, CGSizeMake(0, -1), 3, [UIColor blackColor].CGColor);
    
    [[UIColor whiteColor] setFill];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(size.width, 0)];
    [path addLineToPoint:CGPointMake(size.width, h)];
    [path addLineToPoint:CGPointMake(size.width / 2 + s, h)];
    [path addLineToPoint:CGPointMake(size.width / 2, h + s)];
    [path addLineToPoint:CGPointMake(size.width / 2 - s, h)];
    [path addLineToPoint:CGPointMake(0, h)];
    [path addLineToPoint:CGPointMake(0, 0)];
    
    [path fill];
}


#pragma mark - Text Property

- (void)setText:(NSString *)text
{
    _textLabel.text = text;
}

- (NSString *)text
{
    return _textLabel.text;
}

@end
