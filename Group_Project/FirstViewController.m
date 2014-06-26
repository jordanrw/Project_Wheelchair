//
//  FirstViewController.m
//  Group_Project
//
//  Created by White, Jordan on 6/25/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
            

@end

@implementation FirstViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*Set the color of the tabs based on the color for the Group
    //self.tabBarController.tabBar.tintColor = [UIColor greenColor]; // <-- hard coded
     
    something like the following
     [PFUser currentUser]valueAtKey:@"currentGroup"
     currentGroup valueAtKey:@"color";
     put that into a UIColor, figure this out later.
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)currentUser:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Current User" message:@"place the user info here" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
}

@end
