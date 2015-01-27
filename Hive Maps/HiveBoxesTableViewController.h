//
//  HiveBoxesTableViewController.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/19/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiveDetails.h"
#import "HiveBox.h"

@interface HiveBoxesTableViewController : UITableViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) HiveDetails *hive;


- (IBAction)unwindToBoxDetails:(UIStoryboardSegue *)segue;


@end
