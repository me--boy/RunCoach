//
//  NoticeManager.h
//  Daily Carb
//
//  Created by Maxwell YQ003 on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_NOTICE_ID   @"ID"

// 与soundName数组中一一对应.
#define kNoticeSoundCount   11
typedef enum {
    Sound_default = 0,
    Sound_ascending,
    Sound_birds,
    Sound_classic,
    Sound_cukoo,
    Sound_electronic,
    Sound_highTone,
    Sound_mbira,
    Sound_oldClock,
    Sound_rooster,
    Sound_schoolBell
}SoundType;

extern const char *soundName[];

enum {
    RepeatOnce = 0,
    RepeatSun = 1,
    RepeatMon = 1 << 1,
    RepeatTue = 1 << 2,
    RepeatWed = 1 << 3,
    RepeatThu = 1 << 4,
    RepeatFri = 1 << 5,
    RepeatSat = 1 << 6,
};

// Once -> 0 ,Daily -> 天数 ,Weekly -> (0000000 - 1111111)每位分别代表一周内的一天.
typedef NSUInteger Repeats;

@class TB_Reminder;
@interface NoticeManager : NSObject

// 清空所有已注册通知
+ (void)cancelAllNotices;

// 通过ID取消指定提醒
+ (void)cancelNoticeById:(NSString *)noticeId;

// 注册提醒并返回所注册提醒的ID
+ (NSString*)idForScheduleNotice:(TB_Reminder *)reminder;

+ (id)oneReminder;

@end
