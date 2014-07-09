//
//  ViewController.m
//  login2
//
//  Created by White, Jordan on 6/25/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()


@end

@implementation LoginViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsPasswordForgotten | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsDismissButton; // | PFLogInFieldsFacebook;
    
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![PFUser currentUser]) {
        //Appearance
        //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@""]];
        self.logInView.logo = nil;
        //self.logInView.logInButton  change the button style
        //self.logInView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        //self.logInView.usernameField.backgroundColor = [UIColor colorWithWhite:.4 alpha:0.2];
        //self.logInView.usernameField.textColor = [UIColor blackColor];
        
        [self setDelegate:self];
        PFSignUpViewController *signupVC = [[PFSignUpViewController alloc]init];
        signupVC.signUpView.logo = nil;
        [signupVC setDelegate:self];
        [self setSignUpController:signupVC];
        
        NSLog(@"This is the current user: %@", [PFUser currentUser]);
        
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewDidLoad {

    [super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PFLoginViewControllerDelegateMethods

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Logged in --- now dismiss the view");
    [self.refreshDelegate refresh];
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissModalViewControllerAnimated:YES];
}

/// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissModalViewControllerAnimated:YES];
}

/// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissModalViewControllerAnimated:YES];
}


@end
