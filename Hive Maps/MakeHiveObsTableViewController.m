//
//  MakeHiveObsTableViewController.m
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/4/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//
/* ################### TO DO ########################
 1. Get weather fetches data with progress bar, touching temp tf
    links out to weather view.
 2. Queen Performance to 5-star system
 3. Illness/treatment picker
 4. Expand table for illness frames if sick, otherwise hide.
 5. Wire in Re-queen and enable/disable Queen Source.
*/

#import "MakeHiveObsTableViewController.h"

#import "AppDelegate.h"
#import "MainTableViewController.h"
#import "GetWeatherTableViewController.h"
#import "MakeBoxObservationTableViewController.h"

//Alert View Tag Macros
#define kAlertViewInfo 1
#define kAlertViewSaveData 2

//Constants
#define kFrameWeight 2.5

@interface MakeHiveObsTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *treatmentAlert;

@end

@implementation MakeHiveObsTableViewController

//managers
@synthesize managedObjectContext = _managedObjectContext;
@synthesize locationManager = _locationManager;
@synthesize location = _location;

//Class variables
@synthesize hiveObservation;
@synthesize hive;
@synthesize aggressionLevel;
@synthesize treatmentMethod;
@synthesize treatmentStatus;
 
//Inputs and Outlets
  @synthesize temperatureValue;
  //Behavior
  @synthesize swarmSwitch;
  @synthesize insurSwitch;
  @synthesize droneSwitch;
  //Queen Attributes
  @synthesize obsQueenLablel;
  @synthesize obsQueenSwitch;
  @synthesize queenRateView;
  @synthesize queenRating;
  @synthesize requeenLabel;
  @synthesize requeenSwitch;
  @synthesize queenSourceLabel;
  @synthesize queenSourceTF;
  //Health Attributes
  @synthesize propolisLabel;
  @synthesize propolisSwitch;
  @synthesize statusLabel;
  @synthesize statusSwitch;
  @synthesize treatmentLabel;
  @synthesize treatmentTextField;
  @synthesize treatmentAlert;
  @synthesize treatmentPhaseSegmentControl;

  @synthesize commentTextField;


- (void)viewDidLoad {
    [super viewDidLoad];
    
     //Setup instance of Hive Observation Entity
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
   
    if([CLLocationManager locationServicesEnabled]){
        _locationManager = [appDelegate locationManager];
        _location = appDelegate.locationManager.location;
        [_locationManager startUpdatingLocation];
    }
   hiveObservation = (HiveObservation * )[NSEntityDescription insertNewObjectForEntityForName:@"HiveObservation" inManagedObjectContext:_managedObjectContext];
   
    //Dismiss Keyboard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    //Format Display settings
    self.navigationItem.title = self.hive.hiveID;
        //Aggression Data
    aggressionLevel = [NSNumber numberWithInt:1];
    
    //Queen Performance Rating
    self.queenRateView.rating = 0;
    self.queenRateView.editable = YES;
    self.queenRateView.maxRating = 5;
    self.queenRateView.delegate = self;
    
    //Comment Text Field
    commentTextField.text = @"Add Notes";
    commentTextField.textColor = [UIColor blueColor];
    commentTextField.delegate = self;
    
    //email Bug Report
    UISwipeGestureRecognizer *swipeRightForEmail = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToEmail:)];
    swipeRightForEmail.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRightForEmail.numberOfTouchesRequired = 2;
    [self.tableView addGestureRecognizer:swipeRightForEmail];

}

- (BOOL) textViewShouldBeginEditing:(UITextField *)textField{
    
    if ([commentTextField.text isEqualToString:@"Add Notes"]) {
        commentTextField.text = @"";
        commentTextField.textColor = [UIColor blackColor];
    }
    
    return YES;
}
-(void)textFieldDidChange:(UITextField *)textField{
    if (commentTextField.text.length == 0) {
        commentTextField.text = @"Add Notes";
        commentTextField.textColor = [UIColor blueColor];
        [commentTextField resignFirstResponder];
    }

    
}

-(void) viewDidAppear:(BOOL)animated {
    //code run each time view appears
    
    //Change temperature field to show the temp if collected
    NSString *temperature = [hiveObservation valueForKeyPath:@"weatherObservation.temperature"];
    if(temperature == nil){
        temperatureValue.text = @"--.-";
    }else {
        temperatureValue.text = [NSString stringWithFormat:@"%@", temperature];
    }
    
    [self requeenSwitchChanged:nil];
    [self healthSwitch:nil];
}

- (void) hideKeyboard {
    [treatmentTextField resignFirstResponder];
    [commentTextField resignFirstResponder];
    [queenSourceTF resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --------------- User Input Controls ---------------
//Aggression Input
-(IBAction)segIndexChanged:(UISegmentedControl *)sender
{
    int tempAggressionLevel = 1;
    
    switch (self.aggressionSegControl.selectedSegmentIndex)
    {
        case 0:
            tempAggressionLevel = 1;
            break;
        case 1:
            tempAggressionLevel = 2;
            break;
        case 2:
            tempAggressionLevel = 3;
            break;
        case 3:
            tempAggressionLevel = 4;
            break;
        case 4:
            tempAggressionLevel = 5;
            break;
        default:
            break;
    }
    
    aggressionLevel = [NSNumber numberWithInt:tempAggressionLevel];
}
//Queen Attributes
- (IBAction)obsQueenSwitchChanged:(id)sender {
    if (obsQueenSwitch.on == TRUE) {
        obsQueenLablel.text = @"Yes";
    } else {
        obsQueenLablel.text = @"No";
    }
}

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    queenRating = [NSNumber numberWithFloat: rating];
}

- (IBAction)requeenSwitchChanged:(id)sender {
    //Did Hive Re-Queen??
    if (requeenSwitch.on == YES){
        requeenLabel.text = @"Yes";
        queenSourceLabel.textColor = [UIColor blackColor];
        queenSourceTF.enabled = YES;
        
    } else {
        requeenLabel.text = @"No";
        queenSourceLabel.textColor = [UIColor lightGrayColor];
        queenSourceTF.enabled = NO;
        
    }
}

// Health Attributes
- (IBAction)propolisSwitchChanged:(id)sender {
    if(self.propolisSwitch.on == YES){
        propolisLabel.text = @"Observed";
    } else {
        propolisLabel.text = @"Not Observed";
    }
}

- (IBAction)healthSwitch:(id)sender {
    if(self.statusSwitch.on==YES){
        self.statusLabel.text = @"Status: Sick";
        treatmentTextField.enabled = YES;
        treatmentLabel.textColor = [UIColor blackColor];
        treatmentPhaseSegmentControl.enabled = YES;
        [treatmentPhaseSegmentControl setTintColor:nil];
        treatmentAlert.enabled = YES;
        
    } else {
        self.statusLabel.text = @"Status: Healthy";
        treatmentTextField.enabled = NO;
        treatmentLabel.textColor = [UIColor lightGrayColor];
        treatmentPhaseSegmentControl.enabled = NO;
        treatmentPhaseSegmentControl.tintColor = [UIColor lightGrayColor];
        treatmentAlert.enabled = NO;
    }
    
}

- (IBAction)treatmentSegControl:(UISegmentedControl *)sender {
    
    switch (self.treatmentPhaseSegmentControl.selectedSegmentIndex) {
        case 0:
            treatmentStatus = @"none";
            break;
        case 1:
            treatmentStatus = @"started";
            break;
        case 2:
            treatmentStatus = @"on going";
            break;
        case 3:
            treatmentStatus = @"finished";
            break;
            
        default:
            break;
    }
}

#pragma mark --------------- Alert Views ---------------

- (IBAction)treatmentAlert:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Describe Illness and Treatment"
                                                    message:@"i.e. Varroa Mites, hung 2 Aspistan strips."
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    
    alert.tag = kAlertViewInfo;
    [alert show];
}

- (IBAction)queenPerfPopup:(id)sender {
    NSString *messageText = @"Rate the queen's performance on a scale of 1-10";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Defining Queen Performance"
                                                    message:messageText
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    
    NSArray *subviewArray = alert.subviews;
    for(int x = 0; x < [subviewArray count]; x++){
        
        if([[[subviewArray objectAtIndex:x] class] isSubclassOfClass:[UILabel class]]) {
            UILabel *label = [subviewArray objectAtIndex:x];
            label.textAlignment = NSTextAlignmentLeft;
        }
    }
    
    alert.tag = kAlertViewInfo;
    [alert show];
}

- (IBAction)aggInfoPopup:(id)sender {
    
    NSString *messageText = @"1 - Bees are docile \n3 - Bees are defensive\n5 - Bees are highly aggressive ";
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Defining Aggression Level"
                                                    message:messageText
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    NSArray *subviewArray = alert.subviews;
    for(int x = 0; x < [subviewArray count]; x++){
        
        if([[[subviewArray objectAtIndex:x] class] isSubclassOfClass:[UILabel class]]) {
            UILabel *label = [subviewArray objectAtIndex:x];
            label.textAlignment = NSTextAlignmentLeft;
        }
    }
    alert.tag = kAlertViewInfo;
    [alert show];
}


#pragma mark --------------- SAVE DATA TO CORE DATA ---------------
- (IBAction)saveObsEvent:(id)sender {
    
    hiveObservation.observationDate = [NSDate date];
    
    //Hive Behavior
    hiveObservation.cupsInsur = [NSNumber numberWithBool:insurSwitch.on];
    hiveObservation.drone = [NSNumber numberWithBool:droneSwitch.on];
    hiveObservation.swarm = [NSNumber numberWithBool:swarmSwitch.on];
    hiveObservation.aggressionLevel = aggressionLevel;
    hiveObservation.observedQueen = [NSNumber numberWithBool:obsQueenSwitch.on];
    hiveObservation.queenPerformance = queenRating;
    hiveObservation.requeened = [NSNumber numberWithBool:requeenSwitch.on];
    
    if (requeenSwitch.on == YES) {
        hiveObservation.queenSource = queenSourceTF.text;
        hive.currentQueenSource = queenSourceTF.text;
        hive.requeenedOn = [NSDate date];
        
    } else {
        hiveObservation.queenSource = hive.currentQueenSource;
    }
    
    //Hive Health
    hiveObservation.propolisObserved = [NSNumber numberWithBool:propolisSwitch.on];
    hiveObservation.healthStatus = [NSNumber numberWithBool:statusSwitch.on];
    hiveObservation.treatment = treatmentTextField.text;
    hiveObservation.treatmentStage = treatmentStatus;
    hiveObservation.commentBox = commentTextField.text;
    hive.lastObservation = hiveObservation;
    
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        //Handle the error.
        NSLog(@"Oh NO!%@",error);
    }
    
    [self performSegueWithIdentifier:@"unwindToHome" sender:self];
}

- (IBAction)cancelHiveObs:(id)sender {
    //add popup to notify cancel = lost data
    
    UIAlertView *alertView3 = [[UIAlertView alloc] initWithTitle:@"Warning: Data Will Be Lost"
                                                         message:@"Any hive-related observations from today will be discarded"
                                                        delegate:self
                                               cancelButtonTitle:@"Discard Data"
                                               otherButtonTitles:@"Stay", nil];
    alertView3.tag = kAlertViewSaveData;
    [alertView3 show];
}

//Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == kAlertViewInfo){
        //Dialog boxes, no action needed
        NSLog(@"No Action");
        
    } else if(alertView.tag == kAlertViewSaveData){
        if (buttonIndex == 1){
            //message dismissed, no action
            NSLog(@"Cancel");
            
        }else if(buttonIndex == 0){
            NSLog(@"Data discarded");
            //code for discarding new managed object and recent weather observations
            //[self.managedObjectContext rollback];
            [self performSegueWithIdentifier:@"unwindToHome" sender:self];
        }
    }
    
}

#pragma mark -------  Navigation -------

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //Segue to Get Weather View, initiate communication with API
    if ([[segue identifier] isEqualToString:@"getWeatherSegue"]){
        [self.locationManager stopUpdatingLocation];
        
        //Pass selected Hive to new view controller
        UINavigationController *navController = (UINavigationController *) [segue destinationViewController];
        GetWeatherTableViewController  *getWeatherTableViewController = (GetWeatherTableViewController *)[navController topViewController];
        
        getWeatherTableViewController.location = _location;
        getWeatherTableViewController.hiveObs = hiveObservation;
        
    } else if ([[segue identifier] isEqualToString:@"makeBoxObs"]) {
        [self.locationManager stopUpdatingLocation];

        //Pass selected Hive to new view controller
        UINavigationController *navController = (UINavigationController *) [segue destinationViewController];
        MakeBoxObservationTableViewController *makeBoxObservationTableViewController = (MakeBoxObservationTableViewController *)[navController topViewController];
        makeBoxObservationTableViewController.hive = hive;

    } else {
        
        [self.locationManager stopUpdatingLocation];
    }
    
}

// Unwind Segues
-(IBAction)saveWeatherToObsrvHive:(UIStoryboardSegue *)segue{
    //Get Weather View Controller calls when 'save' tapped
    
    NSLog(@"Relationship: %@", hiveObservation.weatherObservation);
    
}

-(IBAction)unwindToObsrvHive:(UIStoryboardSegue *)segue{
    //return from box-frame observations
    MakeBoxObservationTableViewController *boxObsTVC = [segue sourceViewController];
    NSLog(@"Box Dict: %@", boxObsTVC.completedBoxes);
    
    [hiveObservation addBoxObservations:boxObsTVC.completedBoxes];
    NSLog(@"Hive Observation with Box Relationship: %@", hiveObservation);
    
}

-(IBAction)cancelToObsrvHive:(UIStoryboardSegue *)segue{
}

#pragma mark ----------- Email Bug Report -----------
- (void)swipeToEmail:(UISwipeGestureRecognizer *)sender {
    NSString *viewString = @"Observe Hive";
    
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
