//
//  TB_History.h
//  RunCoach5K
//
//  Created by YQ-011 on 8/8/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TB_tutorial;

@interface TB_History : NSManagedObject

@property (nonatomic, retain) NSString * achvName;
@property (nonatomic, retain) NSString * attribute1;
@property (nonatomic, retain) NSString * attribute2;
@property (nonatomic, retain) NSString * attribute3;
@property (nonatomic, retain) NSString * attribute4;
@property (nonatomic, retain) NSString * attribute5;
@property (nonatomic, retain) NSString * attribute6;
@property (nonatomic, retain) NSString * attribute7;
@property (nonatomic, retain) NSString * attribute8;
@property (nonatomic, retain) NSString * attribute9;
@property (nonatomic, retain) NSNumber * averageVelocity;
@property (nonatomic, retain) NSNumber * maxVelocity;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * pathFileName;
@property (nonatomic, retain) NSString * totalDistance;
@property (nonatomic, retain) NSString * totalTime;
@property (nonatomic, retain) NSDate * happenTime;
@property (nonatomic, retain) TB_tutorial *tutorial;

@property (nonatomic, assign) BOOL finish;//判断ACHV用的，不用保存到数据库
@property (nonatomic, assign) BOOL hasMusic;//是否听音乐
@property (nonatomic, assign) BOOL gpsGood;//gps信号强度好

@end
