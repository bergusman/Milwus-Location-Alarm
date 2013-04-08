//
//  VBNoteCenter.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/4/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBNoteView.h"


extern NSString *const VBNoteWillShowNotification;
extern NSString *const VBNoteDidShowNotification;
extern NSString *const VBNoteWillHideNotification;
extern NSString *const VBNoteDidHideNotification;
extern NSString *const VBNoteWillReplaceNotification;
extern NSString *const VBNoteDidReplaceNotification;


@interface VBNoteCenter : NSObject

@property (nonatomic, assign, readonly) BOOL haveNote;
@property (nonatomic, strong, readonly) VBNoteView *noteView;
@property (nonatomic, strong, readonly) UINavigationController *navigationController;

- (id)initWithNavigationController:(UINavigationController *)navigationController;

- (void)showNoteWithText:(NSString *)text
                   image:(UIImage *)image
                closable:(BOOL)closable;

- (void)showNoteWithAttributedText:(NSAttributedString *)text
                             image:(UIImage *)image
                          closable:(BOOL)closable;

- (void)hideNote;

@end


@interface UINavigationController (VBNoteCenter)

@property (nonatomic, assign, readonly) VBNoteCenter *noteCenter;

@end
