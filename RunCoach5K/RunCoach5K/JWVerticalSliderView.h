//
//  JWVerticalSliderView.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/23/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VerticalSliderValueChangeBlock)(id sender);

@protocol VerticalSliderViewDelegate;

@interface JWVerticalSliderView : UIView

@property (nonatomic) NSInteger selectIndex;//当前选择的阶段

- (id)initWithStagesValue:(NSArray *)values total:(float)allTime;
- (void)setAction:(VerticalSliderValueChangeBlock)action;

@end


@protocol VerticalSliderViewDelegate <NSObject>

@end