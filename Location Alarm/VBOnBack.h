//
//  VBOnBack.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/13/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VBOnBack <NSObject>

@property (nonatomic, copy) void (^onBack)();

@end
