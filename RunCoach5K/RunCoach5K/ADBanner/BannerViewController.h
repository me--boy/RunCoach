//
//  BannerViewController.h
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <iAd/ADBannerView.h>

#define	kUp 1
#define kDown (-1)
#define bannerView_h 50
#define kBannerFrameUnderNav CGRectMake(0, -50, 320, 50)
#define kBannerFrameAboveTab CGRectMake(0, 367, 320, 50)

#define kBannerFrameNav CGRectMake(0, 0, 320, 50)
#define kBannerFrameTab CGRectMake(0, 317, 320, 50)

@protocol ADDelegate 

- (void)ADIsComing:(BOOL)b;

@end

@interface BannerViewController : NSObject <ADBannerViewDelegate>

@property (nonatomic, weak) id<ADDelegate> delegate;
@property (nonatomic, assign) NSInteger upOrDown;//当广告出现时view向上还是向下滑动
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, retain) UIView *view;

+ (id) sharedBanner;
+ (void) releaseSharedBanner;
- (id)initWithFrame:(CGRect)rect;
- (BOOL) isBannerLoaded;

@end

