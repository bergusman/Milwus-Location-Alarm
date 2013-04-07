//
//  VBSoundsViewController.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/25/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBSoundsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VBNoteCenter.h"
#import "VBApp.h"


@interface VBSoundsViewController ()

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *sounds;
@property (nonatomic, assign) NSUInteger soundIndex;

@property (nonatomic, retain) AVAudioPlayer *player;

@end


@implementation VBSoundsViewController

- (void)dealloc
{
    [_onBack release];
    [_tableView release];
    [_sounds release];
    [_player stop];
    [_player release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.sounds = [[VBApp sharedApp].soundsManager sortedSounds];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(noteWillShow)
                                                     name:VBNoteWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(noteWillHide)
                                                     name:VBNoteWillHideNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"SoundTitle", @"");
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav.button.back.png"]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(backAction)] autorelease];
    
    UIView *bv = [[[UIView alloc] init] autorelease];
    bv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ptrn.light.png"]];
    self.tableView.backgroundView = bv;
    
    self.soundIndex = [self.sounds indexOfObject:self.sound];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.soundIndex inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [VBAnalytics viewSounds];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopSound];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)resignActive:(NSNotification *)notification
{
    [self stopSound];
}


#pragma mark - Player

- (void)playSound:(NSString *)soundID
{
    [self stopSound];
    NSString *toneName = [[VBApp sharedApp].soundsManager soundShort:self.sound];
    NSURL *toneURL = [[NSBundle mainBundle] URLForResource:toneName withExtension:nil];
    NSAssert(toneURL, @"Miss %@ sound", toneName);
    self.player = [[[AVAudioPlayer alloc] initWithContentsOfURL:toneURL error:nil] autorelease];
    [self.player play];
}

- (void)stopSound
{
    [self.player stop];
    self.player = nil;
}


#pragma mark - Note Center

- (void)noteWillShow
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(28, 0, 0, 0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(28, 0, 0, 0);
    }];
}

- (void)noteWillHide
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}


#pragma mark - Actions

- (void)backAction
{
    if (self.onBack) {
        self.onBack(self);
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sounds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    
    cell.textLabel.text = [[VBApp sharedApp].soundsManager soundName:self.sounds[indexPath.row]];
    cell.accessoryType = (self.soundIndex == indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:self.soundIndex inSection:0];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:currentIndexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.soundIndex = indexPath.row;
    self.sound = self.sounds[indexPath.row];
    
    [self playSound:self.sound];
}

@end
