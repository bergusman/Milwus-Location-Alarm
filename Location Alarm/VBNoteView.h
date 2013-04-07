//
//  VBNoteView.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/4/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface VBNoteView : UIView

@property (nonatomic, retain, readonly) UIImageView *imageView;
@property (nonatomic, retain, readonly) TTTAttributedLabel *textLabel;

@end
