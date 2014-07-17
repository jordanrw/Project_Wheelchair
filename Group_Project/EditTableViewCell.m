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


- (void)setUpCell:(EditTableViewCell *)cell withToDo:(PFObject *)todo {
    NSLog(@"%@", todo);
    cell.customLabel.text = [todo objectForKey:@"text"];
    
    if ([cell.customLabel.text isEqual:@"tap to add"]) {
        //cell.textLabel.textColor = [UIColor brownColor];
        cell.customLabel.font = [[UIFont italicSystemFontOfSize:13]init];
    }
}

- (void)startEditingWithDelegate:(id<EditTableViewCellDelegate>)delegate {
    
    //textField initialization
    //self.editField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height)];
    //self.editField.font = [UIFont systemFontOfSize:18];
    //self.editField.returnKeyType = UIReturnKeyDone;
    
    self.contentView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.editField];
    
    
    //Pull the text out of the label
    self.cellTextHolder = self.customLabel.text;
    self.customLabel.text = nil;
    [self.customLabel removeFromSuperview];
    
    
    [self.editField becomeFirstResponder];
}

- (void)endEditingForTodo:(PFObject *)todo At:(NSIndexPath *)index {
    NSLog(@"End editing");
    
    //pull data from editField
    self.cellTextHolder = self.editField.text;
    self.editField.text = nil;
    [self.editField removeFromSuperview];
    
    //put data in the label
    [self.contentView addSubview:self.customLabel];
    self.customLabel.text = self.cellTextHolder;
    self.contentView.backgroundColor = [UIColor yellowColor];
    

    [todo setObject:self.cellTextHolder forKey:@"text"];
}



- (void)awakeFromNib {
    // Initialization code
}
/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}*/

@end
