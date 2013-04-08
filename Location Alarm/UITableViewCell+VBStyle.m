//
//  UITableViewCell+VBStyle.m
//  UITest
//
//  Created by Vitaliy Berg on 2/20/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "UITableViewCell+VBStyle.h"


@implementation UITableViewCell (VBStyle)

- (void)vbSetupSearchResultCell
{
    // Selected Background View
    UIView *sbv = [[UIView alloc] init];
    sbv.backgroundColor = VB_RGB(54, 66, 83);
    self.selectedBackgroundView = sbv;

    CGSize size = self.frame.size;
    
    // Top Line
    UIView *topLine = [[UIView alloc] init];
    topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    topLine.frame = CGRectMake(0, 0, size.width, 1);
    topLine.backgroundColor = VB_WHITE(252, 1.0);
    [self addSubview:topLine];
    
    // Bottom Line
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    bottomLine.frame = CGRectMake(0, size.height - 1, size.width, 1);
    bottomLine.backgroundColor = VB_RGB(184, 193, 202);
    [self addSubview:bottomLine];
    
    // Text Label
    self.textLabel.font = [UIFont boldSystemFontOfSize:13];
    self.textLabel.textColor = VB_WHITE(60, 1.0);
    self.textLabel.highlightedTextColor = VB_WHITE(255, 1.0);
    self.textLabel.shadowColor = VB_WHITE(255, 1.0);
    self.textLabel.shadowOffset = CGSizeMake(0, 1);
    
    // Detail Label
    self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    self.detailTextLabel.textColor = VB_WHITE(173, 1.0);
    self.detailTextLabel.highlightedTextColor = VB_WHITE(255, 1.0);
}

- (void)vbSetupLeftCell
{
    // Selected Background View
    UIView *sbv = [[UIView alloc] init];
    sbv.backgroundColor = VB_RGB(23, 28, 36);
    self.selectedBackgroundView = sbv;
    
    CGSize size = self.frame.size;
    
    // Top Line
    UIView *topLine = [[UIView alloc] init];
    topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    topLine.frame = CGRectMake(0, 0, size.width, 0.5);
    topLine.backgroundColor = VB_RGB(48, 60, 76);
    [self addSubview:topLine];
    
    // Bottom Line
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    bottomLine.frame = CGRectMake(0, size.height - 1, size.width, 1);
    bottomLine.backgroundColor = VB_RGB(26, 31, 40);
    [self addSubview:bottomLine];
}

- (void)vbSetupAlarmCell
{
    self.textLabel.font = [UIFont boldSystemFontOfSize:16];
    self.textLabel.textColor = VB_RGB(190, 209, 233);
    self.textLabel.highlightedTextColor = VB_WHITE(250, 1.0);
    self.textLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    self.textLabel.shadowOffset = CGSizeMake(0, 1);
}

- (void)vbSetupMiscCell
{
    self.textLabel.font = [UIFont boldSystemFontOfSize:16];
    self.textLabel.textColor = VB_RGB(245, 246, 247);
}

@end
