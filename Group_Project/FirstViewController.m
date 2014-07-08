//
//  FirstViewController.m
//  Group_Project
//
//  Created by White, Jordan on 6/25/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "FirstViewController.h"
#import <Parse/Parse.h>

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
    NSLog(@"%@", [PFUser currentUser]);
}

- (IBAction)currentGroup:(id)sender {
    NSLog(@"%@", [[PFUser currentUser]objectForKey:@"current"]);
}

@end
