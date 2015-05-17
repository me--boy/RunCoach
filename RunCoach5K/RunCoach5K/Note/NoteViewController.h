//
//  NoteViewController.h
//  BillsMonitor
//
//  Created by  YQ006 on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoteChanged;
@interface NoteViewController : UIViewController {
	UITextView              			*noteView;
}

@property (nonatomic, assign) id<NoteChanged>           delegate;
@property (nonatomic, retain) NSString                  *string;
@property (nonatomic, assign) BOOL isNotificationText;

- (id)initWithDefaultString:(NSString *)string;

@end
