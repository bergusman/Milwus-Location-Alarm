//
//  VBAlarmAnnotationView.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/27/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface VBAlarmAnnotationView : MKAnnotationView

@property (nonatomic, assign) BOOL on;
@property (nonatomic, assign) double progress;

@end
