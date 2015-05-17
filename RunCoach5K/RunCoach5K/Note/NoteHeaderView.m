//
//  NoteHeaderView.m
//  Money Monitor
//
//  Created by YQ006 on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoteHeaderView.h"

static const CGFloat nhv_h = 24.0;

@implementation NoteHeaderView

+ (CGFloat) height {
    return nhv_h;
}

+ (id) view {
    return [[self alloc] init];
}

- (id) init {
    if (self = [super initWithFrame:CGRectMake(0, 0, 320.0, nhv_h)]) {
        self.backgroundColor = [UIColor clearColor];
        self.textColor = kdefaultTextColor;
        self.font = [UIFont systemFontOfSize:nhv_h - 6];
        self.text = @"   Note";
    }
    return self;
}

@end
