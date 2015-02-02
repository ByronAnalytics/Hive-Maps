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

- (void)generateDataArrays:(HiveDetails *)hive{
    NSSet *hiveObservations = hive.hiveObservations;
    NSLog(@"Number Observations: %lu", (unsigned long)hiveObservations.count);
    
    //sort set by date
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"observationDate" ascending:YES]];
    NSArray *sortedObservations = [[hiveObservations allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    NSLog(@"Sored Observations: %@", sortedObservations);
    
    for (int i = 0; i <= hiveObservations.count - 1; i++) {
        //Dependent Variable (Time)
        [self.date addObject:[sortedObservations[i] valueForKey:@"observationDate"]];
        
        //Independent Variables
        [self totalBoxes:sortedObservations[i]]; //Brood, Honey, Workers
        WeatherObservation *weather = [sortedObservations valueForKey:@"weatherObservation"];
        [self.temperature addObject:weather.temperature];
        [self.humidity addObject:weather.humidity];
        [self.pressure addObject:weather.pressure];
        [self.windSpeed addObject:weather.windSpeed];
        
        //Discrete Events
        [self.didRequeen addObject:[sortedObservations[i] valueForKey:@"requeened"]];
        [self.wasSick addObject:[sortedObservations[i] valueForKey:@"healthStatus"]];
        [self.obsQueen addObject:[sortedObservations[i] valueForKey:@"observedQueen"]];
        [self.obsInsuranceCups addObject:[sortedObservations[i] valueForKey:@"cupsInsur"]];
        [self.obsDrones addObject:[sortedObservations[i] valueForKey:@"drone"]];
        [self.osbSwarming addObject:[sortedObservations[i] valueForKey:@"swarm"]];
        //Hover Descriptors
        [self.queenSource addObject:[sortedObservations[i] valueForKey:@"queenSource"]];
        [self.diseaseTreatment addObject:[sortedObservations[i] valueForKey:@"treatment"]];
    }
    
    
    
    
    
}

- (void)totalBoxes:(HiveObservation *)hiveObservation{
    NSSet *boxes = hiveObservation.boxObservations;
    // NSLog(@"Boxes: %@", [boxes valueForKey:@"boxID"]);
    
    float framesBrood = 0;
    float framesWorkers = 0;
    float framesHoney = 0;
    
    for (id box in boxes) {
        framesBrood = framesBrood + [[box valueForKey:@"framesBrood"] floatValue];
        framesWorkers = framesWorkers + [[box valueForKey:@"framesWorkers"] floatValue];
        framesHoney = framesHoney + [[box valueForKey:@"framesHoney"] floatValue];
    }
    
    [self.broodTotals addObject:[NSNumber numberWithFloat:framesBrood]];
    [self.honeyTotals addObject:[NSNumber numberWithFloat:framesWorkers]];
    [self.workerTotals addObject:[NSNumber numberWithFloat:framesHoney]];
    
}




@end
