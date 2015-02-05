//
//  ProcessDataForPlotting.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/28/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "HiveDetails.h"

@interface ProcessDataForPlotting : NSObject

@property (nonatomic, strong, readonly) NSDictionary *dateDictionary, *broodDictionary, *honeyDictionary, *workerDictionary, *queenPerformanceDictionary, *temperatureDictionary, *humidityDictionary, *pressureDictionary, *windSpeedDictionary;

//##################################

@property (nonatomic, strong, readonly) NSMutableArray *dateArray, *broodTotals, *honeyTotals, *workerTotals, *queenPerformance, *temperature, *humidity, *pressure, *windSpeed; //hive parameters and covariates

@property (nonatomic, strong, readonly) NSMutableArray  *didRequeen, *wasSick, *obsQueen, *obsInsuranceCups, *obsDrones, *obsSwarming; //boolean values
@property (nonatomic, strong, readonly) NSMutableArray *siteHive, *queenSource, *diseaseTreatment; //descriptors for 'hover over' displays
@property (nonatomic, strong) NSArray *plotSymbolArray, *colorArray;

- (void)generateDataArrays:(HiveDetails *)hive;


@end
