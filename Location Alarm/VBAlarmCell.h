//
//  VBAlarmCell.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/13/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol VBAlarmCellDelegate;


@interface VBAlarmCell : UITableViewCell

@property (nonatomic, weak) id<VBAlarmCellDelegate> delegate;

@property (nonatomic, strong, readonly) UIImageView *progressImageView;

@property (nonatomic, assign) BOOL on;

@end


@protocol VBAlarmCellDelegate <NSObject>

@optional

- (void)alarmCell:(VBAlarmCell *)cell didOn:(BOOL)on;

@end