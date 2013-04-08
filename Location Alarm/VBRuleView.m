//
//  VBRule.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/28/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBRuleView.h"

@implementation VBRuleView
{
    UIImageView *_spot;
    UILabel *_label;
}

@dynamic label;
@dynamic highlighted;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self setUserInteractionEnabled:NO];
    
    _spot = [[UIImageView alloc] init];
    _spot.image = [UIImage imageNamed:@"rule.spot.png"];
    _spot.highlightedImage = [UIImage imageNamed:@"rule.spot.h.png"];
    [self addSubview:_spot];
    
    _label = [[UILabel alloc] init];
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = UITextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:12];
    _label.textColor = VB_WHITE(155, 1.0);
    _label.highlightedTextColor = VB_WHITE(22, 1.0);
    _label.shadowColor = [UIColor whiteColor];
    _label.shadowOffset = CGSizeMake(0, 0.5);
    [self addSubview:_label];
}

- (void)setupFrame
{
    CGRect frame = self.frame;
    _spot.frame = CGRectMake(0, 0, 11, 11);
    _spot.center = CGPointMake(frame.size.width / 2, 6);
    _label.frame = CGRectMake(0, 12, frame.size.width, 21);
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setupFrame];
}


#pragma mark - Highlighting

- (void)setHighlighted:(BOOL)highlighted
{
    _spot.highlighted = highlighted;
}

- (BOOL)isHighlighted
{
    return _spot.highlighted;
}


#pragma mark - Label

- (void)setLabel:(NSString *)label
{
    _label.text = label;
}

- (NSString *)lable
{
    return _label.text;
}

@end
