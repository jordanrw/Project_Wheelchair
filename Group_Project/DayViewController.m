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
#import "MyCoursesTableViewController.h"
#import <Parse/Parse.h>

@interface DayViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinny;


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
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"downloading everyone's courses..." message:@"swipe to a new day to see" delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
    [alert show];
    
    self.title = NSLocalizedString(@"Meeting Time", @"");
    [self addButtons];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    [self downloadGroupsClasses];
    [self.dayView reloadData];
    //self.navigationController.navigationBar.hairlineDividerView.hidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.hairlineDividerView.hidden = NO;
}

#pragma mark - Buttons
- (void)addButtons {
    //add course button
    self.dayView.daysBackgroundView.backgroundColor = [UIColor colorWithRed:.99 green:.99 blue:.99 alpha:1];
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(([[UIScreen mainScreen]bounds].size.width/2)-50, 50, 100, 30);
    [button setTitle:@"My Courses" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0 green:.49 blue:.96 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:.8 green:.89 blue:.99 alpha:1.0] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(myCoursesVC) forControlEvents:UIControlEventTouchUpInside];
    [self.dayView.daysBackgroundView addSubview:button];
     
    
//    //my courses
//    UIButton *myCoursesButton = [[UIButton alloc]init];
//    myCoursesButton.frame = CGRectMake(150, 50, 110, 30);
//    [myCoursesButton setTitle:@"my courses" forState:UIControlStateNormal];
//    [myCoursesButton setTitleColor:[UIColor colorWithRed:1 green:.49 blue:.96 alpha:1.0] forState:UIControlStateNormal];
//    [myCoursesButton setTitleColor:[UIColor colorWithRed:.8 green:.89 blue:.99 alpha:1.0] forState:UIControlStateHighlighted];
//    [myCoursesButton addTarget:self action:@selector(myCoursesVC) forControlEvents:UIControlEventTouchUpInside];
//    [self.dayView.daysBackgroundView addSubview:myCoursesButton];
    
//    //button to send data to cloud
//    UIButton *sendDataButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    [sendDataButton addTarget:self action:@selector(sendData) forControlEvents:UIControlEventTouchUpInside];
//    sendDataButton.frame = CGRectMake(20, 58, 20, 20);
//    [self.dayView.daysBackgroundView addSubview:sendDataButton];
    
    //button to download data
//    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    [downloadButton addTarget:self action:@selector(downloadGroupsClasses) forControlEvents:UIControlEventTouchUpInside];
//    downloadButton.frame = CGRectMake(270, 58, 20, 20);
//    [self.dayView.daysBackgroundView addSubview:downloadButton];
}

#pragma mark - My Courses View Controller
- (void)myCoursesVC {
    
    self.myCourses = [[NSMutableArray alloc]init];
    //TODO - loading alert
    //TODO - or load the tableview, the add the data when it gets here
        //but signal that its downloading
    PFUser *current = [PFUser currentUser];
    NSLog(@"current user: %@", current);

    PFRelation *relateCour = [current relationForKey:@"myCourses"];
    PFQuery *query = [relateCour query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *courses, NSError *error) {
        if (courses) {
            for (int i = 0; i < [courses count]; i++) {
                [self.myCourses addObject:[courses objectAtIndex:i]];
                NSLog(@"all Courses:%@", self.myCourses);
                if (i == ([courses count] - 1)) {
                    //My Courses view controller added to the screen
                    UINavigationController *myCourseVC = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"myC"];
                    MyCoursesTableViewController *vc = [myCourseVC.childViewControllers objectAtIndex:0];
                    vc.myCourses = self.myCourses;
                    [self presentViewController:myCourseVC animated:YES completion:nil];
                    
                }
            }
        }
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"error" message:@"can't connect to server" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

#pragma mark TKCalendarDayViewDelegate
- (NSArray *) calendarDayTimelineView:(TKCalendarDayView*)calendarDayTimeline eventsForDate:(NSDate *)eventDate{
    NSLog(@"calendarDayTimelineView called");
    
   //if([eventDate compare:[NSDate dateWithTimeIntervalSinceNow:-24*60*60]] == NSOrderedAscending) return @[];
   //if([eventDate compare:[NSDate dateWithTimeIntervalSinceNow:24*60*60]] == NSOrderedDescending) return @[];
   
    NSMutableArray *finalEvents = [[NSMutableArray alloc]init];
    
    //#using Parse
    for (int i = 0; i < [self.allCourses count]; i++) {
        PFObject *course = [self.allCourses objectAtIndex:i];
        
        //        TKCalendarDayEventView *event = [calendarDayTimeline dequeueReusableEventView];
        //        if(event == nil) event = [TKCalendarDayEventView eventView];
        
        DateCalculator *calculateDate = [[DateCalculator alloc]init];
        
        NSArray *begins = [calculateDate addHourMinute:[course objectForKey:@"timeBegin1"] ToDates:[calculateDate datesFromString:[course objectForKey:@"day1"]]];
        NSArray *ends = [calculateDate addHourMinute:[course objectForKey:@"timeEnd1"] ToDates:[calculateDate datesFromString:[course objectForKey:@"day1"]]];
        
        for (int i = 0; i < [begins count]; i++) {
            TKCalendarDayEventView *event = [TKCalendarDayEventView eventViewWithIdentifier:0 startDate:[begins objectAtIndex:i] endDate:[ends objectAtIndex:i] title:nil location:nil];
            
            [finalEvents addObject:event];
            //NSLog(@"final Event array has these items %@ on take %i",finalEvents, i);
        }
    }
    /*
//    //#using local array
//    for (int i = 0; i < [self.myCourses count]; i++) {
//        Course *course = [self.myCourses objectAtIndex:i];
//        
////        TKCalendarDayEventView *event = [calendarDayTimeline dequeueReusableEventView];
////        if(event == nil) event = [TKCalendarDayEventView eventView];
//        
//        DateCalculator *calculateDate = [[DateCalculator alloc]init];
//        
//        NSArray *begins = [calculateDate addHourMinute:course.timeBegin1 ToDates:[calculateDate datesFromString:course.day1]];
//        NSArray *ends = [calculateDate addHourMinute:course.timeEnd1 ToDates:[calculateDate datesFromString:course.day1]];
//
//        for (int i = 0; i < [begins count]; i++) {
//            TKCalendarDayEventView *event = [TKCalendarDayEventView eventViewWithIdentifier:0 startDate:[begins objectAtIndex:i] endDate:[ends objectAtIndex:i] title:nil location:nil];
//            
//            [finalEvents addObject:event];
//            //NSLog(@"final Event array has these items %@ on take %i",finalEvents, i);
//        }
//    }
     */
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
    /*
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
    */
    return finalEvents;
}


- (void) calendarDayTimelineView:(TKCalendarDayView*)calendarDayTimeline eventViewWasSelected:(TKCalendarDayEventView *)eventView{
    //TKLog(@"%@",eventView.titleLabel.text);
    NSLog(@"event was tapped");
}

#pragma mark - convert PFCourse to Course 
- (void)convertPFCourseToCourse {
    NSLog(@"current:%@",[PFUser currentUser]);
    NSArray *courses = [[PFUser currentUser]objectForKey:@"myCourses"];
    PFObject *course1 = [courses objectAtIndex:0];
    [course1 fetch];
    NSLog(@"coure1:%@", course1);
    
    PFQuery *query = [PFQuery queryWithClassName:@"Course"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            NSLog(@"hey yall %@", object);
        }
    }];
}

#pragma mark - downloading courses from Parse
- (void)downloadGroupsClasses {
    NSLog(@"downloading");
    self.allCourses = [[NSMutableArray alloc]init];
    //TODO - put a load screen up while downloading the data
    
    PFUser *current = [PFUser currentUser];
    NSLog(@"current user: %@", current);
    
    PFObject *myGroup = [PFObject objectWithClassName:@"Groups"];
    myGroup = [current objectForKey:@"current"];
    NSLog(@"my current group: %@", myGroup);
    
    PFRelation *relation = [myGroup relationForKey:@"users"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        //these objects are the users
        if (users) {
            for (int i = 0; i < [users count]; i++) {
                NSLog(@"user%i", i);
                PFRelation *relateCour = [[users objectAtIndex:0]relationForKey:@"myCourses"];
                PFQuery *query = [relateCour query];
                [query findObjectsInBackgroundWithBlock:^(NSArray *courses, NSError *error) {
                    if (courses) {
                        for (int i = 0; i < [courses count]; i++) {
                            [self.allCourses addObject:[courses objectAtIndex:i]];
                            NSLog(@"all Courses:%@", self.allCourses);
                        }
                    }
                }];
            }
        }
    }];
}

#pragma mark - New Course View Controller
//NOT being used any more
//- (void)newCourseVC {
//    NSLog(@"Add new course view controller");
//
//    UINavigationController *addCourseVC = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"addC"];
//
//    //just get to the subview to access it properly
//    AddCourseViewController *vc = [addCourseVC.childViewControllers objectAtIndex:0];
//    vc.delegate = self;
//    [self presentViewController:addCourseVC animated:YES completion:nil];
//}

#pragma mark - After a new course is added
//NOT being used anymore
//- (void)sendBackCourse:(Course *)aCourse {
//    [self.localCourses addObject:aCourse];
//    NSLog(@"the number of my courses:%lu", (unsigned long)[self.localCourses count]);
//}

//NOT being used anymore
//- (void)sendBackPFCourse:(PFObject *)aCourse {
//    NSLog(@"%@", aCourse);
//}

#pragma mark - uploading data to Parse

//NOT being used anymore
/*
- (void)sendData {
    NSLog(@"sendData");
    NSLog(@"myCourses Array: %@", self.localCourses);
    Course *aCourse = [self.localCourses objectAtIndex:0];
    NSLog(@"1 course: %@", aCourse);
    NSLog(@"%@", aCourse.day1);
    
    for (int i = 0; i < [self.localCourses count]; i++) {
        Course *course = [self.localCourses objectAtIndex:i];
        PFObject *pfCourse = [PFObject objectWithClassName:@"Course"];
        
        [pfCourse setObject:course.course forKey:@"course"];
        [pfCourse setObject:course.CRN forKey:@"CRN"];
        [pfCourse setObject:course.num forKey:@"num"];
        [pfCourse setObject:course.title forKey:@"title"];
        [pfCourse setObject:course.type forKey:@"type"];
        [pfCourse setObject:course.teacher forKey:@"teacher"];
        
        [pfCourse setObject:course.day1 forKey:@"day1"];
        [pfCourse setObject:course.day2 forKey:@"day2"];
        [pfCourse setObject:course.day3 forKey:@"day3"];
        [pfCourse setObject:course.timeBegin1 forKey:@"timeBegin1"];
        [pfCourse setObject:course.timeBegin2 forKey:@"timeBegin2"];
        [pfCourse setObject:course.timeBegin3 forKey:@"timeBegin3"];
        [pfCourse setObject:course.timeEnd1 forKey:@"timeEnd1"];
        [pfCourse setObject:course.timeEnd2 forKey:@"timeEnd2"];
        [pfCourse setObject:course.timeEnd3 forKey:@"timeEnd3"];
        
        [pfCourse setObject:course.location1 forKey:@"location1"];
        [pfCourse setObject:course.location2 forKey:@"location2"];
        [pfCourse setObject:course.location3 forKey:@"location3"];
        
        [pfCourse saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"success");
                
                PFUser *user = [PFUser currentUser];
                PFRelation *relationship = [user relationForKey:@"myCourses"];
                [relationship addObject:pfCourse];
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"success for relation");
                    }
                }];
            }
        }];
        
    }
}
 */


@end