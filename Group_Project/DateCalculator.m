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
- (NSMutableArray *)addHourMinute:(NSString *)string ToDates:(NSMutableArray*)originals {
    //get dictionary
    NSDictionary *hourMinute = [self splitMinuteHour:string];
    //NSLog(@"dictionary %@", hourMinute);
    //get calendar
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setLocale:[NSLocale currentLocale]];
    //create components
    NSDateComponents *components = [[NSDateComponents alloc]init];
    //create array
    NSMutableArray *arrayFinished = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < (int)[originals count]; i++) {
        
        NSDate *original = [originals objectAtIndex:i];
        NSDate *final = [[NSDate alloc]init];
        
        int min = [[hourMinute objectForKey:@"minute"]intValue];
        //NSLog(@"minute:%i", min);
        int hr = [[hourMinute objectForKey:@"hour"]intValue];
        
        [components setHour:hr];
        [components setMinute:min];
        
        final = [cal dateByAddingComponents:components toDate:original options:0];
        [arrayFinished addObject:final];
    }
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

- (NSMutableArray *)datesFromString:(NSString *)string {
    //get the dictionary
    NSDictionary *time1 = [self splitString:string];
    //NSDictionary *time2 = [self splitString:<#(NSString *)#>];
    //get today at midnight
    NSDate *midtonight = [self todayAtMidnight];
    //get calendar
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setLocale:[NSLocale currentLocale]];
    //create components
    NSDateComponents *components = [[NSDateComponents alloc]init];
    //create array
    NSMutableArray *arrayOfTimes = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < (int)[time1 count]; i++) {
        NSDate *time = [[NSDate alloc]init];
        
        NSString *key = [NSString stringWithFormat:@"class%i",i+1];
        if ((int)[self todaysDayOfWeek] > [[time1 objectForKey:key]intValue]){
            int x = (int)[self todaysDayOfWeek];
            int y = [[time1 objectForKey:key] intValue];
            int z = (7-x)+y;
            [components setDay:z];
            time = [cal dateByAddingComponents:components toDate:midtonight options:0];
            
            [arrayOfTimes addObject:time];
        }
        else {
            //NSLog(@"item is in this weeks view");
            int x = [[time1 objectForKey:key]intValue];
            int y = (int)[self todaysDayOfWeek];
            int z = x - y;
            [components setDay:z];
            time = [cal dateByAddingComponents:components toDate:midtonight options:0];
            
            [arrayOfTimes addObject:time];
        }
    }
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
