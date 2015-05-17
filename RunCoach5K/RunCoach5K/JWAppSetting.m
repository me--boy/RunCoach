//
//  JWAppSetting.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/9/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWAppSetting.h"
#import "TB_Setting.h"
#import "JWAppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>




//appSetting

@interface JWAppSetting ()

@end

static JWAppSetting *appSetting = nil;

@implementation JWAppSetting

@synthesize setting = _setting;

+(id)shareAppSetting{
    if (!appSetting) {
        appSetting = [[JWAppSetting alloc] init];
    }
    return appSetting;
}

-(TB_Setting *)setting{
    if (!_setting) {
        JWAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"TB_Setting"];
        NSError *error;
        NSArray *array = [appDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
        if (array.count >= 1) {
            _setting = [array objectAtIndex:0];
        }else{
            NSEntityDescription *entiDes = [NSEntityDescription entityForName:@"TB_Setting" inManagedObjectContext:appDelegate.managedObjectContext];
            TB_Setting *setting = [[TB_Setting alloc] initWithEntity:entiDes insertIntoManagedObjectContext:appDelegate.managedObjectContext];
            setting.beep = @YES;
            setting.voidce = @YES;
            setting.gps = @YES;//暂且保留
            setting.autoLock = @NO;
            setting.vibrate = @YES;
            setting.coachVoice = @"m";
            setting.distanceUnit = @"mi";
            _setting = setting;
            [appDelegate saveContext];
        }
    }
    return _setting;
}

-(void)appInitializeSettings{
    [UIApplication sharedApplication].idleTimerDisabled=![self.setting.autoLock doubleValue];
}

-(void)refreshSetting{
    self.setting = nil;
}

-(BOOL)beep{
    return self.setting.beep.boolValue;
}

-(BOOL)Voice{
    return self.setting.voidce.boolValue;
}

-(BOOL)AutoLock{
    return self.setting.autoLock.doubleValue;
}


-(BOOL)needVibrate{
    BOOL vibrade = self.setting.vibrate.boolValue;
    if (vibrade)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    return vibrade;
}

-(NSInteger)coachVoice{
    return [self.setting coachVoiceIndex];
}

-(NSInteger)distabceUnit{
    return [self.setting distabceUnitIndex];
}

#pragma mark - tool

+(NSString *)stringWith:(NSTimeInterval)time{
    //目前最高到分钟，就不包含小时了
    int m = 0;
    int s = time;
    if (time >= 60) {
        m = time / 60;
        s = (int)time % 60;
    }
    return [NSString stringWithFormat:@"%d m %02d s",m,s];
}

-(NSString *)speedStringWith:(float)speed{
    if (speed <= 0) {
        return @"N/A";
    }
    //数据库保存单位为m
    if ([self distabceUnit] == 0){
        //英里
        speed *= 2.2369;
        return [NSString stringWithFormat:@"%.2f mi/h",speed];
    }
    speed *= 3.6;
    return [NSString stringWithFormat:@"%.2f km/h",speed];

}

-(NSString *)distanceStringWith:(float)distance{
    if (distance <= 0) {
        return @"N/A";
    }
    //数据库保存单位为m
    if ([self distabceUnit] == 0){
        //英里
        distance = distance * 0.00062137119223733;
        return [NSString stringWithFormat:@"%.2f mi",distance];
    }
    distance *= 0.001;
    return [NSString stringWithFormat:@"%.2f km",distance];
}

-(NSString *)musicNameWithString:(NSString *)str{
    if ([self coachVoice] == 0) {
        return [NSString stringWithFormat:@"m_%@",str];
    }
    return [NSString stringWithFormat:@"w_%@",str];
}

+(BOOL)showAd{
    return YES;
}

+(BOOL)showMap{
    return NO;
}

@end
