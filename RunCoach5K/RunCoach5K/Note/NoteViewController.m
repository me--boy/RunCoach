//
//  NoteViewController.m
//
//  Created by  YQ006 on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "NoteViewController.h"
#import "NoteCell.h"
#import "UIBarButtonItem+Addtions.h"

@implementation NoteViewController
@synthesize delegate;
@synthesize isNotificationText;


- (NSString *) string {
    return noteView.text;
}

- (void) setString:(NSString *)string {
    noteView.text = string;
}

- (id)init {
    self = [super init];
    if (self) {
        noteView = [[UITextView alloc] initWithFrame:CGRectMake(15, 25, 290, 150)];
        if (iPhone5) {
            [noteView setFrame:CGRectMake(15, 25, 290, 180)];
        }
        
        noteView.layer.cornerRadius = 8;
        noteView.layer.borderWidth = 1.f;
        noteView.layer.borderColor = kTableCellSeparatorColor.CGColor;
        noteView.backgroundColor = [UIColor colorWithRed:39/255.0 green:39/255.0
            blue:39/255.0 alpha:1.0];
        noteView.textColor = kdefaultTextColor;
        noteView.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (id)initWithDefaultString:(NSString *)string {
    self = [self init];
    if (self) {
        self.string = string;
    }
    return self;
}

- (void)loadView {
    kNavTitle(@"Note", self);
    self.view = [UIView new];
    self.view.backgroundColor = kBackgroundColor;
    
    UIBarButtonItem *leftBar = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_back"]
                                           target:self
                                           action:@selector(back) Offset:-10];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    [self.view addSubview:noteView];
    [noteView becomeFirstResponder];
}

-(void)back{
    [delegate noteChanged:self.string];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isNotificationText) {
        kNavTitle(@"Notification Text", self);
    }
}


@end
