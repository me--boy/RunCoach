//
//  JWTipsViewController.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/5/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWTipsViewController.h"
#import "SWRevealViewController.h"
#import "UIBarButtonItem+Addtions.h"
#import "JWTipHtmlViewController.h"
#import "JWACHVManager.h"

char * tipTitle[10] = {"Foreword", "Skips and Hops", "High Leg Lift", "Back Step", "Leg Folding Run", "Accelerative Running", "Variable-pace Running", "Interval Run", "Timed Run", "Repeat Run"};

@interface JWTipsViewController ()

@property (nonatomic, weak)UITableView *tableView;

@end

@implementation JWTipsViewController

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
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)
                                                      style:UITableViewStylePlain];
    if (iPhone5) {
        table.frame = CGRectMake(0, 0, 320, 504);
    }
    [self.view addSubview:table];
    table.backgroundView = nil;
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView = table;
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
    kNavTitle(@"Tips", self);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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

#pragma mark - table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"tioCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:Identifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_44px_bg"]];
        cell.backgroundView = view;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = kdefaultTextColor;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithUTF8String:tipTitle[indexPath.row]];
    return cell;
}

#pragma mark - table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JWTipHtmlViewController *tipHtml = [[JWTipHtmlViewController alloc] initWithIndex:indexPath.row + 1];
    kNavTitle([NSString stringWithUTF8String:tipTitle[indexPath.row]], tipHtml);
    [self.navigationController pushViewController:tipHtml animated:YES];
    JWACHVManager *manager = [JWACHVManager shareACHVManager];
    [manager tapTipIndex:indexPath.row];
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
