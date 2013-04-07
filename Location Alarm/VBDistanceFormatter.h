//
//  VBDistanceFormatter.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/4/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VBDistanceFormatter <NSObject>

- (NSString *)numberForDistance:(double)distance;
- (NSString *)numberWithZerosForDistance:(double)distance;
- (NSString *)unitForDistance:(double)distance;
- (NSString *)numberWithUnitForDistance:(double)distance;

@end
