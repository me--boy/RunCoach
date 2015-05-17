//
//  JWReminderViewController.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/12/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kReminderAvailable,
    kReminderWeekDay,
    kReminderTime,
    kReminderNote
} JWReminderCell;

@interface JWReminderViewController : UITableViewController

@end
