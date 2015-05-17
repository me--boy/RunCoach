//
//  JWACHVInfoViewController.m
//  RunCoach5K
//
//  Created by YQ-011 on 8/12/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWACHVInfoViewController.h"
#import "JWACHVView.h"
#import "JWACHVManager.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import "UIBarButtonItem+Addtions.h"
#import "JWACHVManager.h"

@interface JWACHVInfoViewController ()

@property (nonatomic,strong) NSDictionary *achv;

@end

@implementation JWACHVInfoViewController

- (id)initWithAchv:(NSDictionary *)achv
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.achv = achv;
    }
    return self;
}

-(void)loadView{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kBackgroundColor;
    self.view = view;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    kNavTitle([_achv objectForKey:kACHVName], self);
    
    UIBarButtonItem *backButton = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_back"]
                                                                         target:self
                                                                         action:@selector(back) Offset:-10];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"achv_information_frame"]];
    imageView.center = CGPointMake(160, 208);
    if (iPhone5) {
        imageView.image = [UIImage imageNamed:@"achv_information_frame_4in"];
        imageView.frame = CGRectMake(10, 17, 300, 470);
    }
    [self.view addSubview:imageView];
    
    JWACHVView * achv = [[JWACHVView alloc] initWithFrame:CGRectMake(40, 45, 239, 239)
                                                     ACHV:_achv
                                                     Type:KJWACHVViewBig];
    
    [self.view addSubview:achv];
    
    int offsetY = 0;
    if (iPhone5) {
        offsetY = 30;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(115, 297 + offsetY, 90, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"Share on";
    label.textColor = kdefaultYellowColor;
    [self.view addSubview:label];
    
#ifdef VERSION_FREE
    achv.tag = 1001;//for freeVresion
    label.tag = 1002;
#endif
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
        NSArray *buttonImage = @[@"btn_twitter", @"btn_email"];
        BOOL enabled = [[_achv objectForKey:kACHVFinish] boolValue];
        for (int i = 0; i <2; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(160 * i, 340 + offsetY * 1.5, 160, 50)];
            [button setImage:[UIImage imageNamed:buttonImage[i]] forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(buttonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
            button.enabled = enabled;
            button.tag = i + 2;
            [self.view addSubview:button];
        }
    }else{
        NSArray *buttonImage = @[@"btn_facebook", @"btn_twitter", @"btn_email"];
        BOOL enabled = [[_achv objectForKey:kACHVFinish] boolValue];
        for (int i = 0; i <3; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10 + 100 * i, 340+ offsetY * 1.5, 100, 50)];
            [button setImage:[UIImage imageNamed:buttonImage[i]] forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(buttonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
            button.enabled = enabled;
            button.tag = i + 1;
            [self.view addSubview:button];
        }
    }

    
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

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)buttonPressed:(id)sender{
    NSString *twitterStr = [NSString stringWithFormat:@"Amazing! I just earned a badget - %@ from Run Coach 5K.",
                            [self.achv objectForKey:kACHVName]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?mt=8",kAppID]];
    UIImage *image = [UIImage imageNamed:[JWACHVManager achvBigImageName:_achv]];
    switch ([sender tag]) {
        case 1:
            //facebook
        {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultDone) {
                    JWACHVManager *manager = [JWACHVManager shareACHVManager];
                    [manager shareOneACHV];
                }
                [controller dismissViewControllerAnimated:YES completion:Nil];
            };
            controller.completionHandler =myBlock;
            [controller setInitialText:twitterStr];
            [controller addURL:url];
            [controller addImage:image];
            if (controller) {
                [self presentViewController:controller animated:YES completion:Nil];
            }else{
                UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"No Facebook account"
                                                              message:@"There is no Facebook account configured. You can add or create a Facebook account in Settings."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
                [alert show];
            }
            
        }
            break;
        case 2:
            //twitter
        {
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
                TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
                [tweetViewController setInitialText:twitterStr];
                [tweetViewController addURL:url];
                [tweetViewController addImage:image];
                [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
                    if (result == TWTweetComposeViewControllerResultDone) {
                        JWACHVManager *manager = [JWACHVManager shareACHVManager];
                        [manager shareOneACHV];
                    }
                    [self dismissModalViewControllerAnimated:YES];
                }];
                if (tweetViewController) {
                    [self presentViewController:tweetViewController animated:YES completion:Nil];
                }else{
                    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"No Twitter account"
                                                                  message:@"There is no Twitter account configured. You can add or create a Facebook account in Settings."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
                    [alert show];
                }
            }else{
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                    if (result == SLComposeViewControllerResultDone) {
                        JWACHVManager *manager = [JWACHVManager shareACHVManager];
                        [manager shareOneACHV];
                    }
                    [controller dismissViewControllerAnimated:YES completion:Nil];
                };
                controller.completionHandler =myBlock;
                [controller setInitialText:twitterStr];
                [controller addURL:url];
                [controller addImage:image];

                if (controller) {
                    [self presentViewController:controller animated:YES completion:Nil];
                }else{
                    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"No Twitter account"
                                                                  message:@"There is no Twitter account configured. You can add or create a Facebook account in Settings."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
                    [alert show];
                }
            }
            
        }
            break;
        case 3:
            //Email
        {
            if (![MFMailComposeViewController canSendMail]) {
                return;
            }
            MFMailComposeViewController *picker =
            [[MFMailComposeViewController alloc] init];
            //    picker.navigationBar.tintColor = kNavigationTintColor;
            
            picker.mailComposeDelegate = self;
            [picker setSubject:[NSString stringWithFormat:@"%@", kAppName]];
            NSString *html = [NSString stringWithFormat:@"Amazing! I just earned a badget - %@ from <a href=%@>Run Coach – Becoming 5K Runner</a>. ",[self.achv objectForKey:kACHVName], url];
            [picker setMessageBody:html isHTML:YES];
            [picker addAttachmentData:UIImagePNGRepresentation(image) mimeType:@"image/png" fileName:[NSString stringWithFormat:@"%@.png",[self.achv objectForKey:kACHVName]]];
            if (picker) {
                [self presentModalViewController:picker animated:YES];
            }
            picker.navigationBar.tintColor = [UIColor blackColor];
        }
            break;
            
        default:
            break;
    }
}

//等比率缩放
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

#pragma pragma mark - MFMailComposeViewController delegate

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
		case MFMailComposeResultSent:{
            JWACHVManager *manager = [JWACHVManager shareACHVManager];
            [manager shareOneACHV];
        }
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

#pragma mark - AD delegate

-(void)ADIsComing:(BOOL)b{
    int offset = b ? 20 : -20;
    UIView *view = [self.view viewWithTag:1001];
    view.frame = CGRectOffset(view.frame, 0, offset);
    view = [self.view viewWithTag:1002];
    view.frame = CGRectOffset(view.frame, 0, offset/2);
//    CGRect frame = self.tableView.frame;
//    frame.origin.y += offset;
//    frame.size.height -= offset;
//    self.tableView.frame = frame;
}

@end
