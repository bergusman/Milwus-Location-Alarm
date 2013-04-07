//
//  VBAlarmEditorViewController.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/25/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBAlarmEditorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIBarButtonItem+VBStyle.h"
#import "VBSoundsViewController.h"
#import "UITextField+VBCarriageColor.h"
#import "UITextView+VBCarriageColor.h"
#import "VBSwitch.h"
#import "TTTAttributedLabel.h"
#import "UIView+VBFirstResponder.h"
#import "UIView+VBStyle.h"
#import "UIView+VBDimensions.h"
#import "VBSlider.h"
#import "VBRuleView.h"
#import "VBApp.h"
#import "VBNoteCenter.h"
#import "SVGeocoder.h"
#import "VBAlarm.h"


#define NEED_TITLE_NOTE_VIEW_TAG 71713


@interface VBAlarmEditorViewController ()
<
    UITextFieldDelegate,
    UITextViewDelegate,
    UIGestureRecognizerDelegate
>

@property (nonatomic, retain) VBAlarm *alarm;

@property (nonatomic, retain) NSString *address;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet TTTAttributedLabel *addressLabel;

@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain, nonatomic) IBOutlet UIView *namePanel;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;

@property (retain, nonatomic) IBOutlet UILabel *alarmTypeLabel;
@property (retain, nonatomic) IBOutlet VBSwitch *inOutSwitch;

@property (retain, nonatomic) IBOutlet UIButton *soundsButton;
@property (nonatomic, retain) UIImageView *soundsButtonArrow;
@property (retain, nonatomic) IBOutlet UILabel *soundName;

@property (retain, nonatomic) IBOutlet VBSlider *radiusSlider;
@property (retain, nonatomic) IBOutlet TTTAttributedLabel *radiusLabel;

@property (retain, nonatomic) IBOutlet UIView *commentsPanel;
@property (retain, nonatomic) IBOutlet UITextView *commentsTextView;
@property (retain, nonatomic) IBOutlet UILabel *commentsPlacehodler;

@property (nonatomic, retain) id radiusLabelBoldFont;

@property (retain, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) BOOL notUseNoteHiddingAnimation;

@property (nonatomic, assign) BOOL appeared;

@property (nonatomic, copy) NSString *sound;

@property (nonatomic, retain) UIBarButtonItem *cancelBarButton;
@property (nonatomic, retain) UIBarButtonItem *saveBarButton;
@property (nonatomic, retain) UIBarButtonItem *doneBarButton;
@property (nonatomic, retain) UIBarButtonItem *emptyBarButton;

@end


@implementation VBAlarmEditorViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_soundsButton removeObserver:self forKeyPath:@"highlighted"];
    
    [_alarm release];
    [_address release];
    [_scrollView release];
    [_addressLabel release];
    [_contentView release];
    [_namePanel release];
    [_nameTextField release];
    [_alarmTypeLabel release];
    [_inOutSwitch release];
    [_soundsButton release];
    [_soundsButtonArrow release];
    [_soundName release];
    [_radiusSlider release];
    [_radiusLabel release];
    [_commentsPanel release];
    [_commentsTextView release];
    [_commentsPlacehodler release];
    [_radiusLabelBoldFont release];
    [_tapGesture release];
    [_sound release];
    [_cancelBarButton release];
    [_saveBarButton release];
    [_doneBarButton release];
    [_emptyBarButton release];
    
    [super dealloc];
}

- (id)initWithAlarm:(VBAlarm *)alarm;
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        self.alarm = alarm;
        
        [SVGeocoder reverseGeocode:alarm.coordinate completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
            if ([placemarks count] > 0) {
                SVPlacemark *placemark = placemarks[0];
                self.address = placemark.formattedAddress;
                [self setupAddressWithAnimation:YES];
            }
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(noteWillShow)
                                                     name:VBNoteWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(noteWillHide)
                                                     name:VBNoteWillHideNotification
                                                   object:nil];
        
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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ptrn.light.png"]];
    
    UIImageView *titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav.title.png"]] autorelease];
    titleView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = titleView;

    self.cancelBarButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"")
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(cancelAction)] autorelease];
    
    self.saveBarButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"")
                                                           style:UIBarButtonItemStyleBordered
                                                          target:self
                                                          action:@selector(saveAction)] autorelease];
    
    self.doneBarButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"")
                                                           style:UIBarButtonItemStyleBordered
                                                          target:self
                                                          action:@selector(doneAction)] autorelease];
    
    [self.cancelBarButton vbSetupStyle];
    [self.saveBarButton vbSetupStyle];
    [self.doneBarButton vbSetupStyle];
    
    self.emptyBarButton = [[[UIBarButtonItem alloc] initWithCustomView:[[[UIView alloc] init] autorelease]] autorelease];
    
    self.navigationItem.leftBarButtonItem = self.cancelBarButton;
    self.navigationItem.rightBarButtonItem = self.saveBarButton;
    
    self.contentView.frame = CGRectMake(0, 5, 320, 400);
    
    self.addressLabel.lineHeightMultiple = 0.9;
    
    [self.namePanel vbSetupEditorShadow];
    self.namePanel.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.namePanel.bounds].CGPath;
    self.nameTextField.placeholder = NSLocalizedString(@"NamePlaceholder", @"");
    
    self.alarmTypeLabel.text = NSLocalizedString(@"SelectAlarmType", @"");
    self.inOutSwitch.onImage = [UIImage imageNamed:@"switch.in.png"];
    self.inOutSwitch.offImage = [UIImage imageNamed:@"switch.out.png"];
    
    self.commentsPlacehodler.text = NSLocalizedString(@"CommentsPlaceholder", @"");
    
    [self setupAddressWithAnimation:NO];

    [self setupRules];
    self.radiusSlider.continuous = YES;
    
    self.tapGesture.enabled = NO;
    
    [self setupSoundsButton];
    
    [self.commentsPanel vbSetupEditorShadow];
    self.commentsPanel.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.commentsPanel.bounds].CGPath;
    
    [self loadAlarm];
    
    if (self.pushWithKeyboard) {
        [self.nameTextField becomeFirstResponder];
    }
}

- (void)viewDidUnload
{
    [_soundsButton removeObserver:self forKeyPath:@"highlighted"];
    
    [self setScrollView:nil];
    [self setAddressLabel:nil];
    [self setContentView:nil];
    [self setNamePanel:nil];
    [self setNameTextField:nil];
    [self setInOutSwitch:nil];
    [self setSoundsButton:nil];
    [self setCommentsPanel:nil];
    [self setCommentsTextView:nil];
    [self setCommentsPlacehodler:nil];
    [self setRadiusSlider:nil];
    [self setRadiusLabel:nil];
    [self setTapGesture:nil];
    [self setSoundName:nil];
    
    [self setAlarmTypeLabel:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - View Appearing/Dissappearing

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.noteCenter.haveNote) {
        self.scrollView.vbY = 28;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [VBAnalytics viewAlarmEditor];
    self.notUseNoteHiddingAnimation = NO;
    self.appeared = YES;
    [self setupAddressWithAnimation:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.notUseNoteHiddingAnimation = YES;
    [self hideNeedTitleNote];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.scrollView.vbY = 0;
}


#pragma mark - Select Sound Button

- (void)setupSoundsButton
{
    [self.soundsButton vbSetupEditorShadow];
    self.soundsButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.soundsButton.bounds].CGPath;
    [self.soundsButton setBackgroundImage:[UIImage imageNamed:@"white.bg.png"] forState:UIControlStateNormal];
    [self.soundsButton addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
    [self.soundsButton setTitle:NSLocalizedString(@"SelectSound", @"") forState:UIControlStateNormal];
    
    self.soundsButtonArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.dark.png"]
                                                highlightedImage:[UIImage imageNamed:@"arrow.white.png"]] autorelease];
    self.soundsButtonArrow.center = CGPointMake(298, 20);
    [self.soundsButton addSubview:self.soundsButtonArrow];
    
    self.soundName.frame = CGRectMake(180, 10, 106, 20);
    [self.soundsButton addSubview:self.soundName];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.soundsButton) {
        self.soundsButtonArrow.highlighted = self.soundsButton.highlighted;
        self.soundName.highlighted = self.soundsButton.highlighted;
    }
}

- (void)setupAddressWithAnimation:(BOOL)animation
{
    if (![self isViewLoaded] || [self.address length] == 0 || !self.appeared || [self.addressLabel.text length] > 0) return;
    
    NSString *text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Address", @""), self.address];
    
    [self.addressLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                        value:(id)VB_WHITE(126, 1.0).CGColor
                                        range:NSMakeRange(0, [NSLocalizedString(@"Address", @"") length])];
        return mutableAttributedString;
    }];
    
    
    CGSize size = [self.addressLabel sizeThatFits:CGSizeMake(300, 60)];
    
    size.height += 18;
    size.height = (size.height > 60) ? 60 : size.height;
    
    self.addressLabel.frame = CGRectMake(10, 0, 300, size.height);
    
    
    self.addressLabel.alpha = 0;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.addressLabel.alpha = 1;
        self.contentView.frame = CGRectMake(0, size.height, 320, 400);
    }];
    
    //NSLog(@"%@", NSStringFromCGSize(size));
    //NSLog(@"%@", NSStringFromCGRect(self.addressLabel.frame));
    //self.addressLabel.frame = CGRectMake(10, 0, 300, size.height + 1);
}

- (void)setupCommentsHeight
{
    CGSize size = [self.commentsTextView sizeThatFits:CGSizeMake(310, 120)];
    size.height += 8;
    self.commentsPanel.vbHeight = size.height > 80 ? 80 : size.height;
    self.commentsPanel.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.commentsPanel.bounds].CGPath;
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
        rule.center = CGPointMake(20 + i * 55, self.radiusSlider.frame.origin.y + 54);
        [self.contentView addSubview:rule];
    }
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


#pragma mark - Load/Save Alarm

- (void)loadAlarm
{
    self.nameTextField.text = self.alarm.title;
    self.commentsTextView.text = self.alarm.notes;
    [self setupCommentsHeight];
    self.commentsPlacehodler.hidden = ([self.commentsTextView.text length] > 0);
    self.inOutSwitch.on = (self.alarm.type == VBAlarmTypeIn);
    [self setupRadius];
    
    self.sound = self.alarm.sound;
    self.soundName.text = [[VBApp sharedApp].soundsManager soundName:self.alarm.sound];
}

- (void)saveAlarm
{
    self.alarm.title = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.alarm.notes = self.commentsTextView.text;
    self.alarm.radius = [[VBApp sharedApp].currentRadiusFunction y:self.radiusSlider.value];
    self.alarm.type = self.inOutSwitch.on ? VBAlarmTypeIn : VBAlarmTypeOut;
    self.alarm.sound = self.sound;
    
    double distance = [[VBApp sharedApp].currentRadiusFunction y:self.radiusSlider.value];
    if ([VBSettings sharedSettings].system == VBMeasurementSystemImperial) {
        distance *= 0.9144;
    }
    self.alarm.radius = distance;
}


#pragma mark - Note Center Notifications

- (void)noteWillShow
{
    CGPoint contentOffset = self.scrollView.contentOffset;
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.vbY = 28;
    }];
    self.scrollView.contentOffset = contentOffset;
}

- (void)noteWillHide
{
    if (!self.notUseNoteHiddingAnimation) {
        CGPoint contentOffset = self.scrollView.contentOffset;
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.vbY = 0;
        }];
        self.scrollView.contentOffset = contentOffset;
    }
}


#pragma mark - Show/Hide Title Note

- (void)showNeedTitleNote
{
    if (self.navigationController.noteCenter.noteView.tag != NEED_TITLE_NOTE_VIEW_TAG) {
        [self.navigationController.noteCenter showNoteWithText:NSLocalizedString(@"Note_NeedTitle", @"")
                                                         image:[UIImage imageNamed:@"note.icon.error.png"]
                                                      closable:YES];
        self.navigationController.noteCenter.noteView.tag = NEED_TITLE_NOTE_VIEW_TAG;
    }
}

- (void)hideNeedTitleNote
{
    if (self.navigationController.noteCenter.noteView.tag == NEED_TITLE_NOTE_VIEW_TAG) {
        [self.navigationController.noteCenter hideNote];
    }
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    } else {
        return YES;
    }
}


#pragma mark - Actions

- (void)cancelAction
{
    if ([self.delegate respondsToSelector:@selector(alarmEditorDidCancel:)]) {
        [self.delegate alarmEditorDidCancel:self];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)saveAction
{
    NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([name length] > 0) {
        [self saveAlarm];
        if ([self.delegate respondsToSelector:@selector(alarmEditorDidSave:)]) {
            [self.delegate alarmEditorDidSave:self];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self showNeedTitleNote];
    }
}

- (void)doneAction
{
    [self.commentsTextView resignFirstResponder];
}

- (IBAction)soundsAction
{
    VBSoundsViewController *sounds = [[[VBSoundsViewController alloc] init] autorelease];
    sounds.sound = self.sound;
    sounds.onBack = ^(VBSoundsViewController *controller){
        self.sound = controller.sound;
        self.soundName.text = [[VBApp sharedApp].soundsManager soundName:self.sound];
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:sounds animated:YES];
}

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

- (IBAction)radiusAction:(VBSlider *)sender forEvent:(UIEvent *)event
{
    double radius = [[VBApp sharedApp].currentRadiusFunction y:sender.value];
    [self setupRadiusLabelWithRadius:radius];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    [textField vbChangeCarriageColorTo:VB_RGB(214, 223, 252)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, self.contentView.vbY + self.commentsPanel.vbY - 5);
        self.commentsPanel.vbHeight = 136;
    } completion:^(BOOL finished) {
        self.commentsPanel.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.commentsPanel.bounds].CGPath;
    }];
    
    [self.navigationItem setLeftBarButtonItem:self.emptyBarButton animated:YES];
    [self.navigationItem setRightBarButtonItem:self.doneBarButton animated:YES];
    
    [self performSelector:@selector(changeCommentsCarriageColor) withObject:nil afterDelay:0];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.navigationItem setLeftBarButtonItem:self.cancelBarButton animated:YES];
    [self.navigationItem setRightBarButtonItem:self.saveBarButton animated:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.commentsPlacehodler.hidden = ([textView.text length] > 0);
}


#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.tapGesture.enabled = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardFrameEnd = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.tapGesture.enabled = NO;
    
    if (keyboardFrameEnd.origin.y == self.view.frame.size.height) {
        [UIView animateWithDuration:duration animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
            [self setupCommentsHeight];
        } completion:^(BOOL finished) {
        }];
    }
}


#pragma mark - Other

- (void)changeCommentsCarriageColor
{
    [self.commentsTextView vbChangeCarriageColorTo:VB_RGB(214, 223, 252)];
}

@end
