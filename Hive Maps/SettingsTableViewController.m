//
//  SettingsTableViewController.m
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/4/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//


#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize locationAccuracySegmentControl;

@synthesize userLocationAccuracy;

- (void)viewDidLoad {
    [super viewDidLoad];
    
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (IBAction)locationAccuracyChanged:(id)sender {
    switch (self.locationAccuracySegmentControl.selectedSegmentIndex) {
        case 0:
            userLocationAccuracy = @"County";
            break;
        case 1:
            userLocationAccuracy = @"ZipCode";
            break;
        case 2:
            userLocationAccuracy = @"Best";
            break;
        default:
            break;
    }
}

- (IBAction)locationInfoButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"About Location Data"
                                                    message:@"Location data is used to locate the nearest weather station as well as provide important data to the bee keeping community. Please select the most accurate setting you're comfortable sharing with other beekeepers and bee researchers. For more information, see:\n hivemaps.com"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)doneButton:(id)sender {

    NSString *username = usernameTextField.text;
    NSString *password = passwordTextField.text;
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults setObject:username forKey:@"username"];
    //[defaults setObject:userLocationAccuracy forKey:@"userLocationAccuracy"];
   // [defaults synchronize];
//password to be saved in keychain


}
*/
@end
