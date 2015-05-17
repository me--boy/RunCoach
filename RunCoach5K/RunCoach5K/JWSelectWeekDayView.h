//
//  JWSelectWeekDayView.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/13/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RepeatChangeBlock)(id sender);

@interface JWSelectWeekDayView : UIView

@property (nonatomic)NSInteger repeat;

@property (nonatomic, copy)RepeatChangeBlock repeatBlock;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *weekDayButtons;

- (IBAction)buttonpressed:(id)sender;

@end
