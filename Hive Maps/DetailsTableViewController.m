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
          NSLog(@"Hive Details For: %@", hive);
    
    //email Bug Report
    UISwipeGestureRecognizer *swipeRightForEmail = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToEmail:)];
    swipeRightForEmail.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRightForEmail.numberOfTouchesRequired = 2;
    [self.tableView addGestureRecognizer:swipeRightForEmail];

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
    unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitMonth;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    NSString *age = nil;
    
       if ([breakdownInfo month] > 0) {
           //Report age in months
           if([breakdownInfo month] > 1){
               age = [NSString stringWithFormat:@"%ld months", (long)[breakdownInfo month]];
           } else {
               age = [NSString stringWithFormat:@"%ld month", (long)[breakdownInfo month]];
           }
        } else {
            //Report age in days
            if ([breakdownInfo day] > 1) {
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
        
    }
    
    
}

-(IBAction) unwindToHiveDetails:(UIStoryboardSegue *)segue{
    NSLog(@"Unwind to Hive Details");
}

#pragma mark ----------- Email Bug Report -----------
- (void)swipeToEmail:(UISwipeGestureRecognizer *)sender {
    NSString *viewString = @"Hive Details";
    
    // Email Subject
    NSString *emailTitle = @"Hive Maps Bug Report to Developer";
    // Email Content
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    NSString *deviceType = [UIDevice currentDevice].model;
    NSString *messageBody = [NSString stringWithFormat:@"Describe the Bug:\n\nwhat were you doing:\n\nWhat happened?\n\nAny additional information\n\n\n\n---------system info------------\niOS: %@, Device: %@\nCurrent View:%@",currSysVer, deviceType, viewString];
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"kwbyron@byronanalytics.com"];
    NSArray *ccRecipents = [NSArray arrayWithObject:@"quentinalexander2000@gmail.com"];
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    [mc setCcRecipients:ccRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
