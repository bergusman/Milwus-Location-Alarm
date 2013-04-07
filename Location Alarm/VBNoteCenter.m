//
//  VBNoteCenter.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/4/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBNoteCenter.h"
#import <objc/runtime.h>
#import "UIView+VBView.h"


NSString *const VBNoteWillShowNotification = @"VBNoteWillShowNotification";
NSString *const VBNoteDidShowNotification = @"VBNoteDidShowNotification";
NSString *const VBNoteWillHideNotification = @"VBNoteWillHideNotification";
NSString *const VBNoteDidHideNotification = @"VBNoteDidHideNotification";
NSString *const VBNoteWillReplaceNotification = @"VBNoteWillReplaceNotification";
NSString *const VBNoteDidReplaceNotification = @"VBNoteDidReplaceNotification";


static const char *noteCenterKey = "VBNoteCenter";


#define NOTE_PANEL_HEIGHT 44
#define NOTE_VIEW_HEIGHT 35
#define SHOW_ANIMATION_DURATION 0.25
#define REPLACE_ANITMATION_DURATION 0.25
#define HIDE_ANIMATION_DURATION 0.25


@interface VBNoteCenter ()

@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) UIView *notePanel;
@property (nonatomic, retain) VBNoteView *currentNoteView;

@end


@implementation VBNoteCenter

@dynamic haveNote;
@dynamic noteView;

- (void)dealloc
{
    objc_setAssociatedObject(_navigationController, noteCenterKey, nil, OBJC_ASSOCIATION_ASSIGN);
    [_navigationController release];
    [_notePanel release];
    [_currentNoteView release];
    [super dealloc];
}

- (id)initWithNavigationController:(UINavigationController *)navigationController
{
    if (!navigationController) return nil;
    if (navigationController.noteCenter) return [navigationController.noteCenter retain];
    
    self = [super init];
    if (self) {
     
        _navigationController = [navigationController retain];
        objc_setAssociatedObject(_navigationController, noteCenterKey, self, OBJC_ASSOCIATION_ASSIGN);
        
        CGRect rect = _navigationController.navigationBar.frame;
        
        _notePanel = [[UIView alloc] init];
        _notePanel.clipsToBounds = YES;
        _notePanel.frame = CGRectMake(0, rect.size.height, rect.size.width, NOTE_PANEL_HEIGHT);
        _notePanel.pointInsideInsets = UIEdgeInsetsMake(8, 0, 0, 0);
        _notePanel.hidden = YES;
        [_navigationController.view addSubview:_notePanel];
        
    }
    return self;
}

- (void)showNoteWithText:(NSString *)text
                   image:(UIImage *)image
                closable:(BOOL)closable
{
    NSAttributedString *attributedText = [[[NSAttributedString alloc] initWithString:text] autorelease];
    [self showNoteWithAttributedText:attributedText
                               image:image
                            closable:closable];
}

- (void)showNoteWithAttributedText:(NSAttributedString *)text
                             image:(UIImage *)image
                          closable:(BOOL)closable
{
    VBNoteView *noteView = [[[VBNoteView alloc] init] autorelease];
    noteView.imageView.image = image;
    noteView.pointInsideInsets = UIEdgeInsetsMake(8, 0, 0, 0);
    [noteView layoutSubviews];
    
    noteView.textLabel.attributedText = text;
    
    
    [noteView.textLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        [text enumerateAttributesInRange:NSMakeRange(0, [text length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            [mutableAttributedString addAttributes:attrs range:range];
        }];
        return mutableAttributedString;
    }];
    
     
    if (closable) {
        UIButton *button = [[[UIButton alloc] init] autorelease];
        [button setImage:[UIImage imageNamed:@"note.close.button.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(320 - 28, 1, 26, 26);
        button.pointInsideInsets = UIEdgeInsetsMake(9, 10, 9, 2);
        [button addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [noteView addSubview:button];
    }
    
    if (self.currentNoteView) {
        [self replaceNote:noteView];
    } else {
        [self showNote:noteView];
    }
}

- (void)showNote:(VBNoteView *)noteView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:VBNoteWillShowNotification object:nil];
    
    self.currentNoteView = noteView;
    self.notePanel.hidden = NO;
    [self.notePanel addSubview:noteView];
    
    CGRect rect = self.notePanel.frame;
    noteView.frame = CGRectMake(0, -NOTE_VIEW_HEIGHT, rect.size.width, NOTE_VIEW_HEIGHT);
    
    [UIView animateWithDuration:SHOW_ANIMATION_DURATION animations:^{
        noteView.frame = CGRectMake(0, 0, rect.size.width, NOTE_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:VBNoteDidShowNotification object:nil];
    }];
}

- (void)replaceNote:(VBNoteView *)noteView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:VBNoteWillReplaceNotification object:nil];
    
    VBNoteView *oldNoteView = self.currentNoteView;
    self.currentNoteView = noteView;
    [self.notePanel addSubview:noteView];
    
    CGRect rect = self.notePanel.frame;
    noteView.frame = CGRectMake(0, -NOTE_VIEW_HEIGHT, rect.size.width, NOTE_VIEW_HEIGHT);
    
    [UIView animateWithDuration:REPLACE_ANITMATION_DURATION animations:^{
        noteView.frame = CGRectMake(0, 0, rect.size.width, NOTE_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:VBNoteDidReplaceNotification object:nil];
    }];
    
    [UIView animateWithDuration:REPLACE_ANITMATION_DURATION * 2 animations:^{
        oldNoteView.alpha = 0;
    } completion:^(BOOL finished) {
        [oldNoteView removeFromSuperview];
    }];
}

- (void)hideNote
{
    if (!self.currentNoteView) return;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VBNoteWillHideNotification object:nil];
    
    VBNoteView *noteView = self.currentNoteView;
    self.currentNoteView = nil;
    
    [UIView animateWithDuration:HIDE_ANIMATION_DURATION animations:^{
        noteView.alpha = 0;
    } completion:^(BOOL finished) {
        [noteView removeFromSuperview];
        if (!self.currentNoteView) self.notePanel.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:VBNoteDidHideNotification object:nil];
    }];
}

- (BOOL)haveNote
{
    return !!self.currentNoteView;
}

- (VBNoteView *)noteView
{
    return self.currentNoteView;
}

- (void)closeAction
{
    [self hideNote];
}

@end


@implementation UINavigationController (VBNoteCenter)

@dynamic noteCenter;

- (VBNoteCenter *)noteCenter
{
    return objc_getAssociatedObject(self, noteCenterKey);
}

@end
