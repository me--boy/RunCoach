//
//  JWHistoryCell.m
//  RunCoach5K
//
//  Created by YQ-011 on 8/9/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWHistoryCell.h"
#import "TB_History.h"
#import "JWAppSetting.h"

@implementation JWHistoryCell


//通过NSBundle初始化，会调用该方法
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setEntity:(id)entity{
    if ([entity isKindOfClass:[TB_History class]]) {
        TB_History *history = (TB_History *)entity;
        self.timeLabel.text = [JWAppSetting stringWith:history.totalTime.intValue];
        [self.timeLabel sizeToFit];
       
        self.distanceLabel.text =  [[JWAppSetting shareAppSetting] distanceStringWith:history.totalDistance.floatValue];
        [self.distanceLabel sizeToFit];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM"];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:usLocale];
        self.monthLabel.text = [dateFormatter stringFromDate:history.happenTime];
        [dateFormatter setDateFormat:@"dd"];
        self.dayLabel.text = [dateFormatter stringFromDate:history.happenTime];
        NSString *note = [history.note stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.noteImage.hidden = (note == nil || [note isEqual:@""]);
    }
}

@end
