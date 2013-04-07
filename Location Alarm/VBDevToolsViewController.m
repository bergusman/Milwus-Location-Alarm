//
//  VBDevToolsViewController.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/13/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBDevToolsViewController.h"
#import "VBDonateManager.h"
#import "Appirater.h"


@interface VBDevToolsViewController ()

@property (nonatomic, copy) NSArray *toolNames;
@property (nonatomic, copy) NSArray *toolControllers;

@end


@implementation VBDevToolsViewController

- (void)dealloc
{
    [_onBack release];
    [_toolNames release];
    [_toolControllers release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        _toolNames = [@[
            @"Info",
            @"User Defaults",
            @"Crashes",
            @"GPS Signal",
            @"Trash",
            @"Rate App Dialog",
            @"Donate Dialog",
            @"Show Tour in Next Launch"
        ] copy];
        
        _toolControllers = [@[
            @"VBDevInfoViewController",
            @"VBUserDefaultsViewController",
            @"VBCrashesViewController",
            @"VBGPSSignalViewController",
            @"VBDevTrashViewController",
            @"RateAppDialog",
            @"DonateDialog",
            @"ShowTour"
        ] copy];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.title = @"Dev Tools";
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav.button.back.png"]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(backAction)] autorelease];
    
    UIView *bv = [[[UIView alloc] init] autorelease];
    bv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ptrn.light.png"]];
    self.tableView.backgroundView = bv;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Actions

- (void)backAction
{
    if (self.onBack) {
        self.onBack();
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.toolNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    
    cell.textLabel.text = self.toolNames[indexPath.row];
    
    NSString *tool = self.toolControllers[indexPath.row];
    if ([tool isEqualToString:@"RateAppDialog"] ||
        [tool isEqualToString:@"DonateDialog"] ||
        [tool isEqualToString:@"ShowTour"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *tool = self.toolControllers[indexPath.row];
    if ([tool isEqualToString:@"RateAppDialog"]) {
        [Appirater showRatingAlert];
    } else if ([tool isEqualToString:@"DonateDialog"]) {
        [[VBDonateManager sharedManager] showDonateDialog];
    } else if ([tool isEqualToString:@"ShowTour"]) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"VBCurrentVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        Class controllerClass = NSClassFromString(self.toolControllers[indexPath.row]);
        id controller = [[[controllerClass alloc] init] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
