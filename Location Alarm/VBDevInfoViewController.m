//
//  VBDevTrashViewController.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/14/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBDevInfoViewController.h"

@interface VBDevInfoViewController ()

@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation VBDevInfoViewController


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
    
    self.navigationItem.title = @"Info";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav.button.back.png"]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(backAction)];
    
    NSMutableString *text = [NSMutableString string];
    [text appendString:@"Locale\n------\n"];
    [text appendFormat:@"Identifier: %@\n", [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleIdentifier]];
    [text appendFormat:@"Language Code: %@\n", [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleLanguageCode]];
    [text appendFormat:@"Contry Code: %@\n", [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleCountryCode]];
    [text appendFormat:@"Measurement System: %@\n", [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleMeasurementSystem]];
    [text appendFormat:@"Uses Metric System: %@\n", [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleUsesMetricSystem]];
    [text appendFormat:@"First Preferred Language: %@\n", [NSLocale preferredLanguages][0]];
    
    
    [text appendFormat:@"\n\nBundle Info Dictionary\n----------------------\n"];
    [text appendFormat:@"%@", [NSBundle mainBundle].infoDictionary];
    //[text appendFormat:@"%@", [NSLocale currentLocale]];
    
    self.textView.text = text;
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
