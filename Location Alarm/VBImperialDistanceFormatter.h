//
//  VBImperialDistanceFormatter.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/2/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBDistanceFormatter.h"

@interface VBImperialDistanceFormatter : NSObject <VBDistanceFormatter>

- (NSString *)numberForDistance:(double)distance;
- (NSString *)numberWithZerosForDistance:(double)distance;
- (NSString *)unitForDistance:(double)distance;
- (NSString *)numberWithUnitForDistance:(double)distance;

@end
