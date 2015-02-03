//
//  DataLuggage.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 2/2/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HiveDetails.h"

@interface DataLuggage : NSObject

@property (nonatomic, strong) HiveDetails *hive;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (DataLuggage *)sharedObject;


@end
