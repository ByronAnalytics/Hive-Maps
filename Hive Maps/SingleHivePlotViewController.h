//
//  SingleHivePlotViewController.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/8/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "HiveDetails.h"

@interface SingleHivePlotViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CPTScatterPlotDataSource>

@property (strong, nonatomic) HiveDetails *hive;

// Plot Setup
@property (nonatomic, strong) CPTGraphHostingView *hostView;

// Toolbar Setup
@property (weak, nonatomic) IBOutlet UITableView *plotElementsTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *variablesButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *weatherButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *eventsButton;

//Actions
- (IBAction)variablesButton:(id)sender;
- (IBAction)weatherButton:(id)sender;
- (IBAction)eventsButton:(id)sender;

@end
