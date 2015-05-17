//
//  JWHistoryCell.h
//  RunCoach5K
//
//  Created by YQ-011 on 8/9/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noteImage;

-(void)setEntity:(id)entity;

@end
