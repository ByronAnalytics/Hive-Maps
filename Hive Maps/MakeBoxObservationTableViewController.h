//
//  MakeBoxObservationTableViewController.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/16/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiveDetails.h"
#import "HiveObservation.h"
#import <MessageUI/MessageUI.h>

@interface MakeBoxObservationTableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

//Core Data elements
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) HiveDetails *hive;
@property (strong, nonatomic) HiveObservation *hiveObservation;

//Class Variables
@property (strong, nonatomic) NSMutableSet *completedBoxes;
@property (nonatomic, assign, getter=isSampled) BOOL sampled;

//-----USER INTERACTION-----
//Navigation
@property (weak, nonatomic) IBOutlet UIBarButtonItem *commitDataButton;

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
