//
//  VBAlarmCell.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/13/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBAlarmCell.h"
#import "UIView+VBView.h"

@implementation VBAlarmCell
{
    UIButton *_onButton;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.imageView.image = [UIImage imageNamed:@"alarm.cell.icon.progress.bg.png"];
        
        _progressImageView = [[UIImageView alloc] init];
        _progressImageView.frame = CGRectMake(4, 4, 35, 35);
        [self.contentView addSubview:_progressImageView];
        
        _onButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _onButton.frame = CGRectMake(4, 4, 35, 35);
        _onButton.pointInsideInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        [_onButton setImage:[UIImage imageNamed:@"alarm.cell.icon.on.2.png"] forState:UIControlStateNormal];
        [_onButton addTarget:self action:@selector(onOffAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_onButton];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    _onButton.highlighted = NO;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    _onButton.highlighted = NO;
}

- (void)onOffAction
{
    self.on = !self.on;
    if ([self.delegate respondsToSelector:@selector(alarmCell:didOn:)]) {
        [self.delegate alarmCell:self didOn:self.on];
    }
}

- (void)setOn:(BOOL)on
{
    _on = on;
    if (on) {
        [_onButton setImage:[UIImage imageNamed:@"alarm.cell.icon.on.2.png"] forState:UIControlStateNormal];
    } else {
        [_onButton setImage:[UIImage imageNamed:@"alarm.cell.icon.off.2.png"] forState:UIControlStateNormal];
    }
}

@end
