//
//  AddCourseViewController.h
//  Group_Project
//
//  Created by White, Jordan on 7/23/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@protocol AddCourseVCDelegate <NSObject>

- (void)sendBack:(Course *)aCourse;

@end

@interface AddCourseViewController : UIViewController

@property (nonatomic, weak) id<AddCourseVCDelegate> delegate;

@end
