//
//  GKViewController.m
//  GKSlidingText
//
//  Created by Georg Kitz on 2/10/13.
//  Copyright (c) 2013 Georg Kitz. All rights reserved.
//

#import "GKViewController.h"
#import "GKSlidingText.h"

@interface GKViewController ()

@end

@implementation GKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	GKSlidingText *noneSlidingText = [[GKSlidingText alloc] initWithFrame:CGRectMake(20, 100, 280, 25)];
	noneSlidingText.text = @"This is a none sliding text";
	[self.view addSubview:noneSlidingText];
	
	GKSlidingText *slidingText = [[GKSlidingText alloc] initWithFrame:CGRectMake(20, 160, 280, 25)];
	slidingText.text = @"This is a sliding text wohooo slide slide...";
	[self.view addSubview:slidingText];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
