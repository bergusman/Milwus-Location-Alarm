//
//  VBSoundsManager.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/23/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBSoundsManager.h"

@interface VBSoundsManager ()

@property (nonatomic, retain) NSDictionary *soundNames;
@property (nonatomic, retain) NSDictionary *soundShorts;
@property (nonatomic, retain) NSDictionary *soundLongs;

@property (nonatomic, copy) NSString *defaultSound;

@end

@implementation VBSoundsManager

- (id)initWithNames:(NSString *)namesFile
             shorts:(NSString *)shortsFile
              longs:(NSString *)longsFile
       defaultSound:(NSString *)defaultSound
{
    self = [super init];
    if (self) {
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        self.soundNames = [NSDictionary dictionaryWithContentsOfURL:[mainBundle URLForResource:namesFile withExtension:@""]];
        self.soundShorts = [NSDictionary dictionaryWithContentsOfURL:[mainBundle URLForResource:shortsFile withExtension:@""]];
        self.soundLongs = [NSDictionary dictionaryWithContentsOfURL:[mainBundle URLForResource:longsFile withExtension:@""]];
        
        if (!self.soundNames[defaultSound]) {
            self.defaultSound = ([self.soundNames count] > 0 ? [self.soundNames allKeys][0] : nil);
        } else {
            self.defaultSound = defaultSound;
        }
        
    }
    return self;
}

- (NSString *)soundName:(NSString *)soundID
{
    return self.soundNames[soundID];
}

- (NSString *)soundShort:(NSString *)soundID
{
    return self.soundShorts[soundID];
}

- (NSString *)soundLong:(NSString *)soundID
{
    return self.soundLongs[soundID];
}

- (NSArray *)sortedSounds
{
    NSMutableArray *sounds = [NSMutableArray arrayWithArray:[self.soundNames allKeys]];
    [sounds sortUsingComparator:^NSComparisonResult(NSString *id1, NSString *id2) {
        return [self.soundNames[id1] compare:self.soundNames[id2]];
    }];
    return sounds;
}

@end
