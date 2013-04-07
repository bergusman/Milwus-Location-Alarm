//
//  VBDonateDialogView.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/20/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBDonateDialogView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+VBView.h"
#import "VBDonateDialogButton.h"


@implementation VBDonateDialogView
{
    UIWindow *_window;
    UIView *_dimView;
    BOOL _shown;
    UIImageView *_backgroundView;
    UILabel *_donateLabel;
    UIButton *_closeButton;
    NSArray *_donateButtons;
}

- (void)dealloc
{
    [_prices release];
    [_window release];
    [_dimView release];
    [_backgroundView release];
    [_donateLabel release];
    [_closeButton release];
    [_donateButtons release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.image = [[UIImage imageNamed:@"donate.dialog.bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        [self addSubview:_backgroundView];
        
        _donateLabel = [[UILabel alloc] init];
        _donateLabel.backgroundColor = [UIColor clearColor];
        _donateLabel.textColor = VB_RGB(60, 60, 60);
        _donateLabel.font = [UIFont boldSystemFontOfSize:15];
        _donateLabel.text = NSLocalizedString(@"DialogDonateTitle", @"");
        [self addSubview:_donateLabel];
        
        _closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_closeButton setTitle:@"x" forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"donate.dialog.close.png"] forState:UIControlStateNormal];
        _closeButton.pointInsideInsets = UIEdgeInsetsMake(12, 12, 12, 12);
        [self addSubview:_closeButton];
        
    }
    return self;
}

- (void)layoutSubviews
{
    _backgroundView.frame = self.bounds;
    _donateLabel.frame = CGRectMake(10, 10, 260, 21);
    _closeButton.frame = CGRectMake(0, 0, 23, 23);
    _closeButton.center = CGPointMake(284 - 20, 18);
    
    for (int i = 0; i < [_donateButtons count]; i++) {
        int row = i / 3;
        int column = i % 3;
        UIButton *donateButton = _donateButtons[i];
        donateButton.frame = CGRectMake(2 + 8 + column * (80 + 12), 42 + row * 40, 80, 32);
    }
}

- (void)setPrices:(NSArray *)prices
{
    [_prices autorelease];
    _prices = [prices copy];
    [self addDonateButtons];
}


#pragma mark - Donate Buttons

- (void)deleteDonateButtons
{
    [_donateButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_donateButtons release]; _donateButtons = nil;
}

- (void)addDonateButtons
{
    [self deleteDonateButtons];
    
    NSMutableArray *donateButtons = [NSMutableArray arrayWithCapacity:9];
    
    NSArray *pigs = @[
        @"donate.dialog.pig.gray.png",
        @"donate.dialog.pig.green.png",
        @"donate.dialog.pig.red.png",
        @"donate.dialog.pig.blue.png",
        @"donate.dialog.pig.yellow.png",
    ];
    
    int i = 0;
    for (NSNumber *price in self.prices) {
        if (i++ >= 9) break;
        
        VBDonateDialogButton *donateButton = [VBDonateDialogButton buttonWithType:UIButtonTypeCustom];
        donateButton.tag = i - 1;
        [donateButton addTarget:self action:@selector(donateAction:) forControlEvents:UIControlEventTouchUpInside];
        donateButton.price = [price doubleValue];
        [self addSubview:donateButton];
        [donateButtons addObject:donateButton];
        
        if ([price doubleValue] < 100) {
            NSString *pigName = pigs[i % [pigs count]];
            [donateButton setImage:[UIImage imageNamed:pigName] forState:UIControlStateNormal];
            [donateButton setImage:[UIImage imageNamed:pigName] forState:UIControlStateHighlighted];
        }
    }
    
    _donateButtons = [donateButtons copy];
    [self layoutSubviews];
}


#pragma mark - Show / Hidding

- (void)show
{
    if (_shown) return;
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_window makeKeyAndVisible];
    
    _dimView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _dimView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [_window addSubview:_dimView];
    
    _dimView.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        _dimView.alpha = 1;
    }];
    
    [_window addSubview:self];
    
    self.alpha = 0;
    
    self.frame = CGRectMake(0, 0, 284, 164);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:4].CGPath;
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.center = CGPointMake(_window.frame.size.width / 2,
                              statusBarHeight + (_window.frame.size.height - statusBarHeight) / 2);
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1;
    }];
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    bounceAnimation.fillMode = kCAFillModeBoth;
    bounceAnimation.removedOnCompletion = YES;
    bounceAnimation.duration = 0.4;
    bounceAnimation.values = @[
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 0.01f)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.1f)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 0.9f)],
                               [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    bounceAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    bounceAnimation.timingFunctions = @[
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    
    
    [self.layer addAnimation:bounceAnimation forKey:@"bounce"];
    
    _shown = YES;
    [self retain];
}

- (void)hide
{
    [UIView animateWithDuration:0.4 animations:^{
        _window.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self completeHidding];
    }];
}

- (void)completeHidding
{
    [_dimView removeFromSuperview];
    [_dimView release]; _dimView = nil;
    
    [_window release]; _window = nil;
    
    _shown = NO;
    [self autorelease];
}


#pragma - Actions

- (void)closeAction
{
    if ([self.delegate respondsToSelector:@selector(donateDialogCancelled:)]) {
        [self.delegate donateDialogCancelled:self];
    }
    [self hide];
}

- (void)donateAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(donateDialog:clickedDonateButtonAtIndex:)]) {
        [self.delegate donateDialog:self clickedDonateButtonAtIndex:sender.tag];
    }
    [self hide];
}

@end
