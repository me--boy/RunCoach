//
//  TB_Setting.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/11/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "TB_Setting.h"


@implementation TB_Setting

@dynamic attribute;
@dynamic attribute1;
@dynamic attribute2;
@dynamic attribute3;
@dynamic attribute4;
@dynamic attribute5;
@dynamic attribute6;
@dynamic attribute7;
@dynamic attribute8;
@dynamic attribute9;
@dynamic attribute10;
@dynamic attribute11;
@dynamic autoLock;
@dynamic beep;
@dynamic coachVoice;
@dynamic distanceUnit;
@dynamic gps;
@dynamic vibrate;
@dynamic voidce;

-(NSInteger)coachVoiceIndex{
    if ([self.coachVoice isEqualToString:@"m"]) {
        return 0;
    }else{
        return 1;
    }
}

-(NSInteger)distabceUnitIndex{
    if ([self.distanceUnit isEqualToString:@"mi"]) {
        return 0;
    }else{
        return 1;
    }
}

@end
