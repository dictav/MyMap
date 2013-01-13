//
//  PAJFlipsideViewController.h
//  MyMap
//
//  Created by Abe Shintaro on 2013/01/12.
//  Copyright (c) 2013年 Abe Shintaro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PAJFlipsideViewController;

@protocol PAJFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(PAJFlipsideViewController *)controller;
@end

@interface PAJFlipsideViewController : UIViewController

@property (weak, nonatomic) id <PAJFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
