//
//  ProcessDataForPlotting.m
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/28/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
/*/
Data arrays for each variable are created and stored in instance for this class called with data = generateDataForPlotting:hive
 
 
 */
#import <CorePlot/iOS/CorePlot-CocoaTouch.h>

#import "ProcessDataForPlotting.h"
#import "HiveObservation.h"
#import "BoxObservation.h"
#import "HiveBox.h"
#import "WeatherObservation.h"

//Private Variables
@interface ProcessDataForPlotting ()

@property (nonatomic, strong, readonly) NSMutableArray *broodTotals, *honeyTotals, *workerTotals, *queenPerformance, *temperature, *humidity, *pressure, *windSpeed; //hive parameters and covariates

@property (nonatomic, strong, readonly) NSMutableArray  *didRequeen, *wasSick, *obsQueen, *obsInsuranceCups, *obsDrones, *obsSwarming; //boolean values
@property (nonatomic, strong, readonly) NSMutableArray *siteHive, *queenSource, *diseaseTreatment; //descriptors for 'hover over' displays
@property (nonatomic, strong) NSArray *plotSymbolArray, *colorArray;

@end
//******************************************************************

@implementation ProcessDataForPlotting

@synthesize dateArray;
@synthesize honeyTotals, broodTotals, workerTotals, queenPerformance, temperature, humidity, pressure, windSpeed;
@synthesize didRequeen, wasSick, obsQueen, obsInsuranceCups, obsDrones, obsSwarming;
@synthesize siteHive, queenSource, diseaseTreatment;

@synthesize dateDictionary, broodDictionary, honeyDictionary, workerDictionary, queenPerformanceDictionary, temperatureDictionary, humidityDictionary, pressureDictionary, windSpeedDictionary;

- (void)generateDataArrays:(HiveDetails *)hive{
  //initialize arrays
    dateArray = [[NSMutableArray alloc] init];
    honeyTotals = [[NSMutableArray alloc] init];
    broodTotals = [[NSMutableArray alloc] init];
    workerTotals = [[NSMutableArray alloc] init];
    queenPerformance = [[NSMutableArray alloc]init];
    temperature = [[NSMutableArray alloc] init];
    humidity = [[NSMutableArray alloc] init];
    pressure = [[NSMutableArray alloc] init];
    windSpeed = [[NSMutableArray alloc] init];
    didRequeen = [[NSMutableArray alloc] init];
    wasSick = [[NSMutableArray alloc] init];
    obsQueen = [[NSMutableArray alloc] init];
    obsInsuranceCups = [[NSMutableArray alloc] init];
    obsDrones = [[NSMutableArray alloc] init];
    obsSwarming = [[NSMutableArray alloc] init];
    siteHive = [[NSMutableArray alloc] init];
    queenSource = [[NSMutableArray alloc] init];
    diseaseTreatment = [[NSMutableArray alloc] init];

    // get observations connected to hive
    NSSet *hiveObservations = hive.hiveObservations;
    
    //sort set by date
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"observationDate" ascending:YES]];
    NSArray *sortedObservations = [[hiveObservations allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    
    //Iterate through sorted observations, generate paired arrays of data
    for (id obs in sortedObservations) {
        
        //Dependent Variable (Time)
        [dateArray addObject:[obs valueForKey:@"observationDate"]];
        
        //Independent Variables
        
        //verify existing box-level observations
        if([obs valueForKey:@"boxObservations"]){
            NSSet *boxes = [obs valueForKey:@"boxObservations"];
            float framesBrood = 0;
            float framesWorkers = 0;
            float framesHoney = 0;
        
            for (id box in boxes) { //consolidate box observations
                framesBrood = framesBrood + [[box valueForKey:@"framesBrood"] floatValue];
                framesWorkers = framesWorkers + [[box valueForKey:@"framesWorkers"] floatValue];
                framesHoney = framesHoney + [[box valueForKey:@"framesHoney"] floatValue];
            }
        
            [broodTotals addObject:[NSNumber numberWithFloat:framesBrood]];
            [honeyTotals addObject:[NSString stringWithFormat:@"%f", framesHoney]];
            [workerTotals addObject:[NSNumber numberWithFloat:framesWorkers]];
            
        } else {
            //If observations weren't made, pass null for plotting
            [broodTotals addObject:[NSNull null]];
            [honeyTotals addObject:[NSNull null]];
            [workerTotals addObject:[NSNull null]];
        }
        
        //verify Queen Performance Recorded
        if([obs valueForKey:@"queenPerformance"]){
            [queenPerformance addObject:[obs valueForKey:@"queenPerformance"]];
        } else {
            [queenPerformance addObject:[NSNull null]];
        }
        
        //verify weather data collected
        if ([obs valueForKey:@"weatherObservation"]) {
            [temperature addObject:[obs valueForKeyPath:@"weatherObservation.temperature"]];
            [humidity addObject:[obs valueForKeyPath:@"weatherObservation.humidity"]];
            [pressure addObject:[obs valueForKeyPath:@"weatherObservation.pressure"]];
            [windSpeed addObject:[obs valueForKeyPath:@"weatherObservation.windSpeed"]];
        } else {
            [temperature addObject:[NSNull null]];
            [humidity addObject:[NSNull null]];
            [pressure addObject:[NSNull null]];
            [windSpeed addObject:[NSNull null]];
        }
        
        //Discrete Events
        [didRequeen addObject:[obs valueForKey:@"requeened"]];
        [wasSick addObject:[obs valueForKey:@"healthStatus"]];
        [obsQueen addObject:[obs valueForKey:@"observedQueen"]];
        [obsInsuranceCups addObject:[obs valueForKey:@"cupsInsur"]];
        [obsDrones addObject:[obs valueForKey:@"drone"]];
        [obsSwarming addObject:[obs valueForKey:@"swarm"]];
        //Hover Descriptors
        [queenSource addObject:[obs valueForKey:@"queenSource"]];
        [diseaseTreatment addObject:[obs valueForKey:@"treatment"]];
     
    }
    
    [self defineDictionaries:hive];
    [self definePlotSymbolArray];
    [self defineColorArray];    
}

-(void)definePlotSymbolArray{
    self.plotSymbolArray = [NSArray arrayWithObjects: [CPTPlotSymbol rectanglePlotSymbol],  [CPTPlotSymbol pentagonPlotSymbol], [CPTPlotSymbol dashPlotSymbol], nil];
}

-(void)defineColorArray{
    self.colorArray = [NSArray arrayWithObjects: [CPTColor greenColor], [CPTColor orangeColor],   [CPTColor grayColor], nil];
    
}

//3-number distribution for each plot element, @[min, range, max]
-(void)defineDictionaries:(HiveDetails *)hive{
    
    //setup y-value dictionaries //data name symbol color
    broodDictionary = [self calcRange:broodTotals:@"Brood Frames":[CPTPlotSymbol plusPlotSymbol]:[CPTColor brownColor]];
    honeyDictionary = [self calcRange:honeyTotals:@"Honey Frames":[CPTPlotSymbol hexagonPlotSymbol]:[CPTColor yellowColor]];
    workerDictionary = [self calcRange:workerTotals:@"Worker Frames":[CPTPlotSymbol trianglePlotSymbol]:[CPTColor redColor]];
    queenPerformanceDictionary = [self calcRange:queenPerformance:@"Queen Performance":[CPTPlotSymbol starPlotSymbol]:[CPTColor magentaColor]];
    temperatureDictionary = [self calcRange:temperature:@"Temperature":[CPTPlotSymbol snowPlotSymbol]:[CPTColor cyanColor]];
    humidityDictionary = [self calcRange:humidity:@"Humidity":[CPTPlotSymbol crossPlotSymbol]:[CPTColor blueColor]];
    pressureDictionary = [self calcRange:pressure:@"Pressure":[CPTPlotSymbol ellipsePlotSymbol]:[CPTColor purpleColor]];
    windSpeedDictionary = [self calcRange:windSpeed:@"Wind Speed":[CPTPlotSymbol diamondPlotSymbol]:[CPTColor blackColor]];
    
    //Setup Date Dictionary
    if(dateArray.count > 0){
        NSDate *firstDate = dateArray[0];
        NSDate *lastDate = dateArray[dateArray.count-1];
    
        NSTimeInterval dateIntervalinSec = [lastDate timeIntervalSinceDate:firstDate];
        int secInDay = 86400;
        NSNumber *rangeX = [NSNumber numberWithInteger:dateIntervalinSec / secInDay];
        NSDate *minX = dateArray[0];
        NSDate *maxX = dateArray[dateArray.count-1];
        dateDictionary = [NSDictionary dictionaryWithObjects:@[dateArray, minX, rangeX, maxX]
                                                 forKeys:@[@"data", @"minValue", @"range", @"maxValue"]];
    } else {
        dateDictionary = [NSDictionary dictionaryWithObjects:@[[NSNull null], [NSNull null], [NSNull null], [NSNull null]]
                                                     forKeys:@[@"data", @"minValue", @"range", @"maxValue"]];
    }
    
}
    
-(NSDictionary *)calcRange:(NSArray*)plotElement :(NSString*)identifier :(CPTPlotSymbol*)symbol :(CPTColor*)color{
    NSNumber *minValue, *rangeValue, *maxValue;
    
    float xmax = -MAXFLOAT; //system max value for datatype float
    float xmin = MAXFLOAT;
    for (NSNumber *num in plotElement) {
        if(num == (id)[NSNull null] || num == nil){
            NSLog(@"NULL VALUE");
        } else {
            float x = num.floatValue;
            if (x < xmin) xmin = x;
            if (x > xmax) xmax = x;
        }
    }
    
    if (xmax == MAXFLOAT) {
       
        NSDictionary *dataDictionary = [NSDictionary dictionaryWithObjects:@[[NSNull null], [NSNull null], [NSNull null],[NSNull null], identifier, symbol, color]
                                                                   forKeys:@[@"data", @"minValue", @"range", @"maxValue", @"identifier", @"symbol", @"color"]];
        return dataDictionary;
        
    } else {
    
        float range = xmax - xmin;
        minValue = [NSNumber numberWithFloat:xmin];
        rangeValue = [NSNumber numberWithFloat:range];
        maxValue = [NSNumber numberWithFloat:xmax];
    
        NSDictionary *dataDictionary = [NSDictionary dictionaryWithObjects:@[plotElement, minValue, rangeValue, maxValue, identifier, symbol, color]
                                                                   forKeys:@[@"data", @"minValue", @"range", @"maxValue", @"identifier", @"symbol", @"color"]];
        return dataDictionary;
    }
      
    
}



@end
