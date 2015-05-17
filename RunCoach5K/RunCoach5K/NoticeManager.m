//
//  NoticeManager.m
//  Daily Carb
//
//  Created by Maxwell YQ003 on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoticeManager.h"
#import "TB_Reminder.h"
#import "JWAppDelegate.h"

const char *soundName[11] = {
    "Default",
    "Ascending",
    "Birds",
    "Classic",
    "Cuckoo",
    "Electronic",
    "HighTone",
    "Mbira",
    "OldClock",
    "Rooster",
    "SchoolBell"
};

@implementation NSDate (NoticeCategory)
- (NSDate*)getFireDate{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit)
                   fromDate:self];
    NSDate *fireDate = [cal dateFromComponents:comps];
    return fireDate;
}
@end

@implementation NoticeManager

+(id)oneReminder{
    JWAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"TB_Reminder"];
    NSError *error;
    NSArray *array = [appDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
    TB_Reminder *reminder;
    if (array.count >= 1) {
        reminder = [array objectAtIndex:0];
    }else{
        NSEntityDescription *entiDes = [NSEntityDescription entityForName:@"TB_Reminder"
                                                   inManagedObjectContext:appDelegate.managedObjectContext];
        reminder = [[TB_Reminder alloc] initWithEntity:entiDes
                                    insertIntoManagedObjectContext:appDelegate.managedObjectContext];
        reminder.repeat = [NSNumber numberWithInt:74];//week 1, 3, 36
        NSDate *date = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *comps = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:date];
        comps.hour = 7;
        comps.minute = 30;
        reminder.enable = @YES;
        reminder.time = [cal dateFromComponents:comps];
        reminder.note = @"It is time to do your exercise of 5K now!";
        
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef str = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        NSString *nId = (__bridge NSString *)str;
        reminder.identification = nId;
        
        [appDelegate saveContext];
    }
    return reminder;
}




+ (void)cancelAllNotices{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

+ (void)cancelNoticeById:(NSString *)noticeId{
    NSArray *notices = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *obj in notices) {
        NSString *nId = [obj.userInfo objectForKey:KEY_NOTICE_ID];
        if ([nId isEqualToString:noticeId]) {
            [[UIApplication sharedApplication] cancelLocalNotification:obj];
        }
    }
}

+ (void)scheduleOnceNotice:(UILocalNotification*)notice{
    notice.repeatInterval = 0;
    [[UIApplication sharedApplication] scheduleLocalNotification:notice];
}

//+ (void)scheduleDailyNotice:(UILocalNotification*)notice withInfo:(Repeats)repeats{
//    notice.repeatInterval = repeats * NSDayCalendarUnit;
//    [[UIApplication sharedApplication] scheduleLocalNotification:notice];
//}

+ (void)scheduleWeeklyNotice:(UILocalNotification*)notice withInfo:(Repeats)repeats{
    notice.repeatInterval = NSWeekCalendarUnit;
    NSDate *date = notice.fireDate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:(NSYearCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:date];
    for (int i = 0; i < 7; i++) {
        if (repeats >> i & 1) {
            [comps setWeekday:(i+1)];
            notice.fireDate = [cal dateFromComponents:comps];
            [[UIApplication sharedApplication] scheduleLocalNotification:notice];
        }
    }
}

+ (NSString *)idForScheduleNotice:(TB_Reminder *)reminder{
    
    UILocalNotification *notice = [[UILocalNotification alloc] init];
    notice.timeZone = [NSTimeZone defaultTimeZone];
    notice.alertBody = reminder.note;
    notice.userInfo = [NSDictionary dictionaryWithObject:reminder.identification forKey:KEY_NOTICE_ID];
    notice.fireDate = [reminder.time getFireDate];
    if (reminder.repeat.intValue == RepeatOnce) {
        [NoticeManager scheduleOnceNotice:notice];
    }else {
        [NoticeManager scheduleWeeklyNotice:notice withInfo:reminder.repeat.intValue];
    }
    //提醒的铃声
//    if (info.sound == Sound_default) {
//        notice.soundName = UILocalNotificationDefaultSoundName;
//    }else {
//        NSString *str = [NSString stringWithFormat:@"%@.wav",[NSString stringWithUTF8String:soundName[info.sound]]];
//        notice.soundName = str;
//    }
    return nil;
}

@end
