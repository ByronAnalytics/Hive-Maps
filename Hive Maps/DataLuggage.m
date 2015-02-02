//
//  DataLuggage.m
//  Hive Maps
//
//  Created by Byron Analytics LLC on 2/2/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import "DataLuggage.h"
#import "HiveDetails.h"

@implementation DataLuggage
@synthesize hive;

+ (DataLuggage *) sharedObject{
    static DataLuggage *sharedClassObject = nil;
    if (sharedClassObject == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedClassObject = [[DataLuggage alloc] init];
        });
    }
    
    return sharedClassObject;
}


@end
