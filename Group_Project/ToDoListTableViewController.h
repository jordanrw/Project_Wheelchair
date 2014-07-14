//
//  ToDoListTableViewController.h
//  to_do
//
//  Created by White, Jordan on 6/14/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTableViewCell.h"

@interface ToDoListTableViewController : UITableViewController <UITextFieldDelegate, UITableViewDelegate, EditTableViewCellDelegate>

@property (nonatomic, strong) NSIndexPath *indexOfCurrentCell;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end