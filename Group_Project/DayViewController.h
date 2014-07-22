//
//  DayViewController.h
//  Group_Project
//
//  Created by White, Jordan on 7/21/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <TapkuLibrary/TKCalendarDayViewController.h>
#import <Foundation/Foundation.h> 
//#import "TKCalendarDayViewController.h"

@interface DayViewController : TKCalendarDayViewController

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *myCourses;

@end
