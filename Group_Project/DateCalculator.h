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
- (NSMutableArray *)addHourMinute:(NSString *)string ToDates:(NSMutableArray*)originals;

- (NSDictionary *)splitMinuteHour:(NSString *)time;

//the day
- (NSDate *)todayAtMidnight;

- (NSInteger)todaysDayOfWeek;

- (NSDictionary *)splitString:(NSString *)days;

- (NSMutableArray *)datesFromString:(NSString *)string;

@end
