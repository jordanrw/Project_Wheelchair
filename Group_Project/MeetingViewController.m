//
//  SecondViewController.m
//  Group_Project
//
//  Created by White, Jordan on 6/25/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "MeetingViewController.h"
#import <Parse/Parse.h>

@interface MeetingViewController ()
            

@end

@implementation MeetingViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)questionMark:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Onboarding" message:@"A transulcent explanation of what this feature is, comes up" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
    [alert show];
    
    //UIViewController *vc = [[UIViewController alloc]init];
    //[self presentViewController:vc animated:YES completion:nil];
}


- (IBAction)currentUser:(id)sender {
    NSLog(@"%@", [PFUser currentUser]);
}

- (IBAction)currentGroup:(id)sender {
    NSLog(@"%@", [[PFUser currentUser]objectForKey:@"current"]);
}


@end
