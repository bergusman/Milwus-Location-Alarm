//
//  VBDonateManager.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/14/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const VBDonateDidSuccessNotification;
extern NSString *const VBDonateDidFailureNotification;
extern NSString *const VBDonateDidCancelNotification;

extern NSString *const VBDonateProductIDKey;

@interface VBDonateManager : NSObject

@property (nonatomic, assign) NSUInteger activeTransactionCount;

@property (nonatomic, copy) NSArray *dialogPrices;
@property (nonatomic, copy) NSArray *dialogProductIDs;

@property (nonatomic, copy) NSArray *aboutPrices;
@property (nonatomic, copy) NSArray *aboutProductIDs;

- (NSNumber *)priceForProductID:(NSString *)productID;
- (NSString *)productIDForPrice:(NSNumber *)price;

+ (VBDonateManager *)sharedManager;

- (void)donateWithProductID:(NSString *)productID;
- (void)showDonateDialog;

- (void)tryShowDonateDialog;

- (void)retainAlarmTrigeredCount;

@end
