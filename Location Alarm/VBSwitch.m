//
//  VBInOutSwitch.m
//  UITest
//
//  Created by Vitaliy Berg on 2/20/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBSwitch.h"

#import <QuartzCore/QuartzCore.h>


@implementation VBSwitch
{
    UIImageView *_thumbImageView;
    
    UIView *_trackView;
    UIView *_trackContainerView;
    
    UIImageView *_onImageView;
    UIImageView *_offImageView;
    
    CGPoint _leftThumbCenter;
    CGPoint _rightThumbCenter;
    
    CGPoint _leftStateCenter;
    CGPoint _rightStateCenter;
    
    CGPoint _onCenter;
    CGPoint _offCenter;
}

@dynamic onImage, offImage;


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
    self.backgroundColor = [UIColor clearColor];
    
    // Track
    _trackContainerView = [[UIView alloc] init];
    _trackContainerView.frame = CGRectMake(0, 2, 68, 26);
    _trackContainerView.userInteractionEnabled = NO;
    [self addSubview:_trackContainerView];
    
    _trackContainerView.layer.masksToBounds = YES;
    _trackContainerView.layer.cornerRadius = 13;
    
    // State
    _trackView = [[UIView alloc] init];
    _trackView.frame = CGRectMake(0, 0, 100, 26);
    _trackView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"switch.track.bg.png"]];
    _trackView.userInteractionEnabled = NO;
    [_trackContainerView addSubview:_trackView];
    
    _leftStateCenter = CGPointMake(16, 13);
    _rightStateCenter = CGPointMake(52, 13);
    
    // On State
    _onImageView = [[UIImageView alloc] init];
    [_trackView addSubview:_onImageView];
    _onCenter = CGPointMake(78, 13);
    
    // Off State
    _offImageView = [[UIImageView alloc] init];
    [_trackView addSubview:_offImageView];
    _offCenter = CGPointMake(21, 13);
    
    // Cover
    UIImageView *cover = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"switch.overlay.png"]];
    cover.frame = CGRectMake(0, 0, 68, 31);
    [self addSubview:cover];
    
    // Thumb
    _thumbImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"switch.thumb.png"]
                                        highlightedImage:[UIImage imageNamed:@"switch.thumb.h.png"]];
    [self addSubview:_thumbImageView];
    
    _leftThumbCenter = CGPointMake(16, 15);
    _rightThumbCenter = CGPointMake(52, 15);
    
    // Pan Gesture
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.cancelsTouchesInView = NO;
    [self addGestureRecognizer:pan];
    
    // Tap Gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tap];
    
    [self setOn:NO animated:NO];
}

- (void)setOn:(BOOL)on
{
    [self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    _on = on;
    
    if (!animated) {
        _thumbImageView.center = (_on ? _leftThumbCenter : _rightThumbCenter);
        _trackView.center = (_on ? _leftStateCenter : _rightStateCenter);
    } else {
        CGPoint thumbCenter =  (_on ? _leftThumbCenter : _rightThumbCenter);
        CGPoint stateCenter = (_on ? _leftStateCenter : _rightStateCenter);
    
        [UIView animateWithDuration:0.2 animations:^{
            _thumbImageView.center = thumbCenter;
            _trackView.center = stateCenter;
        }];
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        
        CGPoint center = _thumbImageView.center;
        BOOL on = center.x < 34;
        
        CGPoint velocity = [pan velocityInView:self];
        velocity.x = MAX(fabs(velocity.x), 80.0);

        NSTimeInterval duration = 0;
        if (on) {
            duration = (center.x - _leftThumbCenter.x) / velocity.x;
        } else {
            duration = (_rightThumbCenter.x - center.x) / velocity.x;
        }
        
        [UIView animateWithDuration:duration animations:^{
            _thumbImageView.center = (on ? _leftThumbCenter : _rightThumbCenter);
            _trackView.center = (on ? _leftStateCenter : _rightStateCenter);
        } completion:^(BOOL finished) {
            if (_on != on) {
                _on = on;
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }];
        
        return;
    }
    
    CGPoint translation = [pan translationInView:_thumbImageView];
    CGPoint center = _thumbImageView.center;
    center.x += translation.x;
    
    if (center.x < _leftThumbCenter.x) {
        CGFloat diff = _leftThumbCenter.x - center.x;
        center.x = _leftThumbCenter.x;
        [pan setTranslation:CGPointMake(-diff, 0) inView:_thumbImageView];
        _thumbImageView.center = center;
        
    } else if (center.x > _rightThumbCenter.x) {
        CGFloat diff = center.x - _rightThumbCenter.x;
        center.x = _rightThumbCenter.x;
        [pan setTranslation:CGPointMake(+diff, 0) inView:_thumbImageView];
        _thumbImageView.center = center;
               
    } else {
         [pan setTranslation:CGPointZero inView:_thumbImageView];
    }
    
    _thumbImageView.center = center;
    _trackView.center = CGPointMake(center.x, _leftStateCenter.y);
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    [self setOn:!self.on animated:YES];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark - Control Touch Tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _thumbImageView.highlighted = YES;
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _thumbImageView.highlighted = NO;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    _thumbImageView.highlighted = NO;
}


#pragma mark - onImage property

- (void)setOnImage:(UIImage *)onImage
{
    _onImageView.image = onImage;
    [_onImageView sizeToFit];
    _onImageView.center = _onCenter;
}

- (UIImage *)onImage
{
    return _onImageView.image;
}


#pragma mark - offImage property

- (void)setOffImage:(UIImage *)offImage
{
    _offImageView.image = offImage;
    [_offImageView sizeToFit];
    _offImageView.center = _offCenter;
}

- (UIImage *)offImage
{
    return _offImageView.image;
}

@end
