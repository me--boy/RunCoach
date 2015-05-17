//
//  JWSoundManager.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/27/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWSoundManager.h"
#import <AVFoundation/AVFoundation.h>
#import "JWAppSetting.h"

@interface JWSoundManager ()

@property (nonatomic, strong)AVAudioPlayer *audioPlayer;//提示音
@property (nonatomic, strong)AVAudioPlayer *backPlayer;//后台声音
@property (nonatomic)BOOL backPlaying;//后台声音是否开启

@end

@implementation JWSoundManager

+(id)shardSoundManager{
    static JWSoundManager *soundManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        soundManager = [[JWSoundManager alloc] init];
    });
    
    return soundManager;
}

-(BOOL) backgroundPlay{
    if (self.audioPlayer.isPlaying) {
        //等待_audioPlay播放完成后在播放
        self.backPlaying = YES;
    }else{
        
        if (!self.backPlayer) {
            //设置声音混合模式
            @autoreleasepool {
                AudioSessionInitialize(NULL, NULL, NULL, NULL);
                UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
                AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof (sessionCategory), &sessionCategory);
                UInt32 shouldMix = YES;
                AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (shouldMix), &shouldMix);
                AudioSessionSetActive(false);
                AudioSessionSetActive(true);
            }
            
            NSString *soundFilePath=
            [[NSBundle mainBundle] pathForResource: @"silent" ofType: @"wav"];
            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
            self.backPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
            [_backPlayer prepareToPlay];
            [_backPlayer setVolume:.05f];
            _backPlayer.numberOfLoops = -1;
        }
        return [_backPlayer play];
    }
    return YES;
}

-(void)backgroundStop{
    if (self.backPlayer) {
        [self.backPlayer stop];
    }
}

-(BOOL)playSoundWithType:(NSInteger)type{
    JWAppSetting *appSetting = [JWAppSetting shareAppSetting];
    //SoundType
    NSString *music;
    if (type > 0 && type < 7) {
        music = [appSetting musicNameWithString:[NSString stringWithFormat:@"%d_minutes_left",type * 5]];
    }else if (type == kSoundMinutie5s){
        music = @"5s";
    }else if (type == kSoundExerciseComplete){
        music = [appSetting musicNameWithString:@"exercise_complete"];
    }
    [self playWarningToneWithName:music];
    return YES;
}

-(BOOL)playSoundWithStageString:(NSString*)str{
    //stage type and name
    JWAppSetting *appSetting = [JWAppSetting shareAppSetting];
    NSArray *array = [str componentsSeparatedByString:@","];
    NSString *name = array[0];
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    name = [name lowercaseString];
    [self playWarningToneWithName:[appSetting musicNameWithString:[NSString stringWithFormat:@"%@_%@_minutes", name, array[1]]]];
    
    return YES;
}

-(void)playWarningToneWithName:(NSString *)name{
    //所有声音默认MP3格式
    NSString *str = @"mp3";
    if ([name isEqualToString:@"5s"]) {
        str = @"wav";
    }
    
    //名字中带有后缀
    NSArray *array = [name componentsSeparatedByString:@"."];
    if (array.count == 2) {
        name = array[0];
        str = array[1];
    }
    
    NSString *soundFilePath =
    [[NSBundle mainBundle] pathForResource:name ofType:str];
    if (!soundFilePath) {
#ifdef RUN_DEBUG
        NSLog(@"%s  not found file %@.mp3",__FUNCTION__, name);
#endif
        return;
    }
    
    
    
    if (self.backPlayer.isPlaying) {
        [self.backPlayer stop];//暂时停止，在声音播放完后恢复配置并播放声音
    }
    
    if ([self.audioPlayer isPlaying]) {
        //上次提示音没有播放完
        [self.audioPlayer stop];
    }
    
    @autoreleasepool {
        AudioSessionInitialize(NULL, NULL, NULL, NULL);
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty (kAudioSessionProperty_AudioCategory,
                                 sizeof (sessionCategory),
                                 &sessionCategory);
        UInt32 shouldMix = true;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers,
                                 sizeof (shouldMix),
                                 &shouldMix);
        UInt32 doSetProperty = 1;
        AudioSessionSetProperty (
                                 kAudioSessionProperty_OtherMixableAudioShouldDuck,
                                 sizeof (doSetProperty),
                                 &doSetProperty
                                 );
        AudioSessionSetActive(YES);
    }
    
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    AVAudioPlayer *myBackMusic = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
    [myBackMusic prepareToPlay];
    if ([str isEqualToString:@"wav"]) {
        [myBackMusic setVolume:.7f];
    }else{
        [myBackMusic setVolume:1];
    }
    [myBackMusic play];
    myBackMusic.delegate = self;
    self.audioPlayer = myBackMusic;
    
}

-(void)didstopMunsic{
    
    @autoreleasepool {
        AudioSessionInitialize(NULL, NULL, NULL, NULL);
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof (sessionCategory), &sessionCategory);
        UInt32 shouldMix = YES;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (shouldMix), &shouldMix);
        AudioSessionSetActive(false);
        AudioSessionSetActive(true);
    }
    
    
    if (self.backPlayer) {
        [self backgroundPlay];
    }
}


#pragma mark - AVAudioPlayer Delegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (player == self.audioPlayer) {
        [self didstopMunsic];
        self.audioPlayer = nil;
    }
    
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    if (player == self.backPlayer) {
        @autoreleasepool {
            AudioSessionInitialize(NULL, NULL, NULL, NULL);
            UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
            AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof (sessionCategory), &sessionCategory);
            UInt32 shouldMix = YES;
            AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (shouldMix), &shouldMix);
            AudioSessionSetActive(false);
            AudioSessionSetActive(true);
        }
        [self backgroundPlay];
    }
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags{
    if (player == self.backPlayer) {
        @autoreleasepool {
            AudioSessionInitialize(NULL, NULL, NULL, NULL);
            UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
            AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof (sessionCategory), &sessionCategory);
            UInt32 shouldMix = YES;
            AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (shouldMix), &shouldMix);
            AudioSessionSetActive(false);
            AudioSessionSetActive(true);
        }
        [self backgroundPlay];
    }
}

@end
