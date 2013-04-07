//
//  VBGPSSignalViewController.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/13/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBGPSSignalViewController.h"
#import "VBLocationManager.h"

@interface VBGPSSignalViewController ()

@property (retain, nonatomic) IBOutlet UITextView *textView;

@end

@implementation VBGPSSignalViewController

- (void)dealloc
{
    [_textView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateLocation:)
                                                     name:VBLocationManagerDidUpdateLocationNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"GPS Signal";
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav.button.back.png"]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(backAction)] autorelease];
    
    self.textView.text = [NSString stringWithFormat:@"%@", [VBLocationManager sharedManager].location];
}


- (void)viewDidUnload
{
    [self setTextView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateLocation:(NSNotification *)notification
{
    self.textView.text = [NSString stringWithFormat:@"%@", [VBLocationManager sharedManager].location];
}

#pragma mark - Actions

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
