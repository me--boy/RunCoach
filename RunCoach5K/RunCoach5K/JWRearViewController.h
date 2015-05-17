//
//  JWRearViewController.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/5/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

typedef enum{
    kFrontRun,
    kFrontHistory,
    kFrontTips,
    kFrontAchievements,
    kFrontSetting,
    kFrontSendBack,
    kFrontRateApp,
    kFrontControlCount
} kFrontControl;

@interface JWRearViewController : UIViewController<UITableViewDelegate,
UITableViewDataSource,
MFMailComposeViewControllerDelegate>

@end
