//
//  ToDoItem.m
//  to_do
//
//  Created by White, Jordan on 6/15/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "ToDoItem.h"

@implementation ToDoItem

- (instancetype)initWithName:(NSString *)name andDate:(NSDate *)date {
    self = [super init];
    
    if (self) {
        self.itemName = name;
        self.creationDate = date;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.itemName = name;
    }
    return self;
}

- (void)changeName:(NSString *)name andDate:(NSDate *)date {
    self.itemName = name;
    self.creationDate = date;
}

@end
