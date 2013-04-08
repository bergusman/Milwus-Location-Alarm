//
//  VBDonateDialogView.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/20/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol VBDonnateDialogViewDelegate;


@interface VBDonateDialogView : UIView

@property (nonatomic, weak) id<VBDonnateDialogViewDelegate> delegate;
@property (nonatomic, copy) NSArray *prices;

- (void)show;

@end


@protocol VBDonnateDialogViewDelegate <NSObject>
@optional
- (void)donateDialog:(VBDonateDialogView *)dialog clickedDonateButtonAtIndex:(NSUInteger)index;
- (void)donateDialogCancelled:(VBDonateDialogView *)dialog;
@end