//
//  MyCoursesTableViewController.h
//  Group_Project
//
//  Created by White, Jordan on 7/30/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AddCourseViewController.h"

@interface MyCoursesTableViewController : UITableViewController <AddCourseVCDelegate>

@property (nonatomic, strong) NSMutableArray *myCourses;
@property (nonatomic, strong) PFObject *toUpload;

@end
