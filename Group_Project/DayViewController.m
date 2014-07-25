//
//  DayViewController.m
//  Group_Project
//
//  Created by White, Jordan on 7/21/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "DayViewController.h"
#import "DateCalculator.h"
#import "Course.h"
#import <Parse/Parse.h>

@interface DayViewController ()

@end


@implementation DayViewController

- (NSUInteger) supportedInterfaceOrientations {
    return  UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


- (void) viewDidLoad{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    
    self.myCourses = [[NSMutableArray alloc]init];
    self.title = NSLocalizedString(@"Meeting Time", @"");
    self.data = @[
                  @[@"Meeting with five random dudes", @"Five Guys", @5, @0, @5, @30],
                  @[@"Unlimited bread rolls got me sprung", @"Olive Garden", @7, @0, @12, @0],
                  //@[@"Appointment", @"Dennys", @15, @0, @18, @0],
                  //@[@"Hamburger Bliss", @"Wendys", @15, @0, @18, @0],
                  //@[@"Fishy Fishy Fishfelayyyyyyyy", @"McDonalds", @5, @30, @6, @0],
                  //@[@"Turkey Time...... oh wait", @"Chick-fela", @14, @0, @19, @0],
                  @[@"Greet the king at the castle", @"Burger King", @19, @30, @30, @0]];
    
    
    //Button
    self.dayView.daysBackgroundView.backgroundColor = [UIColor colorWithRed:.99 green:.99 blue:.99 alpha:1];
    UIButton *button = [[UIButton alloc]init];
    /* basic contact add button
     button = [UIButton buttonWithType:UIButtonTypeContactAdd];
     button.frame = CGRectMake(([[UIScreen mainScreen]bounds].size.width/2)-10, 50, 20, 20);
     */
    button.frame = CGRectMake(([[UIScreen mainScreen]bounds].size.width/2)-50, 50, 100, 30);
    [button setTitle:@"Add Course" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0 green:.49 blue:.96 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:.8 green:.89 blue:.99 alpha:1.0] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(newCourseVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.dayView.daysBackgroundView addSubview:button];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    [self.dayView reloadData];
    //self.navigationController.navigationBar.hairlineDividerView.hidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.hairlineDividerView.hidden = NO;
    
}

#pragma mark - New Course View Controller
- (void)newCourseVC {
    NSLog(@"Add new course");

    UINavigationController *addCourseVC = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"addC"];
    
    //just get to the subview to access it properly
    AddCourseViewController *vc = [addCourseVC.childViewControllers objectAtIndex:0];
    vc.delegate = self;
    [self presentViewController:addCourseVC animated:YES completion:nil];
}

#pragma mark - After a new course is added
- (void)sendBack:(Course *)aCourse {
    [self.myCourses addObject:aCourse];
    NSLog(@"%@", aCourse.timeBegin1);
    NSLog(@"the number of my courses:%lu", (unsigned long)[self.myCourses count]);
}

#pragma mark TKCalendarDayViewDelegate
- (NSArray *) calendarDayTimelineView:(TKCalendarDayView*)calendarDayTimeline eventsForDate:(NSDate *)eventDate{
    NSLog(@"calendarDayTimelineView called");
    
   //if([eventDate compare:[NSDate dateWithTimeIntervalSinceNow:-24*60*60]] == NSOrderedAscending) return @[];
   //if([eventDate compare:[NSDate dateWithTimeIntervalSinceNow:24*60*60]] == NSOrderedDescending) return @[];
   
    NSMutableArray *finalEvents = [[NSMutableArray alloc]init];
    //NSLog(@"the number of myCourses:%lu", (unsigned long)[self.myCourses count]);
    
    for (int i = 0; i < [self.myCourses count]; i++) {
        Course *course = [self.myCourses objectAtIndex:i];
        
//        TKCalendarDayEventView *event = [calendarDayTimeline dequeueReusableEventView];
//        if(event == nil) event = [TKCalendarDayEventView eventView];
        
        DateCalculator *calculateDate = [[DateCalculator alloc]init];
        
        NSArray *begins = [calculateDate addHourMinute:course.timeBegin1 ToDates:[calculateDate datesFromString:course.day1]];
        NSArray *ends = [calculateDate addHourMinute:course.timeEnd1 ToDates:[calculateDate datesFromString:course.day1]];

        for (int i = 0; i < [begins count]; i++) {
            TKCalendarDayEventView *event = [TKCalendarDayEventView eventViewWithIdentifier:0 startDate:[begins objectAtIndex:i] endDate:[ends objectAtIndex:i] title:nil location:nil];
            
            [finalEvents addObject:event];
            //NSLog(@"final Event array has these items %@ on take %i",finalEvents, i);
        }
    }
    
    /* for (Course *course in self.myCourses) {
        NSLog(@"hit the inside");
        
        TKCalendarDayEventView *event = [calendarDayTimeline dequeueReusableEventView];
        if(event == nil) event = [TKCalendarDayEventView eventView];
        
        event.identifier = nil;
        event.titleLabel.text = nil;
        event.locationLabel.text = nil;
        
        DateCalculator *calculateDate = [[DateCalculator alloc]init];
        
        NSArray *begins = [calculateDate addHourMinute:course.timeBegin1 ToDates:[calculateDate datesFromString:course.day1]];
        NSArray *ends = [calculateDate addHourMinute:course.timeEnd1 ToDates:[calculateDate datesFromString:course.day1]];
        for (int i = 0; i < [begins count]; i++) {
            event.startDate = [begins objectAtIndex:i];
            NSLog(@"startDate %@", event.startDate);
            event.endDate = [ends objectAtIndex:i];
            NSLog(@"endDate %@", event.endDate);
            [finalEvents addObject:event];
        }
    } */
    
    
    
    
    //for(NSArray *ar in self.data){
    
//    TKCalendarDayEventView *event = [calendarDayTimeline dequeueReusableEventView];
//    if(event == nil) event = [TKCalendarDayEventView eventView];
//    
//    event.identifier = nil;
//    event.titleLabel.text = nil;
//    event.locationLabel.text = nil;
//    
//    ////////
//    NSDate *date1 = [self todayAtMidnight];
//    
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSDateComponents *components = [[NSDateComponents alloc]init];
//    [components setHour:4];
//    [components setMinute:25];
//    [components setDay:25];
//    [components setMonth:7];
//    [components setYear:2014];
//    NSDate *date2 = [cal dateFromComponents:components];
//    
//    event.startDate = date1;
//    event.endDate = date2;
//    
//    [finalEvents addObject:event];
    
    //}
    return finalEvents;
}


- (void) calendarDayTimelineView:(TKCalendarDayView*)calendarDayTimeline eventViewWasSelected:(TKCalendarDayEventView *)eventView{
    //TKLog(@"%@",eventView.titleLabel.text);
    NSLog(@"event was tapped");
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

@end