//
//  DayViewController.h
//  Group_Project
//
//  Created by White, Jordan on 7/21/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <TapkuLibrary/TKCalendarDayViewController.h>
#import <TapkuLibrary/TKProgressAlertView.h>
#import <Foundation/Foundation.h> 
#import "AddCourseViewController.h"
//#import "TKCalendarDayViewController.h"

@interface DayViewController : TKCalendarDayViewController <AddCourseVCDelegate>

//local, never has anything to do with anything in Parse
@property (nonatomic, strong) NSMutableArray *localCourses;


//arary that just my Courses are downloaded into
@property (nonatomic, strong) NSMutableArray *myCourses;


//array that everything class is loaded into
@property (nonatomic, strong) NSMutableArray * allCourses;
//array with the dates add to the calendar
@property (nonatomic, strong) NSMutableArray *theFinalEvents;

@end
