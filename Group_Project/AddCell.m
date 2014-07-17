//
//  AddCell.m
//  Group_Project
//
//  Created by White, Jordan on 7/14/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "AddCell.h"

@implementation AddCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)add:(id)sender {
    NSLog(@"add button cell pressed");
}


@end
