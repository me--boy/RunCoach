//
//  JWACHVManager.m
//  RunCoach5K
//
//  Created by YQ-011 on 8/13/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWACHVManager.h"
#import "TB_History.h"
#import "TB_tutorial.h"
#import "JWAppDelegate.h"
#import "JWAnnotation.h"

const int kACHVCount = 24;

char *ACHVName[kACHVCount] = {"Snail", "Tortoise", "Rabbit", "Motorcycle", "Rocket", "King of Endurance", "King of Speed", "5K Terminator", "Take a Walk", "Super Signal", "Run Anywhere", "King of Share", "Love Music", "King of Skip", "Love Study", "W1", "W2", "W3", "W4", "W5", "W6", "W7", "W8", "W9"};
char *ACHVNameDisplay[kACHVCount] = {"Snail", "Tortoise", "Rabbit", "Motorcycle", "Rocket", "King of Endurance", "King of Speed", "5K Terminator", "Take a Walk", "Super Signal", "Run Anywhere", "King of Share", "Love Music", "King of Skip", "Love Study", "Week 1", "Week 2", "Week 3", "Week 4", "Week 5", "Week 6", "Week 7", "Week 8", "Week 9"};
char *ACHVImageName[kACHVCount] = {"snail", "tortoise", "rabbit", "motorcycl", "rocket", "king_of_endurance", "king_of_speed", "5k_terminator", "take_a_walk", "super_signal", "run_anywhere", "king_of_share", "love_music", "king_of_skip", "love_study", "w1", "w2", "w3", "w4", "w5", "w6", "w7", "w8", "w9"};
char *ACHVMessage[kACHVCount] = {"Speed is less than 1.1MPH (1.8KmPH) for 30s in running stage. Your speed is as ‘fast’ as a snail.",
    "Speed is between 1.1MPH (1.8KmPH) and 2.2MPH (3.6KmPH) for 30s in running stage. Your speed is faster than snail, but just catch tortoise.",
    "Speed is between 4.5MPH (7.2KmPH) and 8.8MPH (14.2KmPH) for 30s in running stage. Congratulations! Your speed is normal.",
    "Speed is between 11.1MPH (18KmPH) and 1.34MPH (21.6KmPH) for 30s in running stage. Your speed is faster than average.",
    "Speed is between 20.1MPH (32.4KmPH) and 22.38MPH (36KmPH) for 30s in running stage, are you sure you are running?",
    "Complete 3 routines a week strictly by the sequence of all routines.",
    "Average speed of at least 3 recorders is faster than 8.8MPH (14.2KmPH).",
    "Complete all nine weeks’ routines, no sequence requirement.",
    "Average speed in running stage is less than 3MPH (4.8KmPH) during the whole routine.",
    "GPS signal strength is over 70% for more than 5 times.",
    "Distance between stop and start place is more than 10km (6miles).",
    "Share badges through Facebook, Twitter or email more than 10 times.",
    " Listen to music while running for more than 5 times.",
    "When you don’t complete routine by sequence for more than 3 times.",
    "Read all the tips in Tips page.",
    "Complete all 3 routine of the 1st week.",
    "Complete all 3 routine of the 2nd week.",
    "Complete all 3 routine of the 3rd week.",
    "Complete all 3 routine of the 4th week.",
    "Complete all 3 routine of the 5th week.",
    "Complete all 3 routine of the 6th week.",
    "Complete all 3 routine of the 7th week.",
    "Complete all 3 routine of the 8th week.",
    "Complete all 3 routine of the 9th week."};

#define kACHVFileName @"achv_information"

@interface JWACHVManager ()

@property (nonatomic, strong) NSMutableDictionary *achvDictionary;

@end

@implementation JWACHVManager

#pragma mark - life cycle

+(id)shareACHVManager{
    static JWACHVManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JWACHVManager alloc] init];
    });
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        if (!_achvDictionary) {
            [self createachvDic];
        }
    }
    return self;
}


-(void)createachvDic{
    NSString *strUrl = [self filePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:strUrl]) {
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithContentsOfFile:strUrl];
        self.achvDictionary = muDic;
    }else{
        NSMutableDictionary *muDic = [[NSMutableDictionary alloc] init];
        for (int i = kACHVCount - 1; i >= 0; i --) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[NSString stringWithUTF8String:ACHVName[i]] forKey:kACHVName];
            [dic setObject:[NSString stringWithUTF8String:ACHVImageName[i]] forKey:kACHVImage];
            [dic setObject:@NO forKey:kACHVFinish];
            [dic setObject:@(i+1) forKey:kACHVIndex];
            [dic setObject:[NSDate date] forKey:kACHVFinishDate];
            [dic setObject:@(0) forKey:kACHVProgress];
            [dic setObject:[NSString stringWithUTF8String:ACHVNameDisplay[i]] forKey:kACHVDisplayName];
            [dic setObject:[NSString stringWithUTF8String:ACHVMessage[i]] forKey:kACHVMessage];
            [muDic setObject:dic forKey:[NSString stringWithFormat:@"%d", i + 1]];
        }
        self.achvDictionary = muDic;
        [self saveAchvDic];
    }
}

-(NSString *)filePath{
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()] stringByAppendingPathComponent:kACHVFileName];
    
}

-(void)saveAchvDic{
    NSString *strUrl = [self filePath];
    [self.achvDictionary writeToFile:strUrl atomically:YES];
}

#pragma mark - runing finish

-(NSArray *)allAchv{
    //检查
    BOOL needSave = NO;
    NSArray *keys = [self.achvDictionary allKeys];
    for (int i = 0; i < keys.count; i++) {
        id object = [self.achvDictionary objectForKey:keys[i]];
        if (![object isKindOfClass:[NSDictionary class]]) {
            [self.achvDictionary removeObjectForKey:keys[i]];
            needSave = YES;
        }
    }
    if (needSave) {
        [self saveAchvDic];
    }
    
    
    //排序，先是完成的，然后按index
    NSArray *array = [self.achvDictionary allValues];
    NSSortDescriptor *sortFini = [NSSortDescriptor sortDescriptorWithKey:kACHVFinish ascending:NO];
    NSSortDescriptor *sortFiniDate = [NSSortDescriptor sortDescriptorWithKey:kACHVFinishDate ascending:NO];
    NSSortDescriptor *sortIndex = [NSSortDescriptor sortDescriptorWithKey:kACHVIndex ascending:YES];
    
    NSArray *resout = [array sortedArrayUsingDescriptors:@[sortFini,sortFiniDate,sortIndex]];
    return resout;
}

//跑步结束，根据传递的是history更新achv
-(void)runEndComputeAchv:(TB_History *)history{
    NSMutableArray *achvName = [[NSMutableArray alloc] init];
    
    
    //打算用GCD更新achv，完成后通知主线程
    
    
    NSArray *backString;
    if (history.pathFileName) {
        //平均适度
        float averageVelocity = history.averageVelocity.floatValue;
        backString = [self computeAverageVelocity:averageVelocity Achvs:self.achvDictionary];
        if (backString.count > 0) {
            [achvName addObjectsFromArray:backString];
        }
        
        //最大速度
        float macVelocity = history.maxVelocity.floatValue;
        backString = [self computeMaxVelocity:macVelocity Achvs:self.achvDictionary];
        if (backString.count > 0) {
            [achvName addObjectsFromArray:backString];
        }
    }
    
    
    
    //week finish
    if (history.finish) {
        backString = [self computeWeekFinish:history.tutorial.tutorialID.intValue Achvs:self.achvDictionary];
        if (backString.count > 0) {
            [achvName addObjectsFromArray:backString];
        }
    }
    
    //跟上一次比较
    
    backString = [self computeOldHistoryForHistory:history Achvs:self.achvDictionary];
    if (backString.count > 0) {
        [achvName addObjectsFromArray:backString];
    }
    
    //music and gps
    
    if (history.hasMusic) {
        backString = [self hasMusic];
        if (backString.count > 0) {
            [achvName addObjectsFromArray:backString];
        }
    }
    if (history.gpsGood) {
        backString = [self goodGPS];
        if (backString.count > 0) {
            [achvName addObjectsFromArray:backString];
        }
    }
    
    [self saveAchvDic];
    if (achvName.count != 0) {
        NSString *str = [achvName componentsJoinedByString:@","];
        history.achvName = str;
        [history.managedObjectContext save:nil];
#ifdef ACHIEVEMENTS_DEBUG
        NSLog(@"%s %d",__FUNCTION__,achvName.count);
#endif
        NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@(achvName.count) forKey:kACHVCountChange];
        NSNotification *noti = [NSNotification notificationWithName:kACHVCountChange object:nil userInfo:infoDic];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
    
}

//平均适度
-(NSMutableArray *)computeAverageVelocity:(float)averageVelocity Achvs:(NSMutableDictionary *)achvs{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (averageVelocity >= .5f) {
        NSMutableDictionary *dic = [achvs objectForKey:@"9"];//Take a Walk
        if (![[dic objectForKey:kACHVFinish] boolValue]) {
            [array addObject:[self finish:dic]];
        }
    }else{
        return array;
    }
    if (averageVelocity >= 3.f) {
        NSMutableDictionary *dic = [achvs objectForKey:@"7"];//King of Speed
        if (![[dic objectForKey:kACHVFinish] boolValue]) {
            int count = [[dic objectForKey:kACHVProgress] intValue];
            [dic setObject:@(++count) forKey:kACHVProgress];
            if (count >= 3) {
                [array addObject:[self finish:dic]];
            }
            
        }
    }
    return array;
}


//最大速度
-(NSMutableArray *)computeMaxVelocity:(float)averageVelocity Achvs:(NSMutableDictionary *)achvs{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (averageVelocity >= .5f) {
        NSMutableDictionary *dic = [achvs objectForKey:@"1"];//Snail
        if (![[dic objectForKey:kACHVFinish] boolValue]) {
            [array addObject:[self finish:dic]];
        }
    }else{
        return array;
    }
    if (averageVelocity >= 1.f) {
        NSMutableDictionary *dic = [achvs objectForKey:@"2"];//Tortoise
        if (![[dic objectForKey:kACHVFinish] boolValue]) {
            [array addObject:[self finish:dic]];
        }
    }else{
        return array;
    }
    if (averageVelocity >= 4.f) {
        NSMutableDictionary *dic = [achvs objectForKey:@"3"];//Rabbit
        if (![[dic objectForKey:kACHVFinish] boolValue]) {
            [array addObject:[self finish:dic]];
        }
    }else{
        return array;
    }
    if (averageVelocity >= 6.f) {
        NSMutableDictionary *dic = [achvs objectForKey:@"4"];//Motorcycle
        if (![[dic objectForKey:kACHVFinish] boolValue]) {
            [array addObject:[self finish:dic]];
        }
    }else{
        return array;
    }
    if (averageVelocity >= 10.f) {
        NSMutableDictionary *dic = [achvs objectForKey:@"5"];//Rocket
        if (![[dic objectForKey:kACHVFinish] boolValue]) {
            [array addObject:[self finish:dic]];
        }
    }else{
        return array;
    }
    return array;
}

//完成进度
-(NSMutableArray *)computeWeekFinish:(float)index Achvs:(NSMutableDictionary *)achvs{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    int week = ceil(index / 3.0);
    int day = index - (week - 1) * 3;
    NSMutableDictionary *dic = [achvs objectForKey:[NSString stringWithFormat:@"%d", week + 15]];//week
    if (![[dic objectForKey:kACHVFinish] doubleValue]) {
        int progress = [[dic objectForKey:kACHVProgress] intValue];
        progress = progress | (1 << (day - 1));
        [dic setObject:@(progress) forKey:kACHVProgress];
        if (progress >= 7) {
            [array addObject:[self finish:dic]];
            
            //当完成一项的时候，更新总进度，5K Terminator,King of Endurance
            NSMutableDictionary *dic5K = [achvs objectForKey:@"8"];//5K Terminator
            int progress5K = [[dic5K objectForKey:kACHVProgress] intValue];
            progress5K = progress5K | (1 << (week - 1));
            [dic5K setObject:@(progress5K) forKey:kACHVProgress];
            if (progress5K >= 511) {
                [array addObject:[self finish:dic5K]];
                
                //当 5K Terminator 完成，判断king of endurance
                NSDate *beginDate;//w1完成的时间
                NSDate *endDate;//w9完成时间
                NSDictionary *dicBegin = [achvs objectForKey:@"16"];//w1
                beginDate = [dicBegin objectForKey:kACHVFinishDate];
                NSDictionary *dicEnd = [achvs objectForKey:@"24"];
                endDate = [dicEnd objectForKey:kACHVFinishDate];
                long timeInterval = [endDate timeIntervalSinceDate:beginDate];
                //时间差在9周内
                if (timeInterval < 5443200) {
                    NSMutableDictionary *dicNl = [achvs objectForKey:@"6"];//king of endurance
                    [array addObject:[self finish:dicNl]];
                }
            }
        }
        
        
    }
    return array;
}


//与上次比较

-(NSMutableArray *)computeOldHistoryForHistory:(TB_History *)history Achvs:(NSMutableDictionary *)achvs{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //跟上一个history比较
    
    NSFetchRequest *quest = [[NSFetchRequest alloc] initWithEntityName:@"TB_History"];
    JWAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"happenTime" ascending:NO];
    quest.sortDescriptors = @[sort];
    NSError *error;
    NSArray *resout = [appDelegate.managedObjectContext executeFetchRequest:quest error:&error];
    if (resout.count >1) {
        TB_History *oldHistory = [resout objectAtIndex:1];
        
        
        
        if (history.tutorial.tutorialID.intValue - oldHistory.tutorial.tutorialID.intValue > 1) {
            NSMutableDictionary *dic = [achvs objectForKey:@"14"];//king of skip
            if (![[dic objectForKey:kACHVFinish] boolValue]) {
                int progress = [[dic objectForKey:kACHVProgress] intValue];
                [dic setObject:@(++progress) forKey:kACHVProgress];
                if (progress >= 3) {
                    [array addObject:[self finish:dic]];
                    //更新提醒
                }
                [self saveAchvDic];
            }
        }
        
        
        
        
        NSMutableDictionary *dic2 = [achvs objectForKey:@"11"];//Run Anywhere
        if (![[dic2 objectForKey:kACHVFinish] boolValue]) {
            if (history.pathFileName && oldHistory.pathFileName) {
                NSString *path = [[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()] stringByAppendingPathComponent:history.pathFileName];
                NSString *oldPath = [[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()] stringByAppendingPathComponent:oldHistory.pathFileName];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if([fileManager fileExistsAtPath:path] && [fileManager fileExistsAtPath:oldPath]){
                    NSDictionary *pathDic = [NSDictionary dictionaryWithContentsOfFile:path];
                    NSArray *pathArray = [pathDic objectForKey:@"annotation"];//路线的节点
                    NSDictionary *oldPathDic = [NSDictionary dictionaryWithContentsOfFile:oldPath];
                    NSArray *oldPathArray = [oldPathDic objectForKey:@"annotation"];
                    if(pathArray.count > 0 && oldPathArray.count > 0){
                        JWAnnotation *beginAnnotation = [[JWAnnotation alloc] initWithString:pathArray[0]];
                        JWAnnotation *oldBegin = [[JWAnnotation alloc] initWithString:oldPathArray[0]];
                        CLLocation *beginLocation = [[CLLocation alloc] initWithLatitude:beginAnnotation.coordinate.latitude longitude:beginAnnotation.coordinate.longitude];
                        CLLocation *oldBeginLocation = [[CLLocation alloc] initWithLatitude:oldBegin.coordinate.latitude longitude:oldBegin.coordinate.longitude];
                        CLLocationDistance distance = [beginLocation distanceFromLocation:oldBeginLocation];
                        if(distance >= 10000){
                            [array addObject:[self finish:dic2]];
                        }
                    }
                }
            }
        }

    }
    return array;
}

-(NSArray *)hasMusic{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [self.achvDictionary objectForKey:@"13"];//Love music
    if (![[dic objectForKey:kACHVFinish] boolValue]) {
        int progress = [[dic objectForKey:kACHVProgress] intValue];
        [dic setObject:@(++progress) forKey:kACHVProgress];
        if (progress >= 5) {
            NSString *str = [self finish:dic];
            [array addObject:str];
        }
    }
    return array;
}

-(NSArray *)goodGPS{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [self.achvDictionary objectForKey:@"10"];//Super Signal
    if (![[dic objectForKey:kACHVFinish] boolValue]) {
        int progress = [[dic objectForKey:kACHVProgress] intValue];
        [dic setObject:@(++progress) forKey:kACHVProgress];
        if (progress >= 5) {
            NSString *str = [self finish:dic];
            [array addObject:str];
        }
    }
    return array;
}

#pragma mark - other

//share

-(void)shareOneACHV{
    NSMutableDictionary *dic = [self.achvDictionary objectForKey:@"12"];//Love Study
    if (![[dic objectForKey:kACHVFinish] boolValue]) {
        int progress = [[dic objectForKey:kACHVProgress] intValue];
        [dic setObject:@(++progress) forKey:kACHVProgress];
        if (progress >= 5) {
            [self finish:dic];
            //更新提醒,不用更新
            [[NSNotificationCenter defaultCenter] postNotificationName:kACHVShareCountFive
                                                                object:nil];
        }
        [self saveAchvDic];
    }
}

//tips

-(void)tapTipIndex:(NSInteger)index{
    NSMutableDictionary *dic = [self.achvDictionary objectForKey:@"15"];//Love Study
    if (![[dic objectForKey:kACHVFinish] boolValue]) {
        int progress = [[dic objectForKey:kACHVProgress] intValue];
        progress = progress | (1 << index);
        [dic setObject:@(progress) forKey:kACHVProgress];
        if (progress >= 1023) {
            [self finish:dic];
            //更新提醒
            NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@(1) forKey:kACHVCountChange];
            NSNotification *noti = [NSNotification notificationWithName:kACHVCountChange object:nil userInfo:infoDic];
            [[NSNotificationCenter defaultCenter] postNotification:noti];
        }
        [self saveAchvDic];
    }
}

//设置完成的奖项
-(NSString *)finish:(NSMutableDictionary *)dic{
    [dic setObject:@YES forKey:kACHVFinish];
    [dic setObject:[NSDate date] forKey:kACHVFinishDate];
    return [dic objectForKey:kACHVName];
}

#pragma mark - tool

+(NSString *)achvImageName:(NSDictionary *)achv{
    NSNumber *num = [achv objectForKey:kACHVFinish];
    NSString *image = [achv objectForKey:kACHVImage];
    if (num.boolValue)
        return [NSString stringWithFormat:@"achv_illume_%@",image];
    return [NSString stringWithFormat:@"achv_dark_%@",image];
}

+(NSString *)achvBigImageName:(NSDictionary *)achv{
    NSNumber *num = [achv objectForKey:kACHVFinish];
    NSString *image = [achv objectForKey:kACHVImage];
    if (num.boolValue)
        return [NSString stringWithFormat:@"achv_illume_big_%@",image];
    return [NSString stringWithFormat:@"achv_dark_big_%@",image];
}

@end

