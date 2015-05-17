//
//  JWSegmentedControl.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/11/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, name_id)name;
typedef void(^ActionBlock)(id sender);

@interface JWSegmentedControl : UIView

@property(nonatomic)NSInteger selectedIndex;

-(id)initWithImages:(NSArray *)images SelectImages:(NSArray *)selectImages;
- (void)addaction:(ActionBlock)action;


@end
