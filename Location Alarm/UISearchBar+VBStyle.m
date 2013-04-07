//
//  UISearchBar+VBStyle.m
//  UITest
//
//  Created by Vitaliy Berg on 2/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "UISearchBar+VBStyle.h"


@implementation UISearchBar (VBStyle)

- (void)vbSetupStyle
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"search.bg.png"]];
    [self setBackgroundImage:[UIImage imageNamed:@"search.bg.png"]];
    [self setSearchFieldBackgroundImage:[UIImage imageNamed:@"search.field.png"] forState:UIControlStateNormal];
    
    [self setImage:[UIImage imageNamed:@"search.glass.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"search.clear.png"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"search.clear.h.png"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];
    
    UITextField *textField = [self valueForKey:@"_searchField"];
    textField.textColor = VB_WHITE(180, 1.0);
    
    UILabel *placeholderLabel = [textField valueForKey:@"_placeholderLabel"];
    placeholderLabel.textColor = VB_WHITE(222, 1.0);
}

- (void)vbSetupCancelButton
{
    UIButton *cancelButton = [self valueForKey:@"_cancelButton"];
    
    [cancelButton setBackgroundImage:[[UIImage imageNamed:@"search.cancel.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15]
                            forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[[UIImage imageNamed:@"search.cancel.h.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15]
                            forState:UIControlStateHighlighted];

    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    cancelButton.titleLabel.textColor = [UIColor whiteColor];
    cancelButton.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    cancelButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
}

@end
