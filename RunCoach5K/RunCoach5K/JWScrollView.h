//
//  JWScrollView.h
//  RunCoach5K
//
//  Created by YQ-011 on 8/12/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWScrollView : UIScrollView

@property (nonatomic, weak)UIGestureRecognizer *otherGestureRecognizer;//当滑动到最左边之后，需要响应的手势

@end