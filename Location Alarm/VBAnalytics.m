//
//  VBAnalytics.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/22/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBAnalytics.h"
#import "GAI.h"


#define UI_CATEGORY @"user_interface"
#define APP_LOGIC_CATEGORY @"app_logic"
#define MAP_CONFIG_CATEGORY @"map_config"
#define DONATION_CATEGORY @"donation"

#define BUTTON_PRESSED_ACTION @"button_pressed"
#define DIALOG_SHOWN_ACTION @"dialog_shown"
#define MARKER_ALARMED_ACTION @"marker_alarmed"
#define UNITS_SYSTEM_USED_ACTION @"units_system_used"
#define DONATION_SUCCEED_ACTION @"donation_succeed"
#define DONATION_INITIATED_ACTION @"donation_initiated"
#define MARKER_CREATED_ACTION @"marker_created"
#define MAP_TYPE_USED_ACTION @"map_type_used"

#define RATE_DIALOG_LABEL @"rate_dialog"
#define RATE_BUTTON_LABEL @"rate_button"
#define DONATION_DIALOG_LABEL @"donation_dialog"
#define APPLICATION_WEBSITE_LABEL @"go_to_web_site_button"
#define MILWUS_WEBSITE_LABEL @"milwus_logo_button"
#define IN_ALARM_LABEL @"in_alarm"
#define OUT_ALARM_LABEL @"out_alarm"
#define FACEBOOK_POST_BUTTON_LABEL @"facebook_post_button"
#define TWITTER_TWEET_BUTTON_LABEL @"twitter_tweet_button"
#define GOOGLE_PLUS_SHARE_BUTTON_LABEL @"google_plus_shaer_button"
#define SEARCH_BUTTON_LABEL @"search_button"
#define METRICT_UNIT_SYSTEM_LABEL @"metric_units_system"
#define IMPERIAL_UNIT_SYSTEM_LABEL @"imperial_units_system"
#define ANY_DONATION_SUCCEED_LABEL @"any_donation"
#define ANY_DONATION_INITIATION_LABEL @"any_dontation_initiation"
#define MARKER_CREATION_LABEL @"marker_creation"
#define SETTINGS_PANEL @"settings_panel"
#define ALARM_DELETION_FROM_LEFT_SIDE @"alarm_deletion_from_left_side"
#define ALARM_DELETION_FROM_CARD @"alarm_deletion_from_card"
#define DONATION_INITIATION_SUFFIX_LABEL @"_$_donation_initiation"
#define DONATION_SUCCEED_SUFFIX_LABEL @"_$_donation"
#define NORMAL_APPLE_MAP_TYPE_LABEL @"normal_apple_map"
#define HYBRID_APPLE_MAP_TYPE_LABEL @"hybrid_apple_map"
#define SATELLITE_APPLE_MAP_TYPE_LABEL @"satellite_apple_map"
#define NORMAL_GOOGLE_MAP_TYPE_LABEL @"normal_google_map"
#define HYBRID_GOOGLE_MAP_TYPE_LABEL @"hybrid_google_map"
#define SATELLITE_GOOGLE_MAP_TYPE_LABEL  @"satellite_google_map"


@implementation VBAnalytics

+ (void)viewSplashScreen
{
    [[GAI sharedInstance].defaultTracker sendView:@"Splash Screen"];
}

+ (void)viewAppleMap
{
    [[GAI sharedInstance].defaultTracker sendView:@"Apple Map"];
}

+ (void)viewGoogleMap
{
    [[GAI sharedInstance].defaultTracker sendView:@"Google Map"];
}

+ (void)viewYandexMap
{
    [[GAI sharedInstance].defaultTracker sendView:@"Yandex Map"];
}

+ (void)viewAlarmCard
{
    [[GAI sharedInstance].defaultTracker sendView:@"Alarm Card"];
}

+ (void)viewAlarmEditor
{
    [[GAI sharedInstance].defaultTracker sendView:@"Alarm Editor"];
}

+ (void)viewSounds
{
    [[GAI sharedInstance].defaultTracker sendView:@"Sounds"];
}

+ (void)viewLeftSidePanel
{
    [[GAI sharedInstance].defaultTracker sendView:@"Left Side Panel"];
}

+ (void)viewAbout
{
    [[GAI sharedInstance].defaultTracker sendView:@"About"];
}

+ (void)viewHelp
{
    [[GAI sharedInstance].defaultTracker sendView:@"Help"];
}

+ (void)showMapSettings
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:UI_CATEGORY
                                                    withAction:BUTTON_PRESSED_ACTION
                                                     withLabel:SETTINGS_PANEL
                                                     withValue:nil];
}

+ (void)useMetricUnitSystem
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:UI_CATEGORY
                                                    withAction:UNITS_SYSTEM_USED_ACTION
                                                     withLabel:METRICT_UNIT_SYSTEM_LABEL
                                                     withValue:nil];
}

+ (void)useImperialUnitSystem
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:UI_CATEGORY
                                                    withAction:UNITS_SYSTEM_USED_ACTION
                                                     withLabel:METRICT_UNIT_SYSTEM_LABEL
                                                     withValue:nil];
}

+ (void)useAppleStandardMapType
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:MAP_CONFIG_CATEGORY
                                                    withAction:MAP_TYPE_USED_ACTION
                                                     withLabel:NORMAL_APPLE_MAP_TYPE_LABEL
                                                     withValue:nil];
}

+ (void)useAppleHybridMayType
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:MAP_CONFIG_CATEGORY
                                                    withAction:MAP_TYPE_USED_ACTION
                                                     withLabel:HYBRID_APPLE_MAP_TYPE_LABEL
                                                     withValue:nil];
}

+ (void)useAppleSateliteMapType
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:MAP_CONFIG_CATEGORY
                                                    withAction:MAP_TYPE_USED_ACTION
                                                     withLabel:SATELLITE_APPLE_MAP_TYPE_LABEL
                                                     withValue:nil];
}

+ (void)useGoogleStandardMapType
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:MAP_CONFIG_CATEGORY
                                                    withAction:MAP_TYPE_USED_ACTION
                                                     withLabel:NORMAL_GOOGLE_MAP_TYPE_LABEL
                                                     withValue:nil];
}

+ (void)useGooleHybridMayType
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:MAP_CONFIG_CATEGORY
                                                    withAction:MAP_TYPE_USED_ACTION
                                                     withLabel:HYBRID_GOOGLE_MAP_TYPE_LABEL
                                                     withValue:nil];
}

+ (void)useGoogleSateliteMapType
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:MAP_CONFIG_CATEGORY
                                                    withAction:SATELLITE_GOOGLE_MAP_TYPE_LABEL
                                                     withLabel:@""
                                                     withValue:nil];
}

+ (void)startShareOnFacebook
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:UI_CATEGORY
                                                    withAction:BUTTON_PRESSED_ACTION
                                                     withLabel:FACEBOOK_POST_BUTTON_LABEL
                                                     withValue:nil];
}

+ (void)startShareOnTwitter
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:UI_CATEGORY
                                                    withAction:BUTTON_PRESSED_ACTION
                                                     withLabel:TWITTER_TWEET_BUTTON_LABEL
                                                     withValue:nil];
}

+ (void)startShareOnGooglePlus
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:UI_CATEGORY
                                                    withAction:BUTTON_PRESSED_ACTION
                                                     withLabel:GOOGLE_PLUS_SHARE_BUTTON_LABEL
                                                     withValue:nil];
}

+ (void)completeShareOnFacebook
{
    [[GAI sharedInstance].defaultTracker sendSocial:@"Facebook" withAction:@"Post" withTarget:nil];
}

+ (void)completeShareOnTwitter
{
    [[GAI sharedInstance].defaultTracker sendSocial:@"Twitter" withAction:@"Tweet" withTarget:nil];
}

+ (void)completeShareOnGooglePlus
{
    [[GAI sharedInstance].defaultTracker sendSocial:@"Google+" withAction:@"Share" withTarget:nil];
}

+ (void)createAlarm
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:APP_LOGIC_CATEGORY
                                                    withAction:MARKER_CREATED_ACTION
                                                     withLabel:MARKER_CREATION_LABEL
                                                     withValue:nil];
}

+ (void)fireInAlarm
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:APP_LOGIC_CATEGORY
                                                    withAction:MARKER_ALARMED_ACTION
                                                     withLabel:IN_ALARM_LABEL
                                                     withValue:nil];
}

+ (void)fireOutAlarm
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:APP_LOGIC_CATEGORY
                                                    withAction:MARKER_ALARMED_ACTION
                                                     withLabel:OUT_ALARM_LABEL
                                                     withValue:nil];
}

+ (void)startAddressSearch
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:UI_CATEGORY
                                                    withAction:BUTTON_PRESSED_ACTION
                                                     withLabel:SEARCH_BUTTON_LABEL
                                                     withValue:nil];
}

+ (void)deleteAlarmFromLeftSide
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:UI_CATEGORY
                                                    withAction:BUTTON_PRESSED_ACTION
                                                     withLabel:ALARM_DELETION_FROM_LEFT_SIDE
                                                     withValue:nil];
}

+ (void)deleteAlarmFromAlarmCard
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:UI_CATEGORY
                                                    withAction:BUTTON_PRESSED_ACTION
                                                     withLabel:ALARM_DELETION_FROM_CARD
                                                     withValue:nil];
}

+ (void)showRateDialog
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:UI_CATEGORY
                                                    withAction:DIALOG_SHOWN_ACTION
                                                     withLabel:RATE_DIALOG_LABEL
                                                     withValue:nil];
}

+ (void)showDonationDialog
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:UI_CATEGORY
                                                    withAction:DIALOG_SHOWN_ACTION
                                                     withLabel:DONATION_DIALOG_LABEL
                                                     withValue:nil];
}

+ (void)goToMilwusWebsite
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:UI_CATEGORY
                                                    withAction:BUTTON_PRESSED_ACTION
                                                     withLabel:MILWUS_WEBSITE_LABEL
                                                     withValue:nil];
}

+ (void)goToApplicationWebsite
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:UI_CATEGORY
                                                    withAction:BUTTON_PRESSED_ACTION
                                                     withLabel:APPLICATION_WEBSITE_LABEL
                                                     withValue:nil];
}

+ (void)startDonateWithPrice:(NSString *)price
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:DONATION_CATEGORY
                                                    withAction:DONATION_INITIATED_ACTION
                                                     withLabel:ANY_DONATION_INITIATION_LABEL
                                                     withValue:nil];
    
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:DONATION_CATEGORY
                                                    withAction:DONATION_INITIATED_ACTION
                                                     withLabel:[NSString stringWithFormat:@"%@%@", price, DONATION_INITIATION_SUFFIX_LABEL]
                                                     withValue:nil];
}

+ (void)completeDonateWithPrice:(NSString *)price
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:DONATION_CATEGORY
                                                    withAction:DONATION_SUCCEED_ACTION
                                                     withLabel:ANY_DONATION_SUCCEED_LABEL
                                                     withValue:nil];
    
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:DONATION_CATEGORY
                                                    withAction:DONATION_SUCCEED_ACTION
                                                     withLabel:[NSString stringWithFormat:@"%@%@", price, DONATION_SUCCEED_SUFFIX_LABEL]
                                                     withValue:nil];
}

+ (void)rateApp
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:UI_CATEGORY
                                                    withAction:BUTTON_PRESSED_ACTION
                                                     withLabel:RATE_BUTTON_LABEL
                                                     withValue:nil];
}

@end
