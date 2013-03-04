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
@property (nonatomic, strong) GKSlidingText *noneSlidingText;
@property (nonatomic, strong) GKSlidingText *slidingText;
@end

@implementation GKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.noneSlidingText = [[GKSlidingText alloc] initWithFrame:CGRectMake(20, 100, 280, 25)];
	self.noneSlidingText.text = @"This is a none sliding text";
	[self.view addSubview:self.noneSlidingText];
	
	self.slidingText = [[GKSlidingText alloc] initWithFrame:CGRectMake(20, 160, 280, 25)];
	self.slidingText.text = @"This is a sliding text wohooo slide slide...";
	[self.view addSubview:self.slidingText];
}

- (void)viewWillLayoutSubviews
{
	self.noneSlidingText.frame = CGRectMake(20, 100, CGRectGetWidth(self.view.bounds) - 40, 25);
	self.slidingText.frame = CGRectMake(20, 160, CGRectGetWidth(self.view.bounds) - 40, 25);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
