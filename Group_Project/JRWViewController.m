//
//  JRWViewController.m
//  Json Practice
//
//  Created by White, Jordan on 6/3/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "JRWViewController.h"
#import "JRWFeedFetcher.h"
#import "JRWCourse.h"

@interface JRWViewController ()

@property (weak, nonatomic) IBOutlet UITextField *CRN1;
@property (weak, nonatomic) IBOutlet UILabel *times;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

//@property NSString *savedCRN1;

@property (nonatomic) NSDictionary *courses;
@property (nonatomic) JRWFeedFetcher *fetcher;

@end


@implementation JRWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewLoaded");
    
    //[_spinner startAnimating];
    //self.fetcher = [[JRWFeedFetcher alloc] init];
    //[self.fetcher fetchFeedWith:@"http://brycelanglotz.com/Classifi/VirginiaTech.json"];
}

- (IBAction)dismissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addCourse:(id)sender {
    [self.fetcher iterateThrough:self.fetcher.jsonArray atCRN:self.CRN1.text];
    NSLog(@"%@", self.fetcher.coursesEnrolled);
    
    if ([self.fetcher.coursesEnrolled count] > 0) {
        [self updateLabel:self.times];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Not a Class" message:@"Please enter another CRN" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)updateLabel:(UILabel *)label {
    NSString *CRN = [[self.fetcher.coursesEnrolled objectAtIndex:0]CRN];
    NSString *course = [[self.fetcher.coursesEnrolled objectAtIndex:0] course];
    NSString *number = [[self.fetcher.coursesEnrolled objectAtIndex:0] num];
    NSString *day1 = [[self.fetcher.coursesEnrolled objectAtIndex:0] day1];
    NSString *timeBegin1 = [[self.fetcher.coursesEnrolled objectAtIndex:0] timeBegin1];
    NSString *timeEnd1 = [[self.fetcher.coursesEnrolled objectAtIndex:0] timeEnd1];
    label.text = [NSString stringWithFormat:@"%@ \n %@ %@ \n %@ %@ - %@", CRN, course, number, day1, timeBegin1, timeEnd1];
}




/*Resign the keyboard with this line of code*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
