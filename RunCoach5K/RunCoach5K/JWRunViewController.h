//
//  JWRunViewController.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/5/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef VERSION_FREE
#import "BannerViewController.h"
#endif

@interface JWRunViewController : UIViewController<UITableViewDataSource
, UITableViewDelegate
#ifdef VERSION_FREE
,ADDelegate
#endif
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableBgView;
@property (weak, nonatomic) IBOutlet UIImageView *finishImageView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

- (IBAction)changeTutorials:(id)sender;

- (IBAction)startRun:(id)sender;


@end
