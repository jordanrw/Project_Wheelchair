//
//  InviteTableViewCell.m
//  Group_Project
//
//  Created by White, Jordan on 7/9/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "InviteTableViewCell.h"

@interface InviteTableViewCell ()

@property (copy, nonatomic) void(^didTapButtonBlock)(id sender);

@end


@implementation InviteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self.addButton addTarget:self action:@selector(didTapButtonBlock:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapButtonBlock:(id)sender {
    if (self.didTapButtonBlock) {
        self.didTapButtonBlock(sender);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
