//
//  EditTableViewCell.h
//  to_do
//
//  Created by White, Jordan on 6/16/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItem.h"

@protocol EditTableViewCellDelegate <NSObject>

//#Receiving error
- (void)editTableViewCellDidFinishEditing:(EditTableViewCell *)cell;

@end



@interface EditTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *cellTextHolder;
@property (nonatomic, strong) UITextField *editField;
@property (nonatomic, assign) BOOL isATapToAdd;

//so you can update and add this to the array eventually
@property (nonatomic, strong) ToDoItem *toDoItem;


- (void)setUpCell:(EditTableViewCell *)cell withToDo:(ToDoItem *)todo;
- (void)startEditingWithDelegate:(id<EditTableViewCellDelegate>)delegate;
- (void)endEditingForCellAt:(NSIndexPath *)index;

@end
