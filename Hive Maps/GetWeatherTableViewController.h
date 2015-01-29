//
//  GetWeatherTableViewController.h
//  Hive Saver
//
//  Created by Byron Analytics LLC on 1/4/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking/AFNetworking.h>
#import <MessageUI/MessageUI.h>

@class HiveObservation;

@interface GetWeatherTableViewController : UITableViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate>

//Core Data Elements
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//Variables
@property (strong, nonatomic) NSDictionary *currentCond;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSDictionary *weatherValues;
@property (strong, nonatomic) HiveObservation *hiveObs;

// Text labels
@property (weak, nonatomic) IBOutlet UIButton *getWeather;

@property (weak, nonatomic) IBOutlet UITextField *stationTextField;
@property (weak, nonatomic) IBOutlet UITextField *stationCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *distanceTextField;
@property (weak, nonatomic) IBOutlet UITextField *tempTextField;
@property (weak, nonatomic) IBOutlet UITextField *humidityTextField;
@property (weak, nonatomic) IBOutlet UITextField *precip1HrTextField;
@property (weak, nonatomic) IBOutlet UITextField *precip24HrTextField;
@property (weak, nonatomic) IBOutlet UITextField *pressureTextField;
@property (weak, nonatomic) IBOutlet UITextField *windSpeedTextField;
@property (weak, nonatomic) IBOutlet UITextField *windDirectionTextField;

// Actions
- (IBAction)getWeather:(id)sender;
- (IBAction)weatherInfo:(id)sender;


@end
