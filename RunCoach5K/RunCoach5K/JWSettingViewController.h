//
//  JWSettingViewController.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/5/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef VERSION_FREE
#import "BannerViewController.h"
#endif

typedef enum{
    BeepCell,
    VoiceCell,
    AutoLockCell,
    VibrateCell,
    CoachVoiceCell,
    DistanceUnitCell,
    ReminderCell,
    
#ifndef VERSION_FREE
    SettingCellCount,
    SettingSectionCount = 2
#else
    UpdagradeCell,
    SettingCellCount,
    SettingSectionCount = 3
#endif
    
} SrttingCell;


@interface JWSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate
#ifdef VERSION_FREE
,ADDelegate
#endif
>

@end
