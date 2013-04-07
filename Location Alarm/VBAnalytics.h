//
//  VBAnalytics.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/22/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VBAnalytics : NSObject

// Views

+ (void)viewSplashScreen;
+ (void)viewAppleMap;
+ (void)viewGoogleMap;
+ (void)viewYandexMap;
+ (void)viewAlarmCard;
+ (void)viewAlarmEditor;
+ (void)viewSounds;
+ (void)viewLeftSidePanel;
+ (void)viewAbout;
+ (void)viewHelp;


// Events

+ (void)showMapSettings;

+ (void)useMetricUnitSystem;
+ (void)useImperialUnitSystem;

+ (void)useAppleStandardMapType;
+ (void)useAppleHybridMayType;
+ (void)useAppleSateliteMapType;

+ (void)useGoogleStandardMapType;
+ (void)useGooleHybridMayType;
+ (void)useGoogleSateliteMapType;

+ (void)startShareOnFacebook;
+ (void)startShareOnTwitter;
+ (void)startShareOnGooglePlus;

+ (void)completeShareOnFacebook;
+ (void)completeShareOnTwitter;
+ (void)completeShareOnGooglePlus;

+ (void)createAlarm;
+ (void)fireInAlarm;
+ (void)fireOutAlarm;

+ (void)startAddressSearch;

+ (void)deleteAlarmFromLeftSide;
+ (void)deleteAlarmFromAlarmCard;

+ (void)showRateDialog;
+ (void)showDonationDialog;

+ (void)goToMilwusWebsite;
+ (void)goToApplicationWebsite;

+ (void)startDonateWithPrice:(NSString *)price;
+ (void)completeDonateWithPrice:(NSString *)price;

+ (void)rateApp;

@end
