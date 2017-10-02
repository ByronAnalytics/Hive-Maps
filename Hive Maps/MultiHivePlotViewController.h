//
//  MultiHivePlotViewController.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/8/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot/ios/CorePlot-CocoaTouch.h>

@interface MultiHivePlotViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CPTScatterPlotDataSource>


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// View Setup
@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (weak, nonatomic) IBOutlet UIView *plotSpaceUIView;
@property (weak, nonatomic) IBOutlet UITableView *plotElementsTableView;

// Toolbar Setup
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hivesButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *variablesButton;

//Actions
- (IBAction)hivesButton:(id)sender;
- (IBAction)variablesButton:(id)sender;


//############ Move to Private Variables ############
//Table View
@property (nonatomic, strong) NSArray *tableArray;
@property (strong, nonatomic) NSArray *variablesArray;  //This might need to be a local variable and selectedVariables the only global...
@property (strong, nonatomic) NSArray *hivesArray; //ditto

//Data
@property (strong, nonatomic) NSMutableDictionary *hiveData; //key: hiveID Value: ProcessDataObj

//User Controls
@property (nonatomic, assign, getter=isPlotElementsDisplayed) BOOL plotElementsDisplayed;
@property (nonatomic, strong) NSString *plotElementsGroup; //assigns which tableview was selected


@end
