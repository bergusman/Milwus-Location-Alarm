//
//  VBSoundsManager.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/23/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VBSoundsManager : NSObject

@property (nonatomic, strong, readonly) NSDictionary *soundNames;
@property (nonatomic, strong, readonly) NSDictionary *soundShorts;
@property (nonatomic, strong, readonly) NSDictionary *soundLongs;

- (id)initWithNames:(NSString *)namesFile
             shorts:(NSString *)shortsFile
              longs:(NSString *)longsFile
       defaultSound:(NSString *)defaultSound;

- (NSString *)defaultSound;

- (NSString *)soundName:(NSString *)soundID;
- (NSString *)soundShort:(NSString *)soundID;
- (NSString *)soundLong:(NSString *)soundID;

- (NSArray *)sortedSounds;

@end
