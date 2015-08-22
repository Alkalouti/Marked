//
//  EventDetailsViewController.h
//  Marked
//
//  Created by AlKalouti on 8/22/15.
//  Copyright (c) 2015 company. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface EventDetailsViewController : ViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) PFGeoPoint * EventLocation;

@property (nonatomic, retain) NSString * EventName;

@end
