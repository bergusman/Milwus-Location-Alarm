//
//  VBSegmentFunction.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/28/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBSegmentFunction.h"


@interface VBSegmentFunction ()

@property (nonatomic, retain) NSArray *xes;
@property (nonatomic, retain) NSArray *yes;

@end


@implementation VBSegmentFunction

- (void)dealloc
{
    [_xes release];
    [_yes release];
    [super dealloc];
}

- (void)setXes:(NSArray *)xes yes:(NSArray *)yes
{
    self.xes = xes;
    self.yes = yes;
}

- (double)x:(double)y
{
    return [self y:y xes:self.yes yes:self.xes];
}

- (double)y:(double)x
{
    return [self y:x xes:self.xes yes:self.yes];
}

- (double)y:(double)x xes:(NSArray *)xes yes:(NSArray *)yes
{
    double min = [xes[0] doubleValue];
    if (x <= min) {
        return [yes[0] doubleValue];
    }
    
    double max = [[xes lastObject] doubleValue];
    if (x >= max) {
        return [[yes lastObject] doubleValue];
    }
    
    int count = [_xes count];
    for (int i = 0; i < count - 1; i++) {
        double startX = [xes[i] doubleValue];
        double endX = [xes[i + 1] doubleValue];
        
        if (startX < x && x <= endX) {
            double startY = [yes[i] doubleValue];
            double endY = [yes[i + 1] doubleValue];
            
            double y = startY + (endY - startY) * (x - startX) / (endX - startX);
            return y;
        }
    }
    
    return min;
}

@end
