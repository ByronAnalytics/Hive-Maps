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


@end
