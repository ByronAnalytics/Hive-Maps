//
//  GetWeatherTableViewController.m
//  Hive Saver
//
//  Created by Byron Analytics LLC on 1/4/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import "GetWeatherTableViewController.h"
#import "MakeHiveObsTableViewController.h"
#import "AppDelegate.h"

#import "WeatherObservation.h"
#import <CoreLocation/CoreLocation.h>

@interface GetWeatherTableViewController () <CLLocationManagerDelegate>
@end

@implementation GetWeatherTableViewController

//Variables for use
@synthesize currentCond;
@synthesize location;
@synthesize weatherValues;
@synthesize hiveObs;

//Table view Text Fields
@synthesize getWeather;

@synthesize stationTextField;
@synthesize stationCodeTextField;
@synthesize distanceTextField;
@synthesize tempTextField;
@synthesize humidityTextField;
@synthesize windSpeedTextField;
@synthesize windDirectionTextField;
@synthesize precip1HrTextField;
@synthesize precip24HrTextField;
@synthesize pressureTextField;

// Weather Data Source
NSString *weatherAPI = @"api.openweathermap.org";

// OpenWeatherMap API Key
NSString *APPID = @"aced8d32f3a99cbe735019eb4f8e5bf0";
//from openweathermap.org/my key for HiveSavers, kwbyron@byronanalytics.com
//service is free upto 3000 calls/min 4 mil/day

#pragma mark ------------- View Setup --------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    //Text fields updated in setTextField
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void) hideKeyboard {
    [stationTextField resignFirstResponder];
    [stationCodeTextField resignFirstResponder];
    [distanceTextField resignFirstResponder];
    [tempTextField resignFirstResponder];
    [humidityTextField resignFirstResponder];
    [windSpeedTextField resignFirstResponder];
    [windDirectionTextField resignFirstResponder];
    [precip1HrTextField  resignFirstResponder];
    [precip24HrTextField resignFirstResponder];
    [pressureTextField resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ------- Download Weather Data from openweather.org -------
- (IBAction)getWeather:(id)sender {
    [getWeather setTitle:@"Loading..." forState:UIControlStateNormal];
    [getWeather setEnabled:NO];
    
        //Create URL; requires location
        NSString *baseURL = @"http://api.openweathermap.org/data/2.5/station/find?lat=";
        NSString *countString = @"cnt=1";
    NSString *apiString = [NSString stringWithFormat:@"APPID=%@", APPID];
        NSString *urlString = [NSString stringWithFormat:@"%@%f&lon=%f&%@&%@", baseURL, location.coordinate.latitude, location.coordinate.longitude, countString, apiString];
        NSURL *url = [NSURL URLWithString:urlString];
        NSLog(@"URL: %@", url);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        //------------- Make JSON Request -------------
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        // Success - Failure Blocks
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
            self.currentCond = (NSDictionary *)responseObject;
            [self setTextField];
            
            NSLog(@"JSON Fetch Successfull");
           
            ;
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }];
        
        [operation start];
        
}
- (void)setTextField{
    
    //Get Dictionary Values
    NSString *stationRaw = [NSString stringWithFormat:@"%@", [currentCond valueForKeyPath:@"station.name"]];
    NSString *stationCodeRaw = [NSString stringWithFormat:@"%@", [currentCond valueForKeyPath:@"station.type"]];
    NSString *stationLatRaw = [NSString stringWithFormat:@"%@", [currentCond valueForKeyPath:@"station.coord.lat"]];
    NSString *stationLonRaw = [NSString stringWithFormat:@"%@", [currentCond valueForKeyPath:@"station.coord.lon"]];
    NSString *distanceLong = [NSString stringWithFormat:@"%@", [currentCond valueForKeyPath:@"distance"]];
    NSString *tempLong = [NSString stringWithFormat:@"%@", [currentCond valueForKeyPath:@"last.main.temp"]];
    NSString *humidLong = [NSString stringWithFormat:@"%@",[currentCond valueForKeyPath:@"last.main.humidity"]];
    NSString *rain1hrLong = [NSString stringWithFormat:@"%@", [currentCond valueForKeyPath:@"last.rain.1h"]];
    NSString *rain24hrLong = [NSString stringWithFormat:@"%@", [currentCond valueForKeyPath:@"last.rain.24h"]];
    NSString *pressureLong = [NSString stringWithFormat:@"%@", [currentCond valueForKeyPath:@"last.main.pressure"]];
    NSString *windSpeedLong = [NSString stringWithFormat:@"%@", [currentCond valueForKeyPath:@"last.wind.speed"]];
    NSString *windDirLong = [NSString stringWithFormat:@"%@", [currentCond valueForKeyPath:@"last.wind.deg"]];
    
    //Reformat numeric values for display
    NSString *station = [stationRaw stringByReplacingOccurrencesOfString:@"[() ]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [stationRaw length])];
    NSString *stationCode = [stationCodeRaw stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [stationCodeRaw length])];
    NSString *stationLat = [stationLatRaw stringByReplacingOccurrencesOfString:@"[^0-9.-]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [stationLatRaw length])];
    NSString *stationLon = [stationLonRaw stringByReplacingOccurrencesOfString:@"[^0-9.-]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [stationLonRaw length])];
    NSString *distance = [distanceLong stringByReplacingOccurrencesOfString:@"[^0-9.]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [distanceLong length])];
    NSString *temp = [tempLong stringByReplacingOccurrencesOfString:@"[^0-9.]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [tempLong length])];
    NSString *humid = [humidLong stringByReplacingOccurrencesOfString:@"[^0-9.]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [humidLong length])];
    NSString *rain1hr = [rain1hrLong stringByReplacingOccurrencesOfString:@"[^0-9.]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [rain1hrLong length])];
    NSString *rain24hr = [rain24hrLong stringByReplacingOccurrencesOfString:@"[^0-9.]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [rain24hrLong length])];
    NSString *pressure = [pressureLong stringByReplacingOccurrencesOfString:@"[^0-9.]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [pressureLong length])];
    NSString *windSpeed = [windSpeedLong stringByReplacingOccurrencesOfString:@"[^0-9.]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [windSpeedLong length])];
    NSString *windDir = [windDirLong stringByReplacingOccurrencesOfString:@"[^0-9.]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [windDirLong length])];
    
    //Special Formats
    NSDictionary *stationType = [[NSDictionary alloc] initWithObjectsAndKeys:@"Airport", @"1", @"SWOP", @"2", @"SYNOP", @"3", @"DIY", @"5", @"", @"", nil];
    NSString *stationTypeString = [stationType valueForKeyPath:stationCode];
    
    float tempF = [temp floatValue];
    tempF = ((tempF - 273.15) * 1.8) + 32;
    
    //sets dir to nil if speed is not provided and gusts are
    if ([windSpeed  isEqual: @""]) {
        windDir = @"";
    }
    stationTextField.text = station;
    
    //Set Text Field Values
    distanceTextField.text = [NSString stringWithFormat:@"%.1f", [distance floatValue]];
    stationCodeTextField.text = [stationType valueForKeyPath:stationCode];
    tempTextField.text = [NSString stringWithFormat:@"%.1f", tempF];
    humidityTextField.text = humid;
    precip1HrTextField.text = rain1hr;
    precip24HrTextField.text = rain24hr;
    pressureTextField.text = pressure;
    windSpeedTextField.text = windSpeed;
    windDirectionTextField.text = windDir;
        
    [getWeather setTitle:@"Weather Current" forState:UIControlStateNormal];

    //dictionary to pass data to save opporation
    weatherValues = [[NSDictionary alloc] initWithObjectsAndKeys: stationTextField.text, @"stationID", stationTypeString, @"stationType", stationLat, @"stationLat", stationLon, @"stationLon", distance, @"stationDistanceKm", temp, @"temperatureK", humid, @"humidityRH", pressure, @"pressureMilibars", rain1hr, @"rain1hrMM", rain24hr, @"rain24hrMM", windSpeed, @"windSpeedMetersPSecond", windDir, @"windDirDeg", nil];
}

- (IBAction)weatherInfo:(id)sender {
// Pop up message about weather fetching
    [self setTextField];
    NSLog(@"Updated");
    NSLog(@"TEMP: %@", [currentCond valueForKeyPath:@"last.main.humidity"]);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 10;
}

#pragma mark - Navigation

- (IBAction)saveWeatherData:(id)sender {
    NSNumberFormatter *floatFormat = [[NSNumberFormatter alloc] init];
    [floatFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
 
    WeatherObservation *weather = (WeatherObservation *) [NSEntityDescription insertNewObjectForEntityForName:@"WeatherObservation" inManagedObjectContext:_managedObjectContext];

    weather.dateWeatherObs = [NSDate date];
//Station Details
    weather.stationID = stationTextField.text;
    weather.stationType = stationCodeTextField.text;
    weather.stationLat = [floatFormat numberFromString:[weatherValues valueForKey:@"stationLat"]];
    weather.stationLong = [floatFormat numberFromString:[weatherValues valueForKey:@"stationLon"]];
    weather.stationDistance = [NSNumber numberWithFloat:[distanceTextField.text floatValue]];
//Weather Values
    weather.temperature = [NSNumber numberWithFloat:[tempTextField.text floatValue]];
    weather.humidity = [NSNumber numberWithFloat:[humidityTextField.text floatValue]];
    weather.pressure = [NSNumber numberWithFloat:[pressureTextField.text floatValue]];
    weather.precip1hr = [NSNumber numberWithFloat:[precip1HrTextField.text floatValue]];
    weather.precip24hr = [NSNumber numberWithFloat:[precip24HrTextField.text floatValue]];
    weather.windSpeed = [NSNumber numberWithFloat:[windSpeedTextField.text floatValue]];
    weather.windDir = [NSNumber numberWithFloat:[windDirectionTextField.text floatValue]];
    
//Relationship
    
    NSLog(@"Weather: %@", weather);
    NSLog(@"Hive: %@", hiveObs);

    weather.hiveObservation = hiveObs;
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        //Handle the error.
        NSLog(@"SAVE ERROR: %@",error);
    }
        NSLog(@"Check 4");
    
    
    [self performSegueWithIdentifier:@"saveUnwindToObsHive" sender:self];
        NSLog(@"Check 5");
}


    
@end
