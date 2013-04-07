//
//  VBAboutViewController.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/25/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBAboutViewController.h"
#import "Appirater.h"
#import <QuartzCore/QuartzCore.h>
#import <StoreKit/StoreKit.h>
#import "VBDonateManager.h"
#import <Twitter/Twitter.h>
#import "GPPShare.h"
#import "VBNoteCenter.h"
#import "UIView+VBView.h"


@interface VBAboutViewController ()
<
    UIWebViewDelegate,
    GPPShareDelegate
>

@property (retain, nonatomic) IBOutlet UIButton *milwusButton;
@property (retain, nonatomic) IBOutlet UILabel *versionLabel;

@property (retain, nonatomic) IBOutlet UIView *ratePanel;
@property (retain, nonatomic) IBOutlet UIButton *rateButton;
@property (retain, nonatomic) IBOutlet UIButton *websiteButton;

@property (retain, nonatomic) IBOutlet UIView *aboutPanel;
@property (retain, nonatomic) IBOutlet UIWebView *aboutWebView;

@property (retain, nonatomic) IBOutlet UILabel *donateLabel1;
@property (retain, nonatomic) IBOutlet UILabel *donateLabel2;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *donateButtons;

@property (retain, nonatomic) IBOutlet UIView *sharePanel;
@property (retain, nonatomic) IBOutlet UIButton *facebookButton;
@property (retain, nonatomic) IBOutlet UIButton *twitterButton;
@property (retain, nonatomic) IBOutlet UIButton *googleButton;

@end


@implementation VBAboutViewController

- (void)dealloc
{
    [_onBack release];
    [_milwusButton release];
    [_versionLabel release];
    [_ratePanel release];
    [_rateButton release];
    [_websiteButton release];
    [_aboutPanel release];
    [_aboutWebView release];
    [_donateLabel1 release];
    [_donateLabel2 release];
    [_donateButtons release];
    [_sharePanel release];
    [_facebookButton release];
    [_twitterButton release];
    [_googleButton release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = @"VBAboutViewController";
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        nibName = @"VBAboutViewController-568h";
    }
    
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationItem.title = NSLocalizedString(@"About", @"");
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav.button.back.png"]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(backAction)] autorelease];
    
    self.milwusButton.pointInsideInsets = UIEdgeInsetsMake(4, 0, 4, 0);
    [self.milwusButton setImage:[UIImage imageNamed:@"milwus.png"] forState:UIControlStateNormal];
    
    self.donateLabel1.text = NSLocalizedString(@"About_DonateTitle1", @"");
    self.donateLabel2.text = NSLocalizedString(@"About_DonateTitle2", @"");
    
    [self setupDonationButtons];
    
    self.sharePanel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ptrn.light.png"]];
    
    self.ratePanel.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(-10, 10, 340, 32)].CGPath;
    self.ratePanel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.ratePanel.layer.shadowRadius = 5;
    self.ratePanel.layer.shadowOpacity = 0.54;
    
    self.aboutPanel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.aboutPanel.layer.shadowRadius = 4;
    self.aboutPanel.layer.shadowOpacity = 0.5;
    
    [self.rateButton setBackgroundImage:[[UIImage imageNamed:@"rate.button.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]
                               forState:UIControlStateNormal];
    
    [self.rateButton setBackgroundImage:[[UIImage imageNamed:@"rate.button.h.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]
                               forState:UIControlStateHighlighted];

    [self.rateButton setImage:[UIImage imageNamed:@"rate.start.png"] forState:UIControlStateNormal];
    [self.rateButton setImage:[UIImage imageNamed:@"rate.start.png"] forState:UIControlStateHighlighted];
    [self.rateButton setTitle:NSLocalizedString(@"About_RateApp", @"") forState:UIControlStateNormal];
    
    [self.websiteButton setTitle:NSLocalizedString(@"About_GoToWebsite", @"") forState:UIControlStateNormal];
    
    self.aboutPanel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ptrn.light.png"]];

    
    [self.facebookButton setImage:[UIImage imageNamed:@"share.button.facebook.png"] forState:UIControlStateNormal];
    [self.twitterButton setImage:[UIImage imageNamed:@"share.button.twitter.png"] forState:UIControlStateNormal];
    [self.googleButton setImage:[UIImage imageNamed:@"share.button.googleplus.png"] forState:UIControlStateNormal];
    
    self.versionLabel.text = [self versionString];
    
    // Hide scrolling shadow for web view
    for (UIView *view in [[[self.aboutWebView subviews] lastObject] subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.hidden = YES;
        }
    }

    self.aboutWebView.backgroundColor = [UIColor clearColor];
    self.aboutWebView.scrollView.scrollEnabled = NO;
    [self setupAboutText];
}

- (void)viewDidUnload
{
    [self setMilwusButton:nil];
    [self setVersionLabel:nil];
    [self setRatePanel:nil];
    [self setRateButton:nil];
    [self setWebsiteButton:nil];
    [self setDonateLabel1:nil];
    [self setDonateLabel2:nil];
    [self setDonateButtons:nil];
    [self setAboutPanel:nil];
    [self setAboutWebView:nil];
    [self setSharePanel:nil];
    [self setFacebookButton:nil];
    [self setTwitterButton:nil];
    [self setGoogleButton:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.aboutPanel.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(-10, 10, 340, self.aboutPanel.frame.size.height - 10)].CGPath;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [VBAnalytics viewAbout];
}

- (NSString *)versionString
{
    return [NSString stringWithFormat:@"%@ (%@)",
            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}

- (void)setupAboutText
{
    NSString *commonStyle = @"body {text-align: justify; margin: 0px; padding: 0px; color: #000; font-family: Helvetica; background-color:transparent;} p { padding-bottom: 0.6em; margin: 0px; }";
    NSString *textClass = [UIScreen mainScreen].bounds.size.height == 568 ? @"iphone5" : @"iphone";
    
    NSURL *aboutTextURL = [[NSBundle mainBundle] URLForResource:@"About.html" withExtension:@""];
    NSString *aboutText = [NSString stringWithContentsOfURL:aboutTextURL encoding:NSUTF8StringEncoding error:nil];
    
    aboutText = [aboutText stringByReplacingOccurrencesOfString:@"COMMON_STYLE" withString:commonStyle];
    aboutText = [aboutText stringByReplacingOccurrencesOfString:@"CLASS" withString:textClass];
    
    [self.aboutWebView loadHTMLString:aboutText baseURL:nil];
}

- (void)setupDonationButtons
{
    NSArray *pigs = @[
                      @"donate.dialog.pig.gray.png",
                      @"donate.dialog.pig.green.png",
                      @"donate.dialog.pig.red.png",
                      @"donate.dialog.pig.blue.png",
                      @"donate.dialog.pig.yellow.png",
                      ];
    
    NSNumberFormatter *currencyFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setCurrencyCode:@"USD"];
    [currencyFormatter setMaximumFractionDigits:0];
    [currencyFormatter setMinimumFractionDigits:0];
    
    NSAssert([[VBDonateManager sharedManager].aboutPrices count] == 6, @"Donation number must be six");
    
    for (UIButton *donateButton in self.donateButtons) {
        NSNumber *price = [VBDonateManager sharedManager].aboutPrices[donateButton.tag];
        
        UIImage *bg = [[UIImage imageNamed:@"donate.button.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        [donateButton setBackgroundImage:bg forState:UIControlStateNormal];
        UIImage *hbg = [[UIImage imageNamed:@"donate.button.h.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        [donateButton setBackgroundImage:hbg forState:UIControlStateHighlighted];
        
        if ([price doubleValue] < 100) {
            NSString *pigName = pigs[donateButton.tag % [pigs count]];
            [donateButton setImage:[UIImage imageNamed:pigName] forState:UIControlStateNormal];
            [donateButton setImage:[UIImage imageNamed:pigName] forState:UIControlStateHighlighted];
        }
        
        NSString *title = [currencyFormatter stringFromNumber:price];
        
        if ([[UIDevice currentDevice].systemVersion integerValue] < 6) {
            [donateButton setTitle:title forState:UIControlStateNormal];
        } else {
            
            UIFont *lightFont = [UIFont fontWithName:@"Helvetica" size:15];
            UIFont *boldFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];
            
            NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
            
            NSMutableAttributedString *attributedTitle = [[[NSMutableAttributedString alloc] initWithString:title] autorelease];
            [attributedTitle addAttribute:NSForegroundColorAttributeName value:VB_RGB(60, 60, 60) range:NSMakeRange(0, [title length])];
            [attributedTitle addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(0, [title length])];
            [attributedTitle addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, [title length])];
            
            NSRange range = [title rangeOfString:@"$"];
            [attributedTitle addAttribute:NSFontAttributeName value:lightFont range:range];
            
            [donateButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
        }
    }
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

- (IBAction)donateAction:(UIButton *)sender
{
    NSString *productID = [VBDonateManager sharedManager].aboutProductIDs[sender.tag];
    [[VBDonateManager sharedManager] donateWithProductID:productID];
    NSNumber *price = [[VBDonateManager sharedManager] priceForProductID:productID];
    [VBAnalytics startDonateWithPrice:[price stringValue]];
}

- (IBAction)rateAction
{
    [VBAnalytics rateApp];
    [Appirater rateApp];
}

- (IBAction)websiteAction
{
    [VBAnalytics goToApplicationWebsite];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[VBConfig sharedConfig].applicationWebsite]];
}

- (IBAction)milwusAction
{
    [VBAnalytics goToMilwusWebsite];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[VBConfig sharedConfig].milwusWebsite]];
}


#pragma mark - Share Actions

- (IBAction)facebookAction
{
    [VBAnalytics startShareOnFacebook];
    [self shareOnFacebook];
}

- (IBAction)twitterAction
{
    [VBAnalytics startShareOnTwitter];
    [self shareOnTwitter];
}

- (IBAction)googleAction
{
    [VBAnalytics startShareOnGooglePlus];
    [self shareOnGooglePlus];
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    } else {
        return YES;
    }
}


#pragma mark - Twitter

- (void)shareOnTwitter
{
    if ([SLComposeViewController class]) {
        [self shareOnTwitterNewWay];
    } else {
        [self shareOnTwitterOldWay];
    }
}

- (void)shareOnTwitterOldWay
{
    if ([TWTweetComposeViewController canSendTweet]) {
        TWTweetComposeViewController *tweetSheet = [[[TWTweetComposeViewController alloc] init] autorelease];
        [tweetSheet setInitialText:NSLocalizedString(@"TwitterSharingText", @"")];
        [tweetSheet addURL:[NSURL URLWithString:[self applicationStringURL]]];
        [tweetSheet setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            if (result == TWTweetComposeViewControllerResultDone) {
                [VBAnalytics completeShareOnTwitter];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    } else {
        [self showTwitterFailureAlert];
    }
}

- (void)shareOnTwitterNewWay
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:NSLocalizedString(@"TwitterSharingText", @"")];
        [tweetSheet addURL:[NSURL URLWithString:[self applicationStringURL]]];
        [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultDone) {
                [VBAnalytics completeShareOnTwitter];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    } else {
        [self showTwitterFailureAlert];
    }
}

- (void)showTwitterFailureAlert
{
    [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TwitterSharingFailureTitle", @"")
                                 message:NSLocalizedString(@"TwitterSharingFailureMessage", @"")
                                delegate:nil
                       cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                       otherButtonTitles:nil] autorelease] show];
}


#pragma mark - Facebook

- (void)shareOnFacebook
{
    if ([SLComposeViewController class]) {
        [self shareOnFacebookNewWay];
    } else {
        [self.navigationController.noteCenter showNoteWithText:NSLocalizedString(@"FacebookUnavailable", @"")
                                                         image:[UIImage imageNamed:@"note.icon.error.png"]
                                                      closable:YES];
    }
}

- (void)shareOnFacebookNewWay
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:NSLocalizedString(@"FacebookSharingText", @"")];
        [facebookSheet addURL:[NSURL URLWithString:[self applicationStringURL]]];
        [facebookSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultDone) {
                [VBAnalytics completeShareOnFacebook];
            }
        }];
        [self presentViewController:facebookSheet animated:YES completion:nil];
    } else {
        [self showFacebookFailureAlert];
    }
}

- (void)showFacebookFailureAlert
{
    [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FacebookSharingFailureTitle", @"")
                                 message:NSLocalizedString(@"FacebookSharingFailureMessage", @"")
                                delegate:nil
                       cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                       otherButtonTitles:nil] autorelease] show];
}


#pragma mark - Google Plus

- (void)shareOnGooglePlus
{
    id<GPPShareBuilder> dialog = [[GPPShare sharedInstance] shareDialog];
    [dialog setURLToShare:[NSURL URLWithString:[self applicationStringURL]]];
    [dialog setPrefillText:NSLocalizedString(@"GooglePlusSharingText", @"")];
    [dialog setContentDeepLinkID:@"about_share"];
    [dialog open];
}

- (void)finishedSharing:(BOOL)shared
{
    if (shared) {
        [VBAnalytics completeShareOnGooglePlus];
    }
}


#pragma mark - Sharing Helpers

- (NSString *)applicationStringURL
{
    return [NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@",
            //[NSLocale preferredLanguages][0],
            [VBConfig sharedConfig].applicationID];
}

@end
