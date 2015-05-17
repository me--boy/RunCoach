//
//  JWTutorialsManager.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/9/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TB_tutorial;

@interface JWTutorialsManager : NSObject

+(id)getFirstNufinishedTutorial;

+(id)tutorialWithId:(NSInteger)tId;
+(NSDictionary *) getAllTutorialData;

+(TB_tutorial *)tb_tutorialWithId:(NSInteger)tId;

@end
