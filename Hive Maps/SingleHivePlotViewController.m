//
//  SingleHivePlotViewController.m
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/8/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import "SingleHivePlotViewController.h"

@interface SingleHivePlotViewController ()

@property (nonatomic, strong) CPTGraphHostingView *hostView;

@end

@implementation SingleHivePlotViewController

@synthesize hostView;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    [self initPlot];
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


@end
