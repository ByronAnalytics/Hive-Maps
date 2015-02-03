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
@synthesize honeyTotals, broodTotals, workerTotals, temperature, humidity, pressure, windSpeed;
@synthesize didRequeen, wasSick, obsQueen, obsInsuranceCups, obsDrones, obsSwarming;
@synthesize siteHive, queenSource, diseaseTreatment;

- (void)generateDataArrays:(HiveDetails *)hive{
  //initialize arrays
    dateArray = [[NSMutableArray alloc] init];
    honeyTotals = [[NSMutableArray alloc] init];
    broodTotals = [[NSMutableArray alloc] init];
    workerTotals = [[NSMutableArray alloc] init];
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
        
        [self.broodTotals addObject:[NSNumber numberWithFloat:framesBrood]];
        [self.honeyTotals addObject:[NSString stringWithFormat:@"%f", framesHoney]];
        [self.workerTotals addObject:[NSNumber numberWithFloat:framesHoney]];
        
        //   WeatherObservation *weather = [sortedObservations valueForKey:@"weatherObservation"];
        //[self.temperature addObject:weather.temperature];
        // [self.humidity addObject:weather.humidity];
        // [self.pressure addObject:weather.pressure];
        // [self.windSpeed addObject:weather.windSpeed];
        
        //Discrete Events
        [self.didRequeen addObject:[obs valueForKey:@"requeened"]];
        [self.wasSick addObject:[obs valueForKey:@"healthStatus"]];
        [self.obsQueen addObject:[obs valueForKey:@"observedQueen"]];
        [self.obsInsuranceCups addObject:[obs valueForKey:@"cupsInsur"]];
        [self.obsDrones addObject:[obs valueForKey:@"drone"]];
        [self.obsSwarming addObject:[obs valueForKey:@"swarm"]];
        //Hover Descriptors
        [self.queenSource addObject:[obs valueForKey:@"queenSource"]];
        [self.diseaseTreatment addObject:[obs valueForKey:@"treatment"]];
     
    }
}

    



@end
