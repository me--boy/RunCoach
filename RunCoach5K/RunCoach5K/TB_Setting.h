//
//  TB_Setting.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/11/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TB_Setting : NSManagedObject

@property (nonatomic, retain) NSString * attribute;
@property (nonatomic, retain) NSString * attribute1;
@property (nonatomic, retain) NSString * attribute2;
@property (nonatomic, retain) NSString * attribute3;
@property (nonatomic, retain) NSString * attribute4;
@property (nonatomic, retain) NSString * attribute5;
@property (nonatomic, retain) NSString * attribute6;
@property (nonatomic, retain) NSString * attribute7;
@property (nonatomic, retain) NSString * attribute8;
@property (nonatomic, retain) NSString * attribute9;
@property (nonatomic, retain) NSString * attribute10;
@property (nonatomic, retain) NSString * attribute11;
@property (nonatomic, retain) NSNumber * autoLock;
@property (nonatomic, retain) NSNumber * beep;
@property (nonatomic, retain) NSString * coachVoice;
@property (nonatomic, retain) NSString * distanceUnit;
@property (nonatomic, retain) NSNumber * gps;
@property (nonatomic, retain) NSNumber * vibrate;
@property (nonatomic, retain) NSNumber * voidce;

-(NSInteger)coachVoiceIndex;
-(NSInteger)distabceUnitIndex;

@end
