//
//  VBGoogleMapViewController.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/17/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBGoogleMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SVPlacemark.h"
#import "VBAlarm.h"
#import "VBAlarmTracker.h"
#import "VBApp.h"
#import "VBMarkerInfoView.h"


@interface VBGoogleMapViewController () <GMSMapViewDelegate>

@property (nonatomic, retain) GMSMapView *mapView;

@property (nonatomic, retain) id<GMSMarker> placemarker;
@property (nonatomic, retain) NSMutableDictionary *markers;

@end


@implementation VBGoogleMapViewController

@synthesize delegate=_delegate;
@synthesize mapType=_mapType;

- (void)dealloc
{
    [_mapView release];
    [_placemarker release];
    [_markers release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _mapType = VBMapTypeStandard;
        _markers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)loadView
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:55.751849 longitude:37.622681 zoom:0];
	
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.settings.rotateGestures = NO;
    
    self.view = self.mapView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapType = self.mapType;
    
    NSLog(@"%@", self.mapView.gestureRecognizers);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews
{
    [self positionMapLogo];
}

- (void)positionMapLogo
{
    for (UIView *view in self.mapView.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"GMSSDKLogo")]) {
            CGPoint point = view.center;
            point.x = 160;
            point.y = self.view.bounds.size.height - 16;
            view.center = point;
        }
    }
}

- (CLLocationCoordinate2D)coordinateForPoint:(CGPoint)point
{
    return [self.mapView.projection coordinateForPoint:point];
}

+ (NSString *)localizedName
{
    return NSLocalizedString(@"Google Maps", @"");
}


#pragma mark - Placemark

- (void)showPlacemark:(SVPlacemark *)placemark animated:(BOOL)animated
{
    [self setRegion:placemark.region animated:animated];
    [self addPlacemark:placemark];
    self.mapView.selectedMarker = self.placemarker;
}

- (void)removePlacemark
{
    if (self.placemarker) {
        [self.placemarker remove];
        self.placemarker = nil;
    }
}

- (void)addPlacemark:(SVPlacemark *)placemark
{
    [self removePlacemark];
    
    GMSMarkerOptions *placemarkOptions = [GMSMarkerOptions options];
    placemarkOptions.position = placemark.coordinate;
    placemarkOptions.title = placemark.name;
    placemarkOptions.snippet = placemark.formattedAddress;
    self.placemarker = [self.mapView addMarkerWithOptions:placemarkOptions];
}


#pragma mark - User Location

- (void)setShowsUserLocation:(BOOL)showsUserLocation
{
    self.mapView.myLocationEnabled = showsUserLocation;
}

- (BOOL)showsUserLocation
{
    return self.mapView.myLocationEnabled;
}

- (CLLocation *)userLocation
{
    return self.mapView.myLocation;
}

- (void)showUserLocationAnimated:(BOOL)animated
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.userLocation.coordinate, 500, 500);
    [self setRegion:region animated:animated];
}


#pragma mark - Map Type

- (void)setMapType:(VBMapType)mapType
{
    if (mapType == VBMapTypeStandard || mapType == VBMapTypeSchema) {
        _mapType = VBMapTypeStandard;
        self.mapView.mapType = kGMSTypeNormal;
    } else if (mapType == VBMapTypeSatellite) {
        _mapType = VBMapTypeSatellite;
        self.mapView.mapType = kGMSTypeSatellite;
    } else if (mapType == VBMapTypeHybrid) {
        _mapType = VBMapTypeHybrid;
        self.mapView.mapType = kGMSTypeHybrid;
    } else if (mapType == VBMapTypeTerrain) {
        _mapType = VBMapTypeTerrain;
        self.mapView.mapType = kGMSTypeTerrain;
    } else {
        _mapType = VBMapTypeStandard;
        self.mapView.mapType = kGMSTypeNormal;
    }
}

- (NSArray *)supportedMapTypes
{
    //return @[@(VBMapTypeStandard), @(VBMapTypeHybrid), @(VBMapTypeSatellite), @(VBMapTypeTerrain)];
    return @[@(VBMapTypeStandard), @(VBMapTypeHybrid), @(VBMapTypeSatellite)];
}

- (UIImage *)circle
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(50, 50), NO, 2.0);
    
    [[[UIColor blueColor] colorWithAlphaComponent:0.05] setFill];
    [[[UIColor blueColor] colorWithAlphaComponent:1] setStroke];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 50, 50)];
    [path fill];
    [path stroke];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return result;
}

- (double)progressForAlarm:(VBAlarm *)alarm
{
    if ([VBAlarmTracker sharedTracker].alarmDistances[alarm.objectID]) {
        double distance = [[VBAlarmTracker sharedTracker].alarmDistances[alarm.objectID] doubleValue];
        return [[VBApp sharedApp].distanceProgressFunction y:distance];
    }
    return 0;
}

// bingo

- (UIImage *)emptySegmentWithProgress:(CGFloat)progress on:(BOOL)on;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(50, 70), NO, [UIScreen mainScreen].scale);
    
    [[UIImage imageNamed:@"alarm.marker.shadow.png"] drawAtPoint:CGPointMake(0, 0)];
    [[UIImage imageNamed:@"alarm.marker.progress.png"] drawAtPoint:CGPointMake(0, 0)];
    
    if (progress < 0.999999)
    {
        CGFloat angleOffset = 74.0 * M_PI / 180.0;
        CGFloat startAngle = angleOffset;
        CGFloat endAngle = angleOffset + progress * (2.0 * M_PI);
        CGPoint center = CGPointMake(18, 17);
        CGFloat radius = 16;
        
        UIBezierPath *path = nil;
        
        if (progress > 0.0001) {
            path = [UIBezierPath bezierPathWithArcCenter:center
                                                  radius:radius
                                              startAngle:startAngle
                                                endAngle:endAngle clockwise:NO];
            [path addLineToPoint:center];
        } else {
            CGRect rect = CGRectMake(center.x - radius, center.y - radius, 2 * radius, 2 * radius);
            path = [UIBezierPath bezierPathWithOvalInRect:rect];
        }
        
        [VB_WHITE(208, 1.0) setFill];
        [path fill];
    }
    
    if (on) {
        [[UIImage imageNamed:@"alarm.marker.on.cover.png"] drawAtPoint:CGPointMake(0, 0)];
    } else {
        [[UIImage imageNamed:@"alarm.marker.off.cover.png"] drawAtPoint:CGPointMake(0, 0)];
    }
    
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}



#pragma mark - Region

- (MKCoordinateRegion)region
{
    CLLocationCoordinate2D center = self.mapView.camera.target;
    CGFloat zoom = self.mapView.camera.zoom;
    
    MKMapRect mapRect;
    mapRect.origin = MKMapPointForCoordinate(center);
    mapRect.size.width = MKMapSizeWorld.width / pow(2, zoom);
    mapRect.size.height = MKMapSizeWorld.height / pow(2, zoom);
    mapRect.origin.x -= mapRect.size.width / 2;
    mapRect.origin.y -= mapRect.size.height / 2;
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    region.center = center;
    
    return region;
}

- (void)setRegion:(MKCoordinateRegion)region
{
    [self setRegion:region animated:NO];
}

- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated
{
    MKCoordinateSpan span = region.span;
    CLLocationCoordinate2D center = region.center;
    CLLocationCoordinate2D east = CLLocationCoordinate2DMake(center.latitude, center.longitude  + span.longitudeDelta / 2);
    //CLLocationCoordinate2D south = CLLocationCoordinate2DMake(center.latitude - span.latitudeDelta / 2, center.longitude);
    CLLocationCoordinate2D west = CLLocationCoordinate2DMake(center.latitude , center.longitude - span.longitudeDelta / 2);
    //CLLocationCoordinate2D north = CLLocationCoordinate2DMake(center.latitude + span.latitudeDelta / 2, center.longitude);
    
    MKMapPoint eastPoint = MKMapPointForCoordinate(east);
    //MKMapPoint southPoint = MKMapPointForCoordinate(south);
    MKMapPoint westPoint = MKMapPointForCoordinate(west);
    //MKMapPoint northPoint = MKMapPointForCoordinate(north);
    
    double width = eastPoint.x - westPoint.x;
    //double height = southPoint.y - northPoint.y;
    
    //double zoom = log2(MKMapSizeWorld.height / height);
    double zoom = log2(MKMapSizeWorld.width / width);
    
    //height = height + 0; // To remove warning
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:region.center zoom:zoom];
    
    if (animated) {
        [self.mapView animateToCameraPosition:camera];
    } else {
        [self.mapView setCamera:camera];
    }
}


#pragma mark - Add Alarms

- (void)addAlarm:(VBAlarm *)alarm
{
    double progress = [self progressForAlarm:alarm];
    
    GMSMarkerOptions *options = [[[GMSMarkerOptions alloc] init] autorelease];
    options.title = alarm.title;
    options.snippet = alarm.notes;
    options.position = [alarm coordinate];
    options.icon = [self emptySegmentWithProgress:progress on:alarm.on];
    options.groundAnchor = CGPointMake(0.36, 0.643);
    options.infoWindowAnchor = CGPointMake(0.36, 0);
    options.userData = @{@"progress": @(progress), @"on": @(alarm.on), @"alarm": alarm};
    id<GMSMarker> marker = [self.mapView addMarkerWithOptions:options];
    self.markers[alarm.objectID] = marker;
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
    [[self.markers allValues] makeObjectsPerformSelector:@selector(remove)];
    [self.markers removeAllObjects];
}

- (void)removeAlarmWithObjectID:(NSManagedObjectID *)objectID
{
    id<GMSMarker> marker = self.markers[objectID];
    [marker remove];
    [self.markers removeObjectForKey:objectID];
}


#pragma mark - Update Alarms

- (void)updateAlarm:(VBAlarm *)alarm
{
    id<GMSMarker> marker = [self.markers objectForKey:alarm.objectID];
    marker.title = alarm.title;
    double progress = [self progressForAlarm:alarm];
    marker.icon = [self emptySegmentWithProgress:progress on:alarm.on];
    //[self.markers removeObjectForKey:alarm.objectID];
    //[self addAlarm:alarm];
}

- (void)updateAlarms:(NSArray *)alarms
{
    for (VBAlarm *alarm in alarms) {
        [self updateAlarm:alarm];
    }
}

- (void)updateAllAlarms
{
    for (id<GMSMarker> marker in [self.markers allValues]) {
        [self removeAlarm:marker.userData[@"alarm"]];
        [self addAlarm:marker.userData[@"alarm"]];
    }
}

- (void)updateAlarmProgresses
{
    for (id<GMSMarker> marker in [self.markers allValues]) {
        double progress = [self progressForAlarm:marker.userData[@"alarm"]];
        if (fabs([marker.userData[@"progress"] doubleValue] - progress) > 0.005) {
            [self removeAlarm:marker.userData[@"alarm"]];
            [self addAlarm:marker.userData[@"alarm"]];
        }
        
    }
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self removePlacemark];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id<GMSMarker>)marker
{
    if (marker != self.placemarker) {
        [self removePlacemark];
    
        self.mapView.selectedMarker = marker;
    }
    
    return YES;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(id<GMSMarker>)marker
{
    //NSLog(@"Tap on info window");
    if (marker != self.placemarker) {
        if ([self.delegate respondsToSelector:@selector(mapController:didChooseAlarm:)]) {
            VBAlarm *alarm = marker.userData[@"alarm"];
            [self.delegate mapController:self didChooseAlarm:alarm];
        }
    }
    
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(id<GMSMarker>)marker
{
    if (marker == self.placemarker) {
        return nil;
    } else {
        VBMarkerInfoView *infoView = [[[VBMarkerInfoView alloc] init] autorelease];
        infoView.text = marker.title;
        [infoView sizeToFit];
        return infoView;
    }
}

@end
