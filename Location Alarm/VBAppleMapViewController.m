//
//  VBAppleMapViewController.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/16/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBAppleMapViewController.h"
#import <MapKit/MapKit.h>
#import "SVPlacemark.h"
#import "VBMKPointAnnotation.h"
#import "VBAlarm.h"
#import "VBAlarmAnnotationView.h"
#import "VBAlarmTracker.h"
#import "VBApp.h"


@interface VBAppleMapViewController ()
<MKMapViewDelegate>

@property (nonatomic, retain) MKMapView *mapView;

@property (nonatomic, retain) MKPointAnnotation *placemarkAnnotation;
@property (nonatomic, assign) BOOL animatesPlacemarkDropping;

@property (nonatomic, retain) NSMutableDictionary *alarmAnnotations;
@property (nonatomic, retain) NSMutableDictionary *alarmCircleOverlays;

@end


@implementation VBAppleMapViewController

@synthesize delegate=_delegate;
@synthesize mapType=_mapType;

- (void)dealloc
{
    _mapView.delegate = nil;
    [_mapView release];
    [_placemarkAnnotation release];
    [_alarmAnnotations release];
    [_alarmCircleOverlays release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _mapType = VBMapTypeStandard;
        _alarmAnnotations = [[NSMutableDictionary alloc] init];
        _alarmCircleOverlays = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)loadView
{
    self.mapView = [[[MKMapView alloc] init] autorelease];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.view = self.mapView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapType = self.mapType;
}

- (void)viewWillLayoutSubviews
{
    [self positionMapLogo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)positionMapLogo
{
    for (UIView *view in self.mapView.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"MKAttributionLabel")] ||
            [view isKindOfClass:NSClassFromString(@"UIImageView")]) {
            
            CGPoint point = view.center;
            point.x = 160;
            view.center = point;
            break;
        }
    }
}

- (double)progressForAlarm:(VBAlarm *)alarm
{
    if ([VBAlarmTracker sharedTracker].alarmDistances[alarm.objectID]) {
        double distance = [[VBAlarmTracker sharedTracker].alarmDistances[alarm.objectID] doubleValue];
        return [[VBApp sharedApp].distanceProgressFunction y:distance];
    }
    return 0;
}

- (CLLocationCoordinate2D)coordinateForPoint:(CGPoint)point
{
    return [self.mapView convertPoint:point toCoordinateFromView:self.view];
}

+ (NSString *)localizedName
{
    return NSLocalizedString(@"Apple Maps", @"");
}


#pragma mark - Placemark

- (void)showPlacemark:(SVPlacemark *)placemark animated:(BOOL)animated
{
    self.animatesPlacemarkDropping = animated;
    [self addPlacemark:placemark];
    
    [self.mapView setRegion:placemark.region animated:animated];
    [self.mapView selectAnnotation:self.placemarkAnnotation animated:animated];
}

- (void)removePlacemark
{
    if (self.placemarkAnnotation) {
        id<MKAnnotation> annotation = self.placemarkAnnotation;
        self.placemarkAnnotation = nil;
        [self.mapView removeAnnotation:annotation];
    }
}

- (void)addPlacemark:(SVPlacemark *)placemark
{
    [self removePlacemark];
    
    self.placemarkAnnotation = [[[MKPointAnnotation alloc] init] autorelease];
    self.placemarkAnnotation.coordinate = placemark.coordinate;
    self.placemarkAnnotation.title = placemark.name;
    self.placemarkAnnotation.subtitle = placemark.formattedAddress;
    [self.mapView addAnnotation:self.placemarkAnnotation];
}


#pragma mark - User Location

- (void)setShowsUserLocation:(BOOL)showsUserLocation
{
    self.mapView.showsUserLocation = showsUserLocation;
}

- (BOOL)showsUserLocation
{
    return self.mapView.showsUserLocation;
}

- (CLLocation *)userLocation
{
    return self.mapView.userLocation.location;
}

- (void)showUserLocationAnimated:(BOOL)animated
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.userLocation.coordinate, 500, 500);
    [self.mapView setRegion:region animated:animated];
}


#pragma mark - Map Type

- (void)setMapType:(VBMapType)mapType
{
    if (mapType == VBMapTypeStandard || mapType == VBMapTypeSchema) {
        _mapType = VBMapTypeStandard;
        self.mapView.mapType = MKMapTypeStandard;
    } else if (mapType == VBMapTypeSatellite) {
        _mapType = VBMapTypeSatellite;
        self.mapView.mapType = MKMapTypeSatellite;
    } else if (mapType == VBMapTypeHybrid) {
        _mapType = VBMapTypeHybrid;
        self.mapView.mapType = MKMapTypeHybrid;
    } else if (mapType == VBMapTypeTerrain) {
        if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 6) {
            _mapType = VBMapTypeStandard;
            self.mapView.mapType = MKMapTypeStandard;
        } else {
            _mapType = VBMapTypeTerrain;
            self.mapView.mapType = 4;
        }
    } else {
        _mapType = VBMapTypeStandard;
        self.mapView.mapType = MKMapTypeStandard;
    }
    
    [self positionMapLogo];
}

- (NSArray *)supportedMapTypes
{
    return @[@(VBMapTypeStandard), @(VBMapTypeHybrid), @(VBMapTypeSatellite)];
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 6) {
        return @[@(VBMapTypeStandard), @(VBMapTypeHybrid), @(VBMapTypeSatellite)];
    } else {
        return @[@(VBMapTypeStandard), @(VBMapTypeHybrid), @(VBMapTypeSatellite), @(VBMapTypeTerrain)];
    }
}


#pragma mark - Region

- (MKCoordinateRegion)region
{
    return self.mapView.region;
}

- (void)setRegion:(MKCoordinateRegion)region
{
    [self.mapView setRegion:region animated:NO];
}

- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated
{
    [self.mapView setRegion:region animated:NO];
    [self.mapView setCenterCoordinate:region.center animated:animated];
}


#pragma mark - Add Alarms

- (void)addAlarm:(VBAlarm *)alarm
{
    VBMKPointAnnotation *annotation = [[[VBMKPointAnnotation alloc] init] autorelease];
    annotation.coordinate = CLLocationCoordinate2DMake(alarm.latitude, alarm.longitude);
    annotation.title = alarm.title;
    annotation.userData = alarm;
    [self.mapView addAnnotation:annotation];
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:alarm.coordinate radius:alarm.radius];
    if (!MKMapRectContainsRect(circle.boundingMapRect, self.mapView.visibleMapRect)) {
        [self.mapView addOverlay:circle];
    }
    
    self.alarmAnnotations[alarm.objectID] = annotation;
    self.alarmCircleOverlays[alarm.objectID] = circle;
}

- (void)addAlarms:(NSArray *)alarms
{
    for (VBAlarm *alarm in alarms) {
        [self addAlarm:alarm];
    }
}


#pragma mark - Remove Alarms

- (void)removeAlarm:(VBAlarm *)alarm
{
    [self removeAlarmWithObjectID:alarm.objectID];
}

- (void)removeAlarms:(NSArray *)alarms
{
    for (VBAlarm *alarm in alarms) {
        [self removeAlarm:alarm];
    }
}

- (void)removeAllAlarms
{
    [self.mapView removeAnnotations:[self.alarmAnnotations allValues]];
    [self.mapView removeOverlays:[self.alarmCircleOverlays allValues]];
    [self.alarmAnnotations removeAllObjects];
    [self.alarmCircleOverlays removeAllObjects];
}

- (void)removeAlarmWithObjectID:(NSManagedObjectID *)objectID
{
    if (self.alarmAnnotations[objectID]) {
        [self.mapView removeAnnotation:self.alarmAnnotations[objectID]];
        [self.alarmAnnotations removeObjectForKey:objectID];
    }
    
    if (self.alarmCircleOverlays[objectID]) {
        [self.mapView removeOverlay:self.alarmCircleOverlays[objectID]];
        [self.alarmCircleOverlays removeObjectForKey:objectID];
    }
}


#pragma mark - Update Alarms

- (void)updateAlarm:(VBAlarm *)alarm
{
    if (self.alarmAnnotations[alarm.objectID]) {
        VBMKPointAnnotation *annotation = self.alarmAnnotations[alarm.objectID];
        VBAlarmAnnotationView *marker = (VBAlarmAnnotationView *)[self.mapView viewForAnnotation:annotation];
        annotation.title = alarm.title;
        marker.on = alarm.on;
        marker.progress = [self progressForAlarm:alarm];
    }
    
    if (self.alarmCircleOverlays[alarm.objectID]) {
        MKCircle *circle = self.alarmCircleOverlays[alarm.objectID];
        
        if (fabs(circle.radius - alarm.radius) > 0.5) {
            [self.mapView removeOverlay:circle];
            [self.alarmCircleOverlays removeObjectForKey:alarm.objectID];
            
            circle = [MKCircle circleWithCenterCoordinate:[alarm coordinate] radius:alarm.radius];
            self.alarmCircleOverlays[alarm.objectID] = circle;
            //[self.mapView addOverlay:circle];
            
            if (!MKMapRectContainsRect(circle.boundingMapRect, self.mapView.visibleMapRect)) {
                [self.mapView addOverlay:circle];
            }
        }
    }
}

- (void)updateAlarms:(NSArray *)alarms
{
    for (VBAlarm *alarm in alarms) {
        [self updateAlarm:alarm];
    }
}

- (void)updateAllAlarms
{
    for (VBMKPointAnnotation *annotation in [self.alarmAnnotations allValues]) {
        [self updateAlarm:annotation.userData];
    }
}

- (void)updateAlarmProgresses
{
    for (VBMKPointAnnotation *annotation in [self.alarmAnnotations allValues]) {
        VBAlarmAnnotationView *marker = (VBAlarmAnnotationView *)[self.mapView viewForAnnotation:annotation];
        double progress = [self progressForAlarm:annotation.userData];
        if (fabs(marker.progress - progress) > 0.005) {
            marker.progress = progress;
        }
    }
}


#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    for (id<MKOverlay> overlay in mapView.overlays) {
        if (MKMapRectContainsRect(overlay.boundingMapRect, mapView.visibleMapRect)) {
            [mapView removeOverlay:overlay];
        }
    }
    
    for (id<MKOverlay> overlay in [self.alarmCircleOverlays allValues]) {
        if (![mapView viewForOverlay:overlay]) {
            if (!MKMapRectContainsRect(overlay.boundingMapRect, mapView.visibleMapRect)) {
                [self.mapView addOverlay:overlay];
            }
        }
    }
    
    /*
     NSLog(@"regionDidChangeAnimated");
     
     
     */
    
    /*
    MKCoordinateRegion region = self.mapView.region;
    
    NSLog(@"%f", region.center.latitude);
    NSLog(@"%f", region.center.longitude);
    NSLog(@"%f", region.span.latitudeDelta);
    NSLog(@"%f", region.span.longitudeDelta);
     */
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if (annotation == self.placemarkAnnotation) {
        static NSString *pinID = @"placemarkPinID";
        MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinID];
        if (!pin) {
            pin = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinID] autorelease];
            pin.animatesDrop = self.animatesPlacemarkDropping;
            pin.canShowCallout = YES;
        } else {
            pin.annotation = annotation;
        }

        return pin;
    }
    
    if ([annotation isKindOfClass:[VBMKPointAnnotation class]]) {
        static NSString *annotationViewID = @"alarmAnnotationID";
        VBAlarmAnnotationView *annotationView = (VBAlarmAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewID];
        if (!annotationView) {
            annotationView = [[[VBAlarmAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewID] autorelease];
            annotationView.canShowCallout = YES;
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        VBAlarm *alarm = ((VBMKPointAnnotation *)annotation).userData;
        annotationView.on = alarm.on;
        annotationView.progress = [self progressForAlarm:alarm];
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([self.delegate respondsToSelector:@selector(mapController:didChooseAlarm:)]) {
        VBAlarm *alarm = ((VBMKPointAnnotation *)view.annotation).userData;
        [self.delegate mapController:self didChooseAlarm:alarm];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (view.annotation == self.placemarkAnnotation) {
        [self removePlacemark];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleView *circleView = [[[MKCircleView alloc] initWithCircle:overlay] autorelease];
        circleView.strokeColor = VB_RGB(0, 134, 255);
        circleView.fillColor = [circleView.strokeColor colorWithAlphaComponent:0.18];
        circleView.lineWidth = 2;
        return circleView;
    }
    
    return nil;
}

@end
