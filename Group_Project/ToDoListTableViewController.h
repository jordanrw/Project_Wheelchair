//
//  ToDoListTableViewController.h
//  to_do
//
//  Created by White, Jordan on 6/14/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "EditTableViewCell.h"


@interface ToDoListTableViewController : UITableViewController <UITextFieldDelegate, UITableViewDelegate, EditTableViewCellDelegate>

@property (nonatomic, strong) PFObject *currentGroup;
//@property (nonatomic, strong) NSMutableArray *todoList;
@property (nonatomic, strong) NSArray *todoArray;

@property (nonatomic, strong) NSIndexPath *indexOfCurrentCell;

@end