//
//  VBAlarmDetailsViewController.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/25/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBAlarmDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "VBAlarmEditorViewController.h"
#import "VBSwitch.h"
#import "VBAlarmManager.h"
#import "TTTAttributedLabel.h"
#import "VBMapViewController.h"
#import "VBLocationManager.h"
#import "VBSlider.h"
#import "VBRuleView.h"
#import "VBSegmentFunction.h"
#import "VBConfig.h"
#import "VBSettings.h"
#import "VBAlarmTracker.h"
#import "VBApp.h"


#define ACTION_SHEET_SHOW_DURATION 0.25
#define ACTION_SHEET_HIDE_DURATION 0.25


@interface VBAlarmDetailsViewController ()
<
    VBAlarmEditorViewControllerDelegate
>

@property (nonatomic, retain) VBAlarm *alarm;

@property (retain, nonatomic) IBOutlet UIView *actionSheet;
@property (nonatomic, retain) UIView *actionSheetDim;

@property (retain, nonatomic) IBOutlet UIButton *actionSheetDelete;
@property (retain, nonatomic) IBOutlet UIButton *actionSheetEdit;
@property (retain, nonatomic) IBOutlet UIButton *actionSheetCancel;

@property (retain, nonatomic) IBOutlet UIView *featurePanel;
@property (retain, nonatomic) IBOutlet UIImageView *progressCircle;
@property (retain, nonatomic) IBOutlet UIButton *onOffButton;
@property (retain, nonatomic) IBOutlet TTTAttributedLabel *distanceLabel;
@property (retain, nonatomic) IBOutlet VBSwitch *inOutSwitch;

@property (retain, nonatomic) IBOutlet UIView *miscPanel;

@property (retain, nonatomic) IBOutlet UIImageView *sliderPanel;
@property (retain, nonatomic) IBOutlet VBSlider *radiusSlider;
@property (retain, nonatomic) IBOutlet TTTAttributedLabel *radiusLabel;

@property (retain, nonatomic) IBOutlet UIView *commentsPanel;
@property (retain, nonatomic) IBOutlet UIImageView *commentsBackground;
@property (retain, nonatomic) IBOutlet UITextView *commentsTextView;
@property (retain, nonatomic) IBOutlet UILabel *commentsTitle;


@property (nonatomic, retain) id radiusLabelBoldFont;

@end


@implementation VBAlarmDetailsViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_onBack release];
    [_alarm release];
    [_actionSheet release];
    [_actionSheetDim release];
    [_featurePanel release];
    [_progressCircle release];
    [_onOffButton release];
    [_commentsPanel release];
    [_commentsBackground release];
    [_distanceLabel release];
    [_inOutSwitch release];
    [_commentsTextView release];
    [_radiusSlider release];
    [_radiusLabel release];
    [_sliderPanel release];
    [_miscPanel release];
    [_radiusLabelBoldFont release];
    [_actionSheetDelete release];
    [_actionSheetEdit release];
    [_actionSheetCancel release];
    [_commentsTitle release];
    [super dealloc];
}

- (id)initWithAlarm:(VBAlarm *)alarm
{
    NSString *nibName = @"VBAlarmDetailsViewController";
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        nibName = @"VBAlarmDetailsViewController-568h";
    } 
    
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(alarmsChanged:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:[VBAlarmManager sharedManager].managedObjectContext];
        
        self.alarm = alarm;
        CTFontRef font = CTFontCreateWithName((CFStringRef)[UIFont boldSystemFontOfSize:12].fontName, 12, NULL);
        self.radiusLabelBoldFont = (id)font;
        CFRelease(font);
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSAssert(false, @"Use initWithAlarm: to initing");
    return nil;
}

- (id)init
{
    NSAssert(false, @"Use initWithAlarm: to initing");
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav.button.back.png"]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(backAction)] autorelease];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav.button.action.png"]
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self
                                                                              action:@selector(actionsAction)] autorelease];
    
    self.inOutSwitch.onImage = [UIImage imageNamed:@"switch.in.png"];
    self.inOutSwitch.offImage = [UIImage imageNamed:@"switch.out.png"];
    
    [self.onOffButton setImage:[UIImage imageNamed:@"feature.on.png"] forState:UIControlStateSelected];
    [self.onOffButton setImage:[UIImage imageNamed:@"feature.on.h.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.onOffButton setImage:[UIImage imageNamed:@"feature.off.png"] forState:UIControlStateNormal];
    [self.onOffButton setImage:[UIImage imageNamed:@"feature.off.h.png"] forState:UIControlStateNormal | UIControlStateHighlighted];
    
    self.radiusSlider.continuous = YES;
    [self setupRules];
    
    self.commentsBackground.image = [[UIImage imageNamed:@"comments.bg.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:9];
    self.commentsBackground.layer.shadowColor = [UIColor blackColor].CGColor;
    self.commentsBackground.layer.shadowOpacity = 0.2;
    self.commentsBackground.layer.shadowOffset = CGSizeMake(0, 2);
    self.commentsBackground.layer.shadowRadius = 3;
    self.commentsBackground.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectZero].CGPath;
    
    self.commentsTitle.text = NSLocalizedString(@"CommentsTitle", @"");
    
    [self setupActionSheet];    
    
}

- (void)viewDidUnload
{
    [self setActionSheet:nil];
    [self setProgressCircle:nil];
    [self setOnOffButton:nil];
    [self setFeaturePanel:nil];
    [self setCommentsPanel:nil];
    [self setCommentsBackground:nil];
    [self setDistanceLabel:nil];
    [self setInOutSwitch:nil];
    [self setCommentsTextView:nil];
    [self setRadiusSlider:nil];
    [self setRadiusLabel:nil];
    [self setSliderPanel:nil];
    [self setMiscPanel:nil];
    [self setActionSheetDelete:nil];
    [self setActionSheetEdit:nil];
    [self setActionSheetCancel:nil];
    [self setCommentsTitle:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = self.alarm.title;
    
    self.inOutSwitch.on = (self.alarm.type == VBAlarmTypeIn);
    self.onOffButton.selected = self.alarm.on;
    [self setupProgress];
    [self setupRadius];
    
    if ([self.alarm.notes length] > 0) {
        self.commentsPanel.hidden = NO;
        self.commentsTextView.text = self.alarm.notes;
        self.commentsBackground.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.commentsPanel.bounds
                                                                              cornerRadius:4].CGPath;
    } else {
        self.commentsPanel.hidden = YES;
    }
    
    [self.radiusSlider layoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [VBAnalytics viewAlarmCard];
}

- (void)alarmsChanged:(NSNotification *)notification
{
    for (id updatedAlarm in notification.userInfo[NSUpdatedObjectsKey]) {
        if (updatedAlarm == self.alarm) {
            self.onOffButton.selected = self.alarm.on;
            break;
        }
    }
}

- (UIImage *)progressImageWithProgress:(CGFloat)progress
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(140, 140), NO, [UIScreen mainScreen].scale);
    
    CGFloat angleOffset = 70.9 * M_PI / 180.0;
    CGFloat startAngle = angleOffset;
    CGFloat endAngle = angleOffset + progress * (2.0 * M_PI);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(70, 70)
                                                        radius:140
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:YES];
    
    [path addLineToPoint:CGPointMake(70, 70)];
    
    [path addClip];
    
    [[UIImage imageNamed:@"feature.progress.png"] drawAtPoint:CGPointMake(0, 0)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

- (void)setupRules
{
    NSArray *rules = nil;
    id<VBDistanceFormatter> formatter = nil;
    
    if ([VBSettings sharedSettings].system == VBMeasurementSystemMetric) {
        rules = [VBConfig sharedConfig].metricRadiusRules;
        formatter = [VBApp sharedApp].metricFormatter;
    } else {
        rules = [VBConfig sharedConfig].imperialRadiusRules;
        formatter = [VBApp sharedApp].imperialFormatter;
    }
    
    NSAssert([rules count] == 6, @"Amout of rules must be six");
    
    NSMutableArray *titles = [NSMutableArray array];
    for (NSNumber *rule in rules) {
        [titles addObject:[formatter numberWithUnitForDistance:[rule doubleValue]]];
    }
    
    for (int i = 0; i < 6; i++) {
        VBRuleView *rule = [[[VBRuleView alloc] init] autorelease];
        rule.label = titles[i];
        rule.frame = CGRectMake(0, 0, 60, 60);
        rule.center = CGPointMake(20 + i * 55, 67);
        [self.miscPanel addSubview:rule];
    }
}

- (void)setupProgress
{
    double progress = 1;
    
    if ([VBAlarmTracker sharedTracker].alarmDistances[self.alarm.objectID]) {
        double distance = [[VBAlarmTracker sharedTracker].alarmDistances[self.alarm.objectID] doubleValue];
        
        if (distance <= 0) {
            self.distanceLabel.textColor = VB_RGB(0, 78, 192);
            self.distanceLabel.text = NSLocalizedString(@"InArea", @"");
        } else {
            [self setupAlarmDistance:distance];
            progress = [[VBApp sharedApp].distanceProgressFunction y:distance];
        }
        
    } else {
        self.distanceLabel.textColor = VB_RGB(85, 85, 85);
        self.distanceLabel.text = NSLocalizedString(@"NoData", @"");
        progress = 0;
    }
    
    self.progressCircle.image = [self progressImageWithProgress:progress];
}

- (void)setupAlarmDistance:(double)distance
{
    NSString *number = nil;
    NSString *unit = nil;
    
    if ([VBSettings sharedSettings].system == VBMeasurementSystemMetric) {
        number = [[VBApp sharedApp].metricFormatter numberForDistance:distance];
        unit = [[VBApp sharedApp].metricFormatter unitForDistance:distance];
    } else {
        distance /= 0.9144;
        number = [[VBApp sharedApp].imperialFormatter numberForDistance:distance];
        unit = [[VBApp sharedApp].imperialFormatter unitForDistance:distance];
    }
    
    NSString *text = [NSString stringWithFormat:@"%@ %@", number, unit];
    
    self.distanceLabel.textColor = VB_RGB(85, 85, 85);
    [self.distanceLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                        value:(id)VB_RGB(0, 78, 192).CGColor
                                        range:NSMakeRange(0, [number length])];
        return mutableAttributedString;
    }];
}

- (void)setupRadiusLabelWithRadius:(double)radius
{
    NSString *number = nil;
    NSString *unit = nil;

    if ([VBSettings sharedSettings].system == VBMeasurementSystemMetric) {
        number = [[VBApp sharedApp].metricFormatter numberWithZerosForDistance:radius];
        unit = [[VBApp sharedApp].metricFormatter unitForDistance:radius];
    } else {
        number = [[VBApp sharedApp].imperialFormatter numberWithZerosForDistance:radius];
        unit = [[VBApp sharedApp].imperialFormatter unitForDistance:radius];
    }
    
    NSString *text = [NSString stringWithFormat:@"%@ %@", number, unit];
    
    [self.radiusLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                        value:self.radiusLabelBoldFont
                                        range:NSMakeRange(0, [number length])];
        return mutableAttributedString;
    }];
}

- (void)setupRadius
{
    double radius;
    
    if ([VBSettings sharedSettings].system == VBMeasurementSystemMetric) {
        radius = self.alarm.radius;
    } else {
        radius = self.alarm.radius / 0.9144;
    }
    
    double value = [[VBApp sharedApp].currentRadiusFunction x:radius];
    self.radiusSlider.value = value;
    
    [self setupRadiusLabelWithRadius:radius];
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

- (void)actionsAction
{
    [self showActionSheet];
}

- (IBAction)onOffAction
{
    self.onOffButton.selected = !self.onOffButton.selected;
    self.alarm.on = self.onOffButton.selected;
    [[VBAlarmManager sharedManager] save];
}

- (IBAction)inOutAction:(VBSwitch *)sender
{
    self.alarm.type = (sender.on ? VBAlarmTypeIn : VBAlarmTypeOut);
    [[VBAlarmManager sharedManager] save];
}

- (IBAction)positionAction
{
    VBMapViewController *map = (VBMapViewController *)self.navigationController.viewControllers[0];
    [map showAlarm:self.alarm];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)radiusAction:(VBSlider *)sender forEvent:(UIEvent *)event
{
    double radius = [[VBApp sharedApp].currentRadiusFunction y:sender.value];
    [self setupRadiusLabelWithRadius:radius];
    
    UITouchPhase phase = ((UITouch *)[[event allTouches] anyObject]).phase;
    
    if (phase == UITouchPhaseEnded || phase == UITouchPhaseCancelled) {
        if ([VBSettings sharedSettings].system == VBMeasurementSystemImperial) {
            radius *= 0.9144;
        }
        self.alarm.radius = radius;
        
        [[VBAlarmManager sharedManager] save];
        
        [self setupProgress];
    }
}


#pragma mark - Action Sheet

- (void)setupActionSheet
{
    [self.actionSheetDelete setTitle:NSLocalizedString(@"DeleteAlarm", @"") forState:UIControlStateNormal];
    [self.actionSheetEdit setTitle:NSLocalizedString(@"EditAlarm", @"") forState:UIControlStateNormal];
    [self.actionSheetCancel setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
}


#pragma mark - Show/Hide Action Sheet

- (void)showActionSheet
{
    CGSize size = self.navigationController.view.frame.size;
    
    self.actionSheetDim = [[[UIView alloc] init] autorelease];
    self.actionSheetDim.backgroundColor = [UIColor blackColor];
    self.actionSheetDim.alpha = 0;
    self.actionSheetDim.frame = self.navigationController.view.bounds;
    [self.navigationController.view addSubview:self.actionSheetDim];
    
    self.actionSheet.frame = CGRectMake(0, size.height, 320, 206);
    [self.navigationController.view addSubview:self.actionSheet];
    
    [UIView animateWithDuration:ACTION_SHEET_SHOW_DURATION animations:^{
        self.actionSheetDim.alpha = 0.5;
        self.actionSheet.frame = CGRectMake(0, size.height - 206, 320, 206);
    }];
}

- (void)hideActionSheet
{
    CGSize size = self.navigationController.view.frame.size;
    
    [UIView animateWithDuration:ACTION_SHEET_HIDE_DURATION animations:^{
        self.actionSheetDim.alpha = 0;
        self.actionSheet.frame = CGRectMake(0, size.height, 320, 206);
    } completion:^(BOOL finished) {
        [self.actionSheetDim removeFromSuperview];
        self.actionSheetDim = nil;
        [self.actionSheet removeFromSuperview];
    }];
}


#pragma mark - Action Sheet Actions

- (IBAction)deleteAction
{
    [[VBAlarmManager sharedManager] deleteAlarm:self.alarm];
    [[VBAlarmManager sharedManager] save];
    
    [self hideActionSheet];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editAction
{
    [self hideActionSheet];
    VBAlarmEditorViewController *editor = [[[VBAlarmEditorViewController alloc] initWithAlarm:self.alarm] autorelease];
    editor.delegate = self;
    [self.navigationController pushViewController:editor animated:YES];
}

- (IBAction)cancelAction
{
    [self hideActionSheet];
}


#pragma mark - VBAlarmEditorViewControllerDelegate

- (void)alarmEditorDidCancel:(VBAlarmEditorViewController *)alarmEditor
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alarmEditorDidSave:(VBAlarmEditorViewController *)alarmEditor
{
    [[VBAlarmManager sharedManager] save];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
