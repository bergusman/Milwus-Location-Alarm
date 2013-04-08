//
//  VBMapViewController.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/24/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBMapViewController.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IIViewDeckController.h"
#import "VBSettings.h"
#import "VBAlarmManager.h"
#import "UIButton+VBStyle.h"
#import "UISegmentedControl+VBStyle.h"
#import "VBAlarmDetailsViewController.h"
#import "VBMKPointAnnotation.h"
#import "VBTestPinAnnotationView.h"
#import "VBAlarmAnnotationView.h"
#import "VBApp.h"
#import "VBAlarmTracker.h"
#import "VBAlarmEditorViewController.h"
#import "VBNoteCenter.h"
#import "SVPlacemark.h"
#import "VBMapViewController.h"
#import "VBAppleMapViewController.h"
#import "VBMapController.h"
#import "VBGoogleMapViewController.h"
//#import "VBYandexMapViewController.h"
#import "UISegmentedControl+VBUnhighlighted.h"
#import <OpenGLES/EAGL.h>
#import "VBLocationManager.h"


#define TAP_ON_MAP_NOTE_VIEW_TAG 749
#define VBMapRegionKey @"VBMapRegionKey"


@interface VBMapViewController ()
<
    MKMapViewDelegate,
    VBAlarmEditorViewControllerDelegate,
    VBMapControllerDelegate
>

@property (nonatomic, strong) id<VBMapController> mapController;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *mapViewTap;

@property (strong, nonatomic) UIBarButtonItem *addAlarmBarButton;
@property (strong, nonatomic) UIBarButtonItem *addAlarmSelectedBarButton;

@property (weak, nonatomic) IBOutlet UIButton *toUserLocationButton;

@property (nonatomic, assign) BOOL settingsShown;
@property (nonatomic, assign) CGPoint lastPanTranslation;

@property (weak, nonatomic) IBOutlet UIButton *settingsEpxanderButton;
@property (weak, nonatomic) IBOutlet UIView *settingsPanel;
@property (weak, nonatomic) IBOutlet UIImageView *settingsPanelImageView;

@property (weak, nonatomic) IBOutlet UIButton *metricSystemButton;
@property (weak, nonatomic) IBOutlet UIButton *imperialSystemButton;
@property (weak, nonatomic) IBOutlet UILabel *metricSystemLabel;
@property (weak, nonatomic) IBOutlet UILabel *imperialSystemLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *mapProviderSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;

@property (nonatomic, strong) NSMutableSet *alarmsForUpdating;

@property (nonatomic, strong) VBAlarm *addingAlarm;
@property (nonatomic, copy) NSManagedObjectID *addingAlarmObjectID;

@property (nonatomic, assign) MKCoordinateRegion region;

@property (nonatomic, strong) NSArray *mapProviders;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation VBMapViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    


    [_timer invalidate];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(alarmsChanged:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:[VBAlarmManager sharedManager].managedObjectContext];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(becomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deckWillCloseLeftSide:)
                                                     name:VBDeckWillCloseLeftSideNotification
                                                   object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusDidChange:)
                                                     name:VBLocationManagerDidChangeAuthorizationStatusNotification
                                                   object:nil];
        
        
    
        if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 6) {
            self.mapProviders = @[
                @(VBMapProviderApple),
                @(VBMapProviderGoogle),
                //@(VBMapProviderYandex)
            ];
        } else {
            self.mapProviders = @[
                @(VBMapProviderApple),
                //@(VBMapProviderGoogle),
                //@(VBMapProviderYandex)
            ];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ptrn.light.png"]];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav.title.png"]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav.button.menu.png"]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(leftAction)];
    
    self.addAlarmBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav.button.add.png"]
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(addAction)];
    
    self.addAlarmSelectedBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav.button.add.png"]
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(addAction)];
    
    
    [self.addAlarmSelectedBarButton setBackgroundImage:[UIImage imageNamed:@"nav.button.bg.h.png"]
                                              forState:UIControlStateNormal
                                            barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.rightBarButtonItem = self.addAlarmBarButton;
    
    [self.toUserLocationButton setImage:[UIImage imageNamed:@"map.tolocation.button.png"] forState:UIControlStateNormal];
    
    self.mapViewTap.enabled = NO;
    
    [self setupSettings];

    [self setupMapProviderSegmentedControlSegments];
    self.mapProviderSegmentedControl.selectedSegmentIndex = [self.mapProviders indexOfObject:@([VBSettings sharedSettings].mapProvider)];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:VBMapRegionKey]) {
        self.region = [self loadMapRegion];
    } else {
        self.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(39.368279, -98.964844), 4000000, 4000000);
        [self saveMapRegion:self.region];
    }
    
    [self setupMapProvider:[VBSettings sharedSettings].mapProvider];
    
    [self sendMapTypeEvent];
    [self sendUnitSystemEvent];
    
    //[self.alarmsForUpdating addObjectsFromArray:@[@"sadfasd", @"sdfsdf"]];
    
    [self performSelector:@selector(bingo) withObject:nil afterDelay:1];
}

- (void)bingo
{
    [self.mapController updateAlarmProgresses];
}

- (void)viewDidUnload
{
    [self setMapViewTap:nil];    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateAlarmQueue];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startTimer];
    [self sendView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationItem.rightBarButtonItem = self.addAlarmBarButton;
    self.mapViewTap.enabled = NO;
    [self hideInfoNote];
    if (self.mapController) {
        [self saveMapRegion:self.mapController.region];
    }
    [self stopTimer];
}

- (void)sendView
{
    if ([self.mapController isKindOfClass:[VBAppleMapViewController class]]) {
        [VBAnalytics viewAppleMap];
    } else if ([self.mapController isKindOfClass:[VBGoogleMapViewController class]]) {
        [VBAnalytics viewGoogleMap];
    }
    //} else if ([self.mapController isKindOfClass:[VBYandexMapViewController class]]) {
    //    [VBAnalytics viewYandexMap];
    //}
}

- (void)sendMapTypeEvent
{
    if ([self.mapController isKindOfClass:[VBAppleMapViewController class]]) {
        if (self.mapController.mapType == VBMapTypeStandard) {
            [VBAnalytics useAppleStandardMapType];
        } else if (self.mapController.mapType == VBMapTypeHybrid) {
            [VBAnalytics useAppleHybridMayType];
        } else if (self.mapController.mapType == VBMapTypeSatellite) {
            [VBAnalytics useAppleSateliteMapType];
        }
    } else if ([self.mapController isKindOfClass:[VBGoogleMapViewController class]]) {
        if (self.mapController.mapType == VBMapTypeStandard) {
            [VBAnalytics useGoogleStandardMapType];
        } else if (self.mapController.mapType == VBMapTypeHybrid) {
            [VBAnalytics useGooleHybridMayType];
        } else if (self.mapController.mapType == VBMapTypeSatellite) {
            [VBAnalytics useGoogleSateliteMapType];
        }
    }
}

- (void)sendUnitSystemEvent
{
    if ([VBSettings sharedSettings].system == VBMeasurementSystemMetric) {
        [VBAnalytics useMetricUnitSystem];
    } else {
        [VBAnalytics useImperialUnitSystem];
    }
}

- (void)statusDidChange:(NSNotification *)notification
{
    [self.mapController updateAlarmProgresses];
}


#pragma mark - Become / Resign Active

- (void)resignActive:(NSNotification *)notification
{
    [self stopTimer];
    if (self.mapController) {
        [self saveMapRegion:self.mapController.region];
    }
}

- (void)becomeActive:(NSNotification *)notification
{
    [self startTimer];
    [self updateAlarmQueue];
    [self.mapController updateAlarmProgresses];
}


#pragma mark - Alarm Updating

- (void)alarmsChanged:(NSNotification *)notification
{
    for (id deletedAlarm in notification.userInfo[NSDeletedObjectsKey]) {
        [self.alarmsForUpdating removeObject:deletedAlarm];
        [self deleteAlarm:deletedAlarm];
    }
    
    if (self.navigationController.topViewController == self) {
        for (VBAlarm *alarm in notification.userInfo[NSUpdatedObjectsKey]) {
            [self updateAlarm:alarm];
        }
    } else {
        for (id updatedAlarm in notification.userInfo[NSUpdatedObjectsKey]) {
            [self.alarmsForUpdating addObject:updatedAlarm];
        }
    }
}

- (void)deleteAlarm:(VBAlarm *)alarm
{
    [self.alarmsForUpdating removeObject:alarm];
    [self.mapController removeAlarm:alarm];
}

- (void)updateAlarmQueue
{
    for (VBAlarm *alarm in [self.alarmsForUpdating copy]) {
        [self updateAlarm:alarm];
    }
    [self.alarmsForUpdating removeAllObjects];
}

- (void)updateAlarm:(VBAlarm *)alarm
{
    [self.mapController updateAlarm:alarm];
    [self.alarmsForUpdating removeObject:alarm];
}

- (void)updateAllAlarms
{
    [self.mapController updateAllAlarms];
}

- (NSMutableSet *)alarmsForUpdating
{
    if (!_alarmsForUpdating) {
        _alarmsForUpdating = [[NSMutableSet alloc] init];
    }
    return _alarmsForUpdating;
}


#pragma mark - Timer

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startTimer
{
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:12 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)timerAction
{
    NSLog(@"Refresh Progress");
    [self.mapController updateAlarmProgresses];
}


#pragma mark - Load / Save Map Region

- (MKCoordinateRegion)loadMapRegion
{
    NSDictionary *regionDict = [[NSUserDefaults standardUserDefaults] objectForKey:VBMapRegionKey];
    MKCoordinateRegion region;
    region.center.latitude = [regionDict[@"latitude"] doubleValue];
    region.center.longitude = [regionDict[@"longitude"] doubleValue];
    region.span.latitudeDelta = [regionDict[@"latitudeDelta"] doubleValue];
    region.span.longitudeDelta = [regionDict[@"longitudeDelta"] doubleValue];
    return region;
}

- (void)saveMapRegion:(MKCoordinateRegion)region
{
    NSDictionary *regionDict = @{
        @"latitude": @(region.center.latitude),
        @"longitude": @(region.center.longitude),
        @"latitudeDelta": @(region.span.latitudeDelta),
        @"longitudeDelta": @(region.span.longitudeDelta)
    };
    
    [[NSUserDefaults standardUserDefaults] setObject:regionDict forKey:VBMapRegionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Public Methods

- (void)showAlarm:(VBAlarm *)alarm
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(alarm.coordinate, alarm.radius * 2, alarm.radius * 2);
    [self.mapController setRegion:region animated:YES];
}

- (void)showPlacemark:(SVPlacemark *)placemark
{
    [self.mapController showPlacemark:placemark animated:YES];
}

- (void)showRegion:(MKCoordinateRegion)region
{
    [self.mapController setRegion:region animated:YES];
}


#pragma mark - Map Type

- (NSString *)mapTypeLocalizedName:(VBMapType)mapType
{
    if (mapType == VBMapTypeStandard) {
        return NSLocalizedString(@"MapTypeStandard", @"");
    } else if (mapType == VBMapTypeSatellite) {
        return NSLocalizedString(@"MapTypeSatellite", @"");
    } else if (mapType == VBMapTypeHybrid) {
        return NSLocalizedString(@"MapTypeHybrid", @"");
    } else if (mapType == VBMapTypeTerrain) {
        return NSLocalizedString(@"MapTypeTerrain", @"");
    } else if (mapType == VBMapTypeSchema) {
        return NSLocalizedString(@"MapTypeSchema", @"");
    } else if (mapType == VBMapTypePeoples) {
        return NSLocalizedString(@"MapTypePeoples", @"");
    } else {
        return @"";
    }
}

- (void)setupMapTypeSegmentedControlWithMapTypes:(NSArray *)mapTypes
{
    [self.mapTypeSegmentedControl removeAllSegments];
    NSUInteger index = 0;
    for (NSNumber *mapType in mapTypes) {
        NSString *title = [self mapTypeLocalizedName:[mapType integerValue]];
        [self.mapTypeSegmentedControl insertSegmentWithTitle:title atIndex:index++ animated:NO];
    }
}


#pragma mark - Map Provider

- (Class<VBMapController>)mapProviderClass:(VBMapProvider)mapProvider
{
    if (mapProvider == VBMapProviderApple) {
        return [VBAppleMapViewController class];
    } else if (mapProvider == VBMapProviderGoogle) {
        return [VBGoogleMapViewController class];
    } else if (mapProvider == VBMapProviderYandex) {
        return nil;
        //return [VBYandexMapViewController class];
    } else {
        return Nil;
    }
}

- (void)setupMapProviderSegmentedControlSegments
{
    [self.mapProviderSegmentedControl removeAllSegments];
    NSUInteger index = 0;
    for (NSNumber *provider in self.mapProviders) {
        Class<VBMapController> mapProviderClass = [self mapProviderClass:[provider integerValue]];
        [self.mapProviderSegmentedControl insertSegmentWithTitle:[mapProviderClass localizedName]
                                                         atIndex:index++
                                                        animated:NO];
    }
}

- (void)changeMapProviderOnAtIndex:(NSUInteger)index
{
    [VBSettings sharedSettings].mapProvider = [self.mapProviders[index] integerValue];
    
    self.region = self.mapController.region;
    
    UIViewController *vc = (UIViewController *)self.mapController;
    [vc.view removeFromSuperview];
    
    [self performSelector:@selector(freeMapProvider) withObject:nil afterDelay:0.05];
    [self performSelector:@selector(completeMapProviderChanging) withObject:nil afterDelay:0.1];
    
    self.mapProviderSegmentedControl.userInteractionEnabled = NO;
    self.mapTypeSegmentedControl.userInteractionEnabled = NO;
}

- (void)freeMapProvider
{
    self.mapController = nil;
}

- (void)completeMapProviderChanging
{
    [EAGLContext setCurrentContext:nil];
    
    [self setupMapProvider:[VBSettings sharedSettings].mapProvider];
    
    self.mapProviderSegmentedControl.userInteractionEnabled = YES;
    self.mapTypeSegmentedControl.userInteractionEnabled = YES;
    
    [self sendView];
}

- (void)setupMapProvider:(VBMapProvider)mapProvider
{
    Class mapProviderClass = [self mapProviderClass:mapProvider];
    self.mapController = (id<VBMapController>)[[mapProviderClass alloc] init];
    
    UIViewController *vc = (UIViewController *)self.mapController;
    vc.view.frame = self.view.bounds;
    [self.view addSubview:vc.view];
    [self.view sendSubviewToBack:vc.view];
    [vc.view addGestureRecognizer:self.mapViewTap];
    
    self.mapController.delegate = self;
    self.mapController.showsUserLocation = YES;
    self.mapController.mapType = [VBSettings sharedSettings].mapType;
    [self.mapController addAlarms:[VBAlarmManager sharedManager].alarms];
    self.mapController.region = self.region;
    
    [self setupMapTypeSegmentedControlWithMapTypes:[self.mapController supportedMapTypes]];
    self.mapTypeSegmentedControl.selectedSegmentIndex = [[self.mapController supportedMapTypes] indexOfObject:@(self.mapController.mapType)];
}


#pragma mark - Show/Hide Info Note

- (void)showInfoNote
{
    [self.navigationController.noteCenter showNoteWithText:NSLocalizedString(@"Note_TapOnMap", @"")
                                                     image:[UIImage imageNamed:@"note.icon.info3.png"]
                                                  closable:NO];
    self.navigationController.noteCenter.noteView.tag = TAP_ON_MAP_NOTE_VIEW_TAG;
}

- (void)hideInfoNote
{
    if (self.navigationController.noteCenter.noteView.tag == TAP_ON_MAP_NOTE_VIEW_TAG) {
        [self.navigationController.noteCenter hideNote];
    }
}


#pragma mark - Actions

- (void)leftAction
{
    [self.viewDeckController openLeftView];
}

- (void)addAction
{
    [self saveMapRegion:self.mapController.region];
    if (self.navigationItem.rightBarButtonItem == self.addAlarmBarButton) {
        self.navigationItem.rightBarButtonItem = self.addAlarmSelectedBarButton;
        self.mapViewTap.enabled = YES;
        [self showInfoNote];
    } else {
        self.navigationItem.rightBarButtonItem = self.addAlarmBarButton;
        self.mapViewTap.enabled = NO;
        [self hideInfoNote];
    }
}

- (IBAction)mapViewTap:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:sender.view];
    CLLocationCoordinate2D coordinate = [self.mapController coordinateForPoint:point];
    
    VBAlarm *alarm = [[VBAlarmManager sharedManager] createAlarm];
    alarm.title = @"";
    alarm.type = VBAlarmTypeIn;
    alarm.on = YES;
    alarm.latitude = coordinate.latitude;
    alarm.longitude = coordinate.longitude;
    alarm.sound = [[VBApp sharedApp].soundsManager defaultSound];
    
    if ([VBSettings sharedSettings].system == VBMeasurementSystemMetric) {
        alarm.radius = [VBConfig sharedConfig].metricDefaultRadius;
    } else {
        alarm.radius = [VBConfig sharedConfig].imperialDefaultRadius;
    }
    
    self.addingAlarm = alarm;
    self.addingAlarmObjectID = alarm.objectID;
    [self.mapController addAlarm:self.addingAlarm];
   
    VBAlarmEditorViewController *editor = [[VBAlarmEditorViewController alloc] initWithAlarm:alarm];
    editor.pushWithKeyboard = YES;
    editor.delegate = self;
    [self.navigationController pushViewController:editor animated:YES];
}

- (IBAction)userLocationAction
{
    if (self.mapController.userLocation) {
        [self.mapController showUserLocationAnimated:YES];
    } else {
        NSString *errorTitle = nil;
        NSString *errorMessage = nil;
        
        errorTitle = NSLocalizedString(@"Dialog_UserLocationOffTitle", @"");
        errorMessage = NSLocalizedString(@"Dialog_UserLocationOffMessage", @"");
        
        [[[UIAlertView alloc] initWithTitle:errorTitle
                                     message:errorMessage
                                    delegate:nil
                           cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                           otherButtonTitles:nil] show];
    }
    
    //NSLog(@"Location services enabled: %d", [CLLocationManager locationServicesEnabled]);
    //NSLog(@"Authorization status: %d", [CLLocationManager authorizationStatus]);
    
    // 0 2 - Geolocation off, Application on
    // 1 3 - Geolocation on, Application on
    // 1 2 - Geolocation on, Application off
    // 0 2 - Geolocation off, Application off
}

- (IBAction)mapProviderAction:(UISegmentedControl *)sender
{
    [self changeMapProviderOnAtIndex:sender.selectedSegmentIndex];
}


#pragma mark - Settings

- (void)setupSettings
{
    self.settingsPanelImageView.image = [[UIImage imageNamed:@"map.settings.bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    self.settingsPanelImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.settingsPanelImageView.layer.shadowOffset = CGSizeZero;
    self.settingsPanelImageView.layer.shadowRadius = 3;
    self.settingsPanelImageView.layer.shadowOpacity = 0.4;
    

    [self.settingsEpxanderButton setImage:[UIImage imageNamed:@"map.settings.expander.button.png"] forState:UIControlStateNormal];
    
    [self.mapTypeSegmentedControl vbSetupStyle];
    [self.mapProviderSegmentedControl vbSetupStyle];
    
    self.metricSystemLabel.text = NSLocalizedString(@"MetricSystem", @"");
    self.imperialSystemLabel.text = NSLocalizedString(@"ImperialSystem", @"");
    
    [self.metricSystemButton vbSetupRadioButton];
    [self.imperialSystemButton vbSetupRadioButton];
    
    if ([VBSettings sharedSettings].system == VBMeasurementSystemMetric) {
        self.metricSystemButton.selected = YES;
        self.imperialSystemButton.selected = NO;
    } else {
        self.metricSystemButton.selected = NO;
        self.imperialSystemButton.selected = YES;
    }
    
    self.settingsPanel.hidden = YES;
    
    CGSize size = self.view.bounds.size;
    if ([self.mapProviders count] == 1) {
        self.settingsPanel.frame = CGRectMake(size.width, size.height - 90 - 3, 240, 90);
        self.mapProviderSegmentedControl.hidden = YES;
    } else {
        self.settingsPanel.frame = CGRectMake(size.width, size.height - 130 - 3, 240, 130);
        self.mapProviderSegmentedControl.hidden = NO;
        //self.settingsPanel.center = CGPointMake(size.width + 120, size.height - 3 - 45 - 20);
    }
    
    self.settingsPanelImageView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.settingsPanel.bounds cornerRadius:4].CGPath;
}

- (void)showSettings:(CGFloat)velocity
{
    self.settingsShown = YES;
    self.settingsPanel.hidden = NO;
    self.settingsPanelImageView.layer.shadowOpacity = 0.4;
    
    CGSize size = self.view.bounds.size;
    CGFloat distance = fabs((size.width - 240 - 22) - self.settingsEpxanderButton.center.x);
    
    CGFloat h = self.settingsPanel.bounds.size.height / 2;
    
    [UIView animateWithDuration:(distance / velocity) animations:^{
        self.settingsEpxanderButton.center = CGPointMake(size.width - 240 - 22, size.height - 6 - 22);
        self.settingsPanel.center = CGPointMake(size.width - 240 + 120, size.height - 3 - h);
    } completion:^(BOOL finished) {
    }];
}

- (void)hideSettings:(CGFloat)velocity
{
    self.settingsShown = NO;
    
    CGSize size = self.view.bounds.size;
    CGFloat distance = fabs((size.width - 22) - self.settingsEpxanderButton.center.x);
    
    CGFloat h = self.settingsPanel.bounds.size.height / 2;
    
    [UIView animateWithDuration:(distance / velocity) animations:^{
        self.settingsEpxanderButton.center = CGPointMake(size.width - 22, size.height - 6 - 22);
        self.settingsPanel.center = CGPointMake(size.width + 120, size.height - 3 - h);
    } completion:^(BOOL finished) {
        self.settingsPanelImageView.layer.shadowOpacity = 0;
        self.settingsPanel.hidden = YES;
    }];
}

- (IBAction)settingsExpanderAction
{
    if (self.settingsShown) {
        [self hideSettings:800];
    } else {
        [self showSettings:800];
    }
}

- (IBAction)settingsExpanderPan:(UIPanGestureRecognizer *)sender
{
    if (self.settingsPanel.hidden) {
        self.settingsPanel.hidden = NO;
    }
    
    if (self.settingsPanelImageView.layer.shadowOpacity == 0) {
        self.settingsPanelImageView.layer.shadowOpacity = 0.4;
    }
    
    [self pan:sender];
}

- (IBAction)settingsPanelPan:(UIPanGestureRecognizer *)sender
{
    [self pan:sender];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self.settingsEpxanderButton];
    
    CGPoint velocity = [pan velocityInView:self.settingsEpxanderButton];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self.mapProviderSegmentedControl vbUnhighlighted];
        [self.mapTypeSegmentedControl vbUnhighlighted];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat x = self.view.bounds.size.width - 240 - 22;
        if (self.settingsEpxanderButton.center.x != x) {
            velocity.x = fabs(velocity.x) > 800 ? fabs(velocity.x) : 800;
            if (self.lastPanTranslation.x > 0) {
                [self hideSettings:velocity.x];
            } else {
                [self showSettings:velocity.x];
            }
        }
        return;
    }
    
    self.lastPanTranslation = point;
    
    CGPoint center = self.settingsEpxanderButton.center;
    CGFloat minX = self.view.bounds.size.width - 240 - 22;
    
    CGFloat diff = 0;
    
    center.x += point.x;
    
    if (center.x < minX) {
        diff = minX - center.x;
        center.x = minX;
        [pan setTranslation:CGPointMake(-diff, 0) inView:self.settingsEpxanderButton];
    } else {
        [pan setTranslation:CGPointZero inView:self.settingsEpxanderButton];
    }
    
    self.settingsEpxanderButton.center = center;
    
    center = self.settingsPanel.center;
    center.x += point.x + diff;
    self.settingsPanel.center = center;
}


#pragma mark - Settings Actions

- (IBAction)metricSystemAction
{
    [VBSettings sharedSettings].system = VBMeasurementSystemMetric;
    self.metricSystemButton.selected = YES;
    self.imperialSystemButton.selected = NO;
    [VBAnalytics useMetricUnitSystem];
}

- (IBAction)imperialSystemAction
{
    [VBSettings sharedSettings].system = VBMeasurementSystemImperial;
    self.metricSystemButton.selected = NO;
    self.imperialSystemButton.selected = YES;
    [VBAnalytics useImperialUnitSystem];
}

- (IBAction)mapTypeAction:(UISegmentedControl *)sender
{
    VBMapType mapType = [[self.mapController supportedMapTypes][sender.selectedSegmentIndex] integerValue];
    self.mapController.mapType = mapType;    
    [VBSettings sharedSettings].mapType = self.mapController.mapType;
    [self sendMapTypeEvent];
}


#pragma mark - VBMapControllerDelegate

- (void)mapController:(id<VBMapController>)mapController didChooseAlarm:(VBAlarm *)alarm
{
    VBAlarmDetailsViewController *details = [[VBAlarmDetailsViewController alloc] initWithAlarm:alarm];
    details.onBack = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:details animated:YES];
}


#pragma mark - VBAlarmEditorViewControllerDelegate

- (void)alarmEditorDidCancel:(VBAlarmEditorViewController *)alarmEditor
{
    [self.mapController removeAlarmWithObjectID:self.addingAlarmObjectID];
    [[VBAlarmManager sharedManager] deleteAlarm:self.addingAlarm];
    self.addingAlarmObjectID = nil;
    self.addingAlarm = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alarmEditorDidSave:(VBAlarmEditorViewController *)alarmEditor
{
    [self.mapController removeAlarmWithObjectID:self.addingAlarmObjectID];
    
    [[VBAlarmManager sharedManager] addAlarm:self.addingAlarm];
    [[VBAlarmManager sharedManager] save];
    
    [self.mapController addAlarm:self.addingAlarm];
    
    self.addingAlarm = nil;
    self.addingAlarmObjectID = nil;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Deck Notifications

- (void)deckWillCloseLeftSide:(NSNotification *)notification
{
    [self sendView];
}

@end
