//
//  JWSoundManager.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/27/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
    kSoundMinutie5m = 1,//剩余时间提示
    kSoundMinutie10m,
    kSoundMinutie15m,
    kSoundMinutie20m,
    kSoundMinutie25m,
    kSoundMinutie30m,
    kSoundMinutie5s,
    kSoundExerciseComplete//跑步结束
    
} SoundType;//不包括阶段开始的提示音，

@interface JWSoundManager : NSObject<AVAudioPlayerDelegate>

+(id)shardSoundManager;


-(BOOL)backgroundPlay;

-(void)backgroundStop;

-(BOOL)playSoundWithType:(NSInteger)type;//剩余时间提示音
-(BOOL)playSoundWithStageString:(NSString*)str;//阶段提示音

-(void)playWarningToneWithName:(NSString *)name;//无后缀名；

@end
