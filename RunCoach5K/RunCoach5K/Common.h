//
//  Common.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/10/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#ifndef RunCoach5K_Common_h
#define RunCoach5K_Common_h

#define ktutorialCount 27

#define kForiPhone5(a,b) (iPhone5 ? a : b)

#define SYSTEM_VERSTION_VALUE [[[UIDevice currentDevice] systemVersion] doubleValue]

//background
#define kbackgroundImage    iPhone5 ? [UIImage imageNamed:@"view_bg_548h"] : [UIImage imageNamed:@"view_bg"]
#define kBackgroundColor    [UIColor colorWithPatternImage:kbackgroundImage]

//text
#define kdefaultTextColor   [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.f]
#define kdefaultYellowColor [UIColor colorWithRed:255/255.0 green:179/255.0 blue:0/255.0 alpha:1.f]

//table view
#define kTableCellBackgroundColor [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1.f]
#define kTableCellSeparatorColor [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.f]

//notifation

#define kACHVCountChange @"kACHVCountChange"
#define kACHVShareCountFive @"kACHVShareCountFive"

//color

#define kRGB255UIColor(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//moth

#define     kNavTitle(name,self) 	{UILabel *navTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];\
                                     navTitle.font = [UIFont systemFontOfSize:18];\
                                     navTitle.adjustsFontSizeToFitWidth = YES;\
                                     if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0){\
                                         navTitle.minimumFontSize = 14.f;\
                                         [navTitle setTextAlignment:UITextAlignmentCenter];\
                                     }\
                                     else{\
                                         navTitle.minimumScaleFactor = .7f;\
                                         [navTitle setTextAlignment:NSTextAlignmentCenter];\
                                     }\
                                     navTitle.backgroundColor = [UIColor clearColor];\
                                     navTitle.text = name;\
                                     navTitle.textColor = kdefaultTextColor;\
                                     self.navigationItem.titleView = navTitle;}


#endif

//in app purchase

#define kInAppPurchaseProUpgradeADsProductId @"com.links.5kfree.ads"
#define kInAppPurchaseProUpgradeMapProductId @"com.links.5kfree.map"
#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionFailedNotCancelNotification @"kInAppPurchaseManagerTransactionFailedNotCancelNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

