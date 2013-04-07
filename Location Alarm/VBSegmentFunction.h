//
//  VBSegmentFunction.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/28/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VBSegmentFunction : NSObject

- (void)setXes:(NSArray *)xes yes:(NSArray *)yes;

- (double)x:(double)y;

- (double)y:(double)x;

@end
