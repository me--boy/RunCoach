//
//  JWTutorialsManager.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/9/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWTutorialsManager.h"
#import "JWTutorial.h"
#import "TB_tutorial.h"
#import "JWAppDelegate.h"

//tutorial编号从1开始
@implementation JWTutorialsManager

+(id)getFirstNufinishedTutorial{
    for (int i = 1; i <= ktutorialCount; i++) {
        TB_tutorial *tb_tutorial = [JWTutorialsManager tb_tutorialWithId:i];
        if (!tb_tutorial.tutorialFinish.boolValue) 
            return [JWTutorialsManager tutorialWithId:i];
    }
    return [JWTutorialsManager tutorialWithId:ktutorialCount];
}

#pragma mark - JWTurorial

+(id)tutorialWithId:(NSInteger)tId{
    NSDictionary *dic = [JWTutorialsManager getTutorialDataWith:tId];
    if (!dic) {
        return nil;
    }
    JWTutorial *tutorial = [[JWTutorial alloc] initWith:dic];
    tutorial.tutorialId = tId;
    return tutorial;
}

+(NSDictionary *) getAllTutorialData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dataDictionary" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    return dic;
    
}

+(NSDictionary *)getTutorialDataWith:(NSInteger)tId{
    NSDictionary *dics = [JWTutorialsManager getAllTutorialData];
    NSDictionary *dic = [dics objectForKey:[NSString stringWithFormat:@"turotials%d",tId]];
    return dic;
}

#pragma mark - TB_tutorial

//查询数据库，没有则创建
+(TB_tutorial *)tb_tutorialWithId:(NSInteger)tId{
    TB_tutorial *tutorial;
    NSFetchRequest *quest = [[NSFetchRequest alloc] initWithEntityName:@"TB_tutorial"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tutorialID = %d",tId];
    quest.predicate = predicate;
    JWAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSError *error;
    NSArray *array = [appDelegate.managedObjectContext executeFetchRequest:quest error:&error];
    if (array.count > 0)
        tutorial = [array objectAtIndex:0];
    else{
        //创建数据库对象
        NSEntityDescription *des = [NSEntityDescription entityForName:@"TB_tutorial" inManagedObjectContext:appDelegate.managedObjectContext];
        tutorial = [[TB_tutorial alloc] initWithEntity:des insertIntoManagedObjectContext:appDelegate.managedObjectContext];
        tutorial.tutorialID = [NSNumber numberWithInt:tId];
        JWTutorial *jwTuto = [JWTutorialsManager tutorialWithId:tId];
        tutorial.tutorialName = jwTuto.name;
        [appDelegate saveContext];
    }
    return tutorial;
}

#pragma mark - debug

#ifdef DEBUG
+(void)creatDataDicttinonary{

    NSMutableDictionary *mudic = [[NSMutableDictionary alloc] init];
    for (int i = 1; i <= 27; i++) {
        [mudic setObject:[JWTutorialsManager creatDataWithOrder:i] forKey:[NSString stringWithFormat:@"turotials%d",i]];
    }
    [mudic writeToFile:@"/Users/yq-011/Desktop/dataDictionary.plist" atomically:YES];

}
+(NSDictionary*)creatDataWithOrder:(int)order{
    NSMutableDictionary *mudic1 = [[NSMutableDictionary alloc] init];
    switch (order) {
        case 1:
        {
            [mudic1 setObject:@"Week 1 Day 1" forKey:@"name"];
            [mudic1 setObject:@"25" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 6 ; i ++) {
                [array addObject:@"Run,1"];
                [array addObject:@"Walk,1.5"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 2:
        {
            [mudic1 setObject:@"Week 1 Day 2" forKey:@"name"];
            [mudic1 setObject:@"30" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 8 ; i ++) {
                [array addObject:@"Run,1"];
                [array addObject:@"Walk,1.5"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 3:
        {
            [mudic1 setObject:@"Week 1 Day 3" forKey:@"name"];
            [mudic1 setObject:@"30" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 8 ; i ++) {
                [array addObject:@"Run,1"];
                [array addObject:@"Walk,1.5"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 4:
        {
            [mudic1 setObject:@"Week 2 Day 1" forKey:@"name"];
            [mudic1 setObject:@"30" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 4 ; i ++) {
                [array addObject:@"Run,2"];
                [array addObject:@"Walk,2"];
            }
            for (int i = 0 ; i < 2 ; i ++) {
                [array addObject:@"Run,1"];
                [array addObject:@"Walk,1"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 5:
        {
            [mudic1 setObject:@"Week 2 Day 2" forKey:@"name"];
            [mudic1 setObject:@"30" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 4 ; i ++) {
                [array addObject:@"Run,2"];
                [array addObject:@"Walk,2"];
            }
            for (int i = 0 ; i < 2 ; i ++) {
                [array addObject:@"Run,1"];
                [array addObject:@"Walk,1"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 6:
        {
            [mudic1 setObject:@"Week 2 Day 3" forKey:@"name"];
            [mudic1 setObject:@"34" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 6 ; i ++) {
                [array addObject:@"Run,2"];
                [array addObject:@"Walk,2"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 7:
        {
            [mudic1 setObject:@"Week 3 Day 1" forKey:@"name"];
            [mudic1 setObject:@"28" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 2 ; i ++) {
                [array addObject:@"Run,2"];
                [array addObject:@"Walk,2"];
            }
            for (int i = 0 ; i < 2 ; i ++) {
                [array addObject:@"Run,2.5"];
                [array addObject:@"Walk,2.5"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 8:
        {
            [mudic1 setObject:@"Week 3 Day 2" forKey:@"name"];
            [mudic1 setObject:@"28" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 2 ; i ++) {
                [array addObject:@"Run,2"];
                [array addObject:@"Walk,2"];
            }
            for (int i = 0 ; i < 2 ; i ++) {
                [array addObject:@"Run,2.5"];
                [array addObject:@"Walk,2.5"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 9:
        {
            [mudic1 setObject:@"Week 3 Day 3" forKey:@"name"];
            [mudic1 setObject:@"30" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 2 ; i ++) {
                [array addObject:@"Run,2"];
                [array addObject:@"Walk,2"];
            }
            for (int i = 0 ; i < 2 ; i ++) {
                [array addObject:@"Run,3"];
                [array addObject:@"Walk,3"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 10:
        {
            [mudic1 setObject:@"Week 4 Day 1" forKey:@"name"];
            [mudic1 setObject:@"34" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 2 ; i ++) {
                [array addObject:@"Run,3"];
                [array addObject:@"Walk,2"];
            }
            for (int i = 0 ; i < 2 ; i ++) {
                [array addObject:@"Run,4"];
                [array addObject:@"Walk,3"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 11:
        {
            [mudic1 setObject:@"Week 4 Day 2" forKey:@"name"];
            [mudic1 setObject:@"36" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 2 ; i ++) {
                [array addObject:@"Run,3"];
                [array addObject:@"Walk,2"];
            }
            for (int i = 0 ; i < 2 ; i ++) {
                [array addObject:@"Run,5"];
                [array addObject:@"Walk,3"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 12:
        {
            [mudic1 setObject:@"Week 4 Day 3" forKey:@"name"];
            [mudic1 setObject:@"34" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 2 ; i ++) {
                [array addObject:@"Run,3"];
                [array addObject:@"Walk,2"];
            }
            for (int i = 0 ; i < 2 ; i ++) {
                [array addObject:@"Run,5"];
                [array addObject:@"Walk,2"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 13:
        {
            [mudic1 setObject:@"Week 5 Day 1" forKey:@"name"];
            [mudic1 setObject:@"32" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,5"];
                [array addObject:@"Walk,3"];
            }
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,6"];
                [array addObject:@"Walk,3"];
                [array addObject:@"Run,5"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 14:
        {
            [mudic1 setObject:@"Week 5 Day 2" forKey:@"name"];
            [mudic1 setObject:@"35" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,5"];
                [array addObject:@"Walk,3"];
            }
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,8"];
                [array addObject:@"Walk,4"];
                [array addObject:@"Run,5"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 15:
        {
            [mudic1 setObject:@"Week 5 Day 3" forKey:@"name"];
            [mudic1 setObject:@"30" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,8"];
                [array addObject:@"Walk,4"];
                [array addObject:@"Run,8"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 16:
        {
            [mudic1 setObject:@"Week 6 Day 1" forKey:@"name"];
            [mudic1 setObject:@"35" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,10"];
                [array addObject:@"Walk,5"];
                [array addObject:@"Run,10"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 17:
        {
            [mudic1 setObject:@"Week 6 Day 2" forKey:@"name"];
            [mudic1 setObject:@"33" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,10"];
                [array addObject:@"Walk,3"];
                [array addObject:@"Run,10"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 18:
        {
            [mudic1 setObject:@"Week 6 Day 3" forKey:@"name"];
            [mudic1 setObject:@"33" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,15"];
                [array addObject:@"Walk,3"];
                [array addObject:@"Run,5"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 19:
        {
            [mudic1 setObject:@"Week 7 Day 1" forKey:@"name"];
            [mudic1 setObject:@"30" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,20"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 20:
        {
            [mudic1 setObject:@"Week 7 Day 2" forKey:@"name"];
            [mudic1 setObject:@"30" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,20"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 21:
        {
            [mudic1 setObject:@"Week 7 Day 3" forKey:@"name"];
            [mudic1 setObject:@"30" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,20"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 22:
        {
            [mudic1 setObject:@"Week 8 Day 1" forKey:@"name"];
            [mudic1 setObject:@"35" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,25"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 23:
        {
            [mudic1 setObject:@"Week 8 Day 2" forKey:@"name"];
            [mudic1 setObject:@"35" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,25"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 24:
        {
            [mudic1 setObject:@"Week 8 Day 3" forKey:@"name"];
            [mudic1 setObject:@"35" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,25"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 25:
        {
            [mudic1 setObject:@"Week 9 Day 1" forKey:@"name"];
            [mudic1 setObject:@"38" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,28"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 26:
        {
            [mudic1 setObject:@"Week 9 Day 2" forKey:@"name"];
            [mudic1 setObject:@"40" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,30"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
        case 27:
        {
            [mudic1 setObject:@"Week 9 Day 3" forKey:@"name"];
            [mudic1 setObject:@"45" forKey:@"totalTime"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@"Warm up,5"];
            for (int i = 0 ; i < 1 ; i ++) {
                [array addObject:@"Run,35"];
            }
            [array addObject:@"Cool down,5"];
            [mudic1 setObject:array forKey:@"stages"];
        }
            break;
            
        default:
            break;
        
    }
    
    return mudic1;
}
#endif


@end
