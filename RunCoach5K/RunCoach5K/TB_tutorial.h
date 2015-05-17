//
//  TB_tutorial.h
//  RunCoach5K
//
//  Created by YQ-011 on 8/7/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TB_History;

@interface TB_tutorial : NSManagedObject

@property (nonatomic, retain) NSString * tutorialName;
@property (nonatomic, retain) NSNumber * tutorialFinish;
@property (nonatomic, retain) NSDate * finishDate;
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
@property (nonatomic, retain) NSNumber * tutorialID;
@property (nonatomic, retain) NSSet *history;
@end

@interface TB_tutorial (CoreDataGeneratedAccessors)

- (void)addHistoryObject:(TB_History *)value;
- (void)removeHistoryObject:(TB_History *)value;
- (void)addHistory:(NSSet *)values;
- (void)removeHistory:(NSSet *)values;

@end
