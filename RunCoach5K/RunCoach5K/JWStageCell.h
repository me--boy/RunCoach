//
//  JWStageCell.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/16/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWStageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *unit;

-(void)setEntity:(id)entity;

@end
