//
//  JRWCourse.m
//  Json Practice
//
//  Created by White, Jordan on 6/4/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "JRWCourse.h"

@implementation JRWCourse

- (instancetype)initWithCRN:(NSString *)aCRN {
    self = [super init];
    
    if (self) {
        _CRN = aCRN;
    }
    
    return self;
}


@end
