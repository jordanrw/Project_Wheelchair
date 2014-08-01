//
//  DateCalculator.m
//  testDate
//
//  Created by White, Jordan on 7/24/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "DateCalculator.h"

@implementation DateCalculator

//- (NSMutableArray)initWithDays:(NSString*)days andHourMinutes:(NSString *)hrMn {
//    self = [super init];
//    if (self) {
//        return [self addHourMinute:hrMn ToDates:[self datesFromString:days]];
//    }
//    return self;
//}

#pragma mark - FINISHED & MOVED
#pragma mark - Hour & Minute
- (NSMutableArray *)addHourMinute:(NSString *)hrMin1 andHourMinute2:(NSString *)hrMin2 andHourMinute3:(NSString *)hrMin3 ToDates:(NSMutableArray *)bigArray {
    
    //get dictionary
    NSDictionary *hourMinute1 = [self splitMinuteHour:hrMin1];
    NSDictionary *hourMinute2 = [self splitMinuteHour:hrMin2];
    NSDictionary *hourMinute3 = [self splitMinuteHour:hrMin3];

    //get calendar
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setLocale:[NSLocale currentLocale]];
    //create components
    NSDateComponents *components = [[NSDateComponents alloc]init];
    //create array
    NSMutableArray *arrayFinished = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 3; i++) {
    NSArray *originals = [bigArray objectAtIndex:i];
    NSDictionary *hourMinute = [[NSDictionary alloc]init];
        
        if (i == 0) hourMinute = hourMinute1;
        if (i == 1) hourMinute = hourMinute2;
        if (i == 2) hourMinute = hourMinute3;
        
        for (int j = 0; j < (int)[originals count]; j++) {
            
            NSDate *original = [originals objectAtIndex:j];
            NSDate *final = [[NSDate alloc]init];
            
            int min = [[hourMinute objectForKey:@"minute"]intValue];
            //NSLog(@"minute:%i", min);
            int hr = [[hourMinute objectForKey:@"hour"]intValue];
            
            [components setHour:hr];
            [components setMinute:min];
            
            final = [cal dateByAddingComponents:components toDate:original options:0];
            [arrayFinished addObject:final];
        }

    }
    //array with all the correct NSDates (for times 1,2,3)
    return arrayFinished;
}

- (NSDictionary *)splitMinuteHour:(NSString *)time {
    NSRange hour1 = NSMakeRange(0, 1);
    NSRange minute1 = NSMakeRange(1, 2);
    NSRange hour2 = NSMakeRange(0, 2);
    NSRange minute2 = NSMakeRange(2, 2);
    
    
    NSString *hour = @"";
    NSString *minute = @"";
    int hh;
    int mm;
    
    switch ([time length]) {
        case 3:
            hour = [time substringWithRange:hour1];
            hh = [hour intValue];
            minute = [time substringWithRange:minute1];
            mm = [minute intValue];
            break;
        case 4:
            hour = [time substringWithRange:hour2];
            hh = [hour intValue];
            minute = [time substringWithRange:minute2];
            mm = [minute intValue];
            break;
            
        default:
            break;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:hh], @"hour",
                          [NSNumber numberWithInt:mm], @"minute",
                          nil];
    return dict;
}


#pragma mark - Days
//NEW work
- (NSMutableArray *)datesFromString:(NSString *)string1 fromString2:(NSString *)string2 andString3:(NSString *)string3 {
    //get the dictionaries
    NSDictionary *time1 = [self splitString:string1];
    NSDictionary *time2 = [self splitString:string2];
    NSDictionary *time3 = [self splitString:string3];
    //get today at midnight
    NSDate *midtonight = [self todayAtMidnight];
    //get calendar
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setLocale:[NSLocale currentLocale]];
    //create components
    NSDateComponents *components = [[NSDateComponents alloc]init];
    //create arrays
    NSMutableArray *arrayOfTimes = [[NSMutableArray alloc]init];
    NSMutableArray *time1Array = [[NSMutableArray alloc]init];
    NSMutableArray *time2Array = [[NSMutableArray alloc]init];
    NSMutableArray *time3Array = [[NSMutableArray alloc]init];
    
    
    
    NSDictionary *timeDict = [[NSDictionary alloc]init];
    for (int i = 1; i < 4; i++) {
        
        if (i == 1) timeDict = time1;
        if (i == 2) timeDict = time2;
        if (i == 3) timeDict = time3;
        
        for (int j = 0; j < (int)[timeDict count]; j++) {
            NSDate *time = [[NSDate alloc]init];
            
            NSString *key = [NSString stringWithFormat:@"class%i",j+1];
            if ((int)[self todaysDayOfWeek] > [[timeDict objectForKey:key]intValue]){
                int x = (int)[self todaysDayOfWeek];
                int y = [[timeDict objectForKey:key] intValue];
                int z = (7-x)+y;
                [components setDay:z];
                time = [cal dateByAddingComponents:components toDate:midtonight options:0];
                
                [time1Array addObject:time];
            }
            else {
                //NSLog(@"item is in this weeks view");
                int x = [[timeDict objectForKey:key]intValue];
                int y = (int)[self todaysDayOfWeek];
                int z = x - y;
                [components setDay:z];
                time = [cal dateByAddingComponents:components toDate:midtonight options:0];
                
                [time1Array addObject:time];
            }
        }
        if (i == 1) [arrayOfTimes addObject:time1Array];
        if (i == 2) [arrayOfTimes addObject:time2Array];
        if (i == 3) [arrayOfTimes addObject:time3Array];
    }
    
    //this holds 3 arrays of times (NSDates which have a day value)
    return arrayOfTimes;
}

- (NSDate *)todayAtMidnight {
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setLocale:[NSLocale currentLocale]];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *date = [NSDate date];
    
    NSDateComponents *comps = [cal components:unitFlags fromDate:date];
    [comps setHour:00];
    [comps setMinute:00];
    [comps setSecond:00];
    
    NSDate *beginning = [cal dateFromComponents:comps];
    
    return beginning;
}

- (NSInteger)todaysDayOfWeek {
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setLocale:[NSLocale currentLocale]];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *date = [NSDate date];
    
    NSDateComponents *comps = [cal components:unitFlags fromDate:date];
    [comps setHour:00];
    [comps setMinute:00];
    [comps setSecond:00];
    
    NSInteger weekday = [comps weekday];// % 7;
    
    return weekday;
}

- (NSDictionary *)splitString:(NSString *)days {
    
    NSRange first = NSMakeRange(0, 1);
    NSRange second = NSMakeRange(1, 1);
    NSRange third = NSMakeRange(2, 1);
    NSRange fourth = NSMakeRange(3, 1);
    NSRange fifth = NSMakeRange(4, 1);
    
    NSString *day1 = @"";
    NSString *day2 = @"";
    NSString *day3 = @"";
    NSString *day4 = @"";
    NSString *day5 = @"";
    
    switch ([days length]) {
        case 0:
            NSLog(@"length is 0");
            break;
        case 1:
            day1 = [days substringWithRange:first];
            break;
        case 2:
            day1 = [days substringWithRange:first];
            day2 = [days substringWithRange:second];
            break;
        case 3:
            day1 = [days substringWithRange:first];
            day2 = [days substringWithRange:second];
            day3 = [days substringWithRange:third];
            break;
        case 4:
            day1 = [days substringWithRange:first];
            day2 = [days substringWithRange:second];
            day3 = [days substringWithRange:third];
            day4 = [days substringWithRange:fourth];
            break;
        case 5:
            day1 = [days substringWithRange:first];
            day2 = [days substringWithRange:second];
            day3 = [days substringWithRange:third];
            day4 = [days substringWithRange:fourth];
            day5 = [days substringWithRange:fifth];
            break;
        default:
            NSLog(@"Error in method splitString:");
            break;
    }
    
    //int of days
    int d1 = 0, d2=0, d3=0, d4=0, d5 = 0;
    
    //Monday
    if ([day1 isEqual:@"M"]) d1 = 2;
    
    //Tuesday
    if ([day1 isEqual:@"T"]) d1 = 3;
    if ([day2 isEqual:@"T"]) d2 = 3;
    
    //Wednesday
    if ([day1 isEqual:@"W"]) d1 = 4;
    if ([day2 isEqual:@"W"]) d2 = 4;
    if ([day3 isEqual:@"W"]) d3 = 4;
    
    //Thursday
    if ([day1 isEqual:@"R"]) d1 = 5;
    if ([day2 isEqual:@"R"]) d2 = 5;
    if ([day3 isEqual:@"R"]) d3 = 5;
    if ([day4 isEqual:@"R"]) d4 = 5;
    
    //Friday
    if ([day1 isEqual:@"F"]) d1 = 6;
    if ([day2 isEqual:@"F"]) d2 = 6;
    if ([day3 isEqual:@"F"]) d3 = 6;
    if ([day4 isEqual:@"F"]) d4 = 6;
    if ([day5 isEqual:@"F"]) d5 = 6;
    
    NSDictionary *dict = [[NSDictionary alloc]init];
    
    if (d5 != 0) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithInt:d1], @"class1",
                [NSNumber numberWithInt:d2], @"class2",
                [NSNumber numberWithInt:d3], @"class3",
                [NSNumber numberWithInt:d4], @"class4",
                [NSNumber numberWithInt:d5], @"class5",
                nil];
    }
    else if (d4 != 0) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithInt:d1], @"class1",
                [NSNumber numberWithInt:d2], @"class2",
                [NSNumber numberWithInt:d3], @"class3",
                [NSNumber numberWithInt:d4], @"class4",
                nil];
    }
    
    else if (d3 != 0) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithInt:d1], @"class1",
                [NSNumber numberWithInt:d2], @"class2",
                [NSNumber numberWithInt:d3], @"class3",
                nil];
    }
    
    else if (d2 != 0) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithInt:d1], @"class1",
                [NSNumber numberWithInt:d2], @"class2",
                nil];
    }
    
    else if (d1 != 0) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithInt:d1], @"class1",
                nil];
    }
    return dict;
}


@end
