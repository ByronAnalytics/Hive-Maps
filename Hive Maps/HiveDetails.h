//
//  HiveDetails.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/22/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HiveBox, HiveObservation;

@interface HiveDetails : NSManagedObject

@property (nonatomic, retain) NSString * currentQueenSource;
@property (nonatomic, retain) NSString * hiveID;
@property (nonatomic, retain) NSNumber * hiveLatitude;
@property (nonatomic, retain) NSNumber * hiveLongitude;
@property (nonatomic, retain) NSString * siteName;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * requeenedOn;
@property (nonatomic, retain) NSSet *hiveBoxes;
@property (nonatomic, retain) NSSet *hiveObservations;
@property (nonatomic, retain) HiveObservation *lastObservation;
@end

@interface HiveDetails (CoreDataGeneratedAccessors)

- (void)addHiveBoxesObject:(HiveBox *)value;
- (void)removeHiveBoxesObject:(HiveBox *)value;
- (void)addHiveBoxes:(NSSet *)values;
- (void)removeHiveBoxes:(NSSet *)values;

- (void)addHiveObservationsObject:(HiveObservation *)value;
- (void)removeHiveObservationsObject:(HiveObservation *)value;
- (void)addHiveObservations:(NSSet *)values;
- (void)removeHiveObservations:(NSSet *)values;

@end
