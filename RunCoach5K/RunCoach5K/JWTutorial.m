//
//  JWTutorial.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/15/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWTutorial.h"

@implementation JWTutorial

-(id)initWith:(NSDictionary *)tutorialData{
    self = [super init];
    if (self) {
        self.name = [tutorialData objectForKey:@"name"];
        self.totoalTime = [[tutorialData objectForKey:@"totalTime"] floatValue];
        self.stages = [tutorialData objectForKey:@"stages"];
        [self loadData];
    }
#ifdef RUN_DEBUG
    NSLog(@"%s::%@",__FUNCTION__, self);
#endif
    return self;
}

-(void)loadData{
    NSMutableArray *typeArray = [[NSMutableArray alloc] initWithCapacity:_stages.count];
    NSMutableArray *timeArray = [[NSMutableArray alloc] initWithCapacity:_stages.count];
    for (NSString *str in _stages) {
        NSArray *array  = [str componentsSeparatedByString:@","];
        [typeArray addObject:[array objectAtIndex:0]];
        [timeArray addObject:[array objectAtIndex:1]];
    }
    self.stagetypes = typeArray;
    self.stageTimes = timeArray;
    
}

@end
