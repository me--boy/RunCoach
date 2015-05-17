//
//  JWRunningManager.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/15/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RunningManagerDelegate;

@class JWTutorial;
@interface JWRunningManager : NSObject

@property (nonatomic, weak) id<RunningManagerDelegate> delegate;

-(id)initWith:(JWTutorial *)tutorial;

-(void)begin;//开始，包括倒计时

-(void)startRun;//开始记时

-(void)suspend;//暂停

-(void)stop;//停止
-(void)wasInterrupted;//被打断

-(BOOL)isRuning;

-(void)changeStageto:(NSInteger)index;//改变阶段到

-(int)runningStageIndex;//当前运行阶段
-(NSString *)timeIntervalString;
-(NSString *)stageNameforIndex:(NSInteger)index;
-(NSArray *)getAllStagesTime;
-(int)totalElapsedtime;
-(int)getRunStageLastTime;
@end


@protocol RunningManagerDelegate <NSObject>

//切换阶段
-(void)runningManager:(JWRunningManager *)manager
        changetoStage:(NSInteger)index;
//刷新时间
-(void)runningManager:(JWRunningManager *)manager
              Elapsed:(double)elapsed
            Remaining:(double)remaining;
//正式开始
-(void)runningBegin;
//教程结束
-(void)runningEnd;

@end