//
//  PAJMainViewController.m
//  MyMap
//
//  Created by Abe Shintaro on 2013/01/12.
//  Copyright (c) 2013年 Abe Shintaro. All rights reserved.
//


#import "PAJMainViewController.h"

@interface MyAnnotation : NSObject <MKAnnotation>
@property CLLocationCoordinate2D coordinate;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end

@implementation MyAnnotation
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
    }
    return self;
}
@end

@interface PAJMainViewController ()
@property NSMutableDictionary *overlaysDict;
@end

@implementation PAJMainViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _mapView.region = MKCoordinateRegionMakeWithDistance(_mapView.userLocation.coordinate, 1000.0, 1000.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addMapOverlayWithAnnotations:(NSArray*)annotations overlayId:(NSString*)overlayId
{
    CLLocationCoordinate2D coords[_mapView.annotations.count + 1];
    int count = 0;
    for (id annotation in annotations) {
        if ([annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        coords[count++] = [annotation coordinate];
    }
    coords[count] = coords[0];

    //remove overlays whose title is overlayId
    for (id<MKOverlay> overlay in _mapView.overlays) {
        if ([[overlay title] isEqualToString:overlayId])
            [_mapView removeOverlay:overlay];
    }
    
    MKPolyline *line = [MKPolyline polylineWithCoordinates:coords count:count+1];
    line.title = overlayId;
    [_mapView addOverlay:line];
    
    MKPolygon *polygon = [MKPolygon polygonWithCoordinates:coords count:count];
    polygon.title = overlayId;
    [_mapView addOverlay:polygon];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D centerCoord = userLocation.coordinate;
    [mapView setCenterCoordinate:centerCoord animated:YES];
    
    //create 4 annotations around user location
    CLLocationCoordinate2D coords[] = {
        CLLocationCoordinate2DMake(centerCoord.latitude + 0.005, centerCoord.longitude + 0.005),
        CLLocationCoordinate2DMake(centerCoord.latitude + 0.005, centerCoord.longitude - 0.005),
        CLLocationCoordinate2DMake(centerCoord.latitude - 0.005, centerCoord.longitude - 0.005),
        CLLocationCoordinate2DMake(centerCoord.latitude - 0.005, centerCoord.longitude + 0.005)
    };
    
    NSMutableArray *annotations = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        [annotations addObject:[[MyAnnotation alloc] initWithCoordinate:coords[i]]];
    }
    [mapView addAnnotations:annotations];
    [self addMapOverlayWithAnnotations:annotations overlayId:@"hoge"];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView *view = [[MKPolylineView alloc] initWithOverlay:overlay];
        view.strokeColor = [UIColor blueColor];
        view.lineWidth = 5.0;
        return view;
    } else if([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonView *view = [[MKPolygonView alloc] initWithOverlay:overlay];
        view.fillColor = [UIColor colorWithRed:0 green:0 blue:255 alpha:0.5];
        return view;
    } else {
        return nil;
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *anView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"test"];
    anView.draggable = YES;
    return anView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding) {
        [self addMapOverlayWithAnnotations:mapView.annotations overlayId:@"hoge"];
    }
}

#pragma mark - Flipside View
- (void)flipsideViewControllerDidFinish:(PAJFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}
@end
