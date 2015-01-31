//
//  SingleHivePlotViewController.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/8/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface SingleHivePlotViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CPTScatterPlotDataSource>

// Plot Setup
@property (nonatomic, strong) CPTGraphHostingView *hostView;

// Toolbar Setup
@property (weak, nonatomic) IBOutlet UITableView *plotElementsTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

//Actions
- (IBAction)variablesButton:(id)sender;
- (IBAction)weatherButton:(id)sender;
- (IBAction)eventsButton:(id)sender;
- (IBAction)plotWindowTaped:(id)sender;

@end
