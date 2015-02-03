/*
- (void)generateDataArrays:(HiveDetails *)hive{
    NSSet *hiveObservations = hive.hiveObservations;
    
    NSLog(@"Number Observations: %lu", (unsigned long)hiveObservations.count);
    
    //sort set by date
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"observationDate" ascending:YES]];
    NSArray *sortedObservations = [[hiveObservations allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    
    
    for (id obs in sortedObservations) {
        
        //Dependent Variable (Time)
        [self.date addObject:[obs valueForKey:@"observationDate"]];
        NSLog(@"Date %@", [obs valueForKey:@"observationDate"]);
        
        //Independent Variables
        NSSet *boxes = [obs valueForKey:@"boxObservations"];
        float framesBrood = 0;
        float framesWorkers = 0;
        float framesHoney = 0;
        
        for (id box in boxes) {
            framesBrood = framesBrood + [[box valueForKey:@"framesBrood"] floatValue];
            framesWorkers = framesWorkers + [[box valueForKey:@"framesWorkers"] floatValue];
            framesHoney = framesHoney + [[box valueForKey:@"framesHoney"] floatValue];
        }
        
        [self.broodTotals addObject:[NSNumber numberWithFloat:framesBrood]];
        [self.honeyTotals addObject:[NSString stringWithFormat:@"%f", framesHoney]];
        [self.workerTotals addObject:[NSNumber numberWithFloat:framesHoney]];
        
        //   WeatherObservation *weather = [sortedObservations valueForKey:@"weatherObservation"];
        //[self.temperature addObject:weather.temperature];
        // [self.humidity addObject:weather.humidity];
        // [self.pressure addObject:weather.pressure];
        // [self.windSpeed addObject:weather.windSpeed];
        
        //Discrete Events
        [self.didRequeen addObject:[obs valueForKey:@"requeened"]];
        [self.wasSick addObject:[obs valueForKey:@"healthStatus"]];
        [self.obsQueen addObject:[obs valueForKey:@"observedQueen"]];
        [self.obsInsuranceCups addObject:[obs valueForKey:@"cupsInsur"]];
        [self.obsDrones addObject:[obs valueForKey:@"drone"]];
        [self.osbSwarming addObject:[obs valueForKey:@"swarm"]];
        //Hover Descriptors
        [self.queenSource addObject:[obs valueForKey:@"queenSource"]];
        [self.diseaseTreatment addObject:[obs valueForKey:@"treatment"]];
    }
    
    
}

- (void)totalBoxes:(HiveObservation *)hiveObservation{
    NSSet *boxes = hiveObservation.boxObservations;
    
    float framesBrood = 0;
    float framesWorkers = 0;
    float framesHoney = 0;
    
    for (id box in boxes) {
        NSLog(@"Sum Boxes loop");
        framesBrood = framesBrood + [[box valueForKey:@"framesBrood"] floatValue];
        framesWorkers = framesWorkers + [[box valueForKey:@"framesWorkers"] floatValue];
        framesHoney = framesHoney + [[box valueForKey:@"framesHoney"] floatValue];
    }
    
    [self.broodTotals addObject:[NSNumber numberWithFloat:framesBrood]];
    [honeyTotals addObject:[NSNumber numberWithFloat:framesWorkers]];
    [self.workerTotals addObject:[NSNumber numberWithFloat:framesHoney]];
    NSLog(@"Frames Honey: %f", framesHoney);
    NSLog(@"Honey Array: %@", self.honeyTotals);
    
}
*/