//
//  HiveBox.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/22/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BoxData, BoxObservation, HiveDetails;

@interface HiveBox : NSManagedObject

@property (nonatomic, retain) NSString * boxID;
@property (nonatomic, retain) NSString * boxType;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSNumber * numFrames;
@property (nonatomic, retain) BoxData *boxData;
@property (nonatomic, retain) NSSet *boxObservations;
@property (nonatomic, retain) HiveDetails *hiveDetail;
@end

@interface HiveBox (CoreDataGeneratedAccessors)

- (void)addBoxObservationsObject:(BoxObservation *)value;
- (void)removeBoxObservationsObject:(BoxObservation *)value;
- (void)addBoxObservations:(NSSet *)values;
- (void)removeBoxObservations:(NSSet *)values;

@end
