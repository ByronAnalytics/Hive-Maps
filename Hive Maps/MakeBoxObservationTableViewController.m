//
//  MakeBoxObservationTableViewController.m
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/16/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//
/* ################### TO DO ########################
 1. Grey-out feature for picker views.
 */

#import "MakeBoxObservationTableViewController.h"
#import "AppDelegate.h"
#import "MakeHiveObsTableViewController.h"

#import "HiveBox.h"
#import "BoxObservation.h"

@interface MakeBoxObservationTableViewController ()

//With in Class Variables
@property (strong, nonatomic) NSMutableDictionary *boxStatus; //value: Status key:boxID
@property (strong, nonatomic) NSArray *boxFrameArray;
@property (strong, nonatomic) NSMutableDictionary *managedObjectIDs;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *commitDataButton;

//Picker Elements
@property (strong, nonatomic) UIPickerView *boxPicker;
@property (strong, nonatomic) NSArray *boxPickerData;
@property (strong, nonatomic) NSArray *boxIdArray;
@property (strong, nonatomic) NSArray *boxDataArray;

//Box Details User Elements
@property (weak, nonatomic) IBOutlet UILabel *box1ofNLabel;
@property (weak, nonatomic) IBOutlet UILabel *boxesObservedLabel;
@property (weak, nonatomic) IBOutlet UITextField *boxIDTF;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

//Productivity Inputs
@property (weak, nonatomic) IBOutlet UISlider *broodSlider;
@property (weak, nonatomic) IBOutlet UILabel *broodLabel;
@property (weak, nonatomic) IBOutlet UISlider *workerSlider;
@property (weak, nonatomic) IBOutlet UILabel *workerLabel;
@property (weak, nonatomic) IBOutlet UISlider *honeySlider;
@property (weak, nonatomic) IBOutlet UILabel *honeyLabel;

//Wax BuildOut
@property (weak, nonatomic) IBOutlet UISwitch *waxSwitch;
@property (weak, nonatomic) IBOutlet UILabel *waxSwitchLabel;
@property (weak, nonatomic) IBOutlet UISlider *waxSlider;
@property (weak, nonatomic) IBOutlet UILabel *waxSliderLabel;
@property (weak, nonatomic) IBOutlet UILabel *waxBuildOutLabel;

@end

@implementation MakeBoxObservationTableViewController

//Core Data Elements
@synthesize managedObjectContext = _managedObjectContext;
@synthesize hive;
@synthesize hiveObservation;

//InClass Variables
@synthesize boxStatus;
@synthesize boxFrameArray;
@synthesize managedObjectIDs;
@synthesize completedBoxes; // passed back to hiveObservation to set relationship
@synthesize commitDataButton;

int boxesSavedIndex = 0;
int totalFrames;
BOOL alertMade;


//Picker Elements
@synthesize boxPicker;
@synthesize boxPickerData;
@synthesize boxIdArray;
@synthesize boxDataArray;

//Box Details User Elements
@synthesize box1ofNLabel;
@synthesize boxesObservedLabel;
@synthesize boxIDTF;
@synthesize statusLabel;

//Productivity Inputs
@synthesize broodSlider;
@synthesize broodLabel;
@synthesize workerSlider;
@synthesize workerLabel;
@synthesize honeySlider;
@synthesize honeyLabel;

@synthesize waxSwitch;
@synthesize waxSwitchLabel;
@synthesize waxSlider;
@synthesize waxSliderLabel;
@synthesize waxBuildOutLabel;


- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    
    [self loadBoxes]; //setup arrays for picker, slider limits, and core data
    alertMade = NO;
    
    //Set initial Label Values
    box1ofNLabel.text = [NSString stringWithFormat:@"0 of %lu", (unsigned long)boxIdArray.count];
    statusLabel.text = @"Status:";

    //Setup Picker
    boxPicker = [[UIPickerView alloc] init];
    boxPicker.dataSource = self;
    boxPicker.delegate = self;
    
    boxIDTF.inputView = boxPicker;
    boxPickerData = boxIdArray;
    
    //set initial state for wax buildout
    waxBuildOutLabel.textColor = [UIColor grayColor];
    waxSliderLabel.textColor = [UIColor grayColor];
    
    //email Bug Report
    UISwipeGestureRecognizer *swipeRightForEmail = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToEmail:)];
    swipeRightForEmail.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRightForEmail.numberOfTouchesRequired = 2;
    [self.tableView addGestureRecognizer:swipeRightForEmail];

}

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadBoxes{
    // Fetch Boxes associated with Hive --> boxDataArray
    NSSortDescriptor *boxIDDescriptor = [[NSSortDescriptor alloc] initWithKey:@"boxID" ascending:YES];
    boxDataArray = [hive.hiveBoxes sortedArrayUsingDescriptors:[NSArray arrayWithObject:boxIDDescriptor]];
    boxIdArray = [boxDataArray valueForKey:@"boxID"];
    
    //populate array for setting slider max number of frames
    boxStatus = [[NSMutableDictionary alloc] init];
    managedObjectIDs = [[NSMutableDictionary alloc] initWithCapacity:boxIdArray.count];
    
    boxFrameArray = [boxDataArray valueForKey:@"numFrames"];
    for (int i = 0; i < boxIdArray.count; i++) {
        [boxStatus setValue:@"No" forKey:boxIdArray[i]];
        
    }
}

#pragma mark --------------- Box Picker Controls ---------------
- (IBAction)boxIDTFChanged:(id)sender {
    // Format Labels
    NSInteger index = [boxPicker selectedRowInComponent:0] + 1; //shift from zero index to 1 index
    NSInteger numBoxes = [boxIdArray count];
    NSString *currentBox = boxIDTF.text;
    
    box1ofNLabel.text = [NSString stringWithFormat:@"%ld of %ld",(long)index, (long)numBoxes];
    statusLabel.text = [boxStatus valueForKey:currentBox];

    NSString *rowBoxStatus = [boxStatus valueForKey:currentBox];
    
    if ([rowBoxStatus  isEqual: @"No"] == TRUE) {
        
        statusLabel.text = @"Status: unsaved";
        broodSlider.value = 0;
        workerSlider.value = 0;
        honeySlider.value = 0;
        waxSwitch.on = NO;
        waxSlider.value = 0;
        
        [self broodSliderChanged:nil];
        [self workerSliderChanged:nil];
        [self honeySliderChanged:nil];
        [self waxSliderValueChanged:nil];
        
        
    } else {
        
            statusLabel.text = @"Status: saved";
        BoxObservation *box = [managedObjectIDs valueForKey:boxIDTF.text];
        
        // get current core data values for box
        broodSlider.value = [box.framesBrood floatValue];
        workerSlider.value = [box.framesWorkers floatValue];
        honeySlider.value = [box.framesHoney floatValue];
        if ([box.buildOut integerValue] == 1) {
            waxSwitch.on =  YES;
            waxSlider.value = [box.framesBuildOut floatValue];
        } else {
            waxSwitch.on = NO;
            waxSlider.value = 0;
        }
    }
    
    //Enable Sliders
    if (broodSlider.enabled == NO) {
        commitDataButton.enabled = YES;
        broodSlider.enabled = YES;
        workerSlider.enabled = YES;
        honeySlider.enabled = YES;
    }
    
    // set slider maximum values from selected box values
    totalFrames = [[boxFrameArray objectAtIndex:[boxPicker selectedRowInComponent:0]] intValue];
    broodSlider.maximumValue = [[boxFrameArray objectAtIndex:[boxPicker selectedRowInComponent:0]] floatValue];
    workerSlider.maximumValue = [[boxFrameArray objectAtIndex:[boxPicker selectedRowInComponent:0]] floatValue];
    honeySlider.maximumValue = [[boxFrameArray objectAtIndex:[boxPicker selectedRowInComponent:0]] floatValue];
    waxSlider.maximumValue = [[boxFrameArray objectAtIndex:[boxPicker selectedRowInComponent:0]] floatValue];
  
}

//#Columns in Picker CURRENTLY SINGLE PICKER FOR BOX TYPE
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

//# rows per column, data: array of sitePicker and boxPicker
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger) component{
    return self.boxPickerData.count;
    
}


//Picker delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    boxIDTF.text = boxPickerData[row];
    [boxIDTF resignFirstResponder];
    
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{

    NSString *rowBoxID = boxPickerData[row];
    NSString *rowBoxStatus = [boxStatus valueForKey:rowBoxID];
    
    if ([rowBoxStatus  isEqual: @"Yes"] == TRUE) { //if box data hasn't been committed, text is Black
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:rowBoxID attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        return attString;
    } else {                //if box has been saved, text is greyed out
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:rowBoxID attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        return attString;
    }
}

#pragma mark --------------- Data input Controls ---------------
//Productivity inputs
- (IBAction)broodSliderChanged:(id)sender {
    int sliderValue = ceilf(broodSlider.value);
    broodLabel.text = [NSString stringWithFormat:@"%d", sliderValue];
}

- (IBAction)workerSliderChanged:(id)sender {
    int sliderValue = ceilf(workerSlider.value);
    workerLabel.text = [NSString stringWithFormat:@"%d", sliderValue];
    //Workers exist ontop of frame, not included in maximum possible values
}

- (IBAction)honeySliderChanged:(id)sender {
    int sliderValue = ceilf(honeySlider.value);
    honeyLabel.text = [NSString stringWithFormat:@"%d", sliderValue];
}

// Wax Build out Data
- (IBAction)waxSwtichChanged:(id)sender {
    if (waxSwitch.on == TRUE) {
        waxSwitchLabel.text = @"Yes";
       //slider Attributes
        waxBuildOutLabel.textColor = [UIColor blackColor];
        waxSliderLabel.textColor = [UIColor blackColor];
        waxSlider.enabled = YES;
        waxSlider.maximumValue = [[boxFrameArray objectAtIndex:[boxPicker selectedRowInComponent:0]] floatValue];
    } else {
        waxSwitchLabel.text = @"No";
        waxSlider.value = 0;
        waxSliderLabel.text = [NSString stringWithFormat:@"0"];
        //slider Attributes
        waxBuildOutLabel.textColor = [UIColor grayColor];
        waxSliderLabel.textColor = [UIColor grayColor];
        waxSlider.enabled = NO;
        
    }
}

- (IBAction)waxSliderValueChanged:(id)sender {
    int sliderValue = ceilf(waxSlider.value);
    waxSliderLabel.text = [NSString stringWithFormat:@"%d", sliderValue];
}

#pragma mark --------------- Save Data ---------------
- (IBAction)commitData:(id)sender {
    // Save to Store

    if ([[boxStatus valueForKey:boxIDTF.text] isEqualToString:@"Yes"] == TRUE){
        //Update NSManaged Object
        BoxObservation *box = [managedObjectIDs valueForKey:boxIDTF.text];
        NSLog(@"Old Box Values: %@", box);
        
        box.framesBrood = [NSNumber numberWithFloat:broodSlider.value];
        box.framesWorkers = [NSNumber numberWithFloat:workerSlider.value];
        box.framesHoney = [NSNumber numberWithFloat:honeySlider.value];
        box.buildOut = [NSNumber numberWithBool:waxSwitch.on];
        box.framesBuildOut = [NSNumber numberWithFloat:waxSlider.value];
        
        NSLog(@"Box Set: %@", completedBoxes);
        [completedBoxes removeObject:box];
        NSLog(@"Reduced Box Set: %@", completedBoxes);
        [completedBoxes addObject:box];
        NSLog(@"New Set: %@", completedBoxes);
 
        NSError *error = nil;
        if(![_managedObjectContext save:&error]){
            NSLog(@"Crap %@", error);
        }
        
    } else {
        BoxObservation *box = (BoxObservation *)[NSEntityDescription insertNewObjectForEntityForName:@"BoxObservation" inManagedObjectContext:_managedObjectContext];
        //generate site_hive_box code
        NSString *siteHiveBox = [NSString stringWithFormat:@"%@_%@_%@", hive.siteName, hive.hiveID, boxIDTF.text];
        
        box.siteHiveBox = siteHiveBox;
        box.observationDate = [NSDate date];
        box.framesBrood = [NSNumber numberWithFloat:broodSlider.value];
        box.framesWorkers = [NSNumber numberWithFloat:workerSlider.value];
        box.framesHoney = [NSNumber numberWithFloat:honeySlider.value];
        box.buildOut = [NSNumber numberWithBool:waxSwitch.on];
        box.framesBuildOut = [NSNumber numberWithInt:waxSlider.value];
        
        
        //Relationships
        box.hiveBox = [boxDataArray objectAtIndex:[boxIdArray indexOfObject:boxIDTF.text]];
        
        // set of managed objects to add to relationship in MakeHiveObservationTVC
        if (!completedBoxes) {
            completedBoxes = [[NSMutableSet alloc] init];
        }
        
        [completedBoxes addObject:box];
        NSLog(@"Expanded Set: %@", completedBoxes);
        
        NSError *error = nil;
        if(![_managedObjectContext save:&error]){
            NSLog(@"Crap %@", error);
        }
        
        [managedObjectIDs  setObject:box forKey:boxIDTF.text]; //utility to ease data-update while in view
        [boxStatus setValue:@"Yes" forKey:boxIDTF.text];
        [self nextBox];
    }

}

-(void) nextBox{
    
    int queuedBoxIndex = 0;
    
    NSArray *unsavedBoxes = [boxStatus allKeysForObject:@"No"]; // how many boxes are left
    if (unsavedBoxes.count > 0) {
        //iterate through boxes to find which is unsaved. First box that meets test is set as next sample
        for (int i = 0; i <= boxDataArray.count-1; i++) {
            NSString *tempStatus = [boxStatus valueForKey:[boxIdArray objectAtIndex:i]];
            if ([tempStatus isEqualToString:@"No"]) {
                queuedBoxIndex = i;
                break;
            }
        }
        
        // set picker to unsaved box
        [boxPicker selectRow:queuedBoxIndex inComponent:0 animated:NO];
        boxIDTF.text = [boxPickerData objectAtIndex:[boxPicker selectedRowInComponent:0]];
        [self boxIDTFChanged:nil];
        
        
    } else { //All boxes Saved
        
        //Notify User box observations complete
        if (alertMade == NO) { // only notify once
           [self boxesCompleteAlert];
        }
        
    }
    
        
        
    [boxDataArray objectAtIndex:[boxIdArray indexOfObject:boxIDTF.text]];
    
    
    
    
    
}
- (void) boxesCompleteAlert{
    //alert notification
    //Support depreciation of UIAlertVIew, use UIAlertViewController if possible
    if (NSClassFromString(@"UIAlertController")) {
        UIAlertController *doneAlert = [UIAlertController alertControllerWithTitle:@"Completed Observations!"
                                                                          message:@"Observations for all boxes are complete.\n You may stay on this page and edit values if needed, or return to making observations for the Hive."
                                                                   preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *stay = [UIAlertAction actionWithTitle:@"Edit Values"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         [doneAlert dismissViewControllerAnimated:YES completion:nil];
                                                     }];
        UIAlertAction *segue = [UIAlertAction actionWithTitle:@"Observe Hive"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
                                                          [self performSegueWithIdentifier:@"unwindToObsrvHive" sender:self];
                                                      }];
        
        
        [doneAlert addAction:stay];
        [doneAlert addAction:segue];
        [self presentViewController:doneAlert animated:YES completion:nil];
        
    } else {
        //iOS < 8.0
        UIAlertView *doneAlert = [[UIAlertView alloc] initWithTitle:@"Completed Observations!"
                                                             message:@"Observations for all boxes are complete.\n You may stay on this page and edit values if needed, or return to making observations for the Hive."
                                                            delegate:self
                                                   cancelButtonTitle:@"Edit Values"
                                                   otherButtonTitles:@"Observe Hive", nil];

        [doneAlert show];
    }

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
    }
    else if(buttonIndex == 1)
    {
        [self performSegueWithIdentifier:@"unwindToObsrvHive" sender:self];
    }
}


#pragma mark --------------- Navigation ---------------

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

#pragma mark ----------- Email Bug Report -----------
- (void)swipeToEmail:(UISwipeGestureRecognizer *)sender {
    NSString *viewString = @"Observe Boxes";
    
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
