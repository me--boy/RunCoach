//
//  JWRunViewController.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/5/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWRunViewController.h"
#import "SWRevealViewController.h"
#import "UIBarButtonItem+Addtions.h"
#import "JWTutorialsManager.h"
#import "JWRunningViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JWTutorial.h"
#import "JWStageCell.h"
#import "JWNavigationController.h"
#import "TB_tutorial.h"
#import "JWHourglassView.h"


@interface JWRunViewController ()

@property (nonatomic, strong) NSDictionary *allTutorials;
@property (nonatomic, strong) JWTutorial *showTutorial;

@end

@implementation JWRunViewController

- (id)init
{
    self = [self initWithNibName:@"RunViewController" bundle:nil];
    if (self) {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = kBackgroundColor;
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *back = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_advances"]
                                                                   target:revealController
                                                                   action:@selector(revealToggle:) Offset:-20];
    self.navigationItem.leftBarButtonItem = back;
    self.showTutorial = [JWTutorialsManager getFirstNufinishedTutorial];
    TB_tutorial *tb_tutorial = [JWTutorialsManager tb_tutorialWithId:self.showTutorial.tutorialId];
    if (tb_tutorial.tutorialFinish.boolValue)
        self.finishImageView.alpha = 1.0f;
    self.title = self.showTutorial.name;
    kNavTitle(self.showTutorial.name, self);
    [self.tableView addSubview:self.finishImageView];
    if (iPhone5) {
        self.tableBgView.center = CGPointMake(166, 198);
        
        // why
        if (SYSTEM_VERSTION_VALUE >= 7.0) {
            self.tableBgView.center = CGPointMake(166, 224);
        }
        self.startButton.center = CGPointMake(166, 450);
    }

    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    TB_tutorial *tb_tutorial = [JWTutorialsManager tb_tutorialWithId:self.showTutorial.tutorialId];
    if (tb_tutorial.tutorialFinish.boolValue && self.finishImageView.alpha == 0.f) {
        
        //禁用按钮
        self.leftButton.enabled = NO;
        self.rightButton.enabled = NO;
        self.startButton.enabled = NO;
        
        //添加盖章动画，
        self.finishImageView.alpha = .3f;
        CGRect frame = self.finishImageView.frame;
        self.finishImageView.frame = CGRectMake(self.tableView.bounds.size.width  + 120, -100,
                                                frame.size.width + 300, frame.size.height + 150);
        [UIView animateWithDuration:.7f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.finishImageView.alpha = 1.f;
                             self.finishImageView.frame = frame;
                         } completion:^(BOOL finished) {
                             [self.finishImageView setImage:[UIImage imageNamed:@"icon_finish2"]];
                             [JWHourglassView shareHourglassUse:NO];
                             
                             self.leftButton.enabled = YES;
                             self.rightButton.enabled = YES;
                             self.startButton.enabled = YES;
                         }];
    }else{
        [JWHourglassView shareHourglassUse:NO];
    }
#ifdef VERSION_FREE
    BannerViewController *banner = [BannerViewController sharedBanner];
    [banner setDelegate:self];
    [self.view addSubview:banner.view];
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
#ifdef RUN_DEBUG
    NSLog(@"%s  %d",__FUNCTION__, self.showTutorial.stages.count);
#endif
    return self.showTutorial.stages.count;
}

#pragma mark - table view delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    JWStageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StageCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    if (indexPath.row == 0) {
        cell.bgView.backgroundColor = kRGB255UIColor(235, 190, 32, 1.0f);
        
    }else if (indexPath.row == self.showTutorial.stages.count - 1){
        cell.bgView.backgroundColor = kRGB255UIColor(102, 159, 194, 1.0f);
    }else{
        if (indexPath.row % 2 == 1) {
            cell.bgView.backgroundColor = kRGB255UIColor(235, 131, 24, 1.0f);
        }else{
            cell.bgView.backgroundColor = kRGB255UIColor(241, 178, 100, 1.0f);
        }
        
    }
    [cell setEntity:[self.showTutorial.stages objectAtIndex:indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 22.f;
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setFinishImageView:nil];
    [self setLeftButton:nil];
    [self setRightButton:nil];
    [self setStartButton:nil];
    [self setTableBgView:nil];
    [super viewDidUnload];
}
- (IBAction)changeTutorials:(id)sender {
    if ([sender tag] == 1) {
        JWTutorial *tuto = [JWTutorialsManager tutorialWithId:self.showTutorial.tutorialId-1];
        if (!tuto) {
            return;
        }
        self.showTutorial = tuto;
        kNavTitle(self.showTutorial.name, self);
        [self.tableView reloadData];
        
        TB_tutorial *tb_tutorial = [JWTutorialsManager tb_tutorialWithId:self.showTutorial.tutorialId];
        if (tb_tutorial.tutorialFinish.boolValue)
            self.finishImageView.alpha = 1.f;
        else
            self.finishImageView.alpha = 0.f;
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fillMode = kCAFillModeForwards;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromLeft;
        //    animation.delegate = self;
        [self.tableView.layer addAnimation:animation forKey:nil];
    }else{
        JWTutorial *tuto = [JWTutorialsManager tutorialWithId:self.showTutorial.tutorialId+1];
        if (!tuto) {
            return;
        }
        self.showTutorial = tuto;
        kNavTitle(self.showTutorial.name, self);
        [self.tableView reloadData];
        
        TB_tutorial *tb_tutorial = [JWTutorialsManager tb_tutorialWithId:self.showTutorial.tutorialId];
        if (tb_tutorial.tutorialFinish.boolValue)
            self.finishImageView.alpha = 1.f;
        else
            self.finishImageView.alpha = 0.f;
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fillMode = kCAFillModeForwards;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromRight;
        //    animation.delegate = self;
        [self.tableView.layer addAnimation:animation forKey:nil];
    }
}

- (IBAction)startRun:(id)sender {
    JWRunningViewController *running = [[JWRunningViewController alloc] initWithTutorial:self.showTutorial];
    JWNavigationController *nav = [[JWNavigationController alloc] initWithRootViewController:running];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - AD delegate

-(void)ADIsComing:(BOOL)b{
    int offset = 0;
    CGRect frame;
    
    if (iPhone5) {
        offset = b ? 20 : -20;
        
        self.tableBgView.frame = CGRectOffset(self.tableBgView.frame, 0, offset);
        self.bgImageView.frame = CGRectOffset(self.bgImageView.frame, 0, offset);
        
        self.leftButton.frame = CGRectOffset(self.leftButton.frame, 0, offset);
        self.rightButton.frame = CGRectOffset(self.rightButton.frame, 0, offset);
        self.startButton.frame = CGRectOffset(self.startButton.frame, 0, offset/2);
        
    }else{
        offset = b ? 50 : -50;
        frame = self.tableBgView.frame;
        frame.origin.y += offset;
        frame.size.height -= offset;
        self.tableBgView.frame = frame;
        
        frame = self.bgImageView.frame;
        frame.origin.y += offset;
        frame.size.height -= offset;
        self.bgImageView.frame = frame;
        [self.bgImageView setImage:(b ? [UIImage imageNamed:@"free_run_courses_bg"] : [UIImage imageNamed:@"run_courses_bg"])];
        
        self.leftButton.frame = CGRectOffset(self.leftButton.frame, 0, offset/2);
        self.rightButton.frame = CGRectOffset(self.rightButton.frame, 0, offset/2);
        self.startButton.frame = CGRectOffset(self.startButton.frame, 0, offset/5);
        
    }
    
    
}

@end
