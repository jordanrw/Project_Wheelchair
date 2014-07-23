//
//  DayViewController.m
//  Group_Project
//
//  Created by White, Jordan on 7/21/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "DayViewController.h"
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

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    
    
    //AddCourseViewController *addCourseVC = (AddCourseViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"addCourse"];
    
    //just get to the subview to access it properly
    AddCourseViewController *vc = [addCourseVC.childViewControllers objectAtIndex:0];
    vc.delegate = self;
    [self presentViewController:addCourseVC animated:YES completion:nil];
}

#pragma mark - After a new course is added
- (void)sendBack:(Course *)aCourse {
    [self.myCourses addObject:aCourse];
    NSLog(@"%@", aCourse.timeBegin1);
}


#pragma mark TKCalendarDayViewDelegate
- (NSArray *) calendarDayTimelineView:(TKCalendarDayView*)calendarDayTimeline eventsForDate:(NSDate *)eventDate{
    
    if([eventDate compare:[NSDate dateWithTimeIntervalSinceNow:-24*60*60]] == NSOrderedAscending) return @[];
    if([eventDate compare:[NSDate dateWithTimeIntervalSinceNow:24*60*60]] == NSOrderedDescending) return @[];
    
    //NSDateComponents *info = [[NSDate date] dateComponentsWithTimeZone:calendarDayTimeline.calendar.timeZone];
    NSDateComponents *info = [[NSDateComponents alloc]init];
    
    info.second = 0;
    NSMutableArray *finalEvents = [NSMutableArray array];
    
    for(NSArray *ar in self.data){
        
        TKCalendarDayEventView *event = [calendarDayTimeline dequeueReusableEventView];
        if(event == nil) event = [TKCalendarDayEventView eventView];
        
        event.identifier = nil;
        event.titleLabel.text = ar[0];
        event.locationLabel.text = ar[1];
        
        info.hour = [ar[2] intValue];
        info.minute = [ar[3] intValue];
        
        ////////
         NSCalendar *cal = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [[NSDateComponents alloc]init];
        [components setHour:12];
        [components setMinute:00];
        [components setDay:23];
        [components setMonth:7];
        [components setYear:2014];
        NSDate *date1 = [cal dateFromComponents:components];
        
        ////////
        //NSDateComponents *components2 = [[NSDateComponents alloc]init];
        [components setHour:15];
        [components setMinute:00];
        [components setDay:23];
        [components setMonth:7];
        [components setYear:2014];
        NSDate *date2 = [cal dateFromComponents:components];
        
        
        event.startDate = date1;
        
        info.hour = [ar[4] intValue];
        info.minute = [ar[5] intValue];
        event.endDate = date2;
        
        [finalEvents addObject:event];
        
    }
    return finalEvents;
}

- (void) calendarDayTimelineView:(TKCalendarDayView*)calendarDayTimeline eventViewWasSelected:(TKCalendarDayEventView *)eventView{
    //TKLog(@"%@",eventView.titleLabel.text);
    NSLog(@"event was tapped");
}

@end