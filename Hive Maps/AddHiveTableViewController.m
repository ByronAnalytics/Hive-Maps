//
//  AddHiveTableViewController.m
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/4/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//
/* ################### TO DO ########################
 1. Iron Out unwind Seques
 2. Data input validation
 3. Pin toolbar buttons
 
 4. Date Pickers
 5. Site Pickers
 */

#import "AddHiveTableViewController.h"
#import "AppDelegate.h"

//Core Data imports
//#import "HiveDetails.h"
#import "BoxData.h"
//#import "HiveBox.h"

//Tags for AlertViews
#define kAlertViewSaveData 1
#define kAlertViewCheckBoxPicker 2

@interface AddHiveTableViewController ()

#pragma mark - Pickers
@property (weak, nonatomic) IBOutlet UIDatePicker *hiveDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *boxDatePicker;
@property (strong, nonatomic) NSArray *boxDataResults;
@property (strong, nonatomic) NSArray *boxPickerData;
//Date Pickers
@property (weak, nonatomic) IBOutlet UITableViewCell *hiveDateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *boxDateCell;
@property (nonatomic, assign, getter=isHiveDateOpen) BOOL hiveDateOpen;
@property (nonatomic, assign, getter=isBoxDateOpen) BOOL boxDateOpen;

@property (strong, nonatomic) NSDateFormatter *dateFormat;
@end

@implementation AddHiveTableViewController
//Core Data Objects
@synthesize managedObjectContext = _managedObjectContext;
@synthesize sourceVC;
@synthesize hive;
@synthesize box;
@synthesize boxSet;

//Core Location Objects
@synthesize location = _location;
@synthesize locationManager = _locationManager;

// Picker Elements
@synthesize hiveDatePicker;
@synthesize boxDatePicker;

@synthesize boxDataResults;
@synthesize dateFormat;
int numberBoxes;

// Navigation Buttons
@synthesize saveButton;
@synthesize toolBarLeftButton;
@synthesize toolBarRightButton;

// Labels
@synthesize hiveIDLabel;
@synthesize siteLabel;
@synthesize queenSourceLabel;
@synthesize hiveStartLabel;
@synthesize locationLabel;

@synthesize boxIDLabel;
@synthesize boxTypeLabel;
@synthesize numFramesLabel;
@synthesize boxStartLabel;

// Input Fields
@synthesize hiveIDTextField;
@synthesize siteTextField;
@synthesize queenTextField;
@synthesize startDateTextField;
@synthesize locationButton;
@synthesize locationActivityIndicator;

@synthesize boxIDTextfield;
@synthesize boxTextField;
@synthesize boxStartDateTextField;
@synthesize numFramesTextField;


- (void)viewDidLoad {
    [super viewDidLoad];
    //Load AppDelegate managed objects
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    if([CLLocationManager locationServicesEnabled]){
        _locationManager = [appDelegate locationManager];
        _location = appDelegate.locationManager.location;
    }
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    self.navigationController.toolbarHidden = NO;
    
    //email Bug Report
    UISwipeGestureRecognizer *swipeRightForEmail = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToEmail:)];
    swipeRightForEmail.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRightForEmail.numberOfTouchesRequired = 2;
    [self.tableView addGestureRecognizer:swipeRightForEmail];

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupBoxPicker];
    
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    // Setup Textfields based on source viewcontroller
    if ([sourceVC isEqualToString:@"showAddHive"]) {
        [self viewForAddHive];
        
    } else if ([sourceVC isEqualToString:@"editHiveSegue"]) {
        [self viewForEditHive];
        
    } else if ([sourceVC isEqualToString:@"addBoxSegue"]) {
        [self viewForAddBox];
        
    } else if ([sourceVC isEqualToString:@"editBoxSegue"]) {
        [self viewForEditBox];
        
    }
   
}
- (void) hideKeyboard {
    [hiveIDTextField resignFirstResponder];
    [siteTextField resignFirstResponder];
    [queenTextField resignFirstResponder];
    [startDateTextField resignFirstResponder];
    [boxIDTextfield resignFirstResponder];
    [boxTextField resignFirstResponder];
    [numFramesTextField resignFirstResponder];
    [boxStartDateTextField resignFirstResponder];
    
}
#pragma mark ---------------- Setup Views  ----------------
// ADD HIVE VIEW SETUP
- (void) viewForAddHive{
    //Location Services
    if([CLLocationManager locationServicesEnabled]){
        [_locationManager startUpdatingLocation];
    }
    
    // Setup Navigation buttons.
    [saveButton setTitle:@"Add Hive"];
    [toolBarRightButton setTitle:@"Add Box"];
    [toolBarLeftButton setTitle:@"Add Custom Box"];
    
    //Populate Date Fields
    startDateTextField.text = [dateFormat stringFromDate:[NSDate date]];
    boxStartDateTextField.text = [dateFormat stringFromDate:[NSDate date]];
    
    //Formate Location Button
    [locationButton setTitle:@"Get Location" forState:UIControlStateNormal];
}

//EDIT HIVE VIEW SETUP
-(void) viewForEditHive {
    //Location Services
    if([CLLocationManager locationServicesEnabled]){
        [_locationManager startUpdatingLocation];
    }
    
    // Setup Navigation buttons.
    [saveButton setTitle:@"Save Edits"];
    [toolBarRightButton setTitle:@""];
    [toolBarLeftButton setTitle:@""];
    toolBarLeftButton.enabled = NO;
    toolBarRightButton.enabled = NO;
    
    //populate HIVE text fields
    hiveIDTextField.text = hive.hiveID;
    siteTextField.text = hive.siteName;
    queenTextField.text = hive.currentQueenSource;
    startDateTextField.text = [dateFormat stringFromDate:hive.startDate];;
    //Formate Location Button
    [locationButton setTitle:@"Update Location" forState:UIControlStateNormal];
    
    //----------- Disable Fields -----------
    boxIDLabel.textColor = [UIColor grayColor];
    boxIDTextfield.enabled = NO;
    boxTypeLabel.textColor = [UIColor grayColor];
    boxTextField.enabled = NO;
    numFramesLabel.textColor = [UIColor grayColor];
    numFramesTextField.enabled = NO;
}

//ADD BOX VIEW SETUP
-(void) viewForAddBox{
    //ADD BOX
    // Setup Navigation buttons.
    [saveButton setTitle:@"Add Box"];
    saveButton.enabled = YES;
    [toolBarRightButton setTitle:@""];
    toolBarRightButton.enabled = NO;
    [toolBarLeftButton setTitle:@"Add Custom Box"];
    
    //Set Box Add Date to current Date
    boxStartDateTextField.text = [dateFormat stringFromDate:[NSDate date]];
    
    //populate text fields with hive values
    hiveIDTextField.text = hive.hiveID;
    siteTextField.text = hive.siteName;
    queenTextField.text = hive.currentQueenSource;
    startDateTextField.text = [dateFormat stringFromDate:hive.startDate];;
    
    //----------- Disable Fields -----------
    hiveIDLabel.textColor = [UIColor grayColor];
    hiveIDTextField.textColor = [UIColor grayColor];
    hiveIDTextField.enabled = NO;
    siteLabel.textColor = [UIColor grayColor];
    siteTextField.textColor = [UIColor grayColor];
    siteTextField.enabled = NO;
    queenSourceLabel.textColor = [UIColor grayColor];
    queenTextField.textColor = [UIColor grayColor];
    queenTextField.enabled = NO;
    hiveStartLabel.textColor = [UIColor grayColor];
    startDateTextField.textColor = [UIColor grayColor];
    startDateTextField.enabled = NO;
    locationLabel.textColor = [UIColor grayColor];
    [locationButton setTitle:@"Location Set" forState:UIControlStateNormal];
    [locationButton setEnabled:NO];
    
}

//EDIT BOX VIEW SETUP
-(void) viewForEditBox{
    // Setup Navigation buttons.
    saveButton.title = @"Save Edits";
    toolBarRightButton.title = @"";
    toolBarRightButton.enabled = NO;
    toolBarLeftButton.title = @"Add Custom Box";
    
    
    //populate text fields with box values
    boxIDTextfield.text = box.boxID;
    boxTextField.text = box.boxType;
    numFramesTextField.text = [NSString stringWithFormat:@"%@", box.numFrames];
    boxStartDateTextField.text = [dateFormat stringFromDate:box.dateCreated];
    
    //populate text fields with hive values
    hiveIDTextField.text = hive.hiveID;
    siteTextField.text = hive.siteName;
    queenTextField.text = hive.currentQueenSource;
    startDateTextField.text = [dateFormat stringFromDate:hive.startDate];;
    
    //----------- Disable Fields -----------
    hiveIDLabel.textColor = [UIColor grayColor];
    hiveIDTextField.textColor = [UIColor grayColor];
    hiveIDTextField.enabled = NO;
    siteLabel.textColor = [UIColor grayColor];
    siteTextField.textColor = [UIColor grayColor];
    siteTextField.enabled = NO;
    queenSourceLabel.textColor = [UIColor grayColor];
    queenTextField.textColor = [UIColor grayColor];
    queenTextField.enabled = NO;
    hiveStartLabel.textColor = [UIColor grayColor];
    startDateTextField.textColor = [UIColor grayColor];
    startDateTextField.enabled = NO;
    locationLabel.textColor = [UIColor grayColor];
    [locationButton setTitle:@"Location Set" forState:UIControlStateNormal];
    [locationButton setEnabled:NO];
    
}
//=============================================================================
#pragma mark -------------- User Interactions ---------------

- (IBAction)locationButtonPressed:(id)sender {
    //update Location
        [_locationManager startUpdatingLocation];
        locationLabel.text = @"Locating Hive...";
        [locationButton setTitle:@"Abort?" forState:UIControlStateSelected];
        
        NSLog(@"Location: LAT %f, Long %f", _location.coordinate.latitude, _location.coordinate.longitude);

        // Listen for Location update, when location meets user location setting, update location.
        while (_location.horizontalAccuracy > 10) {
            if (locationButton.selected == NO) {
                break;
            }
            [locationActivityIndicator isAnimating];
            NSLog(@"Accuracy: %f", _location.horizontalAccuracy);
        }
        NSLog(@"Accuracy Dialed In, Set Location");
              
        if (_location.horizontalAccuracy <= 10) {
            locationLabel.text =@"New Location Set";
            hive.hiveLatitude = [NSNumber numberWithFloat:_location.coordinate.latitude];
            hive.hiveLongitude = [NSNumber numberWithFloat:_location.coordinate.longitude];
        }
        

        locationButton.selected = NO;
        [_locationManager stopUpdatingLocation];

}

- (IBAction)upDateNumFrames:(id)sender {
    
    if (boxTextField.text.length == 0 || [boxTextField.text isEqual:nil]) {
        numFramesTextField.text = nil;
        
    } else {
        //Using selected box type, fetch value for number of frames
        NSString *boxType = boxTextField.text;
        NSFetchRequest *getNumFrames = [[NSFetchRequest alloc] initWithEntityName:@"BoxData"];
        NSPredicate *selectBoxType = [NSPredicate predicateWithFormat:@"%K == %@", @"nameBoxType", boxType];
        [getNumFrames setPredicate:selectBoxType];
        
        NSError *fetchError = nil;
        NSArray *results = [self.managedObjectContext executeFetchRequest:getNumFrames error:&fetchError];
        
        if (!fetchError) {
            
            NSArray *numberFrames = [results valueForKey:@"numFrames"];
            
            // Set Number Frames text field value based on database entry
            numFramesTextField.text = [numberFrames[0] stringValue];
            
        } else {
            NSLog(@"Error fetching data.");
            NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
        }
    }
    
    
}

- (IBAction)hiveDatePickerChanged:(id)sender {
    startDateTextField.text = [dateFormat stringFromDate:hiveDatePicker.date];
}
- (IBAction)boxDatePickerChanged:(id)sender {
    boxStartDateTextField.text = [dateFormat stringFromDate:boxDatePicker.date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark ---------------- Pickers ----------------
-(void) setupBoxPicker {
    //Fetch Box Data
    NSFetchRequest *getBoxData = [[NSFetchRequest alloc] initWithEntityName:@"BoxData"];
    NSError *fetchError = nil;
    boxDataResults = [self.managedObjectContext executeFetchRequest:getBoxData error:&fetchError];
    
    // Get array of boxTypes from database
    NSMutableArray *boxTypeArray = [[NSMutableArray alloc] init];
    for (NSManagedObject *managedObject in boxDataResults) {
        [boxTypeArray addObject:[managedObject valueForKey:@"nameBoxType"]];
    }
    
    //setup picker
    UIPickerView *boxPicker = [[UIPickerView alloc] init];
    boxPicker.dataSource = self;
    boxPicker.delegate = self;
    self.boxTextField.inputView = boxPicker;
    self.boxPickerData = boxTypeArray;
}

//#Columns in Picker CURRENTLY SINGLE PICKER FOR BOX TYPE
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}
//# rows per column, data: array of sitePicker and boxPicker
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger) component{
    
    return self.boxPickerData.count;
    
}
//Row titles
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.boxPickerData[row];
    
}
//Picker delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.boxTextField.text = self.boxPickerData[row];
    [self.boxTextField resignFirstResponder];
}

#pragma mark ---------------- Table view data source ----------------
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            
            if (indexPath.row == 4 && !self.isHiveDateOpen) {
                return 0;
            } else {
                return [super tableView:tableView heightForRowAtIndexPath:indexPath];
            }
            break;
        case 1:
            if (indexPath.row == 4 && !self.isBoxDateOpen) {
                return 0;
            } else {
                return [super tableView:tableView heightForRowAtIndexPath:indexPath];
            }
            break;
        default:
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
            break;
    }
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    if (cell == self.hiveDateCell){
        
       self.hiveDateOpen = !self.isHiveDateOpen;
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        NSLog(@"HiveDateCell");
    }
    
    if (cell == self.boxDateCell){
         NSLog(@"BoxDateCell");
       self.BoxDateOpen = !self.isBoxDateOpen;
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
 
}

#pragma mark ---------------- Navigation Button Controls ----------------
// SAVE BUTTON
- (IBAction)saveButtonPressed:(id)sender {
   BOOL areFieldsComplete = [self locateEmptyTextField];
    if (areFieldsComplete) {
     
        if ([sourceVC isEqualToString:@"editBoxSegue"]){
            [self editBox];
            [self performSegueWithIdentifier:@"unwindToBoxDetails" sender:self];

        } else if ([sourceVC isEqualToString:@"addBoxSegue"]){
            BOOL areFieldsComplete = [self locateEmptyTextField];
            if(areFieldsComplete) [self addNewBox];
    
        } else if ([sourceVC isEqualToString:@"editHiveSegue"]){
            [self editHive];
            [self performSegueWithIdentifier:@"unwindToHiveDetails" sender:self];
        
        } else if ([sourceVC isEqualToString:@"showAddHive"]){
            [self saveNewHive];
        
        }
    }

}
// DONE BUTTON
- (IBAction)doneButtonPressed:(id)sender {
    if ([sourceVC isEqualToString:@"editBoxSegue"]){
        [self performSegueWithIdentifier:@"unwindToBoxDetails" sender:self];
        
    } else if ([sourceVC isEqualToString:@"addBoxSegue"]){
        [self performSegueWithIdentifier:@"unwindToBoxDetails" sender:self];
        
    } else if ([sourceVC isEqualToString:@"editHiveSegue"]){
        [self performSegueWithIdentifier:@"unwindToHiveDetails" sender:self];
        
    } else if ([sourceVC isEqualToString:@"showAddHive"]){
        if ([hiveIDTextField.text isEqual:@""]) {
            [self performSegueWithIdentifier:@"unwindToHome" sender:self];
            
        } else {
            [self hiveNotSavedAlert];
        }
        
    }

}
// RIGHT-BAR BUTTON
- (IBAction)toolBarRightButtonPressed:(id)sender {
    BOOL areFieldsComplete = [self locateEmptyTextField];
    if (areFieldsComplete) {

        if ([sourceVC isEqualToString:@"addBoxSegue"]){
            //moved to Save Button
        
        } else if ([sourceVC isEqualToString:@"showAddHive"]){
            NSLog(@"Adding New Hive - Add Box Pressed");
            [self addNewBox];
        }
    }

}
// LEFT-BAR BUTTON
- (IBAction)toolBarLeftButtonPressed:(id)sender {
    //Should Perform Segue setup in storyboard to Custom Box
}

#pragma mark ---------- Commit Changes to Store ----------

-(void) addNewBox{
    
        HiveBox *newBox = (HiveBox *)[NSEntityDescription insertNewObjectForEntityForName:@"HiveBox" inManagedObjectContext:_managedObjectContext];
        newBox.boxID = boxIDTextfield.text;
        newBox.boxType = boxTextField.text;
        newBox.numFrames = [NSNumber numberWithInteger:[numFramesTextField.text integerValue]];
    
        //Set Date format, convert string to date value
        newBox.dateCreated = [dateFormat dateFromString:boxStartDateTextField.text];
        
        //Set BoxData Relationship
        //get managed object for box selected
        NSString *boxType = boxTextField.text;
        NSFetchRequest *getNumFrames = [[NSFetchRequest alloc] initWithEntityName:@"BoxData"];
        NSPredicate *selectBoxType = [NSPredicate predicateWithFormat:@"%K == %@", @"nameBoxType", boxType];
        [getNumFrames setPredicate:selectBoxType];
        
        NSError *fetchError = nil;
        NSArray *selectedBox = [self.managedObjectContext executeFetchRequest:getNumFrames error:&fetchError];
        
        if ([selectedBox count] > 1) {
            NSLog(@"Error, multiple boxes fetched");
            NSLog(@"Array length: %lu",(unsigned long)[selectedBox count]);
          } else {
            newBox.boxData = selectedBox[0];
          }

        if ([sourceVC isEqualToString:@"showAddHive"]) {
            if (!boxSet) {
                boxSet = [[NSMutableSet alloc] init];
            }
             [boxSet addObject:newBox];
             NSLog(@"New Box Stored in boxSet: %@", boxSet);
            
          } else {
            //Set Relationship
            newBox.hiveDetail = hive;
          }
        
        //Clear Box Text Fields
        boxIDTextfield.text = nil;
        boxTextField.text = nil;
        numFramesTextField.text = nil;
        
        NSError *error = nil;
        if (![_managedObjectContext save:&error]) {
            //Handle the error.
        }
    
}

-(void) editBox{
    HiveBox *editedBox = box;
    
    editedBox.boxID = boxIDTextfield.text;
    editedBox.boxType = boxTextField.text;
    editedBox.numFrames = [NSNumber numberWithInteger:[numFramesTextField.text integerValue]];
    
    editedBox.dateCreated = [dateFormat dateFromString:boxStartDateTextField.text];
    
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        //Handle the error.
    }
}

-(void) editHive{
    HiveDetails *editedHive = hive;
    
    editedHive.hiveID = hiveIDTextField.text;
    editedHive.siteName = siteTextField.text;
    editedHive.currentQueenSource = queenTextField.text;
    
    editedHive.startDate = [dateFormat dateFromString:startDateTextField.text];
    editedHive.requeenedOn = [dateFormat dateFromString:startDateTextField.text];
    editedHive.hiveLatitude = [NSNumber numberWithFloat:_location.coordinate.latitude];
    editedHive.hiveLongitude = [NSNumber numberWithFloat:_location.coordinate.longitude];
    
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        //Handle the error.
    }
}

-(void) saveNewHive{
        //Instantiate hive managed object
        hive = (HiveDetails *)[NSEntityDescription insertNewObjectForEntityForName:@"HiveDetails" inManagedObjectContext:_managedObjectContext];
        
        // HiveDetails Managed Object
        hive.hiveID = hiveIDTextField.text;
        hive.currentQueenSource = queenTextField.text;
        hive.siteName = [siteTextField.text capitalizedStringWithLocale:nil];
        hive.hiveLatitude = [NSNumber numberWithFloat:_location.coordinate.latitude];
        hive.hiveLongitude = [NSNumber numberWithFloat:_location.coordinate.longitude];
        
        hive.startDate = [dateFormat dateFromString:startDateTextField.text];
        hive.requeenedOn = [dateFormat dateFromString:startDateTextField.text];
        
        if (![boxTextField.text isEqualToString:@""]) {
            NSLog(@"Add New Hive, Box type not empty");
            //HiveBox Managed Object
            HiveBox *hiveBox = (HiveBox *)[NSEntityDescription insertNewObjectForEntityForName:@"HiveBox" inManagedObjectContext:_managedObjectContext];
            hiveBox.boxID = boxIDTextfield.text;
            hiveBox.numFrames = [NSNumber numberWithInteger:[numFramesTextField.text integerValue]];
            hiveBox.boxType = boxTextField.text;
            hiveBox.dateCreated = [dateFormat dateFromString:boxStartDateTextField.text];
            hiveBox.hiveDetail = hive;
            
            //Set Core Data Relationships
            //get managed object for box selected
            NSString *boxType = boxTextField.text;
            NSFetchRequest *getNumFrames = [[NSFetchRequest alloc] initWithEntityName:@"BoxData"];
            NSPredicate *selectBoxType = [NSPredicate predicateWithFormat:@"%K == %@", @"nameBoxType", boxType];
            [getNumFrames setPredicate:selectBoxType];
            
            NSError *fetchError = nil;
            NSArray *selectedBox = [self.managedObjectContext executeFetchRequest:getNumFrames error:&fetchError];
    
            if ([selectedBox count] > 1) {
                NSLog(@"Error, multiple boxes fetched");
                NSLog(@"Array length: %lu",(unsigned long)[selectedBox count]);
                } else {
                hiveBox.boxData = selectedBox[0];
                }
            }

        if (boxSet.count != 0) {
            
            [hive addHiveBoxes:boxSet];
            NSLog(@"Box Set: %@", boxSet);
            NSLog(@"Relationship set from box Set: %@", hive.hiveBoxes);
        
            }
        
        NSError *error = nil;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Save Error %@", error);
            }
    
        hiveIDTextField.text = nil;
        [self performSegueWithIdentifier:@"unwindToHome" sender:self];
          
    
}

-(BOOL)locateEmptyTextField{
    NSLog(@"Locate Empty Called");
    bool formComplete = NO;
    NSArray *textFieldArray = @[siteTextField, hiveIDTextField, queenTextField, boxTextField, boxIDTextfield];
    
    for(UITextField *field in textFieldArray){
        if (![field hasText] && field.enabled == YES) {
            [self missingBoxTypeAlert];
            formComplete = NO;
            [field becomeFirstResponder];
            return formComplete;
        } else {
            formComplete = YES;
        }
    }
    
    return formComplete;
}


#pragma mark --------------- Alerts ----------------
-(void)missingBoxTypeAlert{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"A Field Has Been Left Blank"
                                                             message:@"The Empty field has been selected."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        alertView.tag = kAlertViewCheckBoxPicker;
        [alertView show];
    
    
}
-(void) hiveNotSavedAlert{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Latest Hive not Saved"
                                                         message:@"Would you like to discard the Hive?"
                                                        delegate:self
                                               cancelButtonTitle:@"Discard"
                                               otherButtonTitles:@"Save Hive", nil];
    alertView.tag = kAlertViewSaveData;
    [alertView show];
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == kAlertViewSaveData) {
        if (buttonIndex == 0){
         //Discard Data, unwind to hive
           [self performSegueWithIdentifier:@"unwindToHome" sender:self];
            
        } else {
            [self locateEmptyTextField];

        }
    }
    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)unWindToAddHive:(UIStoryboardSegue *)segue{
    
}

#pragma mark ----------- Email Bug Report -----------
- (void)swipeToEmail:(UISwipeGestureRecognizer *)sender {
    NSString *viewString = [NSString stringWithFormat:@"Add Hive from: %@", sourceVC];
    
    // Email Subject
    NSString *emailTitle = @"Hive Maps Bug Report to Developer";
    // Email Content
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    NSString *deviceType = [UIDevice currentDevice].model;
    NSString *appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *versionBuildString = [NSString stringWithFormat:@"Version: %@ (%@)", appVersionString, appBuildString];
    
    NSString *messageBody = [NSString stringWithFormat:@"Describe the Bug:\n\nwhat were you doing:\n\nWhat happened?\n\nAny additional information\n\n\n\n---------system info------------\nApp %@\niOS: %@, Device: %@\nCurrent View: %@",versionBuildString, currSysVer, deviceType, viewString];
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
