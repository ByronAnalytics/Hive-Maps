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
@property (nonatomic, assign, getter=isPlotElementsDisplayed) BOOL plotElementsDisplayed;
@property (nonatomic, strong) NSString *plotElementsGroup;

@property (nonatomic, strong) NSArray *tableArray;
@property (nonatomic, strong) NSArray *variablesArray;
@property (nonatomic, strong) NSMutableArray *variablesSelectedArray;
@property (nonatomic, strong) NSMutableArray *variablesSelectedCellsArray;
@property (nonatomic, strong) NSArray *weatherArray;
@property (nonatomic, strong) NSMutableArray *weatherSelectedArray;
@property (nonatomic, strong) NSMutableArray *weatherSelectedCellsArray;
@property (nonatomic, strong) NSArray *eventsArray;
@property (nonatomic, strong) NSMutableArray *eventsSelectedArray;
@property (nonatomic, strong) NSMutableArray *eventsSelectedCellsArray;

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
@synthesize variablesSelectedArray;
@synthesize variablesSelectedCellsArray;
@synthesize weatherArray;
@synthesize weatherSelectedArray;
@synthesize weatherSelectedCellsArray;
@synthesize eventsArray;
@synthesize eventsSelectedArray;
@synthesize eventsSelectedCellsArray;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initPlot];
    
    //Set plotting Elements:
    variablesArray = @[@"Brood Frames", @"Honey Frames", @"Queen Performance", @"Worker Frames"];
    variablesSelectedArray = [[NSMutableArray alloc] init];
    variablesSelectedCellsArray = [[NSMutableArray alloc] init];
    
    weatherArray = @[@"Temperature", @"Humidity", @"Pressure", @"Wind Speed"];
    weatherSelectedArray  = [[NSMutableArray alloc] init];
    weatherSelectedCellsArray  = [[NSMutableArray alloc] init];
    
    eventsArray = @[@"Re-queened", @"Illness", @"Drone Cells", @"Insurance Cups", @"Swarming"];
    eventsSelectedArray  = [[NSMutableArray alloc] init];
    eventsSelectedCellsArray  = [[NSMutableArray alloc] init];
    
    self.plotElementsDisplayed = NO;
    plotElementsTableView.hidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
 
}


-(void)updatePlotElementsTableView{
    if (!self.isPlotElementsDisplayed) {  // plotElements Displayed == NO
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
    if (self.isPlotElementsDisplayed) { //Table is already showing
        if([plotElementsGroup isEqualToString:@"Variables"]){ //Button click to de-select
            self.plotElementsDisplayed = !self.isPlotElementsDisplayed;
            [self updatePlotElementsTableView];
        } else { // either Weather or Events is currently displayed, switch to Variables
           plotElementsGroup = @"Variables";
           [self updatePlotElementsTableView];
        }
    } else { // Plot Elements TableView is hidden, show and set elemets
        plotElementsGroup = @"Variables";
        self.plotElementsDisplayed = !self.isPlotElementsDisplayed;
        [self updatePlotElementsTableView];
    }
    
 }

- (IBAction)weatherButton:(id)sender {
    if (self.isPlotElementsDisplayed) { //Table is already showing
        if([plotElementsGroup isEqualToString:@"Weather"]){ //Button click to de-select
            self.plotElementsDisplayed = !self.isPlotElementsDisplayed;
            [self updatePlotElementsTableView];
        } else { // either Weather or Events is currently displayed, switch to Variables
            plotElementsGroup = @"Weather";
            [self updatePlotElementsTableView];
        }
    } else { // Plot Elements TableView is hidden, show and set elemets
        plotElementsGroup =@"Weather";
        self.plotElementsDisplayed = !self.isPlotElementsDisplayed;
        [self updatePlotElementsTableView];
    }
}

- (IBAction)eventsButton:(id)sender {
    if (self.isPlotElementsDisplayed) { //Table is already showing
        if([plotElementsGroup isEqualToString:@"Events"]){ //Button click to de-select
            self.plotElementsDisplayed = !self.isPlotElementsDisplayed;
            [self updatePlotElementsTableView];
        } else { // either Weather or Events is currently displayed, switch to Variables
            plotElementsGroup = @"Events";
            [self updatePlotElementsTableView];
        }
    } else { // Plot Elements TableView is hidden, show and set elemets
        plotElementsGroup = @"Events";
        self.plotElementsDisplayed = !self.isPlotElementsDisplayed;
        [self updatePlotElementsTableView];
    }
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

#pragma mark ----------- TABLE VIEW DATA SOURCE / DELEGATE -----------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"plotElementCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if ([plotElementsGroup isEqualToString:@"Variables"]) {
        cell.textLabel.text = [variablesArray objectAtIndex:indexPath.row];
        
        //if the indexPath was found among the selected ones, set the checkmark on the cell
        cell.accessoryType = ([self isRowSelectedOnTableView:tableView atIndexPath:indexPath]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        return cell;
        
    } else if ([plotElementsGroup isEqualToString:@"Weather"]) {
        cell.textLabel.text = [weatherArray objectAtIndex:indexPath.row];
        
        //if the indexPath was found among the selected ones, set the checkmark on the cell
        cell.accessoryType = ([self isRowSelectedOnTableView:tableView atIndexPath:indexPath]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        return cell;
       
        //
    } else  {
        cell.textLabel.text = [eventsArray objectAtIndex:indexPath.row];
        
        //if the indexPath was found among the selected ones, set the checkmark on the cell
        cell.accessoryType = ([self isRowSelectedOnTableView:tableView atIndexPath:indexPath]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        return cell;
       
        //
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([plotElementsGroup isEqualToString:@"Variables"]) {
        NSString *plotElement = [variablesArray objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if([self isRowSelectedOnTableView:tableView atIndexPath:indexPath]){
            [variablesSelectedCellsArray removeObject:indexPath];
            [variablesSelectedArray removeObject:plotElement];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            [variablesSelectedCellsArray addObject:indexPath];
            [variablesSelectedArray addObject:plotElement];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [plotElementsTableView reloadData];
        }

    } else if ([plotElementsGroup isEqualToString:@"Weather"]) {
        NSString *plotElement = [weatherArray objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if([self isRowSelectedOnTableView:tableView atIndexPath:indexPath]){
            [weatherSelectedCellsArray removeObject:indexPath];
            [weatherSelectedArray removeObject:plotElement];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            [weatherSelectedCellsArray addObject:indexPath];
            [weatherSelectedArray addObject:plotElement];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    } else if ([plotElementsGroup isEqualToString:@"Events"]) {
        NSString *plotElement = [eventsArray objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if([self isRowSelectedOnTableView:tableView atIndexPath:indexPath]){
            [eventsSelectedCellsArray removeObject:indexPath];
            [eventsSelectedArray removeObject:plotElement];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            [eventsSelectedCellsArray addObject:indexPath];
            [eventsSelectedArray addObject:plotElement];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}

-(BOOL)isRowSelectedOnTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    if ([plotElementsGroup isEqualToString:@"Variables"]) {
        
        return ([variablesSelectedCellsArray containsObject:indexPath]) ? YES : NO;
        
    } else if ([plotElementsGroup isEqualToString:@"Weather"]) {
        
        return ([weatherSelectedCellsArray containsObject:indexPath]) ? YES : NO;
        
    } else { //return values for events elements
        
        return ([eventsSelectedCellsArray containsObject:indexPath]) ? YES : NO;
        
    }

}

@end


















































