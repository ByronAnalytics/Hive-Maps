//
//  BoxData.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/22/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BoxData : NSManagedObject

@property (nonatomic, retain) NSNumber * frameHeight;
@property (nonatomic, retain) NSNumber * frameWidth;
@property (nonatomic, retain) NSString * nameBoxType;
@property (nonatomic, retain) NSNumber * numFrames;

@end
