//
//  JWHistoryDetailViewController.h
//  RunCoach5K
//
//  Created by YQ-011 on 8/9/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Note.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#ifdef VERSION_FREE
#import "BannerViewController.h"
#endif

@class TB_History;

@interface JWHistoryDetailViewController : UIViewController<MKMapViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
NoteChanged,
UIActionSheetDelegate,
MFMailComposeViewControllerDelegate
#ifdef VERSION_FREE
,ADDelegate
#endif

>

@property (strong, nonatomic)TB_History *history;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@property (weak, nonatomic) IBOutlet UITableView *noteTableView;
@property (strong, nonatomic) NoteCell *noteCell;

@end
