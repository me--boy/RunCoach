//
//  JWHistoryViewController.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/5/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFoldTableView.h"

#ifdef VERSION_FREE
#import "BannerViewController.h"
#endif

@interface JWHistoryViewController : UIViewController<DCFoldTableDataSource, DCFoldTableDelegate
#ifdef VERSION_FREE
,ADDelegate
#endif
>

@end
