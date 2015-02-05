//
//  ProcessDataForPlotting.m
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/28/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
/*/
Data arrays for each variable are created and stored in instance for this class called with data = generateDataForPlotting:hive
 
 
 */

#import "ProcessDataForPlotting.h"
#import "HiveObservation.h"
#import "BoxObservation.h"
#import "HiveBox.h"
#import "WeatherObservation.h"

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
        NSSet *boxes = [obs valueForKey:@"boxObservations"];
        float framesBrood = 0;
        float framesWorkers = 0;
        float framesHoney = 0;
        
        for (id box in boxes) {
            framesBrood = framesBrood + [[box valueForKey:@"framesBrood"] floatValue];
            framesWorkers = framesWorkers + [[box valueForKey:@"framesWorkers"] floatValue];
            framesHoney = framesHoney + [[box valueForKey:@"framesHoney"] floatValue];
        }
        
        [broodTotals addObject:[NSNumber numberWithFloat:framesBrood]];
        [honeyTotals addObject:[NSString stringWithFormat:@"%f", framesHoney]];
        [workerTotals addObject:[NSNumber numberWithFloat:framesHoney]];
        [queenPerformance addObject:[sortedObservations valueForKey:@"queenPerformance"]];
        //WeatherObservation *weather = [sortedObservations valueForKey:@"weatherObservation"];
        //[temperature addObject:weather.temperature];
        //[humidity addObject:weather.humidity];
        //[pressure addObject:weather.pressure];
        //[windSpeed addObject:weather.windSpeed];
        
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
    self.plotSymbolArray = [NSArray arrayWithObjects:@"crossPlotSymbol", @"ellipsePlotSymbol", @"rectanglePlotSymbol", @"plusPlotSymbol", @"starPlotSymbol", @"diamondPlotSymbol", @"trainglePlotSymbol", @"pentagonPlotSymbol", @"hexagonPlotSymbol", @"snowPlotSymbol", @"dashPlotSymbol", nil];
}

-(void)defineColorArray{
    self.colorArray = [NSArray arrayWithObjects:@"blackColor", @"redColor", @"greenColor", @"orangeColor", @"blueColor", @"purpleColor", @"cyanColor", @"brownColor", @"magentaColor", @"grayColor", @"yellowColor", nil];
    
}

//3-number distribution for each plot element, @[min, range, max]
-(void)defineDictionaries:(HiveDetails *)hive{
    
    //setup y-value dictionaries
    broodDictionary = [self calcRange:broodTotals];
    honeyDictionary = [self calcRange:honeyTotals];
    workerDictionary = [self calcRange:workerTotals];
    //queenPerformanceDictionary = [self calcRange:queenPerformance];
   // temperatureDictionary = [self calcRange:temperature];
    //humidityDictionary = [self calcRange:humidity];
   // pressureDictionary = [self calcRange:pressure];
   // windSpeedDictionary = [self calcRange:windSpeed];
    
    //Setup Date Dictionary
    NSDate *firstDate = dateArray[0];
    NSDate *lastDate = dateArray[dateArray.count-1];
    
    NSTimeInterval dateIntervalinSec = [lastDate timeIntervalSinceDate:firstDate];
    int secInDay = 86400;
    NSNumber *rangeX = [NSNumber numberWithInteger:dateIntervalinSec / secInDay];
    NSDate *minX = dateArray[0];
    NSDate *maxX = dateArray[dateArray.count-1];
    dateDictionary = [NSDictionary dictionaryWithObjects:@[dateArray, minX, rangeX, maxX]
                                                 forKeys:@[@"data", @"minValue", @"range", @"maxValue"]];
    
}
    
-(NSDictionary *)calcRange:(NSArray*)plotElement{
    NSNumber *minValue, *rangeValue, *maxValue;
    
    float xmax = -MAXFLOAT; //system max value for datatype float
    float xmin = MAXFLOAT;
    for (NSNumber *num in plotElement) {
        float x = num.floatValue;
        if (x < xmin) xmin = x;
        if (x > xmax) xmax = x;
    }
    
    float range = xmax - xmin;
    minValue = [NSNumber numberWithFloat:xmin];
    rangeValue = [NSNumber numberWithFloat:range];
    maxValue = [NSNumber numberWithFloat:xmax];
    
    NSDictionary *dataDictionary = [NSDictionary dictionaryWithObjects:@[plotElement, minValue, rangeValue, maxValue]
                                forKeys:@[@"data", @"minValue", @"range", @"maxValue"]];
    return dataDictionary;
}


@end
