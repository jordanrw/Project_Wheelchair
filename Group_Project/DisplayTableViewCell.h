//
//  DisplayTableViewCell.h
//  Group_Project
//
//  Created by White, Jordan on 7/17/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *customLabel;
@property (strong, nonatomic) IBOutlet UITextField *customField;

@property (strong, nonatomic) IBOutlet UIImageView *checkImage;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;


- (void)startEditingCell;
- (void)endEditingCell;

@end
