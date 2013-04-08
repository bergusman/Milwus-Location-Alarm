//
//  VBSlider.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/27/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBSlider.h"

@implementation VBSlider
{
    UIImageView *_minTrackEnd;
    UIImageView *_maxTrackEnd;
    
    UIView *_minTrack;
    UIView *_maxTrack;
    
    UIImageView *_thumb;
    CGPoint _thumbAnchorPoint;
    
    CGFloat _minX;
    CGFloat _maxX;
    
    BOOL _dragging;
}


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
    
    _minTrackEnd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider.track.min.term.png"]];
    [self addSubview:_minTrackEnd];
    
    _minTrack = [[UIView alloc] init];
    _minTrack.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slider.track.min.bg.png"]];
    [self addSubview:_minTrack];
    
    _maxTrackEnd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider.track.max.term.png"]];
    [self addSubview:_maxTrackEnd];
    
    _maxTrack = [[UIView alloc] init];
    _maxTrack.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slider.track.max.bg.png"]];
    [self addSubview:_maxTrack];
    
    _thumb = [[UIImageView alloc] init];
    _thumb.image = [UIImage imageNamed:@"slider.thumb.png"];
    _thumb.highlightedImage = [UIImage imageNamed:@"slider.thumb.h.png"];
    [self addSubview:_thumb];
    
    _minTrack.userInteractionEnabled = NO;
    _maxTrack.userInteractionEnabled = NO;
    
    _value = 0.5;
    
    [self setupFrame];
}

- (void)setupTracks
{
    CGFloat thumbX = _thumb.center.x;
    _minTrack.frame = CGRectMake(8, 0, thumbX, 12);
    _maxTrack.frame = CGRectMake(thumbX, 0, self.frame.size.width - 8 - thumbX + 0.5, 12);
}

- (void)setupFrame
{
    CGRect frame = self.frame;
    _minTrackEnd.frame = CGRectMake(0, 0, 8, 12);
    _maxTrackEnd.frame = CGRectMake(frame.size.width - 8, 0, 8, 12);
    _minTrack.frame = CGRectMake(8, 0, 40, 12);
    _maxTrack.frame = CGRectMake(8 + 40, 0, frame.size.width - 8 - (40 + 8), 12);
    _thumb.frame = CGRectMake(0, 0, 44, 44);
    _thumb.center = CGPointMake(40, 8);
    _minX = 6;
    _maxX = frame.size.width - 6;
    
    [self setValue:_value];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setupFrame];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return CGRectContainsPoint(CGRectMake(-15, -15, self.bounds.size.width + 30, 65), point);
}

- (void)setValue:(float)value
{
    _value = value;
    CGFloat x = _minX + value * (_maxX - _minX);
    _thumb.center = CGPointMake(x, 8);
    [self setupTracks];
}

- (void)sendValueChangedWithEvent:(UIEvent *)event
{
    for (id targed in [self allTargets]) {
        NSArray *actions = [self actionsForTarget:targed forControlEvent:UIControlEventValueChanged];
        
        for (NSString *action in actions) {
            [self sendAction:NSSelectorFromString(action) to:targed forEvent:event];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setupTracks];
}


#pragma mark - Touch Handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_thumb];
    if (CGRectContainsPoint(CGRectInset(_thumb.bounds, -12, -10), point)) {
        _thumb.highlighted = YES;
        _thumbAnchorPoint = point;
        _dragging = YES;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (!_dragging) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGRect frame = _thumb.frame;
    frame.origin.x = point.x - _thumbAnchorPoint.x;
    
    _thumb.frame = frame;
    
    CGPoint center = _thumb.center;
    
    if (center.x < _minX) center.x = _minX;
    if (center.x > _maxX) center.x = _maxX;

    _thumb.center = center;
    
    
    _value = (center.x - _minX) / (_maxX - _minX);
    
    [self setupTracks];
    
    if (_continuous) {
        [self sendValueChangedWithEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (_dragging) {
        [self sendValueChangedWithEvent:event];
    }
    
    _thumb.highlighted = NO;
    _dragging = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    if (_dragging) {
        [self sendValueChangedWithEvent:event];
    }
    
    _thumb.highlighted = NO;
    _dragging = NO;
}

@end
