//
//  PAJFlipsideViewController.m
//  MyMap
//
//  Created by Abe Shintaro on 2013/01/12.
//  Copyright (c) 2013年 Abe Shintaro. All rights reserved.
//

#import "PAJFlipsideViewController.h"

@interface PAJFlipsideViewController ()

@end

@implementation PAJFlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
