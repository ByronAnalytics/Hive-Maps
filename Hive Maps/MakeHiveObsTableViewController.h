//
//  MakeHiveObsTableViewController.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/4/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "HiveDetails.h"
#import "HiveObservation.h"
#import "WeatherObservation.h"
#import "RateView.h"

@interface MakeHiveObsTableViewController : UITableViewController <UIAlertViewDelegate, CLLocationManagerDelegate, UITextViewDelegate, RateViewDelegate>

//Core Data elements
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) HiveDetails *hive;
@property (strong, nonatomic) HiveObservation *hiveObservation;
@property (strong, nonatomic) NSSet *setData;

//Core Location Elements
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

//Class Variables
@property (strong, nonatomic) NSNumber *aggressionLevel;

//User Inputs and Outlets
//Weather
@property (weak, nonatomic) IBOutlet UITextField *temperatureValue;

// Behavior Elements
@property (weak, nonatomic) IBOutlet UISwitch *swarmSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *insurSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *droneSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *aggressionSegControl;
- (IBAction)segIndexChanged:(id)sender;

// Queen Attributes
@property (weak, nonatomic) IBOutlet UILabel *obsQueenLablel;
@property (weak, nonatomic) IBOutlet UISwitch *obsQueenSwitch;
@property (weak, nonatomic) IBOutlet RateView *queenRateView;
@property (strong, nonatomic) NSNumber *queenRating;

//ReQueen Event
@property (weak, nonatomic) IBOutlet UISwitch *requeenSwitch;
@property (weak, nonatomic) IBOutlet UILabel *requeenLabel;
@property (weak, nonatomic) IBOutlet UITextField *queenSourceTF;
@property (weak, nonatomic) IBOutlet UILabel *queenSourceLabel;
- (IBAction)requeenSwitchChanged:(id)sender;

//Health Elements
@property (weak, nonatomic) IBOutlet UILabel *propolisLabel;
@property (weak, nonatomic) IBOutlet UISwitch *propolisSwitch;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISwitch *statusSwitch;

@property (weak, nonatomic) IBOutlet UILabel *treatmentLabel;
@property (weak, nonatomic) IBOutlet UITextField *treatmentTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *treatmentPhaseSegmentControl;

@property (weak, nonatomic) IBOutlet UITextView *commentTextField;

@property (strong, nonatomic) NSString *treatmentStatus;
@property (strong, nonatomic) NSString *treatmentMethod;

//Actions

@end
