//
//  JWAchievementsViewController.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/5/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWAchievementsViewController.h"
#import "SWRevealViewController.h"
#import "UIBarButtonItem+Addtions.h"
#import "JWScrollView.h"
#import "JWACHVView.h"
#import "JWPageControl.h"
#import "JWACHVInfoViewController.h"
#import "JWACHVManager.h"

extern const int kACHVCount;
extern char *ACHVName[];
extern char *ACHVImageName[];


@interface JWAchievementsViewController (){

    BOOL firstAppear;
}

@property (nonatomic, weak)JWScrollView *backgroundScrollView;
@property (nonatomic, weak)UIPageControl *pageCon;
@property (nonatomic, strong)NSArray *allAahv;

@end

@implementation JWAchievementsViewController


- (void)dealloc
{
    
#ifdef ACHIEVEMENTS_DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kACHVShareCountFive object:nil];
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:kACHVShareCountFive object:nil];
    }
    return self;
}



-(void)loadView{
    UIView *view = [[UIView alloc] init];
    self.view = view;
    
    JWScrollView * scroll = [[JWScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    scroll.contentSize = CGSizeMake(960, 416);//目前有三页
    if (iPhone5) {
        scroll.frame = CGRectMake(0, 0, 320, 504);
    }
    [self.view addSubview:scroll];
    scroll.pagingEnabled = YES;
    scroll.bounces = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.delegate = self;
    self.backgroundScrollView = scroll;
    UIPageControl *pageCon;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
        pageCon = [[JWPageControl alloc] init];
    }else{
        pageCon = [[UIPageControl alloc] init];
        if ([pageCon respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)]) {
            pageCon.currentPageIndicatorTintColor = kdefaultYellowColor;
        }
    }
    [self.view addSubview:pageCon];
    pageCon.autoresizingMask = UIViewAutoresizingNone;
    pageCon.center = CGPointMake(160, 400);
    if (iPhone5) {
        pageCon.center = CGPointMake(160, 480);
    }
    pageCon.numberOfPages = 3;
    self.pageCon = pageCon;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = kBackgroundColor;
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    self.backgroundScrollView.otherGestureRecognizer = self.revealViewController.panGestureRecognizer;
    UIBarButtonItem *back = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_advances"]
                                                                   target:revealController
                                                                   action:@selector(revealToggle:) Offset:-20];
    self.navigationItem.leftBarButtonItem = back;
    kNavTitle(@"Achievements", self);
    JWACHVManager *manager = [JWACHVManager shareACHVManager];
    self.allAahv = [manager allAchv];
    
    int heightOffset = 0.f;
    if (iPhone5) {
        heightOffset = 70.f;
    }
    
    //只加载第一页，其余在viewdidapper中加载
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 380 + heightOffset)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"achievements_frame_bg"]];
    if (iPhone5) {
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"achievements_frame_bg_4in"]];
    }
    [self.backgroundScrollView addSubview:view];
    for (int j = 0; j < 9; j++) {
        NSDictionary *dic = [self.allAahv objectAtIndex:j];
        JWACHVView *achc = [[JWACHVView alloc] initWithFrame:CGRectMake(15 + j % 3 * 95, 22 + j / 3 *121 + heightOffset / 3.7 * (j /3 + .8), 83, 93)
                                                        ACHV:dic
                                                        Type:KJWACHVViewSmall];
        achc.tag = j;
        [achc addTarget:self
                 action:@selector(pressedSender:)
       forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:achc];
    }
    
    firstAppear = YES;//标识第一次显示
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (firstAppear) {
        firstAppear = NO;

        int heightOffset = 0.f;
        if (iPhone5) {
            heightOffset = 70.f;
        }
        for (int i = 1 ; i < ceil(kACHVCount / 9.0f); i ++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10 + i * 320, 10, 300, 380 + heightOffset)];
            view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"achievements_frame_bg"]];
            if (iPhone5) {
                view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"achievements_frame_bg_4in"]];
            }
            [self.backgroundScrollView addSubview:view];
            for (int j = 0; j < 9 && (j + i *9) < kACHVCount; j++) {
                //只加载第一页，其余在viewdidapper中加载
                NSDictionary *dic = [self.allAahv objectAtIndex:(j + i *9)];
                JWACHVView *achc = [[JWACHVView alloc] initWithFrame:CGRectMake(15 + j % 3 * 95, 22 + j / 3 *121 + heightOffset / 3.7 * (j /3 + .8), 83, 93)                                                                ACHV:dic
                                                                Type:KJWACHVViewSmall];
                achc.tag = j + i * 9;
                [achc addTarget:self
                         action:@selector(pressedSender:)
               forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:achc];
            }
        }
    }
#ifdef VERSION_FREE
    BannerViewController *banner = [BannerViewController sharedBanner];
    banner.delegate = self;
    [self.view addSubview:banner.view];
#endif
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - action



-(void)refreshView:(NSNotification*)noti{
#ifdef ACHIEVEMENTS_DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
    NSArray *array = self.backgroundScrollView.subviews;
    for (UIView *view in array) {
        [view removeFromSuperview];
    }
    
    int heightOffset = 0.f;
    if (iPhone5) {
        heightOffset = 70.f;
    }
    
    JWACHVManager *manager = [JWACHVManager shareACHVManager];
    self.allAahv = [manager allAchv];
    
    for (int i = 0 ; i < ceil(kACHVCount / 9.0f); i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10 + i * 320, 10, 300, 380 + heightOffset)];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"achv_information_frame"]];
        if (iPhone5) {
            view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"achievements_frame_bg_4in"]];
            
        }
        [self.backgroundScrollView addSubview:view];
        for (int j = 0; j < 9 && (j + i *9) < kACHVCount; j++) {
            //只加载第一页，其余在viewdidapper中加载
            NSDictionary *dic = [self.allAahv objectAtIndex:(j + i *9)];
            JWACHVView *achc = [[JWACHVView alloc] initWithFrame:CGRectMake(15 + j % 3 * 95, 22 + j / 3 *121 + heightOffset / 3.7 * (j /3 + .8), 83, 93)
                                                            ACHV:dic
                                                            Type:KJWACHVViewSmall];
            achc.tag = j + i * 9;
            [achc addTarget:self
                     action:@selector(pressedSender:)
           forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:achc];
        }
    }
    
}

-(void)pressedSender:(id)sender{
#ifdef ACHIEVEMENTS_DEBUG
    NSLog(@"%s  %d",__FUNCTION__,[sender tag]);
#endif
    
    JWACHVInfoViewController *info = [[JWACHVInfoViewController alloc] initWithAchv:[self.allAahv objectAtIndex:[sender tag]]];
    [self.navigationController pushViewController:info animated:YES];
}

#pragma mark - action

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.pageCon.currentPage = scrollView.contentOffset.x / 320;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];//无论是否有减速，都要走减速方法
    }
}

#pragma mark - AD delegate

-(void)ADIsComing:(BOOL)b{
    int offset = b ? 20 : -20;
//    CGRect frame = self.tableView.frame;
//    frame.origin.y += offset;
//    frame.size.height -= offset;
//    self.tableView.frame = frame;
    self.backgroundScrollView.frame = CGRectOffset(self.backgroundScrollView.frame, 0, offset);
}


@end
