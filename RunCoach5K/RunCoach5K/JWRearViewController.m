//
//  JWRearViewController.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/5/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <sys/types.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>
#import "JWRearViewController.h"
#import "SWRevealViewController.h"
#import "JWSettingViewController.h"
#import "JWRunViewController.h"
#import "JWNavigationController.h"
#import "JWHistoryViewController.h"
#import "JWTipsViewController.h"
#import "JWAchievementsViewController.h"
#import "JWMainCell.h"
#import "JWInAppPurchaseManager.h"

//icon

char *frontIconName[kFrontControlCount] = {"run","history","tips","achievements","settings","contactsupport","ratethisapp"};
char *frontCellName[kFrontControlCount] = {"Run","History","Tips","Achievements","Settings","Send Feedback","Rate this App"};

@interface JWRearViewController (){
    NSInteger _selectCellIndex;
}

@property (nonatomic, strong) UIImageView *achvNotifationView;

@end

@implementation JWRearViewController

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
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(achvCountChange:)
                                                     name:kACHVCountChange
                                                   object:nil];
        
    }
    return self;
}

-(void)loadView{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = kBackgroundColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImageView * navView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_title"]];
    navView.frame = CGRectMake(0, 0, 320, 28);
    navView.contentMode  = UIViewContentModeLeft;
    self.navigationItem.titleView = navView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 430) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc] init];
    tableView.tableFooterView = view;
    tableView.separatorColor = kRGB255UIColor(38, 38, 38, 1.f);
    [self.view addSubview:tableView];
    _selectCellIndex = 0;//默认选择第一个
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 25)];
    [imageView setImage:[UIImage imageNamed:@"total_alertno_bg"]];
    imageView.contentMode = UIViewContentModeCenter;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = kdefaultTextColor;
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = UITextAlignmentCenter;
    label.tag = 123;
    [imageView addSubview:label];
    self.achvNotifationView = imageView;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [self setAchvNotifationCount:[user integerForKey:kACHVCountChange]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //仅在第一次启动时调用
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.view.userInteractionEnabled = NO;
        [self performSelector:@selector(firstRightRevealToggle) withObject:nil afterDelay:.3f];
    });
}

-(void)firstRightRevealToggle{
    SWRevealViewController *revealController = [self revealViewController];
    self.view.userInteractionEnabled = YES;
    NSTimeInterval temp = revealController.toggleAnimationDuration;
    revealController.toggleAnimationDuration = .5f;
    [revealController rightRevealToggleAnimated:YES];
    revealController.toggleAnimationDuration = temp;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    
//    return UIStatusBarStyleDefault;
//}
//
//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}

#pragma mark - costom moth

-(void)achvCountChange:(NSNotification *)notificaiton{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    int count = [userDefault integerForKey:kACHVCountChange];
    NSDictionary *dic = [notificaiton userInfo];
    int change = [[dic objectForKey:kACHVCountChange] integerValue];
    count += change;
    [userDefault setInteger:count forKey:kACHVCountChange];
    [userDefault synchronize];
    [self setAchvNotifationCount:count];
}

-(void)setAchvNotifationCount:(int)count{
    if (count == 0) {
        self.achvNotifationView.hidden = YES;
        return;
    }
    if (count < 10) {
        self.achvNotifationView.hidden = NO;
        self.achvNotifationView.contentMode = UIViewContentModeCenter;
        [self.achvNotifationView setImage:[UIImage imageNamed:@"total_alertno_bg"]];
        UILabel *label = (UILabel *)[self.achvNotifationView viewWithTag:123];
        label.text = [NSString stringWithFormat:@"%d",count];
        return;
    }
    if (count < 100) {
        self.achvNotifationView.hidden = NO;
        UIImage *image = [UIImage imageNamed:@"total_alertno_bg"];
        UIImage *labelBg = [image  stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        self.achvNotifationView.contentMode = UIViewContentModeScaleToFill;
        self.achvNotifationView.image = labelBg;
        UILabel *label = (UILabel *)[self.achvNotifationView viewWithTag:123];
        label.text = [NSString stringWithFormat:@"%d",count];
    }
}

#pragma mark - table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"RearCell";
	JWMainCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell)
	{
		cell = [[[NSBundle mainBundle] loadNibNamed:@"JWMainCell" owner:self options:nil] objectAtIndex:0];
        UIView *view = [[UIView alloc] init];
        cell.backgroundView = view;
        cell.cellText.textColor = kdefaultTextColor;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    if (_selectCellIndex == indexPath.row)
        cell.backgroundView.backgroundColor = [UIColor blackColor];
    else
        cell.backgroundView.backgroundColor = kRGB255UIColor(29, 29, 29, 1.f);
    
    if (indexPath.row == kFrontAchievements) {
        [cell addSubview:self.achvNotifationView];
        self.achvNotifationView.center = CGPointMake(200, 25);
    }
    NSString *iconName = [NSString stringWithFormat:@"icon_%s",frontIconName[indexPath.row]];
    cell.cellImage.image = [UIImage imageNamed:iconName];
	cell.cellText.text = [NSString stringWithUTF8String:frontCellName[indexPath.row]];
    
	
	return cell;

}

#pragma mark - table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int lastSelect = _selectCellIndex;
    
    SWRevealViewController *revealController = [self revealViewController];
    UIViewController *frontViewController = revealController.frontViewController;
    
    UINavigationController *frontNavigationController =nil;
    
    if ([frontViewController isKindOfClass:[UINavigationController class]])
        frontNavigationController = (id)frontViewController;
    
    switch (indexPath.row) {
        case kFrontRun:
        {
            
            if (![frontNavigationController.topViewController isKindOfClass:[JWRunViewController class]]) {
                JWRunViewController *runViewController = [[JWRunViewController alloc] init];
                JWNavigationController *nav = [[JWNavigationController alloc] initWithRootViewController:runViewController];
                [revealController setFrontViewController:nav animated:YES];
            }else{
                [revealController revealToggleAnimated:YES];
            }
            _selectCellIndex = indexPath.row;
        }
            break;
        case kFrontHistory:
        {
            if (![frontNavigationController.topViewController isKindOfClass:[JWHistoryViewController class]]) {
                JWHistoryViewController *history = [[JWHistoryViewController alloc] init];
                JWNavigationController *nav = [[JWNavigationController alloc] initWithRootViewController:history];
                [revealController setFrontViewController:nav animated:YES];
            }else{
                [revealController revealToggleAnimated:YES];
            }
            _selectCellIndex = indexPath.row;
        }
            break;
        case kFrontTips:
        {
            if (![frontNavigationController.topViewController isKindOfClass:[JWTipsViewController class]]) {
                JWTipsViewController *history = [[JWTipsViewController alloc] init];
                JWNavigationController *nav = [[JWNavigationController alloc] initWithRootViewController:history];
                [revealController setFrontViewController:nav animated:YES];
            }else{
                [revealController revealToggleAnimated:YES];
            }
            _selectCellIndex = indexPath.row;
        }
            break;
        case kFrontAchievements:
        {
            
            
            if (![frontNavigationController.topViewController isKindOfClass:[JWAchievementsViewController class]]) {
                
                JWAchievementsViewController *settingCon = [[JWAchievementsViewController alloc] init];
                JWNavigationController *setttingNav = [[JWNavigationController alloc] initWithRootViewController:settingCon];
                [revealController setFrontViewController:setttingNav animated:YES];
                
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                int count = [user integerForKey:kACHVCountChange];
                if (count != 0) {
                    [user setInteger:0 forKey:kACHVCountChange];
                    [user synchronize];
                    [self setAchvNotifationCount:0];
                }
            }else{
                [revealController revealToggleAnimated:YES];
            }
            _selectCellIndex = indexPath.row;
        }
            break;
        case kFrontSetting:
        {
            if (![frontNavigationController.topViewController isKindOfClass:[JWSettingViewController class]]) {
                
                JWSettingViewController *settingCon = [[JWSettingViewController alloc] init];
                JWNavigationController *setttingNav = [[JWNavigationController alloc] initWithRootViewController:settingCon];
                [revealController setFrontViewController:setttingNav animated:YES];
            }else{
                [revealController revealToggleAnimated:YES];
            }
            _selectCellIndex = indexPath.row;
        }
            break;
        case kFrontSendBack:
        {
            [self sendMailComposeController];
//#ifdef DEBUG
//#ifdef VERSION_FREE
//            [[JWInAppPurchaseManager shareInAppPurchaseManager] restore];
//#endif
//#endif
        }
            break;
        case kFrontRateApp:
        {
            NSString *versionPath = [NSString stringWithFormat:@"itms://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",
                                     kAppID];
            [[UIApplication sharedApplication]
             openURL:[NSURL URLWithString:versionPath]];
        }
            break;
            
        default:
            break;
    }

    
    if (lastSelect != _selectCellIndex) {
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelect inSection:0],indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

#pragma mark - mailComposeController delegate

- (NSString *) deviceInfo {
    struct utsname device_info;
    uname(&device_info);
    return [NSString
            stringWithFormat:@"Model: %s\nVersion: %@\nApp: %@\n",
            device_info.machine,
            [[UIDevice currentDevice] systemVersion],
            [[[NSBundle mainBundle] infoDictionary]
             objectForKey:@"CFBundleVersion"]];
}

-(void)sendMailComposeController{
    if (![MFMailComposeViewController canSendMail]) {
        return;
    }
    MFMailComposeViewController *picker =
    [[MFMailComposeViewController alloc] init];
    picker.navigationBar.tintColor = [UIColor blackColor];
    [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    picker.mailComposeDelegate = self;
    [picker setSubject:[NSString stringWithFormat:@"%@ Support", kAppName]];
    [picker setToRecipients:
     [NSArray arrayWithObject:@"applinklinks@gmail.com"]];
    [picker setMessageBody:
     [NSString stringWithFormat:@"%@Feedback here:",
      [self deviceInfo]] isHTML:NO];
    [self presentModalViewController:picker animated:YES];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError *)error{
    // Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
			
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Email"
                                  message:@"Sending Failed - Unknown Error :-("
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
			[alert show];
		}
			
			break;
	}
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
