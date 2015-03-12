//
//  MultiHivePlotViewController.m
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/8/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import "MultiHivePlotViewController.h"
#import "ProcessDataForPlotting.h"
#import "AppDelegate.h"
#import "HiveDetails.h"


@interface MultiHivePlotViewController ()



@end

@implementation MultiHivePlotViewController
//Variables for TableView
@synthesize variablesArray;
@synthesize hivesArray;
@synthesize hiveData;


- (void)viewDidLoad {
    [super viewDidLoad];

    [self aggregateData];
    [self initPlot];
    
    //Set plotting Elements:
    variablesArray = @[@"Brood Frames", @"Honey Frames", @"Queen Performance", @"Worker Frames"];
    hivesArray = [hiveData allKeys];
    
    self.plotElementsDisplayed = NO;
    self.plotElementsTableView.hidden = YES;
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

-(void) aggregateData{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    //Fetch Hives
   NSFetchRequest *fetchAllHives = [[NSFetchRequest alloc] initWithEntityName:@"HiveDetails"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"hiveID" ascending:YES];
    [fetchAllHives setSortDescriptors:@[sortDescriptor]];
    
    NSError *fetchError = nil;
    NSArray *allHives = [self.managedObjectContext executeFetchRequest:fetchAllHives error:&fetchError];
    
    NSMutableDictionary *hiveData = [[NSMutableDictionary alloc] init];
    
    for (HiveDetails *hive in allHives) {
        ProcessDataForPlotting *data = [[ProcessDataForPlotting alloc] init];
        [data generateDataArrays:hive];
        [hiveData setObject:data forKey:hive.hiveID];
    }
    // Each ProcessData Object has: *dateDictionary, *broodDictionary, *honeyDictionary, *workerDictionary, *queenPerformanceDictionary, *temperatureDictionary, *humidityDictionary, *pressureDictionary, *windSpeedDictionary
}

# pragma mark ------- Table View Controls --------
-(void)updatePlotElementsTableView{
    if (!self.isPlotElementsDisplayed) {  // plotElements Displayed == NO (values selected, TV dismissed intended, graph updated)
        self.plotElementsTableView.hidden = YES;        //hide TableView
        [self.view bringSubviewToFront:self.hostView];  // Make Graph front view
        [self updatePlotData];                          //update Graph
        
    } else {
        self.plotElementsTableView.hidden = NO;
        [self.view sendSubviewToBack:self.hostView]; // push plot to background
        
        if ([self.plotElementsGroup isEqualToString:@"Variables"]) {
            self.tableArray = variablesArray;
            NSLog(@"TableArray: %@", self.tableArray);
        } else if ([self.plotElementsGroup isEqualToString:@"Hives"]) {
            self.tableArray = hivesArray;
            NSLog(@"TableArray: %@", self.tableArray);
        }
        
        [self.plotElementsTableView reloadData];
    }
    
}

- (IBAction)variablesButton:(id)sender {
    if (self.isPlotElementsDisplayed) { //Table is already showing
        if([self.plotElementsGroup isEqualToString:@"Variables"]){ //Button click to de-select
            self.plotElementsDisplayed = !self.isPlotElementsDisplayed;
            [self updatePlotElementsTableView];
        } else { // Hives table is currently displayed, switch to Variables table
            self.plotElementsGroup = @"Variables";
            [self updatePlotElementsTableView];
        }
    } else { // Plot Elements TableView is hidden, show and set elemets
        self.plotElementsGroup = @"Variables";
        self.plotElementsDisplayed = !self.isPlotElementsDisplayed;
        [self updatePlotElementsTableView];
    }
    
}

- (IBAction)hivesButton:(id)sender {
    if (self.isPlotElementsDisplayed) { //Table is already showing
        if([self.plotElementsGroup isEqualToString:@"Hives"]){ //Button click to de-select
            self.plotElementsDisplayed = !self.isPlotElementsDisplayed;
            [self updatePlotElementsTableView];
        } else { // Variables table is currently displayed, switch to Hives Table
            self.plotElementsGroup = @"Hives";
            [self updatePlotElementsTableView];
        }
    } else { // Plot Elements TableView is hidden, show and set elemets
        self.plotElementsGroup =@"Hives";
        self.plotElementsDisplayed = !self.isPlotElementsDisplayed;
        [self updatePlotElementsTableView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------------ Chart behavior -----------
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)updatePlotData{
    
    //self.graph = nil;
    
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
    //[self configureLegend];
}

-(void)configureHost {

}

-(void)configureGraph {
    
}

-(void)configurePlots {

}

-(void)configureAxes {
    
}

//Code Should be boiler plate
/*-(void) configureLegend{
    
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
    
}*/

#pragma mark ----------- TABLE VIEW DATA SOURCE / DELEGATE -----------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count; //tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"plotElementCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //cell.textLabel.text = [self.tableArray objectAtIndex:indexPath.row];
    
    
    if ([self.plotElementsGroup isEqualToString:@"Hives"]) {
        cell.textLabel.text = @"a"; //[variablesArray objectAtIndex:indexPath.row];
        
        //if the indexPath was found among the selected ones, set the checkmark on the cell
        //cell.accessoryType = ([self isRowSelectedOnTableView:tableView atIndexPath:indexPath]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        return cell;
        
    } else {
        cell.textLabel.text = [hivesArray objectAtIndex:indexPath.row];
        
        //if the indexPath was found among the selected ones, set the checkmark on the cell
        //cell.accessoryType = ([self isRowSelectedOnTableView:tableView atIndexPath:indexPath]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        return cell;
        
        //
    }
    
    //return cell;
}

@end
