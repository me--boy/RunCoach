//
//  JWRunningViewController.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/15/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWRunningViewController.h"
#import "UIBarButtonItem+Addtions.h"
#import "JWTutorial.h"
#import "JWHourglassView.h"
#import "JWVerticalSliderView.h"
#import "JWAppSetting.h"
#import <MapKit/MapKit.h>
#import "JWSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>
#import "JWMapManager.h"
#import "JWAppDelegate.h"
#import "TB_History.h"
#import "TB_tutorial.h"
#import "JWTutorialsManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "JWACHVManager.h"
#import "Reachability.h"
#import "TB_Setting.h"
#import "JWInAppPurchaseManager.h"


//#define kForiPhone5(a,b) (iPhone5 ? a : b)

#define kHourglassCentre    iPhone5 ? (CGPoint){110, 210} : (CGPoint){110, 180}
#define kSliderCentre   iPhone5 ? (CGPoint){160, 430} : (CGPoint){160, 380}
#define kProgressBarCentre iPhone5 ? (CGPoint){270, 215} : (CGPoint){270, 185}
#define kStageLabelCentre (CGPoint){78,27}
#define klabelBgImageViewCentre (CGPoint){78,268}

@interface JWRunningViewController (){
    BOOL hasMusic;//听音乐
}

@property (nonatomic, strong) JWTutorial *runningTutorial;
@property (nonatomic, strong) JWRunningManager *runningManager;
@property (nonatomic, strong) JWMapManager *mapManager;

@property (nonatomic, strong) Reachability *hostReach;

@property (nonatomic, weak) JWSliderView *sliderView;
@property (nonatomic, weak) JWHourglassView *hourglassView;
@property (nonatomic, weak) JWVerticalSliderView *progressBar;

@property (nonatomic, weak) UIScrollView *backgroundScrollerView;
@property (nonatomic, weak) UILabel *stageLabel;
@property (nonatomic, weak) UILabel *elapsedLabel;
@property (nonatomic, weak) UILabel *remainingLabel;
@property (nonatomic, weak) UIImageView *labelBgImageView;//底部两个label的背景
@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, weak) JWSegmentedControl *mapTypeSegment;
@property (nonatomic, weak) UILabel *distanceLabel;
@property (nonatomic, weak) UILabel *currentSpeedLabel;
@property (nonatomic, weak) UILabel *mapTimeLabel;

@property (nonatomic, weak) UIAlertView *showAlertView;


@end

@implementation JWRunningViewController

@synthesize runningTutorial = _runningTutorial;
@synthesize runningManager = _runningManager;
@synthesize mapManager = _mapManager;

- (void)dealloc
{
#ifdef RUN_DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
    [UIApplication sharedApplication].idleTimerDisabled= NO;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
        self.mapManager = nil;
        self.runningManager = nil;
        self.runningTutorial = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    [self.hostReach stopNotifier];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:[UIApplication sharedApplication]];
}

-(id)initWithTutorial:(JWTutorial *)tutorial{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.runningTutorial = tutorial;
        self.runningManager = [[JWRunningManager alloc] initWith:tutorial];
        self.runningManager.delegate = self;
#ifdef VERSION_FREE
        if ([[JWInAppPurchaseManager shareInAppPurchaseManager] haveToBuyWithId:kInAppPurchaseProUpgradeMapProductId]) {
            self.mapManager = [[JWMapManager alloc] init];
        }
#else
        self.mapManager = [[JWMapManager alloc] init];
#endif
        
        
        
    }
    return self;
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
    view.backgroundColor = kBackgroundColor;
    self.view = view;
    kNavTitle(_runningTutorial.name, self);
    
    UIBarButtonItem *stop = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_end"]
                                                                   target:self
                                                                   action:@selector(back) Offset:-10];
    self.navigationItem.leftBarButtonItem = stop;
    
    UIBarButtonItem *barButton = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_map"]
                                                                        target:self
                                                                        action:@selector(changeShowView:) Offset:20];
    self.navigationItem.rightBarButtonItem = barButton;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    scrollView.contentSize = CGSizeMake(640, 416);
    if (iPhone5) {
        scrollView.frame = CGRectMake(0, 0, 320, 504);
    }
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = NO;
    [self.view addSubview:scrollView];
    self.backgroundScrollerView = scrollView;
    
    //横向滑块
    JWSliderView *slider = [[JWSliderView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    slider.center = kSliderCentre;
    slider.delegate = self;
    [self.backgroundScrollerView addSubview:slider];
    self.sliderView = slider;
    
    
    //竖向滑块
    JWVerticalSliderView *verticalSlider = [[JWVerticalSliderView alloc]
                                            initWithStagesValue:[NSArray arrayWithObjects:self.runningTutorial.stagetypes,
                                                                 self.runningTutorial.stageTimes, nil]
                                            total:self.runningTutorial.totoalTime];
    verticalSlider.center = kProgressBarCentre;
    [self.backgroundScrollerView addSubview:verticalSlider];
    
    __weak JWRunningManager *running = self.runningManager;//防止形成循环引用
    [verticalSlider setAction:^(id sender) {
        JWVerticalSliderView *vertical = sender;
        [running changeStageto:vertical.selectIndex];
    }];
    self.progressBar = verticalSlider;
    
    //沙漏
    JWHourglassView *hourglass = [JWHourglassView shareHourglassUse:YES];
    hourglass.center = kHourglassCentre;
    [self.backgroundScrollerView addSubview:hourglass];
    self.hourglassView = hourglass;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    UILabel *warm = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 23)];
    warm.textColor = [UIColor yellowColor];
    warm.adjustsFontSizeToFitWidth = YES;
    warm.minimumFontSize = 11.f;
    warm.font = [UIFont boldSystemFontOfSize:12];
    warm.backgroundColor = [UIColor clearColor];
    warm.center = kStageLabelCentre;
    warm.textAlignment = UITextAlignmentCenter;
    [self.hourglassView addSubview:warm];
    self.stageLabel = warm;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"running_timer_bottom_bg"]];
    imageView.center = klabelBgImageViewCentre;
    [self.hourglassView addSubview:warm];
    self.labelBgImageView = imageView;
    
    
    UILabel *elapsed = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.labelBgImageView.frame.size.width, 15)];
    elapsed.font = [UIFont boldSystemFontOfSize:12];
    elapsed.adjustsFontSizeToFitWidth = YES;
    elapsed.minimumFontSize = 10.f;
    elapsed.backgroundColor = [UIColor clearColor];
    elapsed.textAlignment = UITextAlignmentCenter;
    [self.labelBgImageView addSubview:elapsed];
    self.elapsedLabel = elapsed;
    
    UILabel *remaining = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, self.labelBgImageView.frame.size.width, 15)];
    remaining.font = [UIFont boldSystemFontOfSize:12];
    remaining.adjustsFontSizeToFitWidth = YES;
    remaining.minimumFontSize = 10.f;
    remaining.backgroundColor = [UIColor clearColor];
    remaining.textAlignment = UITextAlignmentCenter;
    [self.labelBgImageView addSubview:remaining];
    self.remainingLabel = remaining;
    
    [self.runningManager begin];
    
    MPMusicPlayerController *mudic = [MPMusicPlayerController iPodMusicPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(beginMusic:)
                                                 name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                               object:mudic];
    [mudic beginGeneratingPlaybackNotifications];
    if (mudic.playbackState == MPMusicPlaybackStatePlaying) {
        hasMusic = YES;
    }
    

    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    self.hostReach = [Reachability reachabilityWithHostname:@"www.apple.com"];//可以以多种形式初始化
    [_hostReach startNotifier];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground:) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    
    //不自动锁屏
    [UIApplication sharedApplication].idleTimerDisabled = ![[JWAppSetting shareAppSetting] AutoLock];
    

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
#ifdef VERSION_FREE
    BannerViewController *banner = [BannerViewController sharedBanner];
    banner.delegate = self;
    [self.backgroundScrollerView addSubview:banner.view];
    
#endif

}

-(void)loadMapView{
    //加载地图页面
    if (!self.mapView) {
        MKMapView *map = [[MKMapView alloc] initWithFrame:CGRectMake(330, 60, 300, 336)];
        if (iPhone5) {
            map.frame = CGRectMake(330, 60, 300, 420);
        }
        [self.backgroundScrollerView addSubview:map];
        map.layer.borderWidth = 3.f;
        map.layer.borderColor = [kRGB255UIColor(255, 179, 0, 1.f) CGColor];
        self.mapView = map;
        self.mapManager.mapView = map;
        map.delegate = self.mapManager;
        
        JWSegmentedControl *segment = [[JWSegmentedControl alloc] initWithImages:@[[UIImage imageNamed:@"btn_street"],
                                                                                   [UIImage imageNamed:@"btn_satellite"],
                                                                                   [UIImage imageNamed:@"btn_hybrid"]]
                                                                    SelectImages:@[[UIImage imageNamed:@"btn_select_street"],
                                                                                   [UIImage imageNamed:@"btn_select_satellite"],
                                                                                   [UIImage imageNamed:@"btn_select_hybrid"]]];
        segment.center = CGPointMake(480, 30);
        [self.backgroundScrollerView addSubview:segment];
        self.mapTypeSegment = segment;
        segment.selectedIndex = 0;
        
        __weak MKMapView *wMap = self.mapView;
        [segment addaction:^(id sender) {
            wMap.mapType = [sender selectedIndex];
        }];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(150, 260, 150, 60)];
        if (iPhone5) {
            view.frame = CGRectMake(150, 344, 150, 60);
        }
        view.backgroundColor = kRGB255UIColor(255, 255, 255, 0.5f);
        [map addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 140, 18)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:13];
        [view addSubview:label];
        self.distanceLabel = label;
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 18, 140, 18)];
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = [UIColor blackColor];
        label1.font = [UIFont systemFontOfSize:13];
        [view addSubview:label1];
        self.mapTimeLabel = label1;
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 36, 140, 18)];
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor blackColor];
        label2.font = [UIFont systemFontOfSize:13];
        [view addSubview:label2];
        self.currentSpeedLabel = label2;
        
        label.adjustsFontSizeToFitWidth = label1.adjustsFontSizeToFitWidth = label2.adjustsFontSizeToFitWidth = YES;
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
            label.minimumFontSize = label1.minimumFontSize = label2.minimumFontSize = 10;
        }else{
            label.minimumScaleFactor = label1.minimumFontSize = label2.minimumFontSize = .7f;
        }
        
        self.mapTimeLabel.text = self.elapsedLabel.text;
        self.distanceLabel.text = [NSString stringWithFormat:@"Distance: %@",[[JWAppSetting shareAppSetting] distanceStringWith:self.mapManager.roadDistance ]];
        self.currentSpeedLabel.text = [NSString stringWithFormat:@"Current Speed: %@",[[JWAppSetting shareAppSetting] speedStringWith:self.mapManager.instantaneousSpeed]];
        
    }
    [self.mapManager refreshAllRouteline];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

#pragma mark - get/set


#pragma mark - action

#ifdef VERSION_FREE

-(void)transactionFailed{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
}

-(void)transactionSucceed{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
    
    
    if ([[JWInAppPurchaseManager shareInAppPurchaseManager] haveToBuyWithId:kInAppPurchaseProUpgradeMapProductId]) {
        if (!self.mapManager) {
            self.mapManager = [[JWMapManager alloc] init];
            [self.mapManager beginRoadLog];
        }
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status ||
            kCLAuthorizationStatusRestricted == status) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Failed"
                                                            message:@"To use GPS tracking, please ensure location services are enabled for Run Coach."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            self.showAlertView = alert;
            return;
        }else{
            [self.backgroundScrollerView scrollRectToVisible:CGRectMake(320, 0, 320, 416) animated:YES];
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_time"]
                                                               target:self
                                                               action:@selector(changeShowView:) Offset:20];
            [self loadMapView];
        }

    }
    
}

#endif

-(void)enterForeground:(NSNotification *)noti{
    if (self.backgroundScrollerView.contentOffset.x == 320) {
        [self.mapManager refreshAllRouteline];
    }

}

// 连接改变
- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
}

//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == NotReachable) {  //没有连接到网络就弹出提实况
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status ||
            kCLAuthorizationStatusRestricted == status || ![CLLocationManager locationServicesEnabled]) {
            return;
        }
        if (!self.showAlertView) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"To use GPS tracking, please ensure Wifi or cellular data is enabled."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            self.showAlertView = alert;
        }
    }
    
}

-(void)beginMusic:(NSNotification *)noti{
#ifdef RUN_DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
    MPMusicPlayerController *playerCon = [MPMusicPlayerController iPodMusicPlayer];
    if (playerCon.playbackState == MPMusicPlaybackStatePlaying) {
        hasMusic = YES;
    }
}

-(void)back{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"You are stopping the tutorial before it automatically ends."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Stop & Save", @"Stop & Delete", nil];
    alert.tag = 101;
    [alert show];
    self.showAlertView = alert;
}

-(void)changeShowView:(id)sender{
    
#ifdef VERSION_FREE
    if (![[JWInAppPurchaseManager shareInAppPurchaseManager] haveToBuyWithId:kInAppPurchaseProUpgradeMapProductId]) {
        if (![[JWInAppPurchaseManager shareInAppPurchaseManager] canMakePurchasesWithId:kInAppPurchaseProUpgradeMapProductId]) {
            return;
        }
        UIAlertView *buy = [[UIAlertView alloc] initWithTitle:@"Upgrade"
                                                      message:[NSString stringWithFormat:@"Do you want to buy map module for %@?",[[JWInAppPurchaseManager shareInAppPurchaseManager] priceStringWithId:kInAppPurchaseProUpgradeMapProductId]]
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Buy", nil];
        buy.tag = 1234;
        [buy show];
        self.showAlertView = buy;
        return;
    }
#endif
    
    
    UIBarButtonItem *barButton;
    if (self.backgroundScrollerView.contentOffset.x == 0) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status ||
             kCLAuthorizationStatusRestricted == status) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Failed"
                                                            message:@"To use GPS tracking, please ensure location services are enabled for Run Coach."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            self.showAlertView = alert;
            return;
            }else{
                [self.backgroundScrollerView scrollRectToVisible:CGRectMake(320, 0, 320, 416) animated:YES];
                barButton = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_time"]
                                                                   target:self
                                                                   action:@selector(changeShowView:) Offset:20];
                [self loadMapView];
            }
    }else{
        [self.backgroundScrollerView scrollRectToVisible:CGRectMake(0, 0, 320, 416) animated:YES];
        barButton = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_map"]
                                                           target:self
                                                           action:@selector(changeShowView:) Offset:20];
        [self.mapManager noRefreshMapView];
    }
    self.navigationItem.rightBarButtonItem = barButton;
}

-(void)saveHistory:(BOOL)finish mapFile:(NSString *)fileName{
    if ([self.runningManager totalElapsedtime] == 0) {
        return;
    }
    JWAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TB_History" inManagedObjectContext:delegate.managedObjectContext];
    TB_History *history = [[TB_History alloc] initWithEntity:entity insertIntoManagedObjectContext:delegate.managedObjectContext];
    TB_tutorial *tutorial = [JWTutorialsManager tb_tutorialWithId:self.runningTutorial.tutorialId];
    if (finish && !tutorial.tutorialFinish.boolValue) {
        tutorial.tutorialFinish = @YES;
        tutorial.finishDate = [NSDate date];
    }
    history.tutorial = tutorial;
    history.totalTime = [NSString stringWithFormat:@"%d",[self.runningManager totalElapsedtime]];
    history.happenTime = [NSDate date];
    history.hasMusic = hasMusic;
    history.finish = finish;
    if (fileName) {
        history.pathFileName = fileName;
        history.totalDistance = [NSString stringWithFormat:@"%f",self.mapManager.roadDistance];
        history.averageVelocity = [NSNumber numberWithFloat:self.mapManager.roadDistance / self.runningManager.totalElapsedtime];
        history.maxVelocity = [NSNumber numberWithFloat:[self.mapManager maxInstantaneousSpeed]];
        history.gpsGood = self.mapManager.goodGPS;
    }
    [delegate saveContext];
    JWACHVManager *achvManger = [JWACHVManager shareACHVManager];
    [achvManger runEndComputeAchv:history];
}

#pragma mark - runningManager delegate

-(void)runningManager:(JWRunningManager *)manager changetoStage:(NSInteger)index{
//#ifdef RUN_DEBUG
//    NSLog(@"%s, %d",__FUNCTION__,index);
//#endif
    NSString *str = [self.runningTutorial.stageTimes objectAtIndex:index];
    str = [JWAppSetting stringWith:[str floatValue] *60];
    self.stageLabel.text = [NSString stringWithFormat:@"%@: %@",[self.runningTutorial.stagetypes objectAtIndex:index],str];
    self.progressBar.selectIndex = index;
}

-(void)runningManager:(JWRunningManager *)manager Elapsed:(double)elapsed Remaining:(double)remaining{
//#ifdef RUN_DEBUG
//    NSLog(@"%s, %f",__FUNCTION__,elapsed);
//#endif
    JWAppSetting *appSetting = [JWAppSetting shareAppSetting];
    if ([JWAppDelegate applicationIsInForeground]) {
        self.elapsedLabel.text = [NSString stringWithFormat:@"Elapesd: %@",[JWAppSetting stringWith:elapsed]];
        self.remainingLabel.text = [NSString stringWithFormat:@"Remaining: %@",[JWAppSetting stringWith:remaining]];
        self.stageLabel.text = [NSString stringWithFormat:@"%@: %@",
                                [self.runningTutorial.stagetypes objectAtIndex:[manager runningStageIndex]],
                                [JWAppSetting stringWith:[manager getRunStageLastTime]]];
        if ([self.mapManager mapViewIsShow]) {
            self.mapTimeLabel.text = [NSString stringWithFormat:@"Elapesd: %@",[JWAppSetting stringWith:elapsed]];
            self.distanceLabel.text = [NSString stringWithFormat:@"Distance: %@",[appSetting distanceStringWith:self.mapManager.roadDistance ]];
            self.currentSpeedLabel.text = [NSString stringWithFormat:@"Current Speed: %@",[appSetting speedStringWith:self.mapManager.instantaneousSpeed]];
        }
    }
    
    [self.hourglassView refreshViewWithRemaining:remaining];
}

-(void)runningBegin{
    //倒计时结束
    self.sliderView.selected = YES;
    [self.mapManager beginRoadLog];
}

-(void)runningEnd{
    //跑步结束
    [self.hourglassView suspend];
    self.sliderView.selected = NO;
    NSString *filePath = [self.mapManager endAndSaveRoad];
    [self saveHistory:YES mapFile:filePath];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mrak - JWSlider delegate

-(void)sliderDidSlide:(JWSliderView *)slideView{
    //暂停、开始
    if (!slideView.selected) {
        [_runningManager suspend];
        [self.hourglassView suspend];
        [_mapManager suspendRoadLog];
    }else{
        [_runningManager startRun];
        [_mapManager beginRoadLog];
    }
}


#pragma mark - UIAlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
#ifdef VERSION_FREE
    if (alertView.tag == 1234) {
        if (buttonIndex == 1) {
            [[JWInAppPurchaseManager shareInAppPurchaseManager] purchaseProUpgradeWithId:kInAppPurchaseProUpgradeMapProductId];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionFailed) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionSucceed) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
        }
        return;
    }
#endif
    
    
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            //stop and save
            [self.runningManager wasInterrupted];
            self.sliderView.selected = NO;
            [self.hourglassView suspend];
            NSString *filePath = [self.mapManager endAndSaveRoad];
            //#warning 临时修改成完成，用于测试
            [self saveHistory:NO mapFile:filePath];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        if (buttonIndex == 2) {
            //stop and not save
            [self.runningManager wasInterrupted];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
}

#pragma mark - AD delegate

-(void)ADIsComing:(BOOL)b{
    int offSet = b ? 30 : -30;
    self.hourglassView.frame = CGRectOffset(self.hourglassView.frame, 0, offSet);
    self.progressBar.frame = CGRectOffset(self.progressBar.frame, 0, offSet);
    
    
    self.sliderView.frame = CGRectOffset(self.sliderView.frame, 0, offSet/3);
}


@end
