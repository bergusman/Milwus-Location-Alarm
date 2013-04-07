//
//  VBUserDefaultsViewController.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBUserDefaultsViewController.h"
#import "UIBarButtonItem+VBStyle.h"
#import "UILabel+VBStyle.h"

@interface VBUserDefaultsViewController ()

@property (retain, nonatomic) IBOutlet UITextView *textView;

@end

@implementation VBUserDefaultsViewController

- (void)dealloc
{
    [_textView release];
    [super dealloc];
}

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
    titleLabel.text = @"User Defaults";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav.button.back.png"]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(backAction)] autorelease];
    [self.navigationItem.leftBarButtonItem vbSetupStyle];
    
    self.textView.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
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

#pragma mark - Actions

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
