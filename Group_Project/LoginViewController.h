//
//  ViewController.h
//  login2
//
//  Created by White, Jordan on 6/25/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SettingsTableViewController.h"

@protocol RefreshArrayDelegate <NSObject>

- (void)refresh;

@end

@interface LoginViewController : PFLogInViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (nonatomic, weak) id<RefreshArrayDelegate> refreshDelegate;

- (instancetype)init;


@end

