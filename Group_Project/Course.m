//
//  Course.m
//  Group_Project
//
//  Created by White, Jordan on 7/23/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "Course.h"

@implementation Course

- (instancetype)initWithCRN:(NSString *)aCRN {
    self = [super init];
    
    if (self) {
        _CRN = aCRN;
    }
    
    return self;
}

@end
