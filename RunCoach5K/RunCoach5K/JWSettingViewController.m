//
//  JWSettingViewController.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/5/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWSettingViewController.h"
#import "SWRevealViewController.h"
#import "UIBarButtonItem+Addtions.h"
#import "JWAppSetting.h"
#import "TB_Setting.h"
#import "JWSegmentedControl.h"
#import "JWReminderViewController.h"
#import <CoreLocation/CoreLocation.h>

#ifdef VERSION_FREE
#import "JWUpgradeViewController.h"
#endif

#ifndef VERSION_FREE
char *SettingCellTitle[SettingCellCount] = {"Beep", "Voice", "Auto Lock", "Vibrate", "Coach Voice", "Distance Unit", "Reminder"};
int SettingScetion[SettingSectionCount] = {6, 1};
#else
char *SettingCellTitle[SettingCellCount] = {"Beep", "Voice", "Auto Lock", "Vibrate", "Coach Voice", "Distance Unit", "Reminder", "Upgrade"};
int SettingScetion[SettingSectionCount] = {6, 1, 1};
#endif


@interface JWSettingViewController ()

@property (nonatomic, strong) UITableView        *tableView;
@property (nonatomic, strong) JWSegmentedControl *coachSegment;
@property (nonatomic, strong) JWSegmentedControl *distabceSegment;

@end

@implementation JWSettingViewController
- (void)dealloc
{
#ifdef SETTING_DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
        self.coachSegment = nil;
        self.distabceSegment = nil;
    }

}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
    }
    return self;
}

-(void)loadView{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kBackgroundColor;
    self.view = view;
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, 300, 416)
                                                      style:UITableViewStyleGrouped];
    if (iPhone5) {
        table.frame = CGRectMake(10, 0, 300, 504);
    }
    [self.view addSubview:table];
    table.backgroundView = nil;
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSelectionStyleNone;
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    self.tableView = table;
    self.tableView.separatorColor = kTableCellSeparatorColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundView = bgView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *back = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_advances"] target:revealController action:@selector(revealToggle:) Offset:-20];
    self.navigationItem.leftBarButtonItem = back;
    kNavTitle(@"Settings", self);
        
}

#ifdef VERSION_FREE
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    BannerViewController *banner = [BannerViewController sharedBanner];
    banner.delegate = self;
    [self.view addSubview:banner.view];
}
#endif


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (void)switchValueChange:(id)sender{
    if (![sender isKindOfClass:[UISwitch class]]) {
        return;
    }
    UISwitch *settingSwitch = (UISwitch *)sender;
    JWAppSetting *appSetting = [JWAppSetting shareAppSetting];
    switch (settingSwitch.tag) {
        case BeepCell:
        {
            appSetting.setting.beep = [NSNumber numberWithBool:settingSwitch.on];
            NSError *error;
            [appSetting.setting.managedObjectContext save:&error];
        }
            break;
        case VoiceCell:
        {
            appSetting.setting.voidce = [NSNumber numberWithBool:settingSwitch.on];
            NSError *error;
            [appSetting.setting.managedObjectContext save:&error];
        }
            break;
        case AutoLockCell:
        {
            appSetting.setting.autoLock = [NSNumber numberWithBool:settingSwitch.on];
            NSError *error;
            [appSetting.setting.managedObjectContext save:&error];
        }
            break;
        case VibrateCell:
        {
            appSetting.setting.vibrate = [NSNumber numberWithBool:settingSwitch.on];
            NSError *error;
            [appSetting.setting.managedObjectContext save:&error];
            
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - costom

-(UISwitch *)takeSwitch{
    UISwitch *settingSwitvh = [[UISwitch alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 6.0) {
//        settingSwitvh.tintColor = kRGB255UIColor(29, 29, 29, 1.f);
//      settingSwitvh.thumbTintColor = [UIColor whiteColor];
    }
    settingSwitvh.onTintColor = kdefaultYellowColor;
    return settingSwitvh;
}

-(NSInteger)typeWithIndexPath:(NSIndexPath *)indexPath{
    int type = 0;
    for (int i = 0; i < indexPath.section; i ++) {
        type += [self.tableView numberOfRowsInSection:i];
    }
    type += indexPath.row;
    return type;
}

-(JWSegmentedControl *)coachSegment{
    if (!_coachSegment) {
        self.coachSegment  = [[JWSegmentedControl alloc] initWithImages:@[[UIImage imageNamed:@"btn_m"],
                                                                          [UIImage imageNamed:@"btn_f"]]
                                                           SelectImages:@[[UIImage imageNamed:@"btn_select_m"],
                                                                          [UIImage imageNamed:@"btn_select_f"]]];
        [_coachSegment addaction:^(id sender){
            if ([sender selectedIndex] == 0) {
                [[JWAppSetting shareAppSetting] setting].coachVoice = @"m";
            }else if ([sender selectedIndex] == 1){
                [[JWAppSetting shareAppSetting] setting].coachVoice = @"f";
            }
            NSError *error;
            [[[JWAppSetting shareAppSetting] setting].managedObjectContext save:&error];
        }];
    }
    return _coachSegment;
}

-(JWSegmentedControl *)distabceSegment{
    if (!_distabceSegment) {
        self.distabceSegment = [[JWSegmentedControl alloc] initWithImages:@[[UIImage imageNamed:@"btn_mi"],
                                                                            [UIImage imageNamed:@"btn_km"]]
                                                             SelectImages:@[[UIImage imageNamed:@"btn_select_mi"],
                                                                            [UIImage imageNamed:@"btn_select_km"]]];
        [_distabceSegment addaction:^(id sender){
            if ([sender selectedIndex] == 0) {
                [[JWAppSetting shareAppSetting] setting].distanceUnit = @"mi";
            }else if ([sender selectedIndex] == 1){
                [[JWAppSetting shareAppSetting] setting].distanceUnit = @"km";
            }
            NSError *error;
            [[[JWAppSetting shareAppSetting] setting].managedObjectContext save:&error];
        }];
    }
    return _distabceSegment;
}

#pragma mark - table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SettingSectionCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return SettingScetion[section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.backgroundColor = kTableCellBackgroundColor;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.textLabel.textColor = kdefaultTextColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mrak - table view delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
    int type = [self typeWithIndexPath:indexPath];
#ifdef SETTING_DEBUG
    NSLog(@"%s display type : %d", __FUNCTION__, type);
#endif
    cell.textLabel.text = [NSString stringWithUTF8String:SettingCellTitle[type]];
    UISwitch *settingSwitch = nil;
    UISegmentedControl *settingSegment = nil;
    if ([cell.accessoryView isKindOfClass:[UISwitch class]]) {
        settingSwitch = (UISwitch*)cell.accessoryView;
    }else if ([cell.accessoryView isKindOfClass:[UISegmentedControl class]]) {
        settingSegment = (UISegmentedControl*)cell.accessoryView;
    }
    JWAppSetting *appSetting = [JWAppSetting shareAppSetting];
    switch (type) {
        case BeepCell:
        case VoiceCell:
        case AutoLockCell:
        case VibrateCell:
        {
            if (!settingSwitch) {
                settingSwitch = [self takeSwitch];
                [settingSwitch addTarget:self
                                  action:@selector(switchValueChange:)
                        forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = settingSwitch;
            }
            settingSwitch.tag = type;
            if (type == BeepCell) {
                settingSwitch.on = appSetting.setting.beep.boolValue;
            }else if (type == VoiceCell) {
                settingSwitch.on = appSetting.setting.voidce.boolValue;
            }else if (type == AutoLockCell){
                settingSwitch.on = appSetting.setting.autoLock.boolValue;
            }else {
                settingSwitch.on = appSetting.setting.vibrate.boolValue;
            }
        }
            break;
        case CoachVoiceCell:{
            cell.accessoryView = self.coachSegment;
            self.coachSegment.selectedIndex = [appSetting.setting coachVoiceIndex];
        }
            break;
        case DistanceUnitCell:{
            cell.accessoryView = self.distabceSegment;
            self.distabceSegment.selectedIndex = [appSetting.setting distabceUnitIndex];
        }
            break;
        case ReminderCell:{
            UIImage *image = [UIImage imageNamed:@"cell_arrow"];
            cell.accessoryView = [[UIImageView alloc] initWithImage:image];
        }
            break;
#ifdef VERSION_FREE
        case UpdagradeCell:{
            UIImage *image = [UIImage imageNamed:@"cell_arrow"];
            cell.accessoryView = [[UIImageView alloc] initWithImage:image];
        }
            break;
#endif
            
        default:
            break;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        JWReminderViewController *reminderCon = [[JWReminderViewController alloc] init];
        [self.navigationController pushViewController:reminderCon animated:YES];
    }
#ifdef VERSION_FREE
    if (indexPath.section == 2) {
        //进入购买页面
        JWUpgradeViewController *upgrade = [[JWUpgradeViewController alloc] init];
        [self.navigationController pushViewController:upgrade animated:YES];
        
    }
#endif
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0 ? 0.f : 0.1f;
}

#pragma mark - AD delegate

-(void)ADIsComing:(BOOL)b{
    int offset = b ? 50 : -50;
    CGRect frame = self.tableView.frame;
    frame.origin.y += offset;
    frame.size.height -= offset;
    self.tableView.frame = frame;
}

@end
