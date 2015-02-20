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

@property (nonatomic, strong, readonly) NSMutableArray *dateArray;

- (void)generateDataArrays:(HiveDetails *)hive;


@end
