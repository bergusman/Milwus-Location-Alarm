//
//  VBNoteView.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/4/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBNoteView.h"

@interface VBNoteView ()

@end

@implementation VBNoteView

@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;

- (void)dealloc
{
    [_imageView release];
    [_textLabel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"note.bg.png"]];
        
        /*
        UIButton *button = [[[UIButton alloc] init] autorelease];
        [button setImage:[UIImage imageNamed:@"note.close.button.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(320 - 28, 1, 26, 26);
        [v addSubview:button];
         */
        
    }
    return self;
}

- (void)layoutSubviews
{
    if (_imageView) {
        _imageView.frame = CGRectMake(4, 3, 22, 22);
        _textLabel.frame = CGRectMake(30, 2, 260, 23);
    } else {
        _textLabel.frame = CGRectMake(4, 2, 200, 23);
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[TTTAttributedLabel alloc] init];
        _textLabel.font = [UIFont boldSystemFontOfSize:10];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        _textLabel.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

@end
