//
//  JWNavigationController.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/11/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWNavigationController.h"

@interface JWNavigationController ()

@end

@implementation JWNavigationController

- (id) initWithRootViewController:(UIViewController *)rv {
	self = [super initWithRootViewController:rv];
	if (self) {
		[self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
	}
	return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

@end
