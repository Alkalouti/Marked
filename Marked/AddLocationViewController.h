//
//  AddLocationViewController.h
//  Marked
//
//  Created by AlKalouti on 8/21/15.
//  Copyright (c) 2015 company. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface AddLocationViewController : ViewController

@property (weak, nonatomic) IBOutlet UITextField *locationName;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)SaveLocation:(id)sender;

@end
