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
@synthesize allHives;



- (void)viewDidLoad {
    [super viewDidLoad];

    [self aggregateData];
    [self initPlot];
    
    
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
    allHives = [self.managedObjectContext executeFetchRequest:fetchAllHives error:&fetchError];
    
    NSLog(@"Fetch Results: \n%@", allHives);
    
    NSMutableDictionary *hiveData = [[NSMutableDictionary alloc] init];
    
    for (HiveDetails *hive in allHives) {
        ProcessDataForPlotting *data = [[ProcessDataForPlotting alloc] init];
        [data generateDataArrays:hive];
        [hiveData setObject:data forKey:hive.hiveID];
        NSLog(@"Data for %@: %@", hive.hiveID, data);
        
    }
    //test to see if data is aggregating properly
    
    
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
    return 0; //tableArray.count;
}



@end
