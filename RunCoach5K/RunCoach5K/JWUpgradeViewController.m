//
//  JWUpgradeViewController.m
//  RunCoach5K
//
//  Created by YQ-011 on 11/28/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWUpgradeViewController.h"
#import "UIBarButtonItem+Addtions.h"
#import "JWInAppPurchaseManager.h"
#import "SKProduct+LocalizedPrice.h"

@interface JWUpgradeViewController ()

@property (nonatomic, weak) JWInAppPurchaseManager *inAppPurchaseManager;

@end

@implementation JWUpgradeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    UIView *view = [[UIView alloc] init];
    self.view = view;
    self.view.backgroundColor = kBackgroundColor;
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)
                                                      style:UITableViewStyleGrouped];
    if (iPhone5) {
        table.frame = CGRectMake(0, 0, 320, 504);
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
    
    UIView *bootomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    bootomView.backgroundColor = [UIColor clearColor];
    UIButton *restore = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, 320, 50)];
    [restore setImage:[UIImage imageNamed:@"btn_restore"] forState:UIControlStateNormal];
    [restore addTarget:self action:@selector(restore) forControlEvents:UIControlEventTouchUpInside];
    [bootomView addSubview:restore];
    self.tableView.tableFooterView = bootomView;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *back = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_settings"]
                                                                   target:self
                                                                   action:@selector(back) Offset:-10];
    self.navigationItem.leftBarButtonItem = back;
    kNavTitle(@"Upgrade", self);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endRequest) name:kInAppPurchaseManagerProductsFetchedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionFailed) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionSucceed) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
    
    self.inAppPurchaseManager = [JWInAppPurchaseManager shareInAppPurchaseManager];
    if (self.inAppPurchaseManager.proUpgradeProductArray.count == 0) {
        UIView *view_space = [[UIView alloc] initWithFrame:self.tableView.frame];
        view_space.tag = 1001;
        view_space.backgroundColor = [UIColor clearColor];
        UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        centerView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:.5f];
        centerView.center = view_space.center;
        centerView.layer.cornerRadius = 10;
        centerView.layer.masksToBounds = YES;
        [view_space addSubview:centerView];
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:
                                             UIActivityIndicatorViewStyleWhiteLarge];
        activity.center = centerView.center;
        [view_space addSubview:activity];
        [activity startAnimating];
        [self.view addSubview:view_space];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

-(void)back{
    [self.inAppPurchaseManager.productsRequest cancel];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)endRequest{
    [[self.view viewWithTag:1001] removeFromSuperview];
    [self.tableView reloadData];
}

-(void)transactionFailed{
    [[self.view viewWithTag:1001] removeFromSuperview];
    [self.tableView reloadData];
}

-(void)transactionSucceed{
    [[self.view viewWithTag:1001] removeFromSuperview];
    [self.tableView reloadData];
    NSLog(@"%d",[self.inAppPurchaseManager haveToBuyWithId:kInAppPurchaseProUpgradeADsProductId]);
}

-(void)restore{
    UIView *view_space = [[UIView alloc] initWithFrame:self.tableView.frame];
    view_space.tag = 1001;
    view_space.backgroundColor = [UIColor clearColor];
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    centerView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:.5f];
    centerView.center = view_space.center;
    centerView.layer.cornerRadius = 10;
    centerView.layer.masksToBounds = YES;
    [view_space addSubview:centerView];
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle:
                                         UIActivityIndicatorViewStyleWhiteLarge];
    activity.center = centerView.center;
    [view_space addSubview:activity];
    [activity startAnimating];
    [self.view addSubview:view_space];
    
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
    
}

#pragma mark - table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.inAppPurchaseManager.proUpgradeProductArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"tioCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:Identifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kTableCellBackgroundColor;
        cell.backgroundView = view;
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textColor = kdefaultTextColor;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.textColor = kdefaultTextColor;
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SKProduct *proU = [self.inAppPurchaseManager.proUpgradeProductArray objectAtIndex:indexPath.section];
    
    if ([self.inAppPurchaseManager haveToBuyWithId:proU.productIdentifier]) {
        cell.accessoryView = Nil;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ for %@",proU.localizedTitle, proU.localizedPrice];
    cell.detailTextLabel.text = proU.localizedDescription;
    return cell;
}

#pragma mark - table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SKProduct *proU = [self.inAppPurchaseManager.proUpgradeProductArray objectAtIndex:indexPath.section];
    if ([self.inAppPurchaseManager haveToBuyWithId:proU.productIdentifier]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"You have already owned %@.",proU.localizedTitle] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    [self.inAppPurchaseManager purchaseProUpgradeWithIndex:indexPath.section];
    
    UIView *view_space = [[UIView alloc] initWithFrame:self.tableView.frame];
    view_space.tag = 1001;
    view_space.backgroundColor = [UIColor clearColor];
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    centerView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:.5f];
    centerView.center = view_space.center;
    centerView.layer.cornerRadius = 10;
    centerView.layer.masksToBounds = YES;
    [view_space addSubview:centerView];
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle:
                                         UIActivityIndicatorViewStyleWhiteLarge];
    activity.center = centerView.center;
    [view_space addSubview:activity];
    [activity startAnimating];
    [self.view addSubview:view_space];

}


@end
