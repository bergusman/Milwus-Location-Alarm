//
//  VBAlarmEditorViewController.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/25/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VBAlarm;
@protocol VBAlarmEditorViewControllerDelegate;


@interface VBAlarmEditorViewController : UIViewController

@property (nonatomic, weak) id<VBAlarmEditorViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL pushWithKeyboard;

- (id)initWithAlarm:(VBAlarm *)alarm;

@end


@protocol VBAlarmEditorViewControllerDelegate <NSObject>

@optional
- (void)alarmEditorDidCancel:(VBAlarmEditorViewController *)alarmEditor;
- (void)alarmEditorDidSave:(VBAlarmEditorViewController *)alarmEditor;

@end