//
//  VBImperialDistanceFormatter.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/2/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBImperialDistanceFormatter.h"

#define MILE 1760       // Amount yards in one mile
#define HALF_MILE 880   // Amount yards in half mile

@implementation VBImperialDistanceFormatter
{
    NSNumberFormatter *_formatter1;
    NSNumberFormatter *_formatter2;
    NSNumberFormatter *_formatter3;
    NSNumberFormatter *_formatter4;
}

- (void)dealloc
{
    [_formatter1 release];
    [_formatter2 release];
    [_formatter3 release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    _formatter1 = [[NSNumberFormatter alloc] init];
    [_formatter1 setPositiveFormat:@"#,###"];
    
    _formatter2 = [[NSNumberFormatter alloc] init];
    [_formatter2 setPositiveFormat:@"#,##0.#"];
    
    _formatter3 = [[NSNumberFormatter alloc] init];
    [_formatter3 setPositiveFormat:@"#,##0.##"];
    
    _formatter4 = [[NSNumberFormatter alloc] init];
    [_formatter4 setPositiveFormat:@"#,##0.00"];
    
    return self;
}

- (NSString *)numberForDistance:(double)distance
{
    if (distance < HALF_MILE) {
        return [_formatter1 stringFromNumber:@(distance)];
    } else if (distance < 5 * MILE) {
        return [_formatter3 stringFromNumber:@(distance / MILE)];
    } else if (distance < 50 * MILE) {
        return [_formatter2 stringFromNumber:@(distance / MILE)];
    } else {
        return [_formatter1 stringFromNumber:@(distance / MILE)];
    }
}

- (NSString *)numberWithZerosForDistance:(double)distance
{
    if (distance < HALF_MILE) {
        return [_formatter1 stringFromNumber:@(distance)];
    } else {
        return [_formatter4 stringFromNumber:@(distance / MILE)];
    }
}

- (NSString *)unitForDistance:(double)distance
{
    if (distance < HALF_MILE) {
        return NSLocalizedString(@"yard", @"");
    } else {
        return NSLocalizedString(@"mile", @"");
    }
}

- (NSString *)numberWithUnitForDistance:(double)distance
{
    return [NSString stringWithFormat:@"%@ %@", [self numberForDistance:distance], [self unitForDistance:distance]];
}

@end
