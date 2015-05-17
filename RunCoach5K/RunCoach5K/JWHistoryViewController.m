//
//  JWHistoryViewController.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/5/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWHistoryViewController.h"
#import "SWRevealViewController.h"
#import "UIBarButtonItem+Addtions.h"
#import "JWHistoryManager.h"
#import "JWHistoryCell.h"
#import "JWHistoryDetailViewController.h"
#import "TB_History.h"
#import "TB_tutorial.h"

@interface JWHistoryViewController ()

@property (nonatomic, weak)DCFoldTableView *tableView;
@property (nonatomic, strong)JWHistoryManager *historyManager;

@end

@implementation JWHistoryViewController

#pragma mark - life cycle method 

- (void)dealloc
{
#ifdef HISTORY_DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
    
}

- (id)init
{
    self = [self initWithNibName:nil bundle:nil];
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



-(void)loadView{
    UIView *view = [[UIView alloc] init];
    self.view = view;
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
    kNavTitle(@"History", self);
    
    UIBarButtonItem *edit = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_edit"]
                                                                   target:self
                                                                   action:@selector(editTable:) Offset:10];
    edit.tintColor = kdefaultYellowColor;
    self.navigationItem.rightBarButtonItem = edit;
    
    JWHistoryManager *manager = [[JWHistoryManager alloc] init];
    self.historyManager  = manager;
    
    DCFoldTableView *table = [[DCFoldTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)
                                                              style:UITableViewStylePlain];
    if (iPhone5) {
        table.frame = CGRectMake(0, 0, 320, 504);
    }
    [self.view addSubview:table];
    table.backgroundView = nil;
    table.backgroundColor = [UIColor clearColor];
    table.separatorColor = kRGB255UIColor(100, 100, 100, 1.f);
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView = table;
    self.tableView.dcdataSource = self;
    self.tableView.dcdelegate = self;
    __weak DCFoldTableView *wTable = self.tableView;
    //更新完数据回调
    self.historyManager.endBlock = ^(){
        [wTable reloadData];
    };
    [self.historyManager reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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

#pragma mark - action method

-(void)editTable:(id)sender{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    UIBarButtonItem *edit;
    if (self.tableView.editing) {
        edit = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_done"]
                                                                       target:self
                                                                       action:@selector(editTable:) Offset:10];
    }else{
        edit = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_edit"]
                                                      target:self
                                                      action:@selector(editTable:) Offset:10];
    }
    self.navigationItem.rightBarButtonItem = edit;
}

#pragma mark - fold table view data source

-(NSInteger)numberOfSectionsInDCFoldTable:(UITableView *)tableView{
    return [self.historyManager numberOfSection];
}

-(NSInteger)DCFoldTable:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.historyManager numberObjectsForSection:section];
}

-(UITableViewCell *)DCFoldTable:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"historyCell";
    JWHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JWHistoryCell" owner:nil options:nil] objectAtIndex:0];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    }
    [cell setEntity:[self.historyManager objectAtIndexPath:indexPath]];
    return cell;
}

-(UIView *)DCFoldTable:(UITableView *)tableView ViewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_44px_bg"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 30)];
    //    label.background
    label.text = [NSString stringWithFormat:@"Week %d Day %d",(int)ceil((((float)section + 1)/3)),
                                                                (section + 1)%3 != 0 ? (section + 1)%3 : 3];
    [view addSubview:label];
    
    UILabel *countlabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 5, 90, 30)];
    countlabel.text = [NSString stringWithFormat:@"%d %@", [self.historyManager numberObjectsForSection:section],[self.historyManager numberObjectsForSection:section] > 1 ? @"logs" : @"log"];
    countlabel.textAlignment = UITextAlignmentRight;
    countlabel.font = [UIFont systemFontOfSize:14];
    countlabel.backgroundColor = label.backgroundColor = [UIColor clearColor];
    countlabel.textColor = label.textColor = kdefaultTextColor;
    [view addSubview:countlabel];
    return view;
}

-(BOOL)DCFoldTable:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)DCFoldTable:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        BOOL succeed =  [self.historyManager deleteObjectWithIndex:indexPath];
        if (succeed) {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }
        [tableView endUpdates];
        double delayInSeconds = .3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.tableView reloadData];
        });
    }
}

#pragma mark - fold table view delegate

-(void)DCFoldTable:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JWHistoryDetailViewController *detail = [[JWHistoryDetailViewController alloc] initWithNibName:@"JWHistoryDetailViewController" bundle:nil];
    TB_History *history = [self.historyManager objectAtIndexPath:indexPath];
    kNavTitle(history.tutorial.tutorialName, detail);
    [self.navigationController pushViewController:detail animated:YES];
    [detail setHistory:history];
}

-(CGFloat)DCFoldTable:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.f;
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
