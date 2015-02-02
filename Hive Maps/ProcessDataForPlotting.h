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

@property (nonatomic, strong, readonly) NSMutableArray *broodTotals, *honeyTotals, *workerTotals, *temperature, *humidity, *pressure, *windSpeed; //hive parameters and covariates
@property (nonatomic, strong, readonly) NSMutableArray *date, *didRequeen, *wasSick, *obsQueen, *obsInsuranceCups, *obsDrones, *osbSwarming; //boolean values
@property (nonatomic, strong, readonly) NSMutableArray *siteHive, *queenSource, *diseaseTreatment; //descriptors for 'hover over' displays



- (void)generateDataArrays:(HiveDetails *)hive;


@end
