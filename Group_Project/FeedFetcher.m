//
//  FeedFetcher.m
//  Group_Project
//
//  Created by White, Jordan on 7/23/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "FeedFetcher.h"
#import <Parse/Parse.h>

@implementation FeedFetcher

- (void)fetchFeedWith:(NSString *)inputURL andActivity:(UIActivityIndicatorView *)spin andLabel:(UILabel *)label {
    
    __weak FeedFetcher *weakSelf = self;
    
    NSURL *URL = [NSURL URLWithString:inputURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest: request queue: [NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError){
         NSLog(@"data is kinda here");
         //the same as calling self, but its a safety to make sure self hasn't been set to nil
         //since this is inside of a 'block'
         [weakSelf extractData: data];
         
         [spin stopAnimating];
         spin.hidden = YES;
         label.hidden = YES;
     }];
    
}

#pragma mark - extraction

- (void) extractData: (NSData*) someData  {
    
    NSArray *allCourses = [NSJSONSerialization JSONObjectWithData:someData options:0 error:nil];
    NSLog(@"The data is downloaded");
    
    //save the data to the phone locally
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:allCourses forKey:@"courses"];
}


- (void)iterateThrough:(NSArray *)someArray atCRN:(NSString *)someCRN {
    
    self.coursesEnrolled = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dict in someArray) {
        if ([[dict valueForKey:@"CRN"] isEqualToString:someCRN]) {
            
            //if you get inside then you have the right course
            Course *newCourse = [[Course alloc]initWithCRN:someCRN];
            
            //set all the properties
            newCourse.course = [dict valueForKey:@"Course"];
            newCourse.num = [dict valueForKey:@"Num"];
            newCourse.teacher = [dict valueForKey:@"Teacher"];
            newCourse.title = [dict valueForKey:@"Title"];
            newCourse.type = [dict valueForKey:@"Type"];
            newCourse.credits = [dict valueForKey:@"credits"];
            newCourse.location1 = [dict valueForKey:@"Location1"];
            newCourse.location2 = [dict valueForKey:@"Location2"];
            newCourse.location3 = [dict valueForKey:@"Location3"];
            
            //the TIME STUFF THAT MATTERS
            newCourse.day1 = [dict valueForKey:@"Days1"];
            newCourse.day2 = [dict valueForKey:@"Days2"];
            newCourse.day3 = [dict valueForKey:@"Days3"];
            
            newCourse.timeBegin1 = [dict valueForKey:@"timeBegin1"];
            newCourse.timeEnd1 = [dict valueForKey:@"timeEnd1"];
            newCourse.timeBegin2 = [dict valueForKey:@"timeBegin2"];
            newCourse.timeEnd2 = [dict valueForKey:@"timeEnd2"];
            newCourse.timeBegin3 = [dict valueForKey:@"timeBegin3"];
            newCourse.timeEnd3 = [dict valueForKey:@"timeEnd3"];
            
            //add it to the mutableArray
            self.verify = newCourse;
        }
    }
}

- (void)iterateThroughToSave:(NSArray *)someArray atCRN:(NSString *)someCRN {
    self.coursesEnrolled = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dict in someArray) {
        if ([[dict valueForKey:@"CRN"] isEqualToString:someCRN]) {
            
            //if you get inside then you have the right course
            Course *newCourse = [[Course alloc]initWithCRN:someCRN];
            
            //set all the properties
            newCourse.course = [dict valueForKey:@"Course"];
            newCourse.num = [dict valueForKey:@"Num"];
            newCourse.teacher = [dict valueForKey:@"Teacher"];
            newCourse.title = [dict valueForKey:@"Title"];
            newCourse.type = [dict valueForKey:@"Type"];
            newCourse.credits = [dict valueForKey:@"credits"];
            newCourse.location1 = [dict valueForKey:@"Location1"];
            newCourse.location2 = [dict valueForKey:@"Location2"];
            newCourse.location3 = [dict valueForKey:@"Location3"];
            
            //the TIME STUFF THAT MATTERS
            newCourse.day1 = [dict valueForKey:@"Days1"];
            newCourse.day2 = [dict valueForKey:@"Days2"];
            newCourse.day3 = [dict valueForKey:@"Days3"];
            
            newCourse.timeBegin1 = [dict valueForKey:@"timeBegin1"];
            newCourse.timeEnd1 = [dict valueForKey:@"timeEnd1"];
            newCourse.timeBegin2 = [dict valueForKey:@"timeBegin2"];
            newCourse.timeEnd2 = [dict valueForKey:@"timeEnd2"];
            newCourse.timeBegin3 = [dict valueForKey:@"timeBegin3"];
            newCourse.timeEnd3 = [dict valueForKey:@"timeEnd3"];
            
            //add it to the mutableArray
            [self.coursesEnrolled addObject:newCourse];
            //set most recent
            self.lastAdded = newCourse;
        }
    }
}


@end
