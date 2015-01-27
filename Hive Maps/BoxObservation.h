//
//  BoxObservation.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/22/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HiveBox, HiveObservation;

@interface BoxObservation : NSManagedObject

@property (nonatomic, retain) NSNumber * buildOut;
@property (nonatomic, retain) NSNumber * framesBrood;
@property (nonatomic, retain) NSNumber * framesWorkers;
@property (nonatomic, retain) NSNumber * framesHoney;
@property (nonatomic, retain) NSDate * observationDate;
@property (nonatomic, retain) NSString * siteHiveBox;
@property (nonatomic, retain) NSNumber * framesBuildOut;
@property (nonatomic, retain) HiveBox *hiveBox;
@property (nonatomic, retain) HiveObservation *hiveObservation;

@end
