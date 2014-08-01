//
//  DateCalculator.h
//  testDate
//
//  Created by White, Jordan on 7/24/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateCalculator : NSObject

//- (instancetype)initWithDays:(NSString*)days andHourMinutes:(NSString *)hrMn;

//minute & hour
- (NSMutableArray *)addHourMinute:(NSString *)hrMin1 andHourMinute2:(NSString *)hrMin2 andHourMinute3:(NSString *)hrMin3 ToDates:(NSMutableArray*)bigArray;

- (NSDictionary *)splitMinuteHour:(NSString *)time;

//the day
- (NSDate *)todayAtMidnight;

- (NSInteger)todaysDayOfWeek;

- (NSDictionary *)splitString:(NSString *)days;

- (NSMutableArray *)datesFromString:(NSString *)string1 fromString2:(NSString *)string2 andString3:(NSString *)string3;

@end
