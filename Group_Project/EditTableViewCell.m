//
//  EditTableViewCell.m
//  to_do
//
//  Created by White, Jordan on 6/16/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "EditTableViewCell.h"
//#import "ToDoList.h"
//#import "ToDoItem.h"

@implementation EditTableViewCell


- (void)setUpCell:(EditTableViewCell *)cell withToDo:(ToDoItem *)todo {
    cell.textLabel.text = todo.itemName;
    
    if ([cell.textLabel.text isEqual:@"tap to add"]) {
        //cell.textLabel.textColor = [UIColor brownColor];
        cell.textLabel.font = [[UIFont italicSystemFontOfSize:13]init];
    }
}

- (void)startEditingWithDelegate:(id<EditTableViewCellDelegate>)delegate {
    
    //textField initialization
    self.editField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0,
                                                                          self.contentView.bounds.size.width,
                                                                          self.contentView.bounds.size.height)];
    self.editField.font = [UIFont systemFontOfSize:18];
    self.editField.returnKeyType = UIReturnKeyDone;
    //self.contentView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.editField];
    
    
    //Pull the text out of the label
    self.cellTextHolder = self.textLabel.text;
    self.textLabel.text = nil;
    [self.textLabel removeFromSuperview];
    
//#Iffy
    if (![self.cellTextHolder isEqual:@"tap to add"]) {
        self.editField.text = self.cellTextHolder;
    }
    
    [self.editField becomeFirstResponder];
}

- (void)endEditingForCellAt:(NSIndexPath *)index {
    NSLog(@"End editing");
    
    //pull data from editField
    self.cellTextHolder = self.editField.text;
    self.editField.text = nil;
    [self.editField removeFromSuperview];
    //put data in the label
    //[self.contentView addSubview:self.textLabel];
    self.textLabel.text = self.cellTextHolder;
    self.textLabel.font = [UIFont systemFontOfSize:18];
    //self.contentView.backgroundColor = [UIColor yellowColor];
    
    UIImage *box = [[UIImage alloc] initWithContentsOfFile:@"box.png"];
    UIButton *checkBox = [[UIButton alloc]initWithFrame:CGRectMake(4, 4, 36, 36)];
    [checkBox setImage:box forState:UIControlStateNormal];
    [self.contentView addSubview:checkBox];
    
    
    [[ToDoList defaultToDoList]updateToDoAt:index withName:self.cellTextHolder];
}

/*
- (void)addCheckBoxToCell:(EditTableViewCell*)cell WithIndexPath:(NSIndexPath *)index inTableView:(UITableView *)tableView {
    UIButton *checkBoxButton = [[UIButton alloc]initWithFrame:CGRectMake(4, 4, 36, 36)];
    
    [checkBoxButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    [checkBoxButton setImage:[UIImage imageNamed:@"checkbox-pressed.png"] forState:UIControlStateHighlighted];
    [checkBoxButton setImage:[UIImage imageNamed:@"checkbox-checked.png"] forState:UIControlStateSelected];
    
    checkBoxButton.tag = index.row;
    
    //                          self                    idk                                       good
    [checkBoxButton addTarget:tableView action:@selector(checkBoxButton) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:checkBoxButton];
}*/



- (void)awakeFromNib
{
    // Initialization code
}

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}*/

@end
