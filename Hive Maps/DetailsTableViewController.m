//
//  DetailsTableViewController.m
//  Hive Saver
//
//  Created by Developing on 12/22/14.
//  Copyright (c) 2014 Byron Analytics LLC and Hive Savers. All rights reserved.
//
/*########################### TO DO ####################################################
 1) implement edit-hive view 
 2) wire up data to outputs
 3) pass data to plotting window
 */

#import "DetailsTableViewController.h"

#import "AppDelegate.h"
#import "MainTableViewController.h"
#import "AddHiveTableViewController.h"
#import "HiveBoxesTableViewController.h"
#import "SingleHivePlotViewController.h"

#import "DataLuggage.h"
//Core Data Elements
#import "HiveDetails.h"
#import "HiveObservation.h"

@interface DetailsTableViewController ()

@end

@implementation DetailsTableViewController

@synthesize managedObjectContext;
@synthesize hive;
@synthesize lastObservation;

//OutPut Labels
@synthesize siteNameOut;
@synthesize hiveIDOut;
@synthesize hiveCoordinates;
@synthesize ageOut;
@synthesize healthStatusOut;
@synthesize queenSourceOut;
@synthesize queenAgeOut;
@synthesize queenRatingView;

@synthesize lastSampleDateOut;
@synthesize broodTotals;
@synthesize workerTotals;
@synthesize honeyTotals;


- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    self.navigationItem.title = hive.hiveID;
    self.navigationController.toolbarHidden = NO;    
}

-(void)viewDidAppear:(BOOL)animated{
    lastObservation = hive.lastObservation;
    
    
    siteNameOut.text = hive.siteName;
    hiveIDOut.text = hive.hiveID;
    
    float lat = [hive.hiveLatitude floatValue];
    float lon = [hive.hiveLongitude floatValue];
    
    hiveCoordinates.text = [NSString stringWithFormat:@"Lat: %.6f, Long: %.6f", lat, lon];
    ageOut.text = [self printAge:hive.startDate];
    queenAgeOut.text =[self printAge:hive.requeenedOn];
    
    //Queen Performance Rating
    self.queenRatingView.rating = [lastObservation.queenPerformance floatValue];
    self.queenRatingView.editable = NO;
    self.queenRatingView.maxRating = 5;
    self.queenRatingView.delegate = self;
   
    if ([lastObservation.healthStatus integerValue] == 0) {
        healthStatusOut.text = @"Healthy";
    } else {
        healthStatusOut.text = @"Sick";
    }
    
    queenSourceOut.text = hive.currentQueenSource;
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"MM-dd-yyyy"];
    lastSampleDateOut.text = [dateformat stringFromDate:lastObservation.observationDate];
    [self calcHiveValues];

}

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating{
    
}

-(NSString *) printAge:(NSDate *)sourceDate{
    // The time interval
    NSTimeInterval theTimeInterval = -[sourceDate timeIntervalSinceNow];
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    NSString *age = nil;
    
    if([breakdownInfo year] > 0 ){  // If hive is more then a year old, display age as YY:MM
        if ([breakdownInfo month] > 0) {
            if([breakdownInfo year] >= 2){ //pluralize years
                if([breakdownInfo month] >= 2){ //pluralize months
                    age = [NSString stringWithFormat:@"%ld years, %ld months", (long)[breakdownInfo year], (long)[breakdownInfo month]];
                } else {
                    age = [NSString stringWithFormat:@"%ld years, %ld month", (long)[breakdownInfo year], (long)[breakdownInfo month]];
                }
            } else {
                if([breakdownInfo month] >= 2){
                    age = [NSString stringWithFormat:@"%ld year, %ld months", (long)[breakdownInfo year], (long)[breakdownInfo month]];
                } else {
                    age = [NSString stringWithFormat:@"%ld year, %ld month", (long)[breakdownInfo year], (long)[breakdownInfo month]];
                }
            }
            
        } else { // hive is between 12 and 13 months old
            if([breakdownInfo year] >= 2){ //pluralize years
                if([breakdownInfo day] >= 2){ //pluralize months
                    age = [NSString stringWithFormat:@"%ld years, %ld days", (long)[breakdownInfo year], (long)[breakdownInfo day]];
                } else {
                    age = [NSString stringWithFormat:@"%ld years, %ld day", (long)[breakdownInfo year], (long)[breakdownInfo day]];
                }
            } else {
                if([breakdownInfo month] >= 2){
                    age = [NSString stringWithFormat:@"%ld year, %ld days", (long)[breakdownInfo year], (long)[breakdownInfo day]];
                } else {
                    age = [NSString stringWithFormat:@"%ld year, %ld day", (long)[breakdownInfo year], (long)[breakdownInfo day]];
                }
            }
            
        }
    } else if ([breakdownInfo month] > 0) {
        if([breakdownInfo month] >= 2){
            if ([breakdownInfo day] >=2){
                age = [NSString stringWithFormat:@"%ld months, %ld days", (long)[breakdownInfo year], (long)[breakdownInfo month]];
            } else {
                age = [NSString stringWithFormat:@"%ld months, %ld day", (long)[breakdownInfo year], (long)[breakdownInfo month]];
            }
        } else {
            if ([breakdownInfo day] >=2){
                age = [NSString stringWithFormat:@"%ld month, %ld days", (long)[breakdownInfo month], (long)[breakdownInfo day]];
            } else {
                age = [NSString stringWithFormat:@"%ld month, %ld day", (long)[breakdownInfo month], (long)[breakdownInfo day]];
            }
        }
    } else {
        if ([breakdownInfo day] >=2){
            age = [NSString stringWithFormat:@"%ld days", (long)[breakdownInfo day]];
        } else {
            age = [NSString stringWithFormat:@"%ld day", (long)[breakdownInfo day]];
        }
    }
    
    return age;
}

- (void) calcHiveValues{
    
    NSSet *boxes = lastObservation.boxObservations;
   // NSLog(@"Boxes: %@", [boxes valueForKey:@"boxID"]);
    
    float framesBrood = 0;
    float framesWorkers = 0;
    float framesHoney = 0;
    
    for (id box in boxes) {
        framesBrood = framesBrood + [[box valueForKey:@"framesBrood"] floatValue];
        framesWorkers = framesWorkers + [[box valueForKey:@"framesWorkers"] floatValue];
        framesHoney = framesHoney + [[box valueForKey:@"framesHoney"] floatValue];
    }
    
    broodTotals.text = [NSString stringWithFormat:@"%.2f", framesBrood];
    workerTotals.text = [NSString stringWithFormat:@"%.2f", framesWorkers];
    honeyTotals.text = [NSString stringWithFormat:@"%.2f", framesHoney];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"editHiveSegue"]){
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        AddHiveTableViewController *addHiveTVC = (AddHiveTableViewController *)[navController topViewController];
        addHiveTVC.sourceVC = @"editHiveSegue";
        addHiveTVC.hive = hive;
        
    } else if ([[segue identifier] isEqualToString:@"editBoxesSegue"]){
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        HiveBoxesTableViewController *hiveBoxTVC = (HiveBoxesTableViewController *) [navController topViewController];
        hiveBoxTVC.hive = hive;

        
    } else if ([[segue identifier] isEqualToString:@"visualizeDataSegue"]){
        [[DataLuggage sharedObject] setHive:hive];
        NSLog(@"Data Luggage Value: %@", [[DataLuggage sharedObject] hive]);

    }
    
    
}

-(IBAction) unwindToHiveDetails:(UIStoryboardSegue *)segue{
    NSLog(@"Unwind to Hive Details");
}

@end
