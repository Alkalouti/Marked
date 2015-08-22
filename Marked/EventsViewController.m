//
//  ViewController.m
//  Marked
//
//  Created by AlKalouti on 8/21/15.
//  Copyright (c) 2015 company. All rights reserved.
//

#import "EventsViewController.h"
#import <Parse/Parse.h>
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "SVProgressHUD.h"
#import "EventDetailsViewController.h"

@interface EventsViewController ()<MGSwipeTableCellDelegate>
{
    NSMutableArray * EventsArr;
}

@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(Refresh:) forControlEvents:UIControlEventValueChanged];
    [self.TableView addSubview:refreshControl];
    [self.TableView sendSubviewToBack:refreshControl];
    
    EventsArr = [NSMutableArray array];


    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    [query whereKey:@"locationId" equalTo:self.LocationId];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            [EventsArr addObjectsFromArray:objects];
            [self.TableView reloadData];
        }

    }];
   
}
- (void)Refresh:(UIRefreshControl *)refreshControl{
    EventsArr = [NSMutableArray array];
   
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    [query whereKey:@"locationId" equalTo:self.LocationId];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            [EventsArr addObjectsFromArray:objects];
            [self.TableView reloadData];
        }
         [refreshControl endRefreshing];
    }];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return EventsArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject * location = EventsArr[indexPath.row];
    
    static NSString * reuseIdentifier = @"cell";
    MGSwipeTableCell * cell = [self.TableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.textLabel.text = location[@"name"];

    cell.delegate = self; //optional

    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor]],[MGSwipeButton buttonWithTitle:@"Edit" backgroundColor:[UIColor lightGrayColor]]];
   

    
    return cell;
}
-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
    if (direction == MGSwipeDirectionRightToLeft && index == 0) {
        //delete button
        
            NSIndexPath * path = [self.TableView indexPathForCell:cell];
            
            PFObject * location = EventsArr[path.row];
            NSString *deleteID = location.objectId;
            
            [EventsArr removeObjectAtIndex:path.row];
            [self.TableView beginUpdates];
            [self.TableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
            [self.TableView endUpdates];
            PFQuery *query = [PFQuery queryWithClassName:@"Locations"];
            PFObject *obj = [query getObjectWithId:deleteID];
            [obj deleteInBackground];

        return NO;
    }
    
    if (direction == MGSwipeDirectionRightToLeft && index == 1) {
       
        return NO;
        
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"EventDetails"]) {
        NSIndexPath *indexPath=[self.TableView indexPathForSelectedRow];
        
        PFObject * event = EventsArr[indexPath.row];

        EventDetailsViewController * eventVC = [segue destinationViewController];
        eventVC.EventLocation = event[@"location"];
        eventVC.EventName = event[@"name"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
