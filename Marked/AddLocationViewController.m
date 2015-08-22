//
//  AddLocationViewController.m
//  Marked
//
//  Created by AlKalouti on 8/21/15.
//  Copyright (c) 2015 company. All rights reserved.
//

#import "AddLocationViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"

@interface AddLocationViewController ()
{
    float longitude;
    float latitude;

}
@end

@implementation AddLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];
    
    longitude = 0.0;
    latitude = 0.0;
    
}
-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    // This is important if you only want to receive one tap and hold event
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.mapView removeGestureRecognizer:sender];
    }
    else
    {
        // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
        CGPoint point = [sender locationInView:self.mapView];
        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        // Then all you have to do is create the annotation and add it to the map
        longitude = locCoord.longitude;
        latitude = locCoord.latitude;

        MKPointAnnotation *dropPin = [[MKPointAnnotation alloc] init];
        dropPin.coordinate = locCoord;
        [self.mapView addAnnotation:dropPin];

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)SaveLocation:(id)sender {
    
    if (self.locationName.text.length != 0 && longitude != 0 && latitude != 0) {
        [SVProgressHUD show];
        PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:latitude longitude:longitude];
        
        PFObject *SaveLocation = [PFObject objectWithClassName:@"Locations"];
        SaveLocation[@"name"] = self.locationName.text;
        SaveLocation[@"location"] = point;
        [SaveLocation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshLocation" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            } else {

            }
            [SVProgressHUD dismiss];
        }];

    }
}
@end
