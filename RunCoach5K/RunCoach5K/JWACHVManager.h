//
//  JWACHVManager.h
//  RunCoach5K
//
//  Created by YQ-011 on 8/13/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <Foundation/Foundation.h>

//key
#define kACHVName @"name"//nsstring
#define kACHVFinish @"finish"//bool
#define kACHVImage @"image"//nssting
#define kACHVIndex @"index"//number
#define kACHVFinishDate @"finishDate"//nsdate
#define kACHVProgress @"progress"//umber,根据不同情况，判断是用二进制还是十进制
#define kACHVDisplayName @"displayName"//displayName
#define kACHVMessage @"message"//achv message

@class TB_History;

@interface JWACHVManager : NSObject

+(id)shareACHVManager;
+(NSString *)achvImageName:(NSDictionary *)achv;
+(NSString *)achvBigImageName:(NSDictionary *)achv;

-(NSArray *)allAchv;


//跑步结束，根据传递的是history更新achv
-(void)runEndComputeAchv:(TB_History *)history;


//share
-(void)shareOneACHV;

//tips
-(void)tapTipIndex:(NSInteger)index;

@end
