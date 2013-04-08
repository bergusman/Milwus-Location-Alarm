//
//  VBDonateManager.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/14/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBDonateManager.h"
#import <StoreKit/StoreKit.h>
#import "VBDonateDialogView.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>


NSString *const VBDonateDidSuccessNotification = @"VBDonateDidSuccessNotification";
NSString *const VBDonateDidFailureNotification = @"VBDonateDidFailureNotification";
NSString *const VBDonateDidCancelNotification = @"VBDonateDidCancelNotification";

NSString *const VBDonateProductIDKey = @"VBDonateProductIDKey";



@interface VBDonateManager ()
<
    SKPaymentTransactionObserver,
    VBDonnateDialogViewDelegate
>

@property (nonatomic, strong) VBDonateDialogView *donateDialog;

@property (nonatomic, assign) NSUInteger alarmFireCount;

@property (nonatomic, assign) BOOL donated;

@end


@implementation VBDonateManager

- (id)init
{
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        self.activeTransactionCount = [[SKPaymentQueue defaultQueue].transactions count];
    }
    return self;
}

- (NSNumber *)priceForProductID:(NSString *)productID
{
    if ([self.dialogProductIDs containsObject:productID]) {
        NSUInteger index = [self.dialogProductIDs indexOfObject:productID];
        if (index < [self.dialogPrices count]) {
            return self.dialogPrices[index];
        } else {
            return nil;
        }
    } else if ([self.aboutProductIDs containsObject:productID]) {
        NSUInteger index = [self.aboutProductIDs indexOfObject:productID];
        if (index < [self.aboutPrices count]) {
            return self.aboutPrices[index];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (NSString *)productIDForPrice:(NSNumber *)price
{
    if ([self.dialogPrices containsObject:price]) {
        NSUInteger index = [self.dialogPrices indexOfObject:price];
        if (index < [self.dialogProductIDs count]) {
            return self.dialogProductIDs[index];
        } else {
            return nil;
        }
    } else if ([self.aboutPrices containsObject:price]) {
        NSUInteger index = [self.aboutPrices indexOfObject:price];
        if (index < [self.aboutProductIDs count]) {
            return self.aboutProductIDs[index];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (void)showDonateDialog
{
    if (self.donateDialog) return;
    
    VBDonateDialogView *dialog = [[VBDonateDialogView alloc] init];
    dialog.delegate = self;
    dialog.prices = self.dialogPrices;
    [dialog show];
    
    self.donateDialog = dialog;
    
    [VBAnalytics showDonationDialog];
}

- (void)donateWithProductID:(NSString *)productID
{
    if (!productID) return;
    
    SKMutablePayment *payment = [[SKMutablePayment alloc] init];
    payment.productIdentifier = productID;
    payment.quantity = 1;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


#pragma mark - Donated

- (BOOL)donated
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"VBDonated"];
}

- (void)setDonated:(BOOL)donated
{
    [[NSUserDefaults standardUserDefaults] setBool:donated forKey:@"VBDonated"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Fires Count

- (NSUInteger)alarmFireCount
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"VBFireCount"];
}

- (void)setAlarmFireCount:(NSUInteger)count
{
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"VBFireCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - VBDonnateDialogViewDelegate

- (void)donateDialog:(VBDonateDialogView *)dialog clickedDonateButtonAtIndex:(NSUInteger)index
{
    NSString *productID = self.dialogProductIDs[index];
    [self donateWithProductID:productID];
    self.alarmFireCount = 0;
    self.donateDialog = nil;
}

- (void)donateDialogCancelled:(VBDonateDialogView *)dialog
{
    self.alarmFireCount = 0;
    self.donateDialog = 0;
}


#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        NSLog(@"%@", transaction);
        NSLog(@"%@", transaction.error);
        NSLog(@"%d", transaction.transactionState);
        
        if (transaction.transactionState == SKPaymentTransactionStatePurchasing) {
            self.activeTransactionCount++;
        } else if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [queue finishTransaction:transaction];
            self.activeTransactionCount--;
            [self postSuccessNotificationWithTransaction:transaction];
            self.alarmFireCount = 0;
            self.donated = YES;
        } else if (transaction.transactionState == SKPaymentTransactionStateFailed) {
            [queue finishTransaction:transaction];
            self.activeTransactionCount--;
            if (transaction.error.code != SKErrorPaymentCancelled) {
                [self postCancelNotificationWithTransaction:transaction];
            }
            [self postFailureNotificationWithTransaction:transaction];
        }
    }
}


#pragma mark - Notifications

- (void)postSuccessNotificationWithTransaction:(SKPaymentTransaction *)transaction
{
    NSDictionary *userInfo = @{VBDonateProductIDKey: transaction.payment.productIdentifier};
    [[NSNotificationCenter defaultCenter] postNotificationName:VBDonateDidSuccessNotification object:nil userInfo:userInfo];
}

- (void)postFailureNotificationWithTransaction:(SKPaymentTransaction *)transaction
{
    NSDictionary *userInfo = @{VBDonateProductIDKey: transaction.payment.productIdentifier};
    [[NSNotificationCenter defaultCenter] postNotificationName:VBDonateDidFailureNotification object:nil userInfo:userInfo];
}

- (void)postCancelNotificationWithTransaction:(SKPaymentTransaction *)transaction
{
    NSDictionary *userInfo = @{VBDonateProductIDKey: transaction.payment.productIdentifier};
    [[NSNotificationCenter defaultCenter] postNotificationName:VBDonateDidCancelNotification object:nil userInfo:userInfo];
}


#pragma mark - Donate Dialog

- (void)retainAlarmTrigeredCount
{
    self.alarmFireCount++;
    [self tryShowDonateDialog];
}

- (void)tryShowDonateDialog
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                   ^{
                       [self tryShowDonateDialog2];
                   });
}

- (void)tryShowDonateDialog2
{
    if (self.alarmFireCount > 12 && [self connectedToNetwork] && !self.donated)
	{
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self showDonateDialog];
                       });
	}
}

- (BOOL)connectedToNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
	NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com/"];
	NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
	NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
	
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}


#pragma mark - Singleton

static VBDonateManager *_sharedManager;

+ (VBDonateManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [VBDonateManager new];
    });
    return _sharedManager;
}

@end
