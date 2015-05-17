//
//  JWTutorial.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/15/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWTutorial : NSObject

@property (nonatomic) NSInteger tutorialId;//教程的id
@property (nonatomic, copy) NSString *name;//名字
@property (nonatomic, copy) NSArray *stages;//阶段名字和时间字符串数组
@property (nonatomic, strong) NSArray *stagetypes;//阶段名字数组
@property (nonatomic, strong) NSArray *stageTimes;//阶段时间数组（nsstring类型）(取值用floutValue)
@property (nonatomic) float totoalTime;//总时间

-(id)initWith:(NSDictionary *)tutorialData;

@end
