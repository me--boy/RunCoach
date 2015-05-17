//
//  JWScrollView.m
//  RunCoach5K
//
//  Created by YQ-011 on 8/12/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWScrollView.h"

@implementation JWScrollView

//当滑动到最左边的时候，可以让背景接收到手势；
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (self.contentOffset.x == 0 && otherGestureRecognizer == self.otherGestureRecognizer) {
        return YES;
    }
    return NO;
}

//-(BOOL)touchesShouldCancelInContentView:(UIView *)view{
//    return YES;
//}

@end
