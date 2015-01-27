//
//  AddHiveTableViewController.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/4/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "HiveBox.h"
#import "HiveDetails.h"

UIPickerView *boxPicker;

@interface AddHiveTableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate,  UITextFieldDelegate, UIAlertViewDelegate>

// Core Data Objects
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *sourceVC;
@property (strong, nonatomic) HiveDetails *hive;
@property (strong, nonatomic) HiveBox *box;
@property (strong, nonatomic) NSMutableSet *boxSet;
//Core Location Objects
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) CLLocationManager *locationManager;

#pragma mark - input variables
//Hive Section
@property (weak, nonatomic) IBOutlet UITextField *hiveIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *siteTextField;
@property (weak, nonatomic) IBOutlet UITextField *queenTextField;
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

//Box Section
@property (weak, nonatomic) IBOutlet UITextField *boxIDTextfield;
@property (weak, nonatomic) IBOutlet UITextField *boxTextField;
@property (weak, nonatomic) IBOutlet UITextField *boxStartDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *numFramesTextField;

#pragma mark - Input Labels.
//Hive
@property (weak, nonatomic) IBOutlet UILabel *hiveIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;
@property (weak, nonatomic) IBOutlet UILabel *queenSourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *hiveStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *locationActivityIndicator;
//Box
@property (weak, nonatomic) IBOutlet UILabel *boxIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *boxTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFramesLabel;
@property (weak, nonatomic) IBOutlet UILabel *boxStartLabel;


#pragma mark - Navigation Buttons
//properties
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *toolBarRightButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *toolBarLeftButton;
//actions
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)toolBarLeftButtonPressed:(id)sender;
- (IBAction)toolBarRightButtonPressed:(id)sender;

#pragma mark - IBActions
- (IBAction)upDateNumFrames:(id)sender;
- (IBAction)locationButtonPressed:(id)sender;

- (IBAction)unWindToAddHive:(UIStoryboardSegue *)segue;  //for unwind from AddBoxTVC
@end
