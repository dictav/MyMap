//
//  PAJMainViewController.h
//  MyMap
//
//  Created by Abe Shintaro on 2013/01/12.
//  Copyright (c) 2013年 Abe Shintaro. All rights reserved.
//

#import "PAJFlipsideViewController.h"
#import <MapKit/MapKit.h>

@interface PAJMainViewController : UIViewController <PAJFlipsideViewControllerDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end
