//
//  JWHistoryManager.h
//  RunCoach5K
//
//  Created by YQ-011 on 8/6/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DataReloadEnd)();

@interface JWHistoryManager : NSObject

@property (nonatomic, copy) DataReloadEnd endBlock;

//针对tableView提供数据信息
-(NSInteger)numberOfSection;
-(NSInteger)numberObjectsForSection:(NSInteger)section;
-(id)objectAtIndexPath:(NSIndexPath *)indexPath;

//对数据的更新及操作
-(void)reloadData;
-(BOOL)deleteObjectWithIndex:(NSIndexPath *)indexPath;

@end
