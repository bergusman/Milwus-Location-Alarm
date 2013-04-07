//
//  VBMapViewController.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/24/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class VBAlarm;
@class SVPlacemark;

@interface VBMapViewController : UIViewController

- (void)showRegion:(MKCoordinateRegion)region;
- (void)showAlarm:(VBAlarm *)alarm;
- (void)showPlacemark:(SVPlacemark *)placemark;

@end
