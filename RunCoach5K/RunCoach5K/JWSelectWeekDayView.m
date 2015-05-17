//
//  JWSelectWeekDayView.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/13/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWSelectWeekDayView.h"

@implementation JWSelectWeekDayView

@synthesize repeat = _repeat;
@synthesize repeatBlock = _repeatBlock;

- (void)dealloc
{
#ifdef SETTING_DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
}

- (IBAction)buttonpressed:(id)sender {
    UIButton *button = (UIButton*)sender;
    int i = button.tag - 1;
    if (self.repeat >> i & 1) {
        _repeat -= 1 << i;
        [button setImage:[UIImage imageNamed:@"btn_unselect"] forState:UIControlStateNormal];
    }else{
        _repeat += 1 << i;
        [button setImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
    }
    self.repeatBlock(self);
}

-(void)setRepeat:(NSInteger)repeat{
    _repeat = repeat;
    NSArray *array = [self.weekDayButtons sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 tag] > [obj2 tag]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else
            return (NSComparisonResult)NSOrderedAscending;
    }];
    
    for (int i = 0; i < 7; i ++) {
        UIButton *button = [array objectAtIndex:i];
        if (_repeat>>i & 1) {
            [button setImage:[UIImage imageNamed:@"btn_select"]
                    forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage imageNamed:@"btn_unselect"]
                    forState:UIControlStateNormal];
        }
    }
    
}

@end
