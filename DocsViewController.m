//
//  DocsViewController.m
//  Group_Project
//
//  Created by White, Jordan on 6/26/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "DocsViewController.h"

@interface DocsViewController ()

@end

@implementation DocsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Feature coming soon..." message:@"\n The ability to view group documents is coming in a future update." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
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
