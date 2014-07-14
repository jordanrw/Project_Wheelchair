//
//  ToDoItem.h
//  to_do
//
//  Created by White, Jordan on 6/15/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property (nonatomic, strong) NSString  *itemName;
@property (nonatomic, strong) NSDate *creationDate;

@property BOOL completed;

- (instancetype)initWithName:(NSString *)name andDate:(NSDate *)date;
- (instancetype)initWithName:(NSString *)name;

- (void)changeName:(NSString *)name andDate:(NSDate *)date;

@end
