/*
- (void) formatAgeTextField{
    // The time interval
    NSTimeInterval theTimeInterval = [self.hive.startDate timeIntervalSinceNow] * -1;
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    NSString *age = nil;
    
    if([breakdownInfo year] > 0 ){  // If hive is more then a year old, display age as YY:MM
        if ([breakdownInfo month] > 0) {
            if([breakdownInfo year] >= 2){ //pluralize years
                if([breakdownInfo month] >= 2){ //pluralize months
                    age = [NSString stringWithFormat:@"%ld years, %ld months", (long)[breakdownInfo year], (long)[breakdownInfo month]];
                } else {
                    age = [NSString stringWithFormat:@"%ld years, %ld month", (long)[breakdownInfo year], (long)[breakdownInfo month]];
                }
            } else {
                if([breakdownInfo month] >= 2){
                    age = [NSString stringWithFormat:@"%ld year, %ld months", (long)[breakdownInfo year], (long)[breakdownInfo month]];
                } else {
                    age = [NSString stringWithFormat:@"%ld year, %ld month", (long)[breakdownInfo year], (long)[breakdownInfo month]];
                }
            }
            
        } else { // hive is between 12 and 13 months old
            if([breakdownInfo year] >= 2){ //pluralize years
                if([breakdownInfo day] >= 2){ //pluralize months
                    age = [NSString stringWithFormat:@"%ld years, %ld days", (long)[breakdownInfo year], (long)[breakdownInfo day]];
                } else {
                    age = [NSString stringWithFormat:@"%ld years, %ld day", (long)[breakdownInfo year], (long)[breakdownInfo day]];
                }
            } else {
                if([breakdownInfo month] >= 2){
                    age = [NSString stringWithFormat:@"%ld year, %ld days", (long)[breakdownInfo year], (long)[breakdownInfo day]];
                } else {
                    age = [NSString stringWithFormat:@"%ld year, %ld day", (long)[breakdownInfo year], (long)[breakdownInfo day]];
                }
            }
            
        }
    } else if ([breakdownInfo month] > 0) {
        if([breakdownInfo month] >= 2){
            if ([breakdownInfo day] >=2){
                age = [NSString stringWithFormat:@"%ld months, %ld days", (long)[breakdownInfo year], (long)[breakdownInfo month]];
            } else {
                age = [NSString stringWithFormat:@"%ld months, %ld day", (long)[breakdownInfo year], (long)[breakdownInfo month]];
            }
        } else {
            if ([breakdownInfo day] >=2){
                age = [NSString stringWithFormat:@"%ld month, %ld days", (long)[breakdownInfo month], (long)[breakdownInfo day]];
            } else {
                age = [NSString stringWithFormat:@"%ld month, %ld day", (long)[breakdownInfo month], (long)[breakdownInfo day]];
            }
        }
    } else {
        if ([breakdownInfo day] >=2){
            age = [NSString stringWithFormat:@"%ld days", (long)[breakdownInfo day]];
        } else {
            age = [NSString stringWithFormat:@"%ld day", (long)[breakdownInfo day]];
        }
    }
    ageOut.text = age;
    
}
 */
