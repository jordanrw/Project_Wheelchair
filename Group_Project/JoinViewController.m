//
//  JoinViewController.m
//  Group_Project
//
//  Created by White, Jordan on 6/30/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "JoinViewController.h"
#import <Parse/Parse.h>

@interface JoinViewController ()
@property (weak, nonatomic) IBOutlet UITextField *groupNameField;
@property (weak, nonatomic) IBOutlet UITextField *groupPasswordField;

@end

@implementation JoinViewController

#pragma mark - Initial View
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView *txt in self.view.subviews) {
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

#pragma mark - Join a Group
- (IBAction)joinGroup:(id)sender {
    
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Groups"];
    [groupQuery whereKey:@"groupName" equalTo:self.groupNameField.text];
    [groupQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//////Group Doesn't Exist//////
        if (!object) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Group" message:@"there aren't any groups by that name" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
            [alert show];
        }
/////Group Exists////////
        if (object) {
            PFObject *theGroup = object;
        ////Password is Wrong//////
            if (![[theGroup valueForKey:@"password"] isEqualToString:self.groupPasswordField.text]) {
                NSLog(@"wrong password");
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Wrong Password" message:@"please try again" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
                [alert show];
            }
        //////Password is Right/////
            if ([[theGroup valueForKey:@"password"] isEqualToString:self.groupPasswordField.text]) {
                
                //adds the relationship
                PFUser *currentUser = [PFUser currentUser];

                PFRelation *relationUG = [currentUser relationForKey:@"myGroups"];
                [relationUG addObject:theGroup];
                [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    NSLog(@"group is under user");
                }];
                
                PFRelation *relationGU = [theGroup relationForKey:@"users"];
                [relationGU addObject:currentUser];
                [theGroup saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    NSLog(@"user is under group");
                }];

                
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Add to Group" message:@"you've been added to the group" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
                [alert show];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.joinDelegate joinedGroup];
                
            }
        }
        if (error) {
            NSLog(@"error");
        }
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
