//
//  VBCrashesViewController.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/13/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBCrashesViewController.h"
#import "UIBarButtonItem+VBStyle.h"
#import "UILabel+VBStyle.h"

@interface VBCrashesViewController ()

@end

@implementation VBCrashesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    [titleLabel vbSetupNavTitle];
    titleLabel.text = @"Crashes";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav.button.back.png"]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(backAction)] autorelease];
    [self.navigationItem.leftBarButtonItem vbSetupStyle];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ptrn.light.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)action1:(UIButton *)sender
{
    [@[][4] stringValue];
}

- (IBAction)action2:(UIButton *)sender
{
    [@[@4] autorelease];
}

@end
