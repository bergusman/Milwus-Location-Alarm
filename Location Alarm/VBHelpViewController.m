//
//  VBHelpViewController.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/25/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBHelpViewController.h"
#import <QuartzCore/QuartzCore.h>


#define USE_LOGO 0
#define GRAY_TEXT_ON_SCROLL 1


@interface VBHelpViewController ()
<UIScrollViewDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSArray *images;

@property (retain, nonatomic) IBOutlet UIView *textPanel;
@property (retain, nonatomic) IBOutlet UIImageView *textPanelBackground;
@property (retain, nonatomic) IBOutlet UILabel *textLabel;

@property (retain, nonatomic) IBOutlet UIView *closePanel;
@property (retain, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic, retain) NSArray *points;

@property (nonatomic, retain) NSArray *imageNames;
@property (nonatomic, retain) NSArray *textKeys;

@property (nonatomic, assign) NSUInteger index;

@end


@implementation VBHelpViewController

- (void)dealloc
{
    [_onBack release];
    [_scrollView release];
    [_images release];
    [_textPanel release];
    [_textPanelBackground release];
    [_textLabel release];
    [_closePanel release];
    [_closeButton release];
    [_points release];
    [_imageNames release];
    [_textKeys release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.imageNames = @[
            @"help.image2.png",
            @"help.image3.png",
            @"help.image4.png",
            @"help.image5.png",
            @"help.image6.png",
            @"help.image7.png",
            @"help.image8.png"
        ];
        
        self.textKeys = @[
            @"Help_Add_Marker",
            @"Help_Configure_Marker",
            @"Help_View_Marker",
            @"Help_Delete_Edit_Marker",
            @"Help_System_Config",
            @"Help_List_of_Markers",
            @"Help_Search"
        ];
        
        self.index = 0;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if USE_LOGO
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav.title.png"]] autorelease];
#else
    self.navigationItem.title = NSLocalizedString(@"HelpTitle", @"");
#endif
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav.button.back.png"]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(backAction)] autorelease];
    
    [self.closeButton setTitle:NSLocalizedString(@"CloseHelp", @"") forState:UIControlStateNormal];
    
    UIImage *bg = [[UIImage imageNamed:@"help.button.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [self.closeButton setBackgroundImage:bg forState:UIControlStateNormal];
    
    UIImage *bg2 = [[UIImage imageNamed:@"help.text.panel.bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:15];
    self.textPanelBackground.image = bg2;
    
    self.closePanel.hidden = !self.showsCloseButton;
    
    self.textPanel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.textPanel.layer.shadowOpacity = 0.2;
    self.textPanel.layer.shadowRadius = 2;
    self.textPanel.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(-20, 0, 360, 20)].CGPath;
    
    [self addPoints];
    [self selectPointAtIndex:self.index];
    
    [self addImages];
    [self showImageAtIndex:self.index];
    
    [self showTextAtIndex:self.index];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setTextPanel:nil];
    [self setTextLabel:nil];
    [self setTextPanelBackground:nil];
    [self setCloseButton:nil];
    [self setClosePanel:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [VBAnalytics viewHelp];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    BOOL iphone5 = [UIScreen mainScreen].bounds.size.height == 568;
    CGSize size = self.view.bounds.size;
    
    CGRect rect = self.textPanel.frame;
    rect.size.height = iphone5 ? 130 : 115;
    rect.origin.y = (self.showsCloseButton ? size.height - self.closePanel.bounds.size.height : size.height) - rect.size.height;
    self.textPanel.frame = rect;
    
    rect = self.scrollView.frame;
    rect.size.height = MIN(340, self.textPanel.frame.origin.y - 20);
    rect.origin.y = self.textPanel.frame.origin.y - rect.size.height;
    self.scrollView.frame = rect;
    
    [self setupScrollView];
    [self showImageAtIndex:self.index];
    [self layoutPoints];
}


#pragma mark - Text

- (void)showTextAtIndex:(NSUInteger)index
{
    if (index < [self.textKeys count]) {
        self.textLabel.text = NSLocalizedString(self.textKeys[index], @"");
    }
}


#pragma mark - Scroll View

- (void)addImages
{
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[self.imageNames count]];
    for (NSString *imageName in self.imageNames) {
        UIImageView *imageView = [self createImageWithImageName:imageName];
        [self.scrollView addSubview:imageView];
        [images addObject:imageView];
    }
    self.images = images;
}

- (UIImageView *)createImageWithImageName:(NSString *)imageName
{
    UIImageView *imageView = [[[UIImageView alloc] init] autorelease];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}

- (void)setupScrollView
{
    CGSize size = self.scrollView.bounds.size;
    CGFloat x = 0;
    for (UIImageView *imageView in self.images) {
        imageView.frame = CGRectMake(x, 0, size.width, size.height);
        x += size.width;
    }
    self.scrollView.contentSize = CGSizeMake(size.width * [self.images count], size.height);
}

- (void)showImageAtIndex:(NSUInteger)index
{
    self.scrollView.contentOffset = CGPointMake(index * self.scrollView.bounds.size.width, 0);
}


#pragma mark - Points

- (void)addPoints
{
    [self removePoints];
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:[self.textKeys count]];
    for (int i = 0; i < [self.textKeys count]; i++) {
        UIImageView *pointView = [self createPoint];
        [self.textPanel addSubview:pointView];
        [points addObject:pointView];
    }
    self.points = points;
}

- (void)removePoints
{
    [self.points makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.points = nil;
}

- (UIImageView *)createPoint
{
    UIImageView *pointView = [[[UIImageView alloc] init] autorelease];
    pointView.image = [UIImage imageNamed:@"help.point.gray.png"];
    pointView.highlightedImage = [UIImage imageNamed:@"help.point.blue.png"];
    pointView.frame = CGRectMake(0, 0, 10, 10);
    return pointView;
}

- (void)layoutPoints
{
    NSUInteger pointCount = [self.points count];
    CGFloat y = 16;
    CGFloat w = 16;
    CGFloat x = (self.textPanel.bounds.size.width - w * (pointCount - 1)) / 2;
    for (UIView *pointView in self.points) {
        pointView.center = CGPointMake(x, y);
        x += w;
    }
}

- (void)selectPointAtIndex:(NSUInteger)index
{
    for (UIImageView *point in self.points) {
        point.highlighted = NO;
    }
    if (index < [self.points count]) {
        UIImageView *point = self.points[index];
        point.highlighted = YES;
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self selectPointAtIndex:self.index];
    [self showTextAtIndex:self.index];
#if GRAY_TEXT_ON_SCROLL
    [UIView animateWithDuration:0.1 animations:^{
        self.textLabel.alpha = 1;
    }];
#endif
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
#if GRAY_TEXT_ON_SCROLL
    [UIView animateWithDuration:0.1 animations:^{
        self.textLabel.alpha = 0.3;
    }];
#endif
}


#pragma mark - Actions

- (void)backAction
{
    if (self.onBack) {
        self.onBack();
    }
}

- (IBAction)closeAction
{
    if (self.onBack) {
        self.onBack();
    }
}

@end
