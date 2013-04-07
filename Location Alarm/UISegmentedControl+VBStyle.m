//
//  UISegmentedControl+VBStyle.m
//  UITest
//
//  Created by Vitaliy Berg on 2/19/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "UISegmentedControl+VBStyle.h"


@implementation UISegmentedControl (VBStyle)

- (void)vbSetupStyle
{
    [self setBackgroundImage:[UIImage imageNamed:@"segmented.bg.png"]
                                            forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    [self setBackgroundImage:[UIImage imageNamed:@"segmented.bg.s.png"]
                                            forState:UIControlStateHighlighted
                                          barMetrics:UIBarMetricsDefault];
    
    [self setBackgroundImage:[UIImage imageNamed:@"segmented.bg.s.png"]
                                            forState:UIControlStateSelected
                                          barMetrics:UIBarMetricsDefault];
    
    UIControlState states[3] = {
        UIControlStateNormal,
        UIControlStateHighlighted,
        UIControlStateSelected
    };
    
    for (NSInteger i = 0; i < 3; i++) {
        for (NSInteger j = 0; j < 3; j++) {
            [self setDividerImage:[UIImage imageNamed:@"segmented.devider.s.png"]
              forLeftSegmentState:states[i]
                rightSegmentState:states[j]
                       barMetrics:UIBarMetricsDefault];
        }
    }
    
    [self setDividerImage:[UIImage imageNamed:@"segmented.devider.png"]
      forLeftSegmentState:UIControlStateNormal
        rightSegmentState:UIControlStateNormal
               barMetrics:UIBarMetricsDefault];
    
    id attr1 = @{
        UITextAttributeTextColor: [UIColor colorWithWhite:0.388 alpha:1.0],
        UITextAttributeTextShadowColor: [UIColor colorWithWhite:1.0 alpha:0.5],
        UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeMake(0, 1)]
    };
    
    id attr2 = @{
        UITextAttributeTextColor: [UIColor colorWithWhite:1.0 alpha:1.0],
        UITextAttributeTextShadowColor: [UIColor colorWithWhite:0.0 alpha:0.25],
        UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeMake(0, -1)]
    };
    
    [self setTitleTextAttributes:attr1 forState:UIControlStateNormal];
    [self setTitleTextAttributes:attr2 forState:UIControlStateHighlighted];
    [self setTitleTextAttributes:attr2 forState:UIControlStateSelected];
}

@end
