//
//  VBAppDelegate.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/24/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBApp.h"
#import <CoreData/CoreData.h>
#import "IIViewDeckController2.h"
#import "IISideController.h"
#import "IIWrapController.h"
#import "VBMapViewController.h"
#import "VBLeftViewController.h"
#import "UINavigationBar+VBStyle.h"
#import "VBLocationManager.h"
#import "VBAlarmTracker.h"
#import "VBAlarmManager.h"
#import "VBConfig.h"
#import "VBApp.h"
#import "GAI.h"
#import "VBMetricDistanceFormatter.h"
#import "VBImperialDistanceFormatter.h"
#import "VBNoteCenter.h"
#import "Appirater.h"
#import <AudioToolbox/AudioToolbox.h>
#import "VBDonateManager.h"
#import <GoogleMaps/GoogleMaps.h>
#import "VBHelpViewController.h"
#import "GPPSignIn.h"
#import "GPPURLHandler.h"
#import "GPPDeepLink.h"
#import "TestFlight.h"
#import "VBAlarmDetailsViewController.h"
#import <MediaPlayer/MediaPlayer.h>


NSString *const VBDeckWillOpenLeftSideNotification = @"VBDeckWillOpenLeftSideNotification";
NSString *const VBDeckWillCloseLeftSideNotification = @"VBDeckWillCloseLeftSideNotification";


#define GPS_OFF_NOTE_VIEW_TAG 0x69500f
#define BAD_SIGNAL_NOTE_VIEW_TAG 0x695bad

#define VBCurrentVersion @"VBCurrentVersion"


@interface VBApp ()
<
    UINavigationControllerDelegate,
    IIViewDeckControllerDelegate,
    AppiraterDelegate,
    GPPDeepLinkDelegate
>

@property (nonatomic, strong) VBSegmentFunction *currentRadiusFunction;
@property (nonatomic, strong) VBSegmentFunction *metricRadiusFunction;
@property (nonatomic, strong) VBSegmentFunction *imperialRadiusFunction;

@property (nonatomic, strong) VBSegmentFunction *distanceProgressFunction;

@property (nonatomic, strong) id<VBDistanceFormatter> metricFormatter;
@property (nonatomic, strong) id<VBDistanceFormatter> imperialFormatter;

@property (nonatomic, strong) VBSoundsManager *soundsManager;

@property (nonatomic, strong) UIImageView *splash;
@property (nonatomic, assign) BOOL splashShowed;
@property (nonatomic, strong) VBNoteCenter *noteCenter;
@property (nonatomic, strong) VBMapViewController *mapViewController;

@property (nonatomic, strong) NSMutableArray *noteQueue;
@property (nonatomic, strong) NSDate *lastBadSignalNote;

@end


@implementation VBApp
{
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}


- (id)init
{
    self = [super init];
    if (self) {
        _sharedApp = self;
        _noteQueue = [NSMutableArray array];
    }
    return self;
}


#pragma mark - Core Data Stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) return _managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) return _managedObjectModel;
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) return _persistentStoreCoordinator;
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
	
	NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:nil
                                                           error:&error]) {
        // TODO: handle error
    }
	
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[VBMapViewController class]]) {
        viewController.viewDeckController.panningMode = IIViewDeckNavigationBarPanning;
        [self checkNoteQueue];
    } else {
        viewController.viewDeckController.panningMode = IIViewDeckNoPanning;
        [self hideBadSignalNote];
        [self hideGPSOffNote];
    }
}


#pragma mark - Splash

- (void)showSplash
{
    self.splash = [[UIImageView alloc] init];
    self.splash.image = [UIImage imageNamed:@"Default"];
    
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        self.splash.image = [UIImage imageNamed:@"Default-568h"];
    } else {
        self.splash.image = [UIImage imageNamed:@"Default"];
    }
    
    self.splash.frame = self.window.bounds;
    [self.window addSubview:self.splash];
    
    [VBAnalytics viewSplashScreen];
    
    [self performSelector:@selector(hideSplash) withObject:nil afterDelay:0.1];
}

- (void)hideSplash
{
    [UIView animateWithDuration:0.4 animations:^{
        self.splash.alpha = 0;
    } completion:^(BOOL finished) {
        [self.splash removeFromSuperview];
        self.splash = nil;
        [self didHideSplash];
    }];
}

- (void)didHideSplash
{
    self.splashShowed = YES;
    [self checkNoteQueue];
}


#pragma mark - IIViewDeckControllerDelegate

- (BOOL)viewDeckControllerWillOpenLeftView:(IIViewDeckController *)viewDeckController animated:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:VBDeckWillOpenLeftSideNotification object:nil];
    return YES;
}

- (BOOL)viewDeckControllerWillCloseLeftView:(IIViewDeckController *)viewDeckController animated:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:VBDeckWillCloseLeftSideNotification object:nil];
    return YES;
}


#pragma mark - AppiraterDelegate

- (void)appiraterDidDisplayAlert:(Appirater *)appirater
{
    [VBAnalytics showRateDialog];
}

- (void)appiraterDidDeclineToRate:(Appirater *)appirater
{
}

- (void)appiraterDidOptToRate:(Appirater *)appirater
{
    [VBAnalytics rateApp];
}

- (void)appiraterDidOptToRemindLater:(Appirater *)appirater
{
}


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[VBConfig sharedConfig] loadConfigFromFile:[[NSBundle mainBundle] infoDictionary][@"VBConfigName"]];
    
    // Google Analytics
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = [VBConfig sharedConfig].analyticsDispatchInterval;
    [[GAI sharedInstance] trackerWithTrackingId:[VBConfig sharedConfig].analyticsTrackingID];
    
    // TestFlight
    if ([VBConfig sharedConfig].useTestFlight) {
        if ([VBConfig sharedConfig].enableUDID) {
            [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
        }
        [TestFlight takeOff:[VBConfig sharedConfig].appToken];
    }
    
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [GMSServices provideAPIKey:[VBConfig sharedConfig].googleMapsAPIKey];
    //[YMKConfiguration sharedInstance].apiKey = [VBConfig sharedConfig].yandexMapsAPIKey;
    
    [VBAlarmManager sharedManager].managedObjectContext = [self managedObjectContext];
    [[VBAlarmManager sharedManager] load];
    
    [VBAlarmTracker sharedTracker];
    
    self.soundsManager = [[VBSoundsManager alloc] initWithNames:@"SoundNames.plist"
                                                         shorts:@"SoundShorts.plist"
                                                          longs:@"SoundLongs.plist"
                                                   defaultSound:@"Alarm"];
    
    self.distanceProgressFunction = [[VBSegmentFunction alloc] init];
    [self.distanceProgressFunction setXes:[VBConfig sharedConfig].distanceProgressFunction[@"x"]
                                                   yes:[VBConfig sharedConfig].distanceProgressFunction[@"y"]];
    
    self.metricRadiusFunction = [[VBSegmentFunction alloc] init];
    [self.metricRadiusFunction setXes:[VBConfig sharedConfig].metricRadiusFunction[@"x"]
                                               yes:[VBConfig sharedConfig].metricRadiusFunction[@"y"]];
    
    self.imperialRadiusFunction = [[VBSegmentFunction alloc] init];
    [self.imperialRadiusFunction setXes:[VBConfig sharedConfig].imperialRadiusFunction[@"x"]
                                                 yes:[VBConfig sharedConfig].imperialRadiusFunction[@"y"]];
    
    self.metricFormatter = [[VBMetricDistanceFormatter alloc] init];
    self.imperialFormatter = [[VBImperialDistanceFormatter alloc] init];
    
    if ([VBSettings sharedSettings].system == VBMeasurementSystemMetric) {
        self.currentRadiusFunction = self.metricRadiusFunction;
    } else {
        self.currentRadiusFunction = self.imperialRadiusFunction;
    }
    
    [VBDonateManager sharedManager].dialogPrices = [VBConfig sharedConfig].dialogDonatePrices;
    [VBDonateManager sharedManager].dialogProductIDs = [VBConfig sharedConfig].dialogDonateIDs;
    [VBDonateManager sharedManager].aboutPrices = [VBConfig sharedConfig].aboutDonatePrices;
    [VBDonateManager sharedManager].aboutProductIDs = [VBConfig sharedConfig].aboutDonateIDs;
    
    [GPPSignIn sharedInstance].clientID = [VBConfig sharedConfig].googlePlusClientID;
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.mapViewController = [[VBMapViewController alloc] init];
    VBLeftViewController *leftVC = [[VBLeftViewController alloc] init];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.mapViewController];
    nc.delegate = self;
    [nc.navigationBar vbSetypStyle];
    
    IISideController *sideVC = [[IISideController alloc] initWithViewController:leftVC];
    sideVC.constrainedSize = 260;
    
    IIViewDeckController *deckVC = [[IIViewDeckController alloc] init];
    deckVC.delegate = self;
    deckVC.centerController = nc;
    deckVC.leftController = sideVC;
    deckVC.panningMode = IIViewDeckNavigationBarPanning;
    deckVC.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    //deckVC.leftSize = 60;
    deckVC.leftLedge = 60;
    
    self.window.rootViewController = deckVC;
    [self.window makeKeyAndVisible];
    
    [self showSplash];

    self.noteCenter = [[VBNoteCenter alloc] initWithNavigationController:nc];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusDidChange:)
                                                 name:VBLocationManagerDidChangeAuthorizationStatusNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alarmDidTrigger:)
                                                 name:VBAlarmTrackerDidTriggerAlarmNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accuracyDidChange:)
                                                 name:VBAlarmTrackerGPSAccuracyDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(donateDidSuccess:)
                                                 name:VBDonateDidSuccessNotification
                                               object:nil];
    
    // App iRater
    [Appirater setAppId:[VBConfig sharedConfig].applicationID];
    [Appirater setDaysUntilPrompt:-1];
    [Appirater setUsesUntilPrompt:-1];
    [Appirater setSignificantEventsUntilPrompt:5];
    [Appirater setTimeBeforeReminding:2];
    
    if (!launchOptions && [launchOptions isKindOfClass:[UILocalNotification class]]) {
        UILocalNotification *localNotification = (UILocalNotification *)launchOptions;
        NSDictionary *userInfo = localNotification.userInfo;
        [self showAlarm:userInfo];
    }
    
    [VBLocationManager sharedManager].distanceFilter = 5;
    [VBLocationManager sharedManager].desiredAccuracy = kCLLocationAccuracyBest;
    [[VBLocationManager sharedManager] startUpdatingLocation];
    
    [[VBDonateManager sharedManager] addObserver:self forKeyPath:@"activeTransactionCount" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    [[VBSettings sharedSettings] addObserver:self forKeyPath:@"system" options:NSKeyValueObservingOptionNew context:(__bridge void *)(self)];
    
    
    NSString *version = [[NSBundle mainBundle] infoDictionary][(NSString*)kCFBundleVersionKey];
    NSString *currentVersion = [[NSUserDefaults standardUserDefaults] objectForKey:VBCurrentVersion];
    
    if (![version isEqualToString:currentVersion]) {
        VBHelpViewController *help = [[VBHelpViewController alloc] init];
        help.showsCloseButton = YES;
        help.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        help.onBack = ^{
            [self.mapViewController dismissViewControllerAnimated:YES completion:nil];
        };
        [self.mapViewController presentViewController:help animated:YES completion:nil];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:VBCurrentVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self customizeAppearance];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
    [[VBDonateManager sharedManager] tryShowDonateDialog];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (application.applicationState != UIApplicationStateActive) {
        [self showAlarm:notification.userInfo];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[GAI sharedInstance] dispatch];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation]) {
        return YES;
    }
    return YES;
}


#pragma mark - Appearance

- (void)customizeAppearance
{
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"nav.button.bg.png"]
                                            forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"nav.button.bg.h.png"]
                                            forState:UIControlStateHighlighted
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                UITextAttributeTextColor: [UIColor colorWithWhite:0.267 alpha:1.0],
                          UITextAttributeTextShadowColor: [UIColor colorWithWhite:1.0 alpha:0.65],
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                     UITextAttributeFont: [UIFont boldSystemFontOfSize:16]
     }];
    
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:3 forBarMetrics:UIBarMetricsDefault];
    
    
    
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == [VBSettings sharedSettings]) {
        if ([keyPath isEqualToString:@"system"]) {
            if ([VBSettings sharedSettings].system == VBMeasurementSystemMetric) {
                self.currentRadiusFunction = self.metricRadiusFunction;
            } else {
                self.currentRadiusFunction = self.imperialRadiusFunction;
            }
        }
    }
}


#pragma mark - Other

- (void)showAlarm:(NSDictionary *)alarmDict
{
    if (!alarmDict) return;
    
    VBAlarm *alarm = nil;
    for (alarm in [VBAlarmManager sharedManager].alarms) {
        if ([[[alarm.objectID URIRepresentation] absoluteString] isEqualToString:alarmDict[@"objectID"]]) {
            break;
        }
    }
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake([alarmDict[@"latitude"] doubleValue], [alarmDict[@"longitude"] doubleValue]);
    CLLocationDistance radius = [alarmDict[@"radius"] doubleValue];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, radius, radius);
    [self.mapViewController showRegion:region];
    
    if (alarm) {
        [self.noteCenter.navigationController.viewDeckController closeLeftViewAnimated:NO];
        [self.noteCenter.navigationController popToRootViewControllerAnimated:NO];
        
        VBAlarmDetailsViewController *vc = [[VBAlarmDetailsViewController alloc] initWithAlarm:alarm];
        
        UINavigationController *nc = self.noteCenter.navigationController;
        
        vc.onBack = ^{
            [nc popViewControllerAnimated:YES];
        };
        
        [nc pushViewController:vc animated:NO];
        
    } else {
    }
}


#pragma mark - Alarm Tracker Notifications

- (void)accuracyDidChange:(NSNotification *)notification
{
    if ([VBAlarmTracker sharedTracker].accuracy == VBGPSAccuracyBad) {
        [self performSelector:@selector(throwBadSignal) withObject:nil afterDelay:2];
    } else {
        [self.noteQueue removeObject:@"BadSignal"];
        [self hideBadSignalNote];
    }
}

- (void)alarmDidTrigger:(NSNotification *)notification
{
    VBAlarm *alarm = notification.userInfo[VBAlarmTrackerAlarmUserInfoKey];
    
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        //[[MPMusicPlayerController applicationMusicPlayer] setVolume:1];
    }
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.soundName = [self.soundsManager soundLong:alarm.sound];
    localNotification.userInfo = [alarm dictionaryRepresentation];
    if (alarm.type == VBAlarmTypeIn) {
        localNotification.alertBody = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Reached", @""), alarm.title];
    } else {
        localNotification.alertBody = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Left", @""), alarm.title];
    }
    
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        NSString *action = (alarm.type == VBAlarmTypeIn ? NSLocalizedString(@"Reached", @"") : NSLocalizedString(@"Left", @""));
        NSString *text = [NSString stringWithFormat:@"%@ %@", action, alarm.title];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
        
        [attributedText addAttribute:(NSString *)kCTFontAttributeName
                               value:(id)[self regularNoteFont]
                               range:NSMakeRange(0, [action length])];
        
        [self.noteCenter showNoteWithAttributedText:attributedText
                                              image:[UIImage imageNamed:@"note.icon.marker.png"]
                                           closable:YES];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    } else {
    }
    
    [Appirater userDidSignificantEvent:YES];
    [[VBDonateManager sharedManager] retainAlarmTrigeredCount];
    
    if (alarm.type == VBAlarmTypeIn) {
        [VBAnalytics fireInAlarm];
    } else {
        [VBAnalytics fireOutAlarm];
    }

    if ([VBConfig sharedConfig].offAlarmAfterFiring) {
        [self performSelector:@selector(offAlarm:) withObject:alarm afterDelay:0.0];
    }
}

- (void)offAlarm:(VBAlarm *)alarm
{
    alarm.on = NO;
    [[VBAlarmManager sharedManager] save];
}


#pragma mark - Location Manager Notifications

- (void)statusDidChange:(NSNotification *)notification
{
    if ([VBLocationManager sharedManager].authorizationStatus == kCLAuthorizationStatusDenied) {
        [self.noteQueue addObject:@"GPSOff"];
        [self checkNoteQueue];
    } else {
        [self.noteQueue removeObject:@"GPSOff"];
        [self hideGPSOffNote];
    }
}


#pragma mark - Note Center Helpers

- (CTFontRef)regularNoteFont
{
    static CTFontRef font = nil;
    if (!font) {
        font = CTFontCreateWithName((__bridge CFStringRef)[UIFont systemFontOfSize:10].fontName, 10, NULL);
    }
    return font;
}

- (void)checkNoteQueue
{
    if (!self.splashShowed) return;
    
    if ([self.noteCenter.navigationController.topViewController isKindOfClass:[VBMapViewController class]]) {
        BOOL gpsOff = NO;
        BOOL badSignal = NO;
        
        for (NSString *note in self.noteQueue) {
            if ([note isEqualToString:@"GPSOff"]) gpsOff = YES;
            else if ([note isEqualToString:@"BadSignal"]) badSignal = YES;
        }
        
        [self.noteQueue removeAllObjects];
        
        if (gpsOff) {
            [self showGPSOffNote];
        } else if (badSignal) {
            if (!self.lastBadSignalNote || fabs([self.lastBadSignalNote timeIntervalSinceNow]) > 60 * 2) {
                self.lastBadSignalNote = [NSDate date];
                [self showBadSignalNote];
            }
        }
    }
}


#pragma mark - GPS Off Note

- (void)showGPSOffNote
{
    [self.noteCenter showNoteWithText:NSLocalizedString(@"Note_GPSOff", @"")
                                image:[UIImage imageNamed:@"note.icon.error.png"]
                             closable:YES];
    self.noteCenter.noteView.tag = GPS_OFF_NOTE_VIEW_TAG;
}

- (void)hideGPSOffNote
{
    if (self.noteCenter.noteView.tag == GPS_OFF_NOTE_VIEW_TAG) {
        [self.noteCenter hideNote];
    }
}


#pragma mark - Bad Signal Note

- (void)throwBadSignal
{
    [self.noteQueue addObject:@"BadSignal"];
    [self checkNoteQueue];
}

- (void)showBadSignalNote
{
    return;
    [self.noteCenter showNoteWithText:NSLocalizedString(@"Note_BadSignal", @"")
                                image:[UIImage imageNamed:@"note.icon.error.png"]
                             closable:YES];
    self.noteCenter.noteView.tag = BAD_SIGNAL_NOTE_VIEW_TAG;
}

- (void)hideBadSignalNote
{
    if (self.noteCenter.noteView.tag == BAD_SIGNAL_NOTE_VIEW_TAG) {
        [self.noteCenter hideNote];
    }
}


#pragma mark - Donage Notification

- (void)donateDidSuccess:(NSNotification *)notificaiton
{
    NSString *productID = notificaiton.userInfo[VBDonateProductIDKey];
    NSNumber *price = [[VBDonateManager sharedManager] priceForProductID:productID];
    
    [VBAnalytics completeDonateWithPrice:[price stringValue]];
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SuccessDonateTitle", @"")
                                message:NSLocalizedString(@"SuccessDonateMessage", @"")
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                      otherButtonTitles:nil] show];
}


#pragma mark - GPPDeepLinkDelegate

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink
{
    
}


#pragma mark - Singleton

static VBApp *_sharedApp;

+ (VBApp *)sharedApp
{
    return _sharedApp;
}

@end
