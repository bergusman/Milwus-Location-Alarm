//
//  VBSlider.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/27/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VBSlider : UIControl

@property (nonatomic, assign) float value;

@property (nonatomic, getter=isContinuous) BOOL continuous;

@end
