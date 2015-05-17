//
//  JWInAppPurchaseManager.h
//  RunCoach5K
//
//  Created by YQ-011 on 11/28/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>



@interface JWInAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}

@property (nonatomic, strong) NSArray *proUpgradeProductArray;
@property (nonatomic, strong) SKProductsRequest *productsRequest;

+(id)shareInAppPurchaseManager;

// public methods
- (void)loadStore;
- (BOOL)canMakePurchases;
- (BOOL)canMakePurchasesWithId:(NSString *)interface;
- (void)purchaseProUpgradeWithIndex:(NSInteger)index;
- (void)purchaseProUpgradeWithId:(NSString *)interface;
- (BOOL)haveToBuyWithId:(NSString *)interface;
- (NSString *)priceStringWithId:(NSString *)interface;


//-(void)restore;

@end
