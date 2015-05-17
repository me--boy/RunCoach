//
//  JWHistoryDetailViewController.m
//  RunCoach5K
//
//  Created by YQ-011 on 8/9/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWHistoryDetailViewController.h"
#import "TB_History.h"
#import "TB_tutorial.h"
#import "JWAppSetting.h"
#import <QuartzCore/QuartzCore.h>
#import "JWMapManager.h"
#import "JWAnnotation.h"
#import "JWAppSetting.h"
#import "JWAppDelegate.h"
#import "UIBarButtonItem+Addtions.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>

@interface JWHistoryDetailViewController ()

@end

@implementation JWHistoryDetailViewController

#pragma mark - life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = kBackgroundColor;
    
    UIBarButtonItem *backButton = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_back"]
                                                                         target:self
                                                                         action:@selector(back) Offset:-10];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *shareButton = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_share"]
                                                                          target:self
                                                                          action:@selector(share) Offset:20];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    self.noteTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.noteTableView.separatorColor = kTableCellSeparatorColor;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if (self.history) {
        self.history = _history;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDateLabel:nil];
    [self setTotalTime:nil];
    [self setDistanceLabel:nil];
    [self setAverageLabel:nil];
    [self setMaxLabel:nil];
    [self setMapView:nil];
    [self setNoteTableView:nil];
    [super viewDidUnload];
}

#ifdef VERSION_FREE
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    BannerViewController *banner = [BannerViewController sharedBanner];
    banner.delegate = self;
    [self.view addSubview:banner.view];
}
#endif

#pragma mark get/set

-(void)setHistory:(TB_History *)history{
    _history = history;
    if (!self.dateLabel) {
        return;
    }
    //给界面添加数据
    self.dateLabel.text = [NSDateFormatter localizedStringFromDate:_history.happenTime
                                                         dateStyle:NSDateFormatterMediumStyle
                                                         timeStyle:NSDateFormatterNoStyle];
    [self.dateLabel sizeToFit];
    
    self.totalTime.text = [JWAppSetting stringWith:_history.totalTime.intValue];
    [self.totalTime sizeToFit];
    
    JWAppSetting *appSetting = [JWAppSetting shareAppSetting];
    self.averageLabel.text = [appSetting speedStringWith:[history.averageVelocity doubleValue]];
    [self.averageLabel sizeToFit];
    
    self.distanceLabel.text = [appSetting distanceStringWith:[history.totalDistance doubleValue]];
    [self.distanceLabel  sizeToFit];
    
    self.maxLabel.text = [appSetting speedStringWith:[history.maxVelocity doubleValue]];
    [self.maxLabel sizeToFit];
    if (history.pathFileName) {
        self.mapView.layer.borderWidth = 3.f;
        self.mapView.layer.borderColor = [kRGB255UIColor(255, 179, 0, 1.f) CGColor];
        self.mapView.delegate = self;
        [self loadMapViewLine:history.pathFileName];
    }else{
        self.mapView.hidden = YES;
        self.noteTableView.frame = CGRectMake(0, 130, 320, 300);
        self.noteTableView.autoresizingMask = 0;
    }
    
    self.noteCell.string = self.history.note;
    
}

-(NoteCell *)noteCell{
    if (!_noteCell) {
        self.noteCell = [[NoteCell alloc] initWithReuseIdentifier:[NoteCell identifier]
                                                   tableViewStyle:UITableViewStyleGrouped];
        _noteCell.editedObject = self;
    }
    return _noteCell;
}

#pragma mark costom

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)share{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 6.0) {
        UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", @"Email", nil];
        [actionsheet showInView:self.view];
    }else{
        UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Twitter",@"Email", nil];
        [actionsheet showInView:self.view];
    }
    
}

-(void)loadMapViewLine:(NSString *)fileName{
    NSString *strUrl = [[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()] stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:strUrl]) {
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:strUrl];
    
    NSArray *lines = [dic objectForKey:kJWMapRouteline];
    for (NSArray *line in lines) {
        [self.mapView addOverlay:[self makePolylineWithLocations:line]];
    }
    
    
    //ammotaions
    NSArray *annotations = [dic objectForKey:kJWMapAnnotation];
    if (annotations.count > 0) {
        for (NSString *annstr in annotations) {
            JWAnnotation *ann = [[JWAnnotation alloc] initWithString:annstr];
            [self.mapView addAnnotation:ann];
        }
        
        JWAnnotation *annota = [[JWAnnotation alloc] initWithString:annotations[0]];
        
        self.mapView.region = MKCoordinateRegionMake([annota coordinate], MKCoordinateSpanMake(.02f, .02f));
    }
}

- (MKPolyline *)makePolylineWithLocations:(NSArray *)newLocations{
    MKMapPoint *pointArray = malloc(sizeof(MKMapPoint)* newLocations.count);
    for(int i = 0; i < newLocations.count; i++)
    {
        NSString* currentPointString = [newLocations objectAtIndex:i];
        NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        CLLocationDegrees latitude  = [[latLonArr objectAtIndex:0] doubleValue];
        CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        pointArray[i] = MKMapPointForCoordinate(coordinate);
    }
    MKPolyline *polyline = [MKPolyline polylineWithPoints:pointArray count:newLocations.count];
    free(pointArray);
    return polyline;
}

#pragma mark - MKMapView delegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[JWAnnotation class]]) {
        
        static NSString *Identifier = @"CalloutView";
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:Identifier];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
            annotationView.centerOffset = CGPointMake(0, -12);
        }
        if ([(JWAnnotation*)annotation annotationType] == kAnnotationBegin) {
            [annotationView setImage:[UIImage imageNamed:@"map_start_icon"]];
        }else if ([(JWAnnotation*)annotation annotationType] == kAnnotationEnd){
            [annotationView setImage:[UIImage imageNamed:@"map_stop_icon"]];
        }else {
            [annotationView setImage:[UIImage imageNamed:@"map_susoend_icon"]];
        }
        return annotationView;
	}
	return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView *routeLineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        routeLineView.strokeColor = kRGB255UIColor(20, 156, 76, 1.f);
        routeLineView.fillColor = kRGB255UIColor(20, 156, 76, .5f);
        routeLineView.lineWidth = 6;
        return routeLineView;
    }
    return nil;
}

#pragma mark - uitable view data source and delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.noteCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:self.noteCell.noteViewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 23;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [NoteHeaderView view];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.noteCell.noteCellHeight;;
}

-(void)noteChanged:(NSString *)note{
    self.history.note = note;
    JWAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [delegate saveContext];
    [self.noteTableView reloadData];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
#ifdef HISTORY_DEBUG
    NSLog(@"%s%d",__FUNCTION__,buttonIndex);
#endif
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
        buttonIndex++;
    }
    
    NSString *dateStr = [NSDateFormatter localizedStringFromDate:_history.happenTime
                                                       dateStyle:NSDateFormatterLongStyle
                                                       timeStyle:NSDateFormatterNoStyle];
    
    NSString *earned = @"";
    if (_history.achvName) {
        NSArray *array = [_history.achvName componentsSeparatedByString:@","];
        if (array.count > 0){
            if (array.count == 1) {
                earned = [NSString stringWithFormat:@"earned the %@ ",_history.achvName];
            }else if (array.count == 2){
                earned = [NSString stringWithFormat:@"earned the %@ and %@ ",array[0], array[1]];
            }else{
                NSMutableArray *muArray = [NSMutableArray arrayWithArray:array];
                [muArray removeObjectAtIndex:(muArray.count  - 1)];
                
                NSString *str = [muArray componentsJoinedByString:@", "];
                earned = [NSString stringWithFormat:@"earned the %@ and %@ ",str, array[array.count - 1]];
            }
        }
        
        
    }
    NSString *twitterStr = [NSString stringWithFormat:@"Cheers! I have finished %@, used total %@, %@by Run Coach – Becoming 5K Runner.", _history.tutorial.tutorialName, [JWAppSetting stringWith:_history.totalTime.intValue],earned];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?mt=8",kAppID]];
    switch (buttonIndex) {
        case 0:
            //facebook
        {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                [controller dismissViewControllerAnimated:YES completion:Nil];
            };
            controller.completionHandler =myBlock;
            [controller setInitialText:twitterStr];
            [controller addURL:url];
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
        case 1:
            //twitter
        {
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
                TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
                [tweetViewController setInitialText:twitterStr];
                BOOL succeed = [tweetViewController addURL:url];
                if(!succeed && ![earned isEqualToString:@""]){
                    twitterStr = [NSString stringWithFormat:@"Cheers! I have finished %@, used total %@, %@.", _history.tutorial.tutorialName, [JWAppSetting stringWith:_history.totalTime.intValue],earned];
                    [tweetViewController setInitialText:twitterStr];
                    [tweetViewController addURL:url];
                }
  
                [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
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
                    [controller dismissViewControllerAnimated:YES completion:Nil];
                };
                controller.completionHandler =myBlock;
                [controller setInitialText:twitterStr];
                BOOL succeed = [controller addURL:url];
                if(!succeed && ![earned isEqualToString:@""]){
                    twitterStr = [NSString stringWithFormat:@"Cheers! I have finished %@, used total %@, %@.", _history.tutorial.tutorialName, [JWAppSetting stringWith:_history.totalTime.intValue],earned];
                    [controller setInitialText:twitterStr];
                    [controller addURL:url];
                }
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
        case 2:
            //Email
        {
            if (![MFMailComposeViewController canSendMail]) {
                return;
            }
            MFMailComposeViewController *picker =
            [[MFMailComposeViewController alloc] init];
            //    picker.navigationBar.tintColor = kNavigationTintColor;
//            [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
            picker.mailComposeDelegate = self;
            [picker setSubject:[NSString stringWithFormat:@"%@", kAppName]];
            
            NSString *html = [NSString stringWithFormat:@"Cheers! I have finished  %@ on %@, used total %@, %@by <a href=%@>Run Coach – Becoming 5K Runner</a>. ", _history.tutorial.tutorialName, dateStr, [JWAppSetting stringWith:_history.totalTime.intValue],earned, url];
            
            [picker setMessageBody:html isHTML:YES];
            [self presentModalViewController:picker animated:YES];
            picker.navigationBar.tintColor = [UIColor blackColor];
        }
            break;
            
        default:
            break;
    }
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

#pragma mark - ADdelegate

-(void)ADIsComing:(BOOL)b{
    int offset = b ? 50 : -50;
    CGRect frame = self.bgScrollView.frame;
    frame.origin.y += offset;
    frame.size.height -= offset;
    self.bgScrollView.frame = frame;
}


@end
