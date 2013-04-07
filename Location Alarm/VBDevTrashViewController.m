//
//  VBDevTrashViewController.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/20/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBDevTrashViewController.h"
#import "UIBarButtonItem+VBStyle.h"
#import "UILabel+VBStyle.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "VBDonateDialogView.h"

@interface VBDevTrashViewController ()

@property (retain, nonatomic) IBOutlet UIButton *button1;
@property (retain, nonatomic) IBOutlet UIButton *button2;

@end

@implementation VBDevTrashViewController

- (void)dealloc
{
    [_button1 release];
    [_button2 release];
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
    titleLabel.text = @"Trash";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav.button.back.png"]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(backAction)] autorelease];
    [self.navigationItem.leftBarButtonItem vbSetupStyle];
    
    UIImage *image = [[UIImage imageNamed:@"donate.dialog.button.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    UIImage *image2 = [[UIImage imageNamed:@"donate.dialog.button.h.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [self.button1 setBackgroundImage:image forState:UIControlStateNormal];
    [self.button1 setBackgroundImage:image2 forState:UIControlStateHighlighted];
    self.button1.titleLabel.textAlignment = UITextAlignmentCenter;
    self.button1.titleLabel.backgroundColor = [UIColor greenColor];
    
    UIImage *image3 = [UIImage imageNamed:@"donate.dialog.pig.gray.png"];
    [self.button1 setImage:image3 forState:UIControlStateNormal];
    self.button1.imageView.backgroundColor = [UIColor yellowColor];
    
    [self.button2 setBackgroundImage:image forState:UIControlStateNormal];
    [self.button2 setBackgroundImage:image2 forState:UIControlStateHighlighted];
    [self.button2 setImage:image3 forState:UIControlStateNormal];
    
}

- (void)viewDidUnload
{
    [self setButton1:nil];
    [self setButton2:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    NSLog(@"!!!!!! alertViewCancel");
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"!!!!!!! clickedButtonAtIndex: %d", buttonIndex);
}



- (IBAction)action3:(id)sender {
    
    //NSLog(@"%@", self.button1.titleLabel.attributedText);
    
    //self.button1.titleLabel.attributedText;
    
    
    
    VBDonateDialogView *donateDialog = [[[VBDonateDialogView alloc] init] autorelease];
    donateDialog.prices = @[@(1), @(2), @(5), @(10), @(20), @(50), @(100), @(200), @(500)];
    [donateDialog show];
}


- (IBAction)action1:(id)sender {
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Bingo" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
    [alertView show];
    
    NSLog(@"%@", alertView.layer.animationKeys);
    NSLog(@"%@", [alertView.layer animationForKey:@"transform"]);
    NSLog(@"%@", [alertView.layer animationForKey:@"opacity"]);
    
    CABasicAnimation *anim1 = (CABasicAnimation *)[alertView.layer animationForKey:@"opacity"];
    NSLog(@"%@", anim1.fromValue);
    NSLog(@"%@", anim1.toValue);
    NSLog(@"%@", anim1.byValue);
    NSLog(@"%@", anim1.delegate);
    NSLog(@"%@", anim1.timingFunction);
    NSLog(@"%@", anim1.keyPath);
    NSLog(@"%@", anim1.valueFunction);
    NSLog(@"%d", anim1.cumulative);
    NSLog(@"%d", anim1.additive);
    
    anim1 = (CABasicAnimation *)[alertView.layer animationForKey:@"transform"];
    NSLog(@"%@", anim1.fromValue);
    NSLog(@"%@", anim1.toValue);
    NSLog(@"%@", anim1.byValue);
    NSLog(@"%@", anim1.delegate);
    NSLog(@"%@", anim1.timingFunction);
    NSLog(@"%@", anim1.keyPath);
    NSLog(@"%@", anim1.valueFunction);
    NSLog(@"%d", anim1.cumulative);
    NSLog(@"%d", anim1.additive);
    
    [self performSelector:@selector(bingo:) withObject:alertView afterDelay:0.65];
}

- (void)bingo:(UIAlertView *)alertView
{
    CABasicAnimation *anim1 = (CABasicAnimation *)[alertView.layer animationForKey:@"opacity"];
    NSLog(@"%@", anim1.fromValue);
    NSLog(@"%@", anim1.toValue);
    NSLog(@"%@", anim1.byValue);
    NSLog(@"%@", anim1.delegate);
    NSLog(@"%@", anim1.timingFunction);
    NSLog(@"%@", anim1.keyPath);
    NSLog(@"%@", anim1.valueFunction);
    NSLog(@"%d", anim1.cumulative);
    NSLog(@"%d", anim1.additive);
    
    anim1 = (CABasicAnimation *)[alertView.layer animationForKey:@"transform"];
    NSLog(@"%@", anim1.fromValue);
    NSLog(@"%@", anim1.toValue);
    NSLog(@"%@", anim1.byValue);
    NSLog(@"%@", anim1.delegate);
    NSLog(@"%@", anim1.timingFunction);
    NSLog(@"%@", anim1.keyPath);
    NSLog(@"%@", anim1.valueFunction);
    NSLog(@"%d", anim1.cumulative);
    NSLog(@"%d", anim1.additive);
    NSLog(@"%f", anim1.beginTime);
    NSLog(@"%f", anim1.duration);
    NSLog(@"%f", anim1.speed);
    NSLog(@"%f", anim1.repeatCount);
    NSLog(@"%f", anim1.repeatDuration);

    NSLog(@"%@", alertView);
    NSLog(@"%@", NSStringFromCGPoint(alertView.center));
}


- (IBAction)action2:(id)sender {
    
    CALayer *l = [self.view.layer valueForKey:@"Lol"];
    if (l) {
        [l removeFromSuperlayer];
    }
    
    CAGradientLayer *gragient1 = [[[CAGradientLayer alloc] init] autorelease];
    gragient1.colors = @[(id)VB_RGB(178, 183, 194).CGColor, (id)VB_RGB(226, 227, 228).CGColor];
    gragient1.locations = @[@0.81, @1];
    gragient1.bounds = CGRectMake(0, 0, 284, 164);
    gragient1.position = CGPointMake(160, 200);
    gragient1.cornerRadius = 4;
    gragient1.startPoint = CGPointMake(0, 1);
    gragient1.endPoint = CGPointMake(0, 0);
    gragient1.opacity = 0.9;
    gragient1.opaque = NO;
    
    CAGradientLayer *gragient2 = [[[CAGradientLayer alloc] init] autorelease];
    gragient2.colors = @[(id)VB_RGB(228, 228, 228).CGColor, (id)VB_RGB(200, 200, 200).CGColor];
    gragient2.locations = @[@0.0, @1];
    gragient2.bounds = CGRectMake(0, 0, 280, 160);
    gragient2.position = CGPointMake(142, 82);
    gragient2.cornerRadius = 4;
    gragient2.startPoint = CGPointMake(0, 0);
    gragient2.endPoint = CGPointMake(0, 1);
    
    CATextLayer *text = [[[CATextLayer alloc] init] autorelease];
    text.position = CGPointMake(142, 82);
    text.bounds = CGRectMake(0, 0, 100, 30);
    
    NSMutableAttributedString *mas = [[[NSMutableAttributedString alloc] initWithString:@"Bingo Bongo"] autorelease];
    [mas addAttribute:(id)kCTForegroundColorAttributeName  value:(id)[UIColor redColor].CGColor range:NSMakeRange(0, 4)];
    
    text.string = mas;
    text.contentsScale = 2;
    
    [gragient2 addSublayer:text];
    
    //gragient2.opacity = 0.9;
    //gragient2.opaque = NO;
    
    [gragient1 addSublayer:gragient2];
    
    
    [self.view.layer addSublayer:gragient1];
    //[gragient1 retain];
    
    //self.view.layer
    [self.view.layer setValue:gragient1 forKey:@"Lol"];
    
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = @0;
    alpha.toValue = @1;
    alpha.duration = 0.4;
    [gragient1 addAnimation:alpha forKey:@"Bingo"];
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    bounceAnimation.fillMode = kCAFillModeBoth;
    bounceAnimation.removedOnCompletion = YES;
    bounceAnimation.duration = 0.4;
    bounceAnimation.values = @[
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 0.01f)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.1f)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 0.9f)],
                               [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    bounceAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    bounceAnimation.timingFunctions = @[
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    


    [gragient1 addAnimation:bounceAnimation forKey:@"bounce"];
    
    /*
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [window makeKeyAndVisible];
     */
}

#pragma mark - Actions

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
