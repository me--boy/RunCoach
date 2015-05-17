//
//  BannerViewController.m
//  BillsMonitor
//
//  Created by  YQ006 on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BannerViewController.h"
#import "JWAppSetting.h"
#import "JWInAppPurchaseManager.h"

#define kHaveMyAd YES

BOOL receiveAd = NO;
BannerViewController *bannerViewController;
BOOL InAppPurchaseAd = NO;

@interface BannerViewController ()

@property (nonatomic, retain)ADBannerView *iADView;
@property (nonatomic, retain)UIImageView *myADView;
@property (nonatomic, assign)NSInteger showADIndex;

@end


@implementation BannerViewController

@synthesize delegate;
@synthesize upOrDown;
@synthesize view;
@synthesize iADView;
@synthesize myADView;
@synthesize showADIndex;


+ (id) sharedBanner {
    if (!InAppPurchaseAd) {
        InAppPurchaseAd = [[JWInAppPurchaseManager shareInAppPurchaseManager] haveToBuyWithId:kInAppPurchaseProUpgradeADsProductId];
    }
    
    
    if (!InAppPurchaseAd) {
        if (bannerViewController == nil) {
            if (kHaveMyAd) {
                bannerViewController = [[[self class] alloc] initWithFrame:kBannerFrameNav];
            }else{
                bannerViewController = [[[self class] alloc] initWithFrame:kBannerFrameUnderNav];
            }
            bannerViewController.upOrDown = kUp;
        }
        return bannerViewController;
    }else{
        if (bannerViewController) {//去除广告
            bannerViewController.delegate = nil;
            [bannerViewController.view removeFromSuperview];
            bannerViewController = nil;
        }
        return nil;
    }
    
}

+ (void) releaseSharedBanner {
    bannerViewController = nil;
}

-(void)buyADs{
    [BannerViewController sharedBanner];
}

- (id)initWithFrame:(CGRect)rect {
    self = [super init];
    if (self != nil) {
        self.view = [[UIView alloc] initWithFrame:rect];
        if (kHaveMyAd) {
            [self.view addSubview:self.iADView];
            [self.view addSubview:self.myADView];
            [NSTimer scheduledTimerWithTimeInterval:30.f
                                             target:self
                                           selector:@selector(ArrowAnimationPlay:)
                                           userInfo:nil
                                            repeats:YES];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyADs) name:kInAppPurchaseManagerTransactionSucceededNotification object:Nil];
        }else{
            
        }
    }
    return self;
}

- (void)setDelegate:(id <ADDelegate>)d {
    if (delegate == d) return;
    if (kHaveMyAd) {
        if (delegate != nil) {
            [delegate ADIsComing:NO];
        }
        if ([JWAppSetting showAd]) {
            [d ADIsComing:YES];
        }
    }else{
        if (iADView.isBannerLoaded) {
            if (delegate != nil) {
                [delegate ADIsComing:NO];
            }
            if ([JWAppSetting showAd]) {
                [d ADIsComing:YES];
            }
        }
    }
    delegate = d;
}

- (CGRect)frame {
    return view.frame;
}

- (void)setFrame:(CGRect)r {
    view.frame = r;
}

- (BOOL) isBannerLoaded {
    return YES;
}


#pragma mark - get/set

-(ADBannerView *)iADView{
    if (!iADView) {
        self.iADView = [[ADBannerView alloc] initWithFrame:kBannerFrameNav];
        self.iADView.hidden = YES;
        self.iADView.delegate = self;
    }
    return iADView;
}

-(UIImageView *)myADView{
    if (!myADView) {
        self.myADView = [[UIImageView alloc] initWithFrame:kBannerFrameNav];
        self.showADIndex = 1;
        [self.myADView setImage:[self myAdImageAtIndex:self.showADIndex]];
        [self.myADView setUserInteractionEnabled:YES];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:kBannerFrameNav];
        [button addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
        [self.myADView addSubview:button];
    }
    return myADView;
}

-(UIImage *)myAdImageAtIndex:(NSInteger)index{
    NSString *imageName = nil;
    switch (index) {
        case 0:
        {
            imageName = @"RunCoach10K";
        }
            break;
        case 1:
        {
            imageName = @"fuelmonitor_ads";
        }
            break;
            
        default:
            break;
    }
    return [UIImage imageNamed:imageName];
}


#pragma mark - costom method

-(void)download{
    if (self.showADIndex == 1) {
        NSString*	url=@"https://itunes.apple.com/us/app/fuel-monitor-fuels-economy/id600375778?mt=8";
        [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:url]];
    }else{
        NSString*	url=@"https://itunes.apple.com/us/app/run-coach-becoming-10k-runner/id717804249?mt=8";
        [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:url]];
    }
    
}

-(void)ArrowAnimationPlay:(NSTimer *) timer{
    self.showADIndex++;
    self.showADIndex = self.showADIndex % [self myADCount];
    [self.myADView setImage:[self myAdImageAtIndex:self.showADIndex]];
}

-(NSInteger)myADCount{
    return 2;
}


#pragma mark - adbanner view delegage

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (receiveAd == NO) {
        receiveAd = YES;
        if (kHaveMyAd) {
            self.iADView.hidden = NO;
            self.myADView.hidden = YES;
        }else{
            [delegate ADIsComing:YES];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            banner.frame = CGRectOffset(banner.frame, 0, upOrDown * banner.frame.size.height);
            [UIView commitAnimations];
        }
        
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (receiveAd == YES) {
        receiveAd = NO;
        if (kHaveMyAd) {
            self.iADView.hidden = YES;
            self.myADView.hidden = NO;
        }else{
            [delegate ADIsComing:NO];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            banner.frame = CGRectOffset(banner.frame, 0, -(upOrDown * banner.frame.size.height));
            [UIView commitAnimations];
        }
    }
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {

}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.view = nil;
}

@end
