//
//  ViewController.h
//  Marked
//
//  Created by AlKalouti on 8/21/15.
//  Copyright (c) 2015 company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (nonatomic, retain) NSString * LocationId;

@end

