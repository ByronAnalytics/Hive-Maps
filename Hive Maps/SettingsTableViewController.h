//
//  SettingsTableViewController.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/4/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *locationAccuracySegmentControl;
@property (weak, nonatomic) NSString *userLocationAccuracy;
/*
- (IBAction)locationAccuracyChanged:(id)sender;
- (IBAction)locationInfoButton:(id)sender;
*/
@end
