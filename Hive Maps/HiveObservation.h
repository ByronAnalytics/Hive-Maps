//
//  HiveObservation.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/22/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BoxObservation, HiveDetails, WeatherObservation;

@interface HiveObservation : NSManagedObject

@property (nonatomic, retain) NSNumber * aggressionLevel;
@property (nonatomic, retain) NSString * commentBox;
@property (nonatomic, retain) NSNumber * cupsInsur;
@property (nonatomic, retain) NSNumber * drone;
@property (nonatomic, retain) NSNumber * healthStatus;
@property (nonatomic, retain) NSDate * observationDate;
@property (nonatomic, retain) NSNumber * observedQueen;
@property (nonatomic, retain) NSNumber * propolisObserved;
@property (nonatomic, retain) NSNumber * queenPerformance;
@property (nonatomic, retain) NSString * queenSource;
@property (nonatomic, retain) NSNumber * requeened;
@property (nonatomic, retain) NSString * siteHive;
@property (nonatomic, retain) NSNumber * swarm;
@property (nonatomic, retain) NSString * treatment;
@property (nonatomic, retain) NSString * treatmentStage;
@property (nonatomic, retain) NSSet *boxObservations;
@property (nonatomic, retain) WeatherObservation *weatherObservation;
@property (nonatomic, retain) HiveDetails *hiveDetail;
@property (nonatomic, retain) HiveDetails *lastObservation;
@end

@interface HiveObservation (CoreDataGeneratedAccessors)

- (void)addBoxObservationsObject:(BoxObservation *)value;
- (void)removeBoxObservationsObject:(BoxObservation *)value;
- (void)addBoxObservations:(NSSet *)values;
- (void)removeBoxObservations:(NSSet *)values;

@end
