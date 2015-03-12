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
@property (nonatomic, strong) CPTGraph *graph;
@property (nonatomic, strong) NSMutableArray *plots;
@property (nonatomic, strong) NSDictionary *plotElementsDictionary; //holds potential plot elements
@property (nonatomic, strong) NSMutableDictionary *selectedElementsDictionary; //copy of plotElementsDictionary with selected elements.// should replace variables, weather, and events array

@end

@implementation SingleHivePlotViewController
//Plot Setup
@synthesize plotElementsTableView;
@synthesize plotData;
@synthesize hive;
@synthesize plots;

//Plot Window
@synthesize hostView;
@synthesize plotSpaceUIView;
@synthesize graph;

//Toolbar Buttons
@synthesize toolbar;

//In Class Variables
@synthesize plotElementsGroup;

@synthesize plotElementsDictionary;
@synthesize selectedElementsDictionary;

@synthesize tableArray;
@synthesize variablesArray;
@synthesize variablesSelectedCellsArray;
@synthesize weatherArray;
@synthesize weatherSelectedCellsArray;
@synthesize eventsArray;
@synthesize eventsSelectedArray;
@synthesize eventsSelectedCellsArray;

float maxYValue;

- (void)viewDidLoad{
    self.hive = [[DataLuggage sharedObject] hive];
   
    [super viewDidLoad];
    [self initPlot];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];

    
    plotData = [[ProcessDataForPlotting alloc] init];
    [plotData generateDataArrays:self.hive];
    
    //Set plotting Elements:
    variablesArray = @[@"Brood Frames", @"Honey Frames", @"Queen Performance", @"Worker Frames"];
    variablesSelectedCellsArray = [[NSMutableArray alloc] init];
    
    weatherArray = @[@"Temperature", @"Humidity", @"Pressure", @"Wind Speed"];
    weatherSelectedCellsArray  = [[NSMutableArray alloc] init];
    
    eventsArray = @[@"Re-queened", @"Illness", @"Drone Cells", @"Insurance Cups", @"Swarming"];
    eventsSelectedArray  = [[NSMutableArray alloc] init];
    eventsSelectedCellsArray  = [[NSMutableArray alloc] init];
    
    self.plotElementsDisplayed = NO;
    plotElementsTableView.hidden = YES;
    
    plots = [[NSMutableArray alloc] init];
    
    NSArray *plotElementKeys = @[@"Brood Frames", @"Honey Frames", @"Worker Frames", @"Queen Performance", @"Temperature", @"Humidity", @"Pressure", @"Wind Speed"];
    NSArray *plotElementValues = @[plotData.broodDictionary, plotData.honeyDictionary, plotData.workerDictionary, plotData.queenPerformanceDictionary, plotData.temperatureDictionary, plotData.humidityDictionary, plotData.pressureDictionary, plotData.windSpeedDictionary];
    
    
    plotElementsDictionary = [NSDictionary dictionaryWithObjects:plotElementValues forKeys:plotElementKeys];
    selectedElementsDictionary = [[NSMutableDictionary alloc] init];
    
    NSLog(@"View Setup Complete");
}


-(void)updatePlotElementsTableView{
    if (!self.isPlotElementsDisplayed) {  // plotElements Displayed == NO
        plotElementsTableView.hidden = YES;
            [self.view bringSubviewToFront:self.hostView];
        [self updatePlotData];
    } else {
        plotElementsTableView.hidden = NO;
        [self.view sendSubviewToBack:self.hostView]; // push plot to background
        
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
    // 1 - Set up view frame
    CGRect parentRect = self.view.bounds;
    CGSize toolbarSize = self.toolbar.bounds.size;
    parentRect = CGRectMake(parentRect.origin.x,
                            (parentRect.origin.y + toolbarSize.height),
                           parentRect.size.width,
                           (parentRect.size.height - 2 * toolbarSize.height));
    //2 - Create host view
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView.allowPinchScaling = YES;
    [self.view addSubview:self.hostView];

}

-(void)configureGraph {
    //Initiate and Set Theme ****Currently plain white - user setting later??
    graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.hostView.hostedGraph = graph;
    
    //Setup Title
    NSString *title = [NSString stringWithFormat:@" Hive Productivity Data for %@", hive.hiveID];
    NSLog(@"HIVE in Graph: %@", hive.hiveID);
    
    graph.title = title;
    
    //Text Style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -5.0f);
    
    //Manipulate padding for desired effect....
    graph.paddingBottom = 5.0f;
    graph.paddingLeft = 10.0f;
    graph.paddingTop = 5.0f;
    graph.paddingRight = 10.0;

    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
}

-(void)configurePlots {
    //Get Graph and PlotSpace
    graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    NSDictionary *tempDict = [[NSDictionary alloc] init];
    //Generate Plots
    for (id element in selectedElementsDictionary) {
        tempDict = [selectedElementsDictionary valueForKey:element];
        
        CPTScatterPlot *xyPlot = [[CPTScatterPlot alloc] init];
        xyPlot.dataSource = self;
        xyPlot.identifier = [tempDict valueForKey:@"identifier"];
        [graph addPlot:xyPlot toPlotSpace:plotSpace];
        
        CPTColor *xyColor = [tempDict valueForKey:@"color"];
        
        CPTMutableLineStyle *xyPlotLineStyle = [xyPlot.dataLineStyle mutableCopy];
        xyPlotLineStyle.lineWidth = 2.5;
        xyPlotLineStyle.lineColor = xyColor;
        xyPlot.dataLineStyle = xyPlotLineStyle;
        
        CPTMutableLineStyle *xyPlotSymbolLineStyle = [CPTMutableLineStyle lineStyle];
        xyPlotSymbolLineStyle.lineColor = xyColor;
        CPTPlotSymbol *xyPlotSymbol = [tempDict valueForKey:@"symbol"];
        xyPlotSymbol.fill = [CPTFill fillWithColor:xyColor];
        xyPlotSymbol.lineStyle = xyPlotSymbolLineStyle;
        xyPlotSymbol.size = CGSizeMake(6.0f, 6.0f);
        xyPlot.plotSymbol = xyPlotSymbol;
        
        [plots addObject:xyPlot];
    }
    
    // 3 - Set up plot space
    [plotSpace scaleToFitPlots:plots];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    plotSpace.yRange = yRange;
    
}

-(void)configureAxes {
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor whiteColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor whiteColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor whiteColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 1.0f;
    
    // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
   
    // 3 - Configure x-axis
    CPTAxis *x = axisSet.xAxis;
    x.title = @"Day of Month";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 15.0f;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 4.0f;
    x.tickDirection = CPTSignNegative;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];

    CGFloat dateCount = [plotData.dateArray count];
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
    NSInteger i = 0;
    for (NSDate *date in plotData.dateArray) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[dateFormat stringFromDate:date]  textStyle:x.labelTextStyle];
        CGFloat location = i++;
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = x.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    x.axisLabels = xLabels;
    x.majorTickLocations = xLocations;
    
    // 4 - Configure y-axis
    CPTAxis *y = axisSet.yAxis;
    y.title = @"# Frames";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -40.0f;
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 16.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    NSInteger majorIncrement = 100;
    NSInteger minorIncrement = 50;
    CGFloat yMax = 700.0f;  // should determine dynamically based on max price
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%li", (long)j] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = -y.majorTickLength - y.labelOffset;
            if (label) {
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    y.axisLabels = yLabels;    
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
}
-(void) configureLegend{
    
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    // 3 - Configure legend
    theLegend.numberOfColumns = 1;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    // 4 - Add legend to graph
    graph.legend = theLegend;
    graph.legendAnchor = CPTRectAnchorTopLeft;
    //CGFloat legendPadding = (self.view.bounds.size.width / 8);
    graph.legendDisplacement = CGPointMake(11, -30);

}



#pragma mark ----------- CPTPlotDataSource methods -----------
-(void)updatePlotData{
    
    self.graph = nil;
    
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
    [self configureLegend];
}


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return plotData.dateArray.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {

    NSInteger valueCount = plotData.dateArray.count;
    NSArray *data = [[plotElementsDictionary valueForKey:(NSString *)plot.identifier] valueForKey:@"data"];
    
    switch (fieldEnum) {
        case CPTScatterPlotFieldX: //X-position of data point
            if (index < valueCount) {
                return [NSNumber numberWithUnsignedInteger:index];
            }
            break;
            
        case CPTScatterPlotFieldY: //Y-position of data point at index i
            
            return data[index];
            break;
    }
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
            [selectedElementsDictionary removeObjectForKey:plotElement];
            //[variablesSelectedArray removeObject:plotElement];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            [variablesSelectedCellsArray addObject:indexPath];
            [selectedElementsDictionary setObject:[plotElementsDictionary valueForKey:plotElement] forKey:plotElement];
            //[variablesSelectedArray addObject:plotElement];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [plotElementsTableView reloadData];
        }

    } else if ([plotElementsGroup isEqualToString:@"Weather"]) {
        NSString *plotElement = [weatherArray objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if([self isRowSelectedOnTableView:tableView atIndexPath:indexPath]){
            [weatherSelectedCellsArray removeObject:indexPath];
            [selectedElementsDictionary removeObjectForKey:plotElement];
            //[weatherSelectedArray removeObject:plotElement];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            [weatherSelectedCellsArray addObject:indexPath];
            [selectedElementsDictionary setObject:[plotElementsDictionary valueForKey:plotElement] forKey:plotElement];
            //[weatherSelectedArray addObject:plotElement];
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


















































