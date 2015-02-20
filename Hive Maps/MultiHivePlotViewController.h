//
//  MultiHivePlotViewController.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/8/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface MultiHivePlotViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CPTScatterPlotDataSource>


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// View Setup
@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (weak, nonatomic) IBOutlet UIView *plotSpaceUIView;
@property (weak, nonatomic) IBOutlet UITableView *plotElementsTV;

// Toolbar Setup
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hivesButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *variablesButton;

//Actions
- (IBAction)hivesButton:(id)sender;
- (IBAction)variablesButton:(id)sender;


//############ Move to Private Variables

@property (strong, nonatomic) NSArray *allHives;


@end
