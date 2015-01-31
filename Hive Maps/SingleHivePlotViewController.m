//
//  SingleHivePlotViewController.m
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/8/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//
/* #################### TO DO ####################
  - dictionaries are unordered... maybe paired arrays? variablesArray & variableSelectedArray
  - didSelectRow to toggle dictionary value YES/NO
  - Graphing window
  - can toolbar hide?
 
*/

#import "SingleHivePlotViewController.h"

@interface SingleHivePlotViewController ()

//Inclas Variables
@property (nonatomic, assign, getter=isPlotElementsHidden) BOOL plotElementsHidden;
@property (nonatomic, strong) NSString *plotElementsGroup;

@property (nonatomic, strong) NSArray *tableArray;
@property (nonatomic, strong) NSMutableDictionary *variablesArray;
@property (nonatomic, strong) NSMutableDictionary *weatherArray;
@property (nonatomic, strong) NSMutableDictionary *eventsArray;

@end

@implementation SingleHivePlotViewController
//Plot Setup
@synthesize plotElementsTableView;


//Plot Window
@synthesize hostView;

//Toolbar Buttons
@synthesize toolbar;

//In Class Variables
@synthesize plotElementsGroup;

@synthesize tableArray;
@synthesize variablesArray;
@synthesize weatherArray;
@synthesize eventsArray;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    [self initPlot];
    
    //Set plotting Elements:
    variablesArray = [NSMutableDictionary dictionaryWithObjects:@[@"NO",@"NO",@"NO",@"NO"]
                                                        forKeys: @[@"Brood Frames", @"Honey Frames", @"Queen Performance", @"Worker Frames"]];
    weatherArray = [NSMutableDictionary dictionaryWithObjects:@[@"NO",@"NO",@"NO",@"NO"]
                                                      forKeys:@[@"Temperature", @"Humidity", @"Pressure", @"Wind Speed"]];
    eventsArray = [NSMutableDictionary dictionaryWithObjects:@[@"NO",@"NO",@"NO",@"NO",@"NO"]
                                                     forKeys:@[@"Re-queened", @"Illness", @"Drone Cells", @"Insurance Cups", @"Swarming"]];
}

-(void)updatePlotElementsTableView{
    if (self.isPlotElementsHidden) {
        plotElementsTableView.hidden = YES;
    
    } else {
        plotElementsTableView.hidden = NO;
        
        if ([plotElementsGroup isEqualToString:@"Variables"]) {
            tableArray = variablesArray;
        } else if ([plotElementsGroup isEqualToString:@"Weather"]) {
            tableArray = weatherArray;
        } else if ([plotElementsGroup isEqualToString:@"Events"]) {
            tableArray = eventsArray;
        }
        [self.plotElementsTableView reloadData];
    }
    
}

#pragma mark - Toolbar Actions
- (IBAction)variablesButton:(id)sender {
    if (self.isPlotElementsHidden) {
        self.plotElementsHidden = !self.isPlotElementsHidden;
    }
    plotElementsGroup = @"Variables";
    
    [self updatePlotElementsTableView];
}

- (IBAction)weatherButton:(id)sender {
    if (self.isPlotElementsHidden) {
        self.plotElementsHidden = !self.isPlotElementsHidden;
    }
    plotElementsGroup = @"Weather";
    
    [self updatePlotElementsTableView];
}

- (IBAction)eventsButton:(id)sender {
    if (self.isPlotElementsHidden) {
        self.plotElementsHidden = !self.isPlotElementsHidden;
    }
    plotElementsGroup = @"Events";
    
    [self updatePlotElementsTableView];
}

- (IBAction)plotWindowTaped:(id)sender {
    self.plotElementsHidden = !self.isPlotElementsHidden;
    [self updatePlotElementsTableView];
}


#pragma mark - Chart behavior
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)configureHost {
}

-(void)configureGraph {
}

-(void)configurePlots {
}

-(void)configureAxes {
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    return [NSDecimalNumber zero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TABLE VIEW DATA SOURCE / DELEGATE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableArray.count;
}

//Customize cell
-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.textLabel.text = [tableArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"hiveCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //configure cell
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}



@end


















































