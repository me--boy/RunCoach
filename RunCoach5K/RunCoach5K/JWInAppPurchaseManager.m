//
//  JWInAppPurchaseManager.m
//  RunCoach5K
//
//  Created by YQ-011 on 11/28/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWInAppPurchaseManager.h"
#import "SKProduct+LocalizedPrice.h"
#import "KeychainItemWrapper.h"

#define kInAppPurchaseProUpgradeADsSucceed @"com.links.5kfree.ads_Succeed"
#define kInAppPurchaseProUpgradeMapSucceed @"com.links.5kfree.map_Succeed"

@interface JWInAppPurchaseManager ()

@property (nonatomic, strong)KeychainItemWrapper *keychainADs;
@property (nonatomic, strong)KeychainItemWrapper *keychainMap;

@end

@implementation JWInAppPurchaseManager

@synthesize productsRequest;

+(id)shareInAppPurchaseManager{
    static JWInAppPurchaseManager *InAppPurchaseManager;
    if (!InAppPurchaseManager) {
        InAppPurchaseManager = [[JWInAppPurchaseManager alloc] init];
        [InAppPurchaseManager loadStore];
        InAppPurchaseManager.keychainADs = [[KeychainItemWrapper alloc] initWithIdentifier:kInAppPurchaseProUpgradeADsProductId accessGroup:nil];
        InAppPurchaseManager.keychainMap = [[KeychainItemWrapper alloc] initWithIdentifier:kInAppPurchaseProUpgradeMapProductId accessGroup:nil];
    }
    return InAppPurchaseManager;
}

//-(void)restore{
//#ifdef DEBUG
//    [self.keychainADs resetKeychainItem];
//    [self.keychainMap resetKeychainItem];
//#endif
//    
//}

- (void)requestProUpgradeProductData
{
    NSSet *productIdentifiers = [NSSet setWithObjects:kInAppPurchaseProUpgradeADsProductId, kInAppPurchaseProUpgradeMapProductId, nil];
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
    
    // we will release the request object in the delegate callback
}



#pragma -
#pragma Public methods

-(NSString *)priceStringWithId:(NSString *)interface{
    NSString *str = @"";
    for (SKProduct *proU in self.proUpgradeProductArray) {
        if ([proU.productIdentifier isEqualToString:interface]) {
            str = proU.localizedPrice;
            break;
        }
    }
    return str;
}

-(BOOL)haveToBuyWithId:(NSString *)interface{
    
    
    
    if ([interface isEqualToString:kInAppPurchaseProUpgradeADsProductId]) {
        NSString *str = [self.keychainADs objectForKey:(__bridge_transfer id)(kSecAttrService)];
        return [str isEqualToString:kInAppPurchaseProUpgradeADsSucceed];
    }
    if ([interface isEqualToString:kInAppPurchaseProUpgradeMapProductId]) {
        NSString *str = [self.keychainMap objectForKey:(__bridge_transfer id)(kSecAttrService)];
        return [str isEqualToString:kInAppPurchaseProUpgradeMapSucceed];
    }
    
    return NO;
}

//
// call this method once on startup
//
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestProUpgradeProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

-(BOOL)canMakePurchasesWithId:(NSString *)interface{
    BOOL can = YES;
    for (SKPaymentTransaction *tran in [[SKPaymentQueue defaultQueue] transactions]) {
        if ([tran.payment.productIdentifier isEqualToString:interface]) {
            can = NO;
            break;
        }
    }
    return can;
}

//
// kick off the upgrade transaction
//


-(void)purchaseProUpgradeWithIndex:(NSInteger)index{
    SKPayment *payment = [SKPayment paymentWithProduct:[self.proUpgradeProductArray objectAtIndex:index]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void)purchaseProUpgradeWithId:(NSString *)interface{
    SKProduct *product = nil;
    for (SKProduct *proU in self.proUpgradeProductArray) {
        if ([proU.productIdentifier isEqualToString:interface]) {
            product = proU;
            break;
        }
    }
    if (product) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
//    [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:transaction.transactionIdentifier];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:kInAppPurchaseProUpgradeADsProductId]) {
        [self.keychainADs setObject:kInAppPurchaseProUpgradeADsSucceed forKey:(__bridge_transfer id)(kSecAttrService)];
    }
    if ([productId isEqualToString:kInAppPurchaseProUpgradeMapProductId]) {
        [self.keychainMap setObject:kInAppPurchaseProUpgradeMapSucceed forKey:(__bridge_transfer id)(kSecAttrService)];
    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
//    [self finishTransaction:transaction wasSuccessful:YES];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"%@",transaction.error);
    [self finishTransaction:transaction wasSuccessful:NO];
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Faild" message:@"Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
//                NSLog(@"begin");
                break;
            case SKPaymentTransactionStatePurchased:{
                [self completeTransaction:transaction];
                
                SKProduct *product = nil;
                for (SKProduct *proU in self.proUpgradeProductArray) {
                    if ([proU.productIdentifier isEqualToString:transaction.payment.productIdentifier]) {
                        product = proU;
                        break;
                    }
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:[NSString stringWithFormat:@"You have already %@.",product.localizedTitle] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"%@",error);
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Faild" message:@"Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Restored" message:@"Your previously in app purchases have been restored." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads{
    NSLog(@"downloads");
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    self.proUpgradeProductArray = products;
    
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

@end
