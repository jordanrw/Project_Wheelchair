//
//  DisplayTableViewCell.m
//  Group_Project
//
//  Created by White, Jordan on 7/17/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "DisplayTableViewCell.h"

@interface DisplayTableViewCell ()

@property (nonatomic, strong) NSString *textHolder;

@end


@implementation DisplayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)startEditingCell {
    
    //pull the current text
    _textHolder = self.customLabel.text;
    NSLog(@"textHolder: %@", _textHolder);
    self.customLabel.text = nil;
    self.customField.hidden = NO;
    self.customField.text = _textHolder;
    [self.customField becomeFirstResponder];
}

- (void)endEditingCell {
    _textHolder = self.customField.text;
    self.customField.hidden = YES;
    
    self.customLabel.text = _textHolder;
}

@end
