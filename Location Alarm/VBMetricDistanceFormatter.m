//
//  VBMetricDistanceFormatter.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/2/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBMetricDistanceFormatter.h"

#define KILOMETRE 1000  // Metres in one kilometre

@implementation VBMetricDistanceFormatter
{
    NSNumberFormatter *_formatter1;
    NSNumberFormatter *_formatter2;
    NSNumberFormatter *_formatter3;
    NSNumberFormatter *_formatter4;
}


- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    _formatter1 = [[NSNumberFormatter alloc] init];
    [_formatter1 setPositiveFormat:@"#,###"];
    
    _formatter2 = [[NSNumberFormatter alloc] init];
    [_formatter2 setPositiveFormat:@"#,###.#"];
  
    _formatter3 = [[NSNumberFormatter alloc] init];
    [_formatter3 setPositiveFormat:@"#,###.##"];
    
    _formatter4 = [[NSNumberFormatter alloc] init];
    [_formatter4 setPositiveFormat:@"#,###.00"];
    
    return self;
}

- (NSString *)numberForDistance:(double)distance
{
    if (distance < KILOMETRE) {
        return [_formatter1 stringFromNumber:@(distance)];
    } else if (distance < 10 * KILOMETRE) {
        return [_formatter3 stringFromNumber:@(distance / KILOMETRE)];
    } else if (distance < 100 * KILOMETRE) {
        return [_formatter2 stringFromNumber:@(distance / KILOMETRE)];
    } else {
        return [_formatter1 stringFromNumber:@(distance / KILOMETRE)];
    }
}

- (NSString *)numberWithZerosForDistance:(double)distance
{
    if (distance < KILOMETRE) {
        return [_formatter1 stringFromNumber:@(distance)];
    } else {
        return [_formatter4 stringFromNumber:@(distance / KILOMETRE)];
    }
}

- (NSString *)unitForDistance:(double)distance
{
    if (distance < KILOMETRE) {
        return NSLocalizedString(@"metre", @"");
    } else {
        return NSLocalizedString(@"kilometre", @"");
    }
}

- (NSString *)numberWithUnitForDistance:(double)distance
{
    return [NSString stringWithFormat:@"%@ %@", [self numberForDistance:distance], [self unitForDistance:distance]];
}

@end
