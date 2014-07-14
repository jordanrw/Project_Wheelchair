//
//  ToDoList.h
//  to_do
//
//  Created by White, Jordan on 6/19/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ToDoItem;




@interface ToDoList : NSObject

@property (nonatomic, readonly) NSArray *publicToDos;

+(instancetype)defaultToDoList;
-(ToDoItem *)createBlank;

- (void)updateToDoAt:(NSIndexPath *)index withName:(NSString *)name;
- (void)moveToDoAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (void)removeToDo:(ToDoItem *)item;


@end
