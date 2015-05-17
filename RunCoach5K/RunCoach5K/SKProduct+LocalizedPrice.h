//
//  SKProduct+LocalizedPrice.h
//  RunCoach5K
//
//  Created by YQ-011 on 11/28/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end
