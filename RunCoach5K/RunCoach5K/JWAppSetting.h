//
//  JWAppSetting.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/9/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <Foundation/Foundation.h>

//判断是否是4in设备
//BOOL __isiPhone5(){
//    static BOOL useiPhone5 = NO;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        useiPhone5 = iPhone5;
//    });
//    return useiPhone5;
//}

@class TB_Setting;
@interface JWAppSetting : NSObject

@property (nonatomic, strong)TB_Setting *setting;

+ (id)shareAppSetting;

+ (NSString *)stringWith:(NSTimeInterval)time;

-(void)appInitializeSettings;
-(BOOL)beep;
-(BOOL)Voice;
-(BOOL)AutoLock;
-(BOOL)needVibrate;
-(NSInteger)coachVoice;
-(NSInteger)distabceUnit;
-(NSString *)speedStringWith:(float)speed;
-(NSString *)distanceStringWith:(float)distance;
-(NSString *)musicNameWithString:(NSString *)str;


#ifdef VERSION_FREE

+(BOOL)showAd;//广告是否显示
+(BOOL)showMap;//地图是否允许用

#endif

@end
