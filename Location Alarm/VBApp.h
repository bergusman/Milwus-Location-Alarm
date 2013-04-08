//
//  VBAppDelegate.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/24/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBSegmentFunction.h"
#import "VBDistanceFormatter.h"
#import "VBSoundsManager.h"

extern NSString *const VBDeckWillOpenLeftSideNotification;
extern NSString *const VBDeckWillCloseLeftSideNotification;

@interface VBApp : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong, readonly) VBSegmentFunction *currentRadiusFunction;
@property (nonatomic, strong, readonly) VBSegmentFunction *metricRadiusFunction;
@property (nonatomic, strong, readonly) VBSegmentFunction *imperialRadiusFunction;

@property (nonatomic, strong, readonly) VBSegmentFunction *distanceProgressFunction;

@property (nonatomic, strong, readonly) id<VBDistanceFormatter> metricFormatter;
@property (nonatomic, strong, readonly) id<VBDistanceFormatter> imperialFormatter;

@property (nonatomic, strong, readonly) VBSoundsManager *soundsManager;

+ (VBApp *)sharedApp;

@end
