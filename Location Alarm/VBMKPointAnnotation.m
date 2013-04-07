//
//  VBPointAnnotation.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/25/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBMKPointAnnotation.h"

@implementation VBMKPointAnnotation

- (void)dealloc
{
    [_userData release];
    [super dealloc];
}

@end
