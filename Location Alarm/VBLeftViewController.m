//
//  VBLeftViewController.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/24/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBLeftViewController.h"
//#import "IIViewDeckController.h"
#import "IIViewDeckController2.h"
#import "IISideController.h"
#import "UISearchBar+VBStyle.h"
#import "UITextField+VBCarriageColor.h"
#import "UITableViewCell+VBStyle.h"
#import "VBAlarmDetailsViewController.h"
#import "VBAboutViewController.h"
#import "VBHelpViewController.h"
#import "VBAlarmManager.h"
#import "VBLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "VBApp.h"
#import <QuartzCore/QuartzCore.h>
#import "VBDevToolsViewController.h"
#import "VBSegmentFunction.h"
#import "VBAlarmTracker.h"
#import "VBApp.h"
#import "UIView+VBDimensions.h"
#import "VBMapViewController.h"
#import "VBOnBack.h"
#import "VBAlarmCell.h"
#import "SVGeocoder.h"


@interface VBLeftViewController ()
<
    UISearchDisplayDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    VBAlarmCellDelegate
>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *placemarks;

@property (nonatomic, strong) NSMutableDictionary *alarmIconCache;

@end


@implementation VBLeftViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deckWillOpenLeftSide:)
                                                     name:VBDeckWillOpenLeftSideNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ptrn.dark.png"]];
    [self.searchDisplayController.searchBar vbSetupStyle];
    self.searchDisplayController.searchBar.placeholder = NSLocalizedString(@"SearchAddressPlaceholder", @"");
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIImage *)progressImageWithProgress:(CGFloat)progress
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(35, 35), NO, [UIScreen mainScreen].scale);
    
    if (progress < 0.999999)
    {
        CGFloat angleOffset = 74.0 * M_PI / 180.0;
        CGFloat startAngle = angleOffset;
        CGFloat endAngle = angleOffset + progress * (2.0 * M_PI);
        CGPoint center = CGPointMake(17, 17);
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
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (VBMapViewController *)mapVC
{
    return ((UINavigationController *)self.viewDeckController.centerController).viewControllers[0];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([self.placemarks count] > 0) {
        SVPlacemark *placemark = self.placemarks[0];
        [[self mapVC] showPlacemark:placemark];
        
        [self.view endEditing:YES];
        
        self.searchDisplayController.searchResultsTableView.allowsSelection = NO;
        [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller) {
            self.searchDisplayController.searchResultsTableView.allowsSelection = YES;
            [self.searchDisplayController setActive:NO animated:YES];
        }];
    }
}


#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    //self.viewDeckController.leftSize = 0;
    self.viewDeckController.leftLedge = 0;
    self.sideController.constrainedSize = 320;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    //self.viewDeckController.leftSize = 60;
    self.viewDeckController.leftLedge = 60;
    self.sideController.constrainedSize = 260;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 48;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = VB_WHITE(245, 1.0);
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:[VBLocationManager sharedManager].location.coordinate
                                                                radius:[VBConfig sharedConfig].geocodingRadius
                                                            identifier:nil];
    
    [SVGeocoder geocode:searchString region:region completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
        self.placemarks = placemarks;
        [controller.searchResultsTableView reloadData];
    }];

    return NO;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    if (tableView == self.tableView) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            return [[VBAlarmManager sharedManager].sortedAlarms count];
        } else {
            return [VBConfig sharedConfig].useDevTools ? 3 : 2;
        }
    } else {
        return [self.placemarks count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            VBAlarm *alarm = [VBAlarmManager sharedManager].sortedAlarms[indexPath.row];
            
            static NSString *cellID = @"AlarmCellID";
            VBAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[VBAlarmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                [cell vbSetupLeftCell];
                [cell vbSetupAlarmCell];
                cell.delegate = self;
            }
            
            cell.textLabel.text = alarm.title;
            cell.on = alarm.on;
            
            UIImage *icon = self.alarmIconCache[@(indexPath.row)];
            if (!icon) {
                double progress = 0;
                if ([VBAlarmTracker sharedTracker].alarmDistances[alarm.objectID]) {
                    double distance = [[VBAlarmTracker sharedTracker].alarmDistances[alarm.objectID] doubleValue];
                    progress = [[VBApp sharedApp].distanceProgressFunction y:distance];
                }
                icon = [self progressImageWithProgress:progress];
                self.alarmIconCache[@(indexPath.row)] = icon;
            }
            
            cell.progressImageView.image = icon;
            
            return cell;
        } else {
            static NSString *cellID = @"miscCellID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:cellID];
                [cell vbSetupLeftCell];
                [cell vbSetupMiscCell];
            }
            
            if (indexPath.row == 0) {
                cell.imageView.image = [UIImage imageNamed:@"info.icon.png"];
                cell.textLabel.text = NSLocalizedString(@"AboutCell", @"");
            } else if (indexPath.row == 1) {
                cell.imageView.image = [UIImage imageNamed:@"help.icon.png"];
                cell.textLabel.text = NSLocalizedString(@"HelpCell", @"");
            } else if (indexPath.row == 2) {
                cell.imageView.image = [UIImage imageNamed:@"dev.icon.png"];
                cell.textLabel.text = NSLocalizedString(@"Dev Tools", @"");
            }
            
            return cell;
        }
    } else {
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            [cell vbSetupSearchResultCell];
        }
        
        SVPlacemark *placemark = self.placemarks[indexPath.row];
        
        if ([placemark.name length] > 0) {
            cell.textLabel.text = placemark.name;
            cell.detailTextLabel.text = placemark.formattedAddress;
        } else {
            //cell.textLabel.text = placemark.addressDictionary[@"City"];
            //cell.detailTextLabel.text = placemark.addressDictionary[@"Country"];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            VBAlarm *alarm = [VBAlarmManager sharedManager].sortedAlarms[indexPath.row];
            [[VBAlarmManager sharedManager] deleteAlarm:alarm];
            [[VBAlarmManager sharedManager] save];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (tableView == self.tableView) {
        UIViewController<VBOnBack> *vc = nil;
        
        if (indexPath.section == 0) {
            VBAlarm *alarm = [VBAlarmManager sharedManager].sortedAlarms[indexPath.row];
            vc = [[VBAlarmDetailsViewController alloc] initWithAlarm:alarm];
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                vc = [[VBAboutViewController alloc] init];
            } else if (indexPath.row == 1) {
                vc = [[VBHelpViewController alloc] init];
            } else if (indexPath.row == 2) {
                vc = [[VBDevToolsViewController alloc] initWithStyle:UITableViewStyleGrouped];
            }
        }
        
        __weak UINavigationController *nc = (UINavigationController *)self.viewDeckController.centerController;
        
        vc.onBack = ^{
            [self.viewDeckController openLeftViewAnimated:YES completion:^(IIViewDeckController *controller) {
                [nc popViewControllerAnimated:NO];
            }];
        };
        
        [nc pushViewController:vc animated:NO];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        self.tableView.allowsSelection = NO;
        [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller) {
            self.tableView.allowsSelection = YES;
        }];
    } else {
        SVPlacemark *placemark = self.placemarks[indexPath.row];
        [[self mapVC] showPlacemark:placemark];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.view endEditing:YES];
        
        tableView.allowsSelection = NO;
        [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller) {
            tableView.allowsSelection = YES;
            [self.searchDisplayController setActive:NO animated:YES];
        }];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 1) {
            return 17;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 1) {
            UIView *header = [[UIView alloc] init];
            header.frame = CGRectMake(0, 0, 10, 17);
            header.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dark.table.separator.png"]];
            return header;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}


#pragma mark - VBAlarmCellDelegate

- (void)alarmCell:(VBAlarmCell *)cell didOn:(BOOL)on
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    VBAlarm *alarm = [VBAlarmManager sharedManager].sortedAlarms[indexPath.row];
    alarm.on = on;
    [[VBAlarmManager sharedManager] save];
}


#pragma mark - Deck Notifications

- (void)deckWillOpenLeftSide:(NSNotification *)notification
{
    [VBAnalytics viewLeftSidePanel];
    self.alarmIconCache = [NSMutableDictionary dictionary];
    [self.tableView reloadData];
}


#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    UITextField *textField = [self.searchDisplayController.searchBar valueForKey:@"_searchField"];
    [textField vbChangeCarriageColorTo:VB_RGB(214, 223, 252)];
    [self.searchDisplayController.searchBar vbSetupCancelButton];
}

@end
