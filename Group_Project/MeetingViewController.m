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


- (IBAction)newTodo:(id)sender {
    PFObject *currentGroup = [[PFUser currentUser]objectForKey:@"current"];
    
    //new todo
    PFObject *new = [PFObject objectWithClassName:@"Todo"];
    [new setObject:@"Go to walmart" forKey:@"text"];
    [new setObject:@NO forKey:@"complete"];
    [new setObject:currentGroup forKey:@"group"];
    [new save];
    
    [currentGroup addObject:new forKey:@"todos"];
    
    
}



- (IBAction)currentUser:(id)sender {
    NSLog(@"%@", [PFUser currentUser]);
    
    PFObject *currentGroup = [[PFUser currentUser]objectForKey:@"current"];
    NSLog(@"currentGroup: %@", currentGroup);
    
    
    NSLog(@"Then save a todo");
    PFObject *one = [PFObject objectWithClassName:@"Todo"];
    [one setObject:@"Walmart" forKey:@"text"];
    [one setObject:currentGroup forKey:@"group"];
    [one save];
    
    PFObject *two = [PFObject objectWithClassName:@"Todo"];
    [two setObject:@"Submit an app" forKey:@"text"];
    [two save];
    
//    PFObject *three = [PFObject objectWithClassName:@"Todo"];
//    [three setValue:@"call mom back" forKey:@"text"];
//    [three save];
    
    NSArray *array = @[one, two];
    [currentGroup setObject:array forKey:@"todos"];
    [currentGroup saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"success?ish?");
    }];
 
    /*
    [currentGroup addObject:one forKey:@"todos"];
    [currentGroup addObject:two forKey:@"todos"];
//    [currentGroup addObject:three forKey:@"todos"];
  [currentGroup saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"saved yo");
        }
    }];
     */
}





- (IBAction)currentGroup:(id)sender {
    NSLog(@"%@", [[PFUser currentUser]objectForKey:@"current"]);
}


@end
