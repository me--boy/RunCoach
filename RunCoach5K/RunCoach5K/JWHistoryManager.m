//
//  JWHistoryManager.m
//  RunCoach5K
//
//  Created by YQ-011 on 8/6/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWHistoryManager.h"
#import "TB_History.h"
#import "TB_tutorial.h"
#import "JWAppDelegate.h"

@interface JWHistoryManager()

@property(atomic, strong)NSMutableArray *allSections;

@end

@implementation JWHistoryManager

#pragma mark - costom method


#pragma mark - life cycle

- (void)dealloc
{
#ifdef HISTORY_DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)reloadData{
    NSMutableArray *allArray = [[NSMutableArray alloc] initWithCapacity:27];
    for (int i = 0; i < 27; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [allArray addObject:array];
    }
    NSFetchRequest *quest = [[NSFetchRequest alloc] initWithEntityName:@"TB_History"];
    JWAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"happenTime" ascending:NO];
    quest.sortDescriptors = @[sort];
    NSError *error;
    NSArray *array = [appDelegate.managedObjectContext executeFetchRequest:quest error:&error];
    for (TB_History *history in array) {
        NSMutableArray *array = [allArray objectAtIndex:history.tutorial.tutorialID.intValue - 1];
        [array addObject:history];
    }
    self.allSections = allArray;
    self.endBlock();
}

-(NSInteger)numberObjectsForSection:(NSInteger)section{
    NSArray *array = self.allSections[section];
    return array.count;
}

-(id)objectAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = self.allSections[indexPath.section];
    return array[indexPath.row];
}

-(NSInteger)numberOfSection{
    return 27;
}

-(BOOL)deleteObjectWithIndex:(NSIndexPath *)indexPath{
    if (self.allSections.count <= indexPath.section) {
        return NO;
    }
    NSMutableArray *array = self.allSections[indexPath.section];
    if (array.count <= indexPath.row) {
        return NO;
    }
    TB_History *history = [array objectAtIndex:indexPath.row];
    if (history.pathFileName) {
        NSString *strUrl = [[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()]
                            stringByAppendingPathComponent:history.pathFileName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:strUrl]) {
            [fileManager removeItemAtPath:strUrl error:nil];
        }
    }
    [array removeObject:history];
    JWAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.managedObjectContext deleteObject:history];
    [appDelegate saveContext];
    return YES;
}

@end
