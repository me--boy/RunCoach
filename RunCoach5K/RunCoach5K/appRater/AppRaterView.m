//
//  AppRaterView.m
//  Period Planner
//
//  Created by SL02 on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppRaterView.h"
#import "Appirater.h"
#import "JWAppDelegate.h"

@implementation AppRaterView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
    }
    return self;
}
-(void)loadView{
    self.view = [[UIView alloc] init];
    if (iPhone5) {
        [self.view setFrame:CGRectMake(0, 20, 320, 548)];
    }else{
        [self.view setFrame:CGRectMake(0, 20, 320, 460)];
    }
self.view.backgroundColor = [UIColor redColor];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
#ifdef IS_FREE
    NSString *imageName = @"rate_f";
#else
    NSString *imageName = @"rate";
#endif
    
    if (iPhone5) {
        imageName = [imageName stringByAppendingString:@"_548h"];
    }
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    image.userInteractionEnabled = YES;

    
    if (iPhone5) {
        [image setFrame:CGRectMake(0, 0, 320, 548)];
    }else{
        [image setFrame:CGRectMake(0, 0, 320, 460)];
    }
    
    int height = iPhone5 ? 46 : 0;
    
    [self.view addSubview:image];
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(40, 238 + height, 248, 46)];
    [button1 setBackgroundColor:[UIColor clearColor]];
    [button1 setTag:0];
    [button1 addTarget:self action:@selector(BtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(40, 298 + height, 248, 46)];
    [button2 setBackgroundColor:[UIColor clearColor]];
    [button2 setTag:1];
    [button2 addTarget:self action:@selector(BtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(40, 356 + height * 1.05, 248, 40)];
    [button3 setBackgroundColor:[UIColor clearColor]];
    [button3 setTag:2];
    [button3 addTarget:self action:@selector(BtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];

}
-(void)BtnPressed:(id)sender
{
	UIButton * btn = (UIButton *)sender;
	if(btn.tag == 0)
	{
		[Appirater BtnPressed:0];
	}
    if (btn.tag == 2)
	{
		[Appirater BtnPressed:2];
	}
	[self.view removeFromSuperview];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
