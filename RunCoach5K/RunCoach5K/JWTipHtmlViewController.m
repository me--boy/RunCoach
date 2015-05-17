//
//  JWTipHtmlViewController.m
//  RunCoach5K
//
//  Created by YQ-011 on 8/10/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWTipHtmlViewController.h"
#import "JWAppSetting.h"
#import "UIBarButtonItem+Addtions.h"

@interface JWTipHtmlViewController ()

@property (nonatomic) NSInteger index;
@property (nonatomic, weak)UIWebView *webView;

@end

@implementation JWTipHtmlViewController

- (id)initWithIndex:(NSInteger)index
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.index = index;
    }
    return self;
}

-(void)loadView{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kBackgroundColor;
    self.view = view;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    if (iPhone5) {
        [webView setFrame:CGRectMake(0, 0, 320, 504.0f)];
    }
    [self.view addSubview:webView];
    self.webView = webView;
    if (_index > 0 && _index < 11) {
        NSURL *docURL = [[NSBundle mainBundle]
                         URLForResource:[NSString stringWithFormat:@"runcoach5k_tips_%d", _index] withExtension:@"html"];
        [_webView loadRequest:[NSURLRequest requestWithURL:docURL]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *backButton = [UIBarButtonItem barButtonItemWithCustomImage:[UIImage imageNamed:@"btn_back"]
                                                                         target:self
                                                                         action:@selector(back) Offset:-10];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get/set

-(void)setIndex:(NSInteger)index{
    _index = index;
    if (_webView) {
        NSURL *docURL = [[NSBundle mainBundle]
                         URLForResource:[NSString stringWithFormat:@"runcoach5k_tips_%d", _index] withExtension:@"html"];
        [_webView loadRequest:[NSURLRequest requestWithURL:docURL]];
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
