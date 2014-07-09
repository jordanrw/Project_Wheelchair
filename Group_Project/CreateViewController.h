//
//  CreateViewController.h
//  Group_Project
//
//  Created by White, Jordan on 6/30/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsTableViewController.h"

@protocol CreateGroupDelegate <NSObject>

- (void)createGroupCancelled;
- (void)createGroupFinished;

@end

@interface CreateViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<CreateGroupDelegate> creationDelegate;

@end
