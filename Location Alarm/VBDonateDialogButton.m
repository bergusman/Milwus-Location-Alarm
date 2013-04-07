//
//  VBDonateDialogButton.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/20/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBDonateDialogButton.h"

@implementation VBDonateDialogButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //self.titleLabel.backgroundColor = [UIColor greenColor];
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UIImage *bg = [[UIImage imageNamed:@"donate.dialog.button.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        UIImage *hbg = [[UIImage imageNamed:@"donate.dialog.button.h.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        
        [self setBackgroundImage:bg forState:UIControlStateNormal];
        [self setBackgroundImage:hbg forState:UIControlStateHighlighted];
        [self setTitleColor:VB_RGB(60, 60, 60) forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        self.titleLabel.shadowOffset = CGSizeMake(0, 1);
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect2 = self.imageView.frame;
    
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    
    CGRect rect = self.titleLabel.frame;
    rect.origin.x = self.imageView.image ? rect2.origin.x + rect2.size.width : 6;
    rect.size.width = self.bounds.size.width - (rect.origin.x + 6);
    self.titleLabel.frame = rect;
}

- (NSNumberFormatter *)currencyFormatter
{
    static NSNumberFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setCurrencyCode:@"USD"];
        [formatter setMaximumFractionDigits:0];
        [formatter setMinimumFractionDigits:0];
    }
    return formatter;
}

- (void)setPrice:(double)price
{
    _price = price;
    
    NSString *title = [[self currencyFormatter] stringFromNumber:@(price)];
    
    if ([[UIDevice currentDevice].systemVersion integerValue] < 6) {
        [self setTitle:title forState:UIControlStateNormal];
    } else {
        
        UIFont *lightFont = [UIFont fontWithName:@"Helvetica-Light" size:15];
        UIFont *boldFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        
        NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
        
        NSMutableAttributedString *attributedTitle = [[[NSMutableAttributedString alloc] initWithString:title] autorelease];
        [attributedTitle addAttribute:NSForegroundColorAttributeName value:VB_RGB(60, 60, 60) range:NSMakeRange(0, [title length])];
        [attributedTitle addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(0, [title length])];
        [attributedTitle addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, [title length])];
        
        NSRange range = [title rangeOfString:@"$"];
        [attributedTitle addAttribute:NSFontAttributeName value:lightFont range:range];
        
        [self setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    }
}

@end
