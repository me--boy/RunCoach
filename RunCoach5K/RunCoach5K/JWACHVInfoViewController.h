//
//  JWACHVInfoViewController.h
//  RunCoach5K
//
//  Created by YQ-011 on 8/12/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#ifdef VERSION_FREE
#import "BannerViewController.h"
#endif

@interface JWACHVInfoViewController : UIViewController<MFMailComposeViewControllerDelegate
#ifdef VERSION_FREE
,ADDelegate
#endif

>

- (id)initWithAchv:(NSDictionary *)achv;

@end
