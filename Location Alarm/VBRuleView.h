//
//  VBRule.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/28/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VBRuleView : UIView

@property (nonatomic, copy) NSString *label;

@property (nonatomic, assign, getter=isHighlighted) BOOL highlighted;

@end
