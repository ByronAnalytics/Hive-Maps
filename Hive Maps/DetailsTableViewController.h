//
//  DetailsTableViewController.h
//  Hive Saver
//
//  Created by Developing on 12/22/14.
//  Copyright (c) 2014 Byron Analytics LLC and Hive Savers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@class HiveDetails, HiveObservation;

@interface DetailsTableViewController : UITableViewController <RateViewDelegate>

@property (strong, nonatomic) HiveDetails *hive;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) HiveObservation *lastObservation;

#pragma mark - Hive Details Outputs
@property (weak, nonatomic) IBOutlet UILabel *siteNameOut;
@property (weak, nonatomic) IBOutlet UILabel *hiveIDOut;
@property (weak, nonatomic) IBOutlet UILabel *hiveCoordinates;
@property (weak, nonatomic) IBOutlet UILabel *ageOut;
@property (weak, nonatomic) IBOutlet UILabel *healthStatusOut;
@property (weak, nonatomic) IBOutlet UILabel *queenSourceOut;
@property (weak, nonatomic) IBOutlet UILabel *queenAgeOut;
@property (weak, nonatomic) IBOutlet RateView *queenRatingView;

#pragma mark - HiveTotalOutputs
@property (weak, nonatomic) IBOutlet UILabel *lastSampleDateOut;
@property (weak, nonatomic) IBOutlet UILabel *broodTotals;
@property (weak, nonatomic) IBOutlet UILabel *workerTotals;
@property (weak, nonatomic) IBOutlet UILabel *honeyTotals;

#pragma mark - Actions
@property (weak, nonatomic) IBOutlet UIButton *visualizeDataButton;
-(IBAction) unwindToHiveDetails:(UIStoryboardSegue *)segue;
@end
