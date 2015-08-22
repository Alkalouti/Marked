//
//  EventDetailsViewController.m
//  Marked
//
//  Created by AlKalouti on 8/22/15.
//  Copyright (c) 2015 company. All rights reserved.
//

#import "EventDetailsViewController.h"

@interface EventDetailsViewController ()

@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.EventName;
    
    PFGeoPoint *geoPoint = self.EventLocation;
    
    CLLocationCoordinate2D locCoord = CLLocationCoordinate2DMake(geoPoint.latitude,
                                                                   geoPoint.longitude);

//    CLLocationCoordinate2D locCoord = [self.EventLocation coordinate];
//    // Then all you have to do is create the annotation and add it to the map
//    
    MKPointAnnotation *dropPin = [[MKPointAnnotation alloc] init];
    dropPin.coordinate = locCoord;
    dropPin.title = self.EventName;
    [self.mapView addAnnotation:dropPin];
    
    self.mapView.userTrackingMode=YES;

    MKCoordinateRegion region = self.mapView.region;
    
    region.center.latitude = geoPoint.latitude ;
    region.center.longitude = geoPoint.longitude;
    region.span.longitudeDelta /= 1000.0;
    region.span.latitudeDelta /= 1000.0;
    
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
