//
//  ToDoList.m
//  to_do
//
//  Created by White, Jordan on 6/19/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "ToDoList.h"
#import "ToDoItem.h"

@interface ToDoList ()

@property (nonatomic) NSMutableArray *privateToDos;

@end


@implementation ToDoList

+(instancetype)defaultToDoList {
    static ToDoList *defaultToDoList = nil;
    
    if (!defaultToDoList) {
        defaultToDoList = [[ToDoList alloc]init];
    }
    return defaultToDoList;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _privateToDos = [[NSMutableArray alloc] init];
    }
    return self;
}

//when asked for todo's it returns the privateToDos as an NSArray
- (NSArray *)publicToDos {
    return self.privateToDos;
}

- (ToDoItem *)createBlank {
    //new item
    ToDoItem *item = [[ToDoItem alloc]initWithName:@"tap to add"];
    [self.privateToDos addObject:item];
    
    return item;
}

/*
- (void)updateToDoAt:(NSIndexPath *)index withName:(NSString *)name {
    NSLog(@"updateToDoAt");
    //updates the itemName & sets a date
    //[[_privateToDos objectAtIndex:index.row] changeName:name andDate:[NSDate date]];
    
    //if name is @"" then
    if ([name isEqualToString:@""]) {
        [[_privateToDos objectAtIndex:index.row] changeName:@"tap to add" andDate:[NSDate date]];
    }
    if ([name isEqualToString:@""] && (index.row != [_privateToDos count] -1)) {
        ToDoItem *todo = [[[ToDoList defaultToDoList]publicToDos]objectAtIndex:index.row];
        [[ToDoList defaultToDoList]removeToDo:todo];
    }
    
    //if it is the last item in the array, add another
    if (([_privateToDos count] - 1) == index.row && (![name isEqualToString:@""])) {
        [self createBlank];
    }
}*/

- (void)removeToDo:(ToDoItem *)item {
    [self.privateToDos removeObjectIdenticalTo:item];
}

- (void)moveToDoAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex) {
        return;
    }
    //get pointer to object being moved
    ToDoItem *item = [self.privateToDos objectAtIndex:fromIndex];
    
    //remove item & add item
    [self.privateToDos removeObjectAtIndex:fromIndex];
    [self.privateToDos insertObject:item atIndex:toIndex];
}



@end
