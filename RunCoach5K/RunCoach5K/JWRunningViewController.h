//
//  JWRunningViewController.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/15/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWRunningManager.h"
#import "JWSliderView.h"

#ifdef VERSION_FREE
#import "BannerViewController.h"
#endif

@class JWTutorial;
@interface JWRunningViewController : UIViewController<RunningManagerDelegate,
JWSliderViewDelegate,
UIAlertViewDelegate
#ifdef VERSION_FREE
,ADDelegate
#endif
>

-(id)initWithTutorial:(JWTutorial *)tutorial;

@end
