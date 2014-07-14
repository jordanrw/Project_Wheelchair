//
//  JoinViewController.h
//  Group_Project
//
//  Created by White, Jordan on 6/30/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JoinGroupDelegate <NSObject>

- (void)joinedGroup;

@end


@interface JoinViewController : UIViewController

@property (nonatomic, weak) id<JoinGroupDelegate> joinDelegate;

@end
