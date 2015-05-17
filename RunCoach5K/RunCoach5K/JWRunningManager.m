//
//  JWRunningManager.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/15/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWRunningManager.h"
#import "JWTutorial.h"
#import "JWSoundManager.h"
#import "JWAppSetting.h"

@interface JWRunningManager (){
    BOOL isRunning;
    BOOL beep;//提示音
    BOOL voice;//教练音
}

@property (nonatomic, strong)JWTutorial *runningTutorial;//当前选择教程
@property (nonatomic, strong)NSDate *startTime;//开始时间
@property (nonatomic, strong)NSDate *lastTime;//最后记时点
@property (nonatomic, strong)NSDate *countDownTime;//倒计时开始时间
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic) NSTimeInterval elapsed;//已用时间，除去当前阶段
@property (nonatomic) NSTimeInterval remaining;//剩余时间，包括当前阶段总时间

@property (nonatomic) NSInteger runstage;//当前阶段
@property (nonatomic) NSTimeInterval stageTime;//当前阶段总时间
@property (nonatomic) NSTimeInterval stageElapsedTime;//当前阶段已过时间
@property (nonatomic) NSInteger runStageLastTime;//当前阶段剩余时间的整秒,以整秒改变
@end

@implementation JWRunningManager

@synthesize runningTutorial = _runningTutorial;

#pragma mark - init

- (void)dealloc
{
#ifdef RUN_DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
}

-(id)initWith:(JWTutorial *)tutorial{
    
    self = [super init];
    if (self) {
        self.runningTutorial = tutorial;
        beep = [[JWAppSetting shareAppSetting] beep];
        voice = [[JWAppSetting shareAppSetting] Voice];
        [self loadData];
    }
    return self;
}

-(void)loadData{
    self.elapsed = 0;
    self.remaining = self.runningTutorial.totoalTime * 60;
    self.runstage = 0;
    self.stageTime = [self getStageTimeWith:0];
    self.stageElapsedTime = 0;
    self.runStageLastTime = self.stageTime;
    self.startTime = nil;
    self.lastTime = nil;
}

#pragma mark - save


#pragma mark - run manager

-(BOOL)isRuning{
    if (self.lastTime) {
        return YES;
    }
    return NO;
}

-(void)begin{
    if (self.timer) {
        [self.timer invalidate];
        self.timer  = nil;
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.2f
                                                      target:self
                                                    selector:@selector(runLoop:)
                                                    userInfo:nil
                                                     repeats:YES];
    self.timer = timer;
    self.countDownTime = [NSDate date];
    
    //初始状态
    if ([self.delegate respondsToSelector:@selector(runningManager:changetoStage:)]) {
        [self.delegate runningManager:self changetoStage:self.runstage];
    }
    
    if ([self.delegate respondsToSelector:@selector(runningManager:Elapsed:Remaining:)]) {
        [self.delegate runningManager:self Elapsed:0 Remaining:self.remaining];
    }
    [[JWSoundManager shardSoundManager] backgroundPlay];
}

-(void)startRun{
    if (self.timer) {
        return;
    }
    self.startTime = [NSDate date];
    self.lastTime = [NSDate date];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.2f
                                                      target:self
                                                    selector:@selector(runLoop:)
                                                    userInfo:nil
                                                     repeats:YES];
    self.timer = timer;
}


-(void)suspend{
    [self.timer invalidate];
    self.timer = nil;
    self.startTime = nil;
    self.lastTime = nil;
    
}

-(void)stop{
    [self.timer invalidate];
    self.timer = nil;
    [[JWSoundManager shardSoundManager] backgroundStop];
    [_delegate runningEnd];
}

-(void)wasInterrupted{
    //当被打断，不回调委托，因为是外部直接打断
    [self.timer invalidate];
    self.timer = nil;
    [[JWSoundManager shardSoundManager] backgroundStop];
    self.elapsed += (int)self.stageElapsedTime;
    self.remaining -= (int)self.stageElapsedTime;
    self.stageElapsedTime = 0;
    self.stageTime = 0;
}


-(void)runLoop:(NSTimer*)timer{
    if (self.countDownTime) {
        //倒计时3s
        if ([self.countDownTime timeIntervalSinceNow] + 3 <= 0) {
            //倒计时结束
            self.countDownTime = nil;
            self.startTime = [NSDate date];
            self.lastTime = [NSDate date];
            [_delegate runningBegin];
            JWSoundManager *soundManager = [JWSoundManager shardSoundManager];
            if (voice) {
                [soundManager playSoundWithStageString:self.runningTutorial.stages[self.runstage]];
                [[JWAppSetting shareAppSetting] needVibrate];
            }
        }
        return;
    }
    if (!self.lastTime) {
        return;
    }
    
    
    NSTimeInterval timeInterval = [self.lastTime timeIntervalSinceNow];
    if (timeInterval > 0 || timeInterval < -60) {
        //与上次的时间间隔有异常，则修正
        self.lastTime = [NSDate date];
        return;
    }
    
    
    //计算本阶段已用时间，并判断本阶段是否完成
    self.stageElapsedTime += (-timeInterval);//等价-=
    if (self.stageElapsedTime >= self.stageTime) {
        [self nextStage];
    }else{
        //剩余时间的提醒,以整数为单位切换
        
        int lastTime = self.stageTime -(int)self.stageElapsedTime;
        if (lastTime != self.runStageLastTime) {
            self.runStageLastTime = lastTime;
            switch (self.runStageLastTime) {
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                    if (beep) {
                        [[JWSoundManager shardSoundManager] playSoundWithType:kSoundMinutie5s];
                        [[JWAppSetting shareAppSetting] needVibrate];
                    }
                    break;
                case 300:
                    if (voice) {
                        [[JWSoundManager shardSoundManager] playSoundWithType:kSoundMinutie5m];
                        [[JWAppSetting shareAppSetting] needVibrate];
                    }
                    break;
                case 600:
                    if (voice) {
                        [[JWSoundManager shardSoundManager] playSoundWithType:kSoundMinutie10m];
                        [[JWAppSetting shareAppSetting] needVibrate];
                    }
                    break;
                case 900:
                    if (voice) {
                        [[JWSoundManager shardSoundManager] playSoundWithType:kSoundMinutie15m];
                        [[JWAppSetting shareAppSetting] needVibrate];
                    }
                    break;
                case 1200:
                    if (voice) {
                        [[JWSoundManager shardSoundManager] playSoundWithType:kSoundMinutie20m];
                        [[JWAppSetting shareAppSetting] needVibrate];
                    }
                    break;
                case 1500:
                    if (voice) {
                        [[JWSoundManager shardSoundManager] playSoundWithType:kSoundMinutie25m];
                        [[JWAppSetting shareAppSetting] needVibrate];
                    }
                    break;
                case 1800:
                    if (voice) {
                        [[JWSoundManager shardSoundManager] playSoundWithType:kSoundMinutie30m];
                        [[JWAppSetting shareAppSetting] needVibrate];
                    }
                    break;
                default:
                    break;
            }
        }
    }
    
    self.lastTime = [NSDate date];
    
    [self.delegate runningManager:self
                          Elapsed:self.elapsed + (int)self.stageElapsedTime
                        Remaining:self.remaining - (int)self.stageElapsedTime];
}


-(void)nextStage{
    //进行下一个阶段
    self.elapsed += (int)self.stageElapsedTime;
    self.remaining -= (int)self.stageElapsedTime;
    self.stageElapsedTime = 0;
    self.stageTime = 0;
    self.runstage += 1;
    if (self.runstage >= self.runningTutorial.stages.count) {
        self.runstage = self.runningTutorial.stages.count - 1;
        [self stop];
        [[JWSoundManager shardSoundManager] playSoundWithType:kSoundExerciseComplete];
        return;
    }
    self.stageTime = [self getStageTimeWith:self.runstage];
    self.runStageLastTime = self.stageTime;
    
    JWSoundManager *soundManager = [JWSoundManager shardSoundManager];
    if (voice) {
        [soundManager playSoundWithStageString:self.runningTutorial.stages[self.runstage]];
        [[JWAppSetting shareAppSetting] needVibrate];
    }
    
    [self.delegate runningManager:self changetoStage:self.runstage];
    
    [self.delegate runningManager:self
                          Elapsed:self.elapsed + (int)self.stageElapsedTime
                        Remaining:self.remaining - (int)self.stageElapsedTime];
    
}

-(void)changeStageto:(NSInteger)index{
    if (index < 0 || index >= self.runningTutorial.stages.count || index == self.runstage ) {
        return;
    }
    self.elapsed += (int)self.stageElapsedTime;
    if (index > self.runstage) {
        for (int i = _runstage; i < index; i++) {
            self.remaining -= [self getStageTimeWith:i];
        }
        
    }else {
        for  (int i = _runstage - 1; i >= index; i--) {
            self.remaining += [self getStageTimeWith:i];
        }
    }
    self.runstage = index;
    self.stageTime = [self getStageTimeWith:self.runstage];
    self.runStageLastTime = self.stageTime;
    self.stageElapsedTime = 0;
    [self.delegate runningManager:self changetoStage:self.runstage];
    
    JWSoundManager *soundManager = [JWSoundManager shardSoundManager];
    if (voice) {
        [soundManager playSoundWithStageString:self.runningTutorial.stages[self.runstage]];
        [[JWAppSetting shareAppSetting] needVibrate];
    }
    
}

-(NSArray *)getAllStagesTime{
    return [NSArray arrayWithArray:self.runningTutorial.stages];
}

-(NSString *)timeIntervalString{
    return nil;
}

-(NSString *)stageNameforIndex:(NSInteger)index{
    return nil;
}

-(NSTimeInterval)getStageTimeWith:(NSInteger)index{
    NSString *str = [self.runningTutorial.stages objectAtIndex:index];
    NSArray *array  = [str componentsSeparatedByString:@","];
    NSTimeInterval time = [[array objectAtIndex:1] floatValue] * 60;
    return time;
}



#pragma mark - get

-(int)runningStageIndex{
    if (_runstage >= self.runningTutorial.stages.count) {
        return self.self.runningTutorial.stages.count - 1;
    }
    return _runstage;
}
//总共所用时间
-(int)totalElapsedtime{
    return self.elapsed;
}

//当前阶段剩余时间
-(int)getRunStageLastTime{
    return self.runStageLastTime;
}

@end
