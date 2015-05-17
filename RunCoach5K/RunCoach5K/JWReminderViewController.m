//
//  JWReminderViewController.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/12/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWReminderViewController.h"
#import "UIBarButtonItem+Addtions.h"
#import "TB_Reminder.h"
#import "JWAppDelegate.h"
#import "NoticeManager.h"
#import "JWSelectWeekDayView.h"
#import "Note.h"

@interface JWReminderViewController ()

@property (nonatomic, strong) TB_Reminder *reminder;
@property (nonatomic, strong) JWSelectWeekDayView *selectWeekDay;
@property (nonatomic, strong) NoteCell *noteCell;
@property (nonatomic, weak) UIDatePicker *timePicker;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UITextField *pickFild;

@end

@implementation JWReminderViewController

@synthesize reminder =_reminder;
@synthesize selectWeekDay = _selectWeekDay;
@synthesize noteCell = _noteCell;
@synthesize timePicker = _timePicker;
@synthesize timeLabel = _timeLabel;


- (void)dealloc
{
#ifdef SETTING_DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    UIBarButtonItem *backButton = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_settings"]
                                                                         target:self
                                                                         action:@selector(back) Offset:-10];
    self.navigationItem.leftBarButtonItem = backButton;
    kNavTitle(@"Reminder", self);

    self.tableView.backgroundColor = kBackgroundColor;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kBackgroundColor;
    self.tableView.backgroundView = view;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = kTableCellSeparatorColor;
    self.reminder = [NoticeManager oneReminder];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    self.selectWeekDay = [[[NSBundle mainBundle] loadNibNamed:@"SelectWeekDay"
                                                        owner:self
                                                      options:nil] objectAtIndex:0];
    __weak JWReminderViewController *reminderCon = self;
    self.selectWeekDay.repeatBlock = ^(id sender){
        JWSelectWeekDayView *weekDayView = (JWSelectWeekDayView *)sender;
        reminderCon.reminder.repeat = [NSNumber numberWithInt:weekDayView.repeat];
    };
    
    
    
    UITextField *textFild = [[UITextField alloc] init];
    textFild.hidden = YES;
    self.tableView.tableHeaderView = textFild;
    self.pickFild = textFild;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.frame = CGRectMake(0, 416, 320, 216);
    textFild.inputView = datePicker;
    self.timePicker = datePicker;
    self.timePicker.datePickerMode = UIDatePickerModeTime;
    self.timePicker.date = [self.reminder.time copy];
    [self.timePicker addTarget:self action:@selector(timeChange:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - costom

-(NoteCell *)noteCell{
    if (!_noteCell) {
        NoteCell *cell = [[NoteCell alloc] initWithReuseIdentifier:[NoteCell identifier]
                                                    tableViewStyle:UITableViewStyleGrouped];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.string = self.reminder.note;
        self.noteCell = cell;
    }
    return _noteCell;
}

-(void)back{
    self.reminder.note = self.noteCell.string;
    JWAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)timeChange:(id)sender{
    self.timeLabel.text = [NSDateFormatter localizedStringFromDate:[sender date]
                                                         dateStyle:NSDateFormatterNoStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    self.reminder.time = [sender date];
}

-(void)enterBackground:(NSNotification *)notification{
    self.reminder.note = self.noteCell.string;
    JWAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];
}

-(void)reminderSwitchChange:(id)sender{
    UISwitch *settingSwitch = (UISwitch*)sender;
    self.reminder.enable = [NSNumber numberWithBool:settingSwitch.on];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return self.noteCell;
    }
    NSString *CellIdentifier = [NSString stringWithFormat:@"ReminderCell%d",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.backgroundColor = kTableCellBackgroundColor;
        cell.textLabel.textColor = kdefaultTextColor;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.detailTextLabel.textColor = kdefaultTextColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Enable Notification";
        UISwitch *settingSwitvh = [[UISwitch alloc] init];
        [settingSwitvh addTarget:self
                          action:@selector(reminderSwitchChange:)
                forControlEvents:UIControlEventTouchUpInside];
        settingSwitvh.onTintColor = kdefaultYellowColor;
        settingSwitvh.on = self.reminder.enable.doubleValue;
        cell.accessoryView = settingSwitvh;
        cell.detailTextLabel.text = nil;
    }else if (indexPath.row == 1){
        [cell addSubview:self.selectWeekDay];
        self.selectWeekDay.repeat = self.reminder.repeat.intValue;
        cell.detailTextLabel.text = nil;
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"Time";
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
        cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:self.reminder.time
                                                                   dateStyle:NSDateFormatterNoStyle
                                                                   timeStyle:NSDateFormatterShortStyle];
        self.timeLabel = cell.detailTextLabel;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40.f;
    }
    return 0.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return [NoteHeaderView view];
    }
    return nil;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        self.noteCell.noteViewController.isNotificationText = YES;
        [self.navigationController pushViewController:self.noteCell.noteViewController animated:YES];
        
    }else if (indexPath.row == 2){
        if ([self.pickFild isFirstResponder])
            [self.pickFild resignFirstResponder];
        else
            [self.pickFild becomeFirstResponder];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1){
        NSLog(@"%f",self.noteCell.noteCellHeight);
        return self.noteCell.noteCellHeight;
    }
    else
        return 44.f;
}





@end
