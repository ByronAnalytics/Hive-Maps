//
//  SingleHivePlotViewController.m
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/8/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//
/* #################### TO DO ####################
 -Data Class is implimeneted, setup graphing
 
  - can toolbar hide?
 
*/

#import "SingleHivePlotViewController.h"
#import "ProcessDataForPlotting.h"
#import "DataLuggage.h"
#import "AppDelegate.h"
#import "HiveObservation.h"

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

@property (nonatomic, strong) ProcessDataForPlotting *plotData;

@property (nonatomic, strong) NSDictionary *plotElementsDictionary; //holds potential plot elements
@end

@implementation SingleHivePlotViewController
//Plot Setup
@synthesize plotElementsTableView;
@synthesize plotData;
@synthesize hive;

//Plot Window
@synthesize hostView;

//Toolbar Buttons
@synthesize toolbar;

//In Class Variables
@synthesize plotElementsGroup;

@synthesize plotElementsDictionary;
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

float maxYValue;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initPlot];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];

    self.hive = [[DataLuggage sharedObject] hive];
   
    plotData = [[ProcessDataForPlotting alloc] init];
    [plotData generateDataArrays:self.hive];
    
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
    
    //Setup Dictionary to communicate between selected Elements and Data
    NSArray *plotElementKeys = @[@"Brood Frames", @"Honey Frames", @"Worker Frames", @"Queen Performance", @"Temperature", @"Humidity", @"Pressure", @"Wind Speed"];
    NSArray *plotElementValues = @[plotData.broodDictionary, plotData.honeyDictionary, plotData.workerDictionary, plotData.queenPerformanceDictionary, plotData.temperatureDictionary, plotData.humidityDictionary, plotData.pressureDictionary, plotData.windSpeedDictionary];
    
    plotElementsDictionary = [NSDictionary dictionaryWithObjects:plotElementValues forKeys:plotElementKeys];

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

#pragma mark ------------ Chart behavior -----------
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)configureHost {
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    self.hostView.allowPinchScaling = YES;
    [self.view addSubview:self.hostView];
}

-(void)configureGraph {
    //Initiate and Set Theme ****Currently plain white - user setting later??
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.hostView.hostedGraph = graph;
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    graph.paddingBottom = 30.0f;
    graph.paddingLeft = 30.0f;
    graph.paddingTop = -1.0f;
    graph.paddingRight = -5.0;
    
    //Setup Title
    NSString *title = [NSString stringWithFormat:@" Hive Productivity Data for %@", hive.hiveID];
    graph.title = title;
    
    //Text Style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -16.0f);
    
    //Setup Plotting Space
    CGFloat xMin = 0.0f;
    CGFloat xMax = [[plotData.dateDictionary valueForKey:@"range"] floatValue]; // number of days of observations
    CGFloat yMin = 0.0f;
    CGFloat yMax = maxYValue;
    
    
    
    
}

-(void)configurePlots {
}

-(void)configureAxes {
}

#pragma mark ----------- CPTPlotDataSource methods -----------
-(void)updatePlotData{
    //Generate array of selected plot elements
    NSMutableSet *selectedPlotElementArrays = [[NSMutableSet alloc]init];
    
    for (id key in variablesSelectedArray) {
        [selectedPlotElementArrays addObject:[plotElementsDictionary objectForKey:key]];
    }
    
    for (id key in weatherSelectedArray) {
        [selectedPlotElementArrays addObject:[plotElementsDictionary objectForKey:key]];
    }
   
    //Set maxY value for establishing plot space
    float maxRange = 0;
    for (id element in selectedPlotElementArrays) {
        float range = [[element valueForKey:@"range"] floatValue];
        if(range > maxRange) maxRange = range;
    }
    maxYValue = maxRange;
    
}


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


//#####################################################################
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


















































