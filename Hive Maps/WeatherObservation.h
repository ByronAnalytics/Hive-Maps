//
//  WeatherObservation.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/22/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HiveObservation;

@interface WeatherObservation : NSManagedObject

@property (nonatomic, retain) NSDate * dateWeatherObs;
@property (nonatomic, retain) NSNumber * humidity;
@property (nonatomic, retain) NSNumber * precip1hr;
@property (nonatomic, retain) NSNumber * precip24hr;
@property (nonatomic, retain) NSNumber * pressure;
@property (nonatomic, retain) NSString * siteHive;
@property (nonatomic, retain) NSNumber * stationDistance;
@property (nonatomic, retain) NSString * stationID;
@property (nonatomic, retain) NSNumber * stationLat;
@property (nonatomic, retain) NSNumber * stationLong;
@property (nonatomic, retain) NSString * stationType;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSNumber * windDir;
@property (nonatomic, retain) NSNumber * windSpeed;
@property (nonatomic, retain) HiveObservation *hiveObservation;

@end
