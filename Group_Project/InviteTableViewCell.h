//
//  InviteTableViewCell.h
//  Group_Project
//
//  Created by White, Jordan on 7/9/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateViewController.h"

@interface InviteTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UIButton *addButton;

- (void)setDidTapButtonBlock:(void (^)(id sender))didTapButtonBlock;

@end
