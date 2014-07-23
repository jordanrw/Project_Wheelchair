//
//  FeedFetcher.h
//  Group_Project
//
//  Created by White, Jordan on 7/23/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Course.h"


@interface FeedFetcher : NSObject

//courses they're in right now
@property (nonatomic) NSMutableArray *coursesEnrolled;
@property (nonatomic, weak) Course *lastAdded;

- (void)fetchFeedWith:(NSString *)URL andActivity:(UIActivityIndicatorView *)spin andLabel:(UILabel *)label;
- (void)iterateThrough:(NSArray *)someArray atCRN:(NSString *)someCRN;


@end
