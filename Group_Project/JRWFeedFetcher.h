//
//  JRWFeedFetcher.h
//  Json Practice
//
//  Created by White, Jordan on 6/4/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRWFeedFetcher : NSObject

//all the JSON is stored in here
@property (nonatomic) NSArray *jsonArray;
//courses they're in right now
@property (nonatomic) NSMutableArray *coursesEnrolled;


//@property (nonatomic) NSMutableArray *arrayOfCourses;
//@property (nonatomic) NSDictionary *dictOfCourses;

//- (void)fetchFeedWith:(NSString *)URL andActivity:(UIActivityIndicatorView *)spin;
- (void)fetchFeedWith:(NSString *)URL;
- (void)printTheArray;
- (void)iterateThrough:(NSArray *)someArray atCRN:(NSString *)someCRN;
- (void)json;

@end
