//
//  EditTableViewCell.h
//  to_do
//
//  Created by White, Jordan on 6/16/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol EditTableViewCellDelegate <NSObject>

//#Receiving error
//- (void)editTableViewCellDidFinishEditing:(EditTableViewCell *)cell;

@end



@interface EditTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *cellTextHolder;
@property (strong, nonatomic) IBOutlet UITextField *editField;
@property (nonatomic, assign) BOOL isATapToAdd;

@property (strong, nonatomic) IBOutlet UILabel *customLabel;



- (void)setUpCell:(EditTableViewCell *)cell withToDo:(PFObject *)todo;
- (void)startEditingWithDelegate:(id<EditTableViewCellDelegate>)delegate;
- (void)endEditingForTodo:(PFObject *)todo At:(NSIndexPath *)index;

@end
