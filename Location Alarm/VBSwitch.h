//
//  VBInOutSwitch.h
//  UITest
//
//  Created by Vitaliy Berg on 2/20/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VBSwitch : UIControl

@property (nonatomic, strong) UIImage *onImage;
@property (nonatomic, strong) UIImage *offImage;

@property (nonatomic, assign) BOOL on;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
