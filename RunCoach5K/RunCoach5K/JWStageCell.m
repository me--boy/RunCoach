//
//  JWStageCell.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/16/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWStageCell.h"
#import "JWTutorial.h"

@implementation JWStageCell

-(void)setEntity:(id)entity{
    NSString *str = (NSString *)entity;
    NSArray *arr = [str componentsSeparatedByString:@","];
    self.name.text = [arr objectAtIndex:0];
    self.time.text = [arr objectAtIndex:1];
    if ([[arr objectAtIndex:1] floatValue] > 1.0) {
        self.unit.text = @"mins";
    }else{
        self.unit.text = @"min";
    }
    
}

@end
