//
//  AddCourseViewController.m
//  Group_Project
//
//  Created by White, Jordan on 7/23/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "AddCourseViewController.h"
#import "FeedFetcher.h"
#import <Parse/Parse.h>

@interface AddCourseViewController ()

@property (weak, nonatomic) IBOutlet UITextField *CRN;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UILabel *pleasewait;
@property (strong, nonatomic) IBOutlet UILabel *courseLabel;



//@property NSString *savedCRN1;

@property (nonatomic) NSDictionary *courses;
@property (nonatomic) FeedFetcher *fetcher;

@end


@implementation AddCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _spinner.hidden = YES;
    _pleasewait.hidden = YES;
    
    self.fetcher = [[FeedFetcher alloc] init];
    //[self.CRN becomeFirstResponder];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *courses = [prefs arrayForKey:@"courses"];
    
    if (courses) {
        NSLog(@"the courses are saved locally");
    }
    if (!courses) {
        NSLog(@"the courses aren't saved locally");
        _spinner.hidden = NO;
        _pleasewait.hidden = NO;
        [_spinner startAnimating];
        [self.fetcher fetchFeedWith:@"http://brycelanglotz.com/Classifi/VirginiaTech.json" andActivity:_spinner andLabel:_pleasewait];
    }
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)send:(id)sender {
    //called when we press 'Add'
    
    
    //pulls the user defaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *courses = [prefs arrayForKey:@"courses"];
    
    [self.fetcher iterateThrough:courses atCRN:self.CRN.text];
    
    if ([self.fetcher.coursesEnrolled count] > 0) {
        Course *course = [self.fetcher.coursesEnrolled objectAtIndex:0];
        NSLog(@"%@ from %@ - %@", course.day1, course.timeBegin1, course.timeEnd1);
        
        
        //self.fetcher.lastAdded
        [self.delegate sendBack:self.fetcher.lastAdded];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Not a Class" message:@"Please enter another CRN" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        [self.CRN resignFirstResponder];
    }
}

- (IBAction)verify:(id)sender {
    //pulls the user defaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *courses = [prefs arrayForKey:@"courses"];
    
    [self.fetcher iterateThrough:courses atCRN:self.CRN.text];
    
    if ([self.fetcher.coursesEnrolled count] > 0) {
        Course *course = [self.fetcher.coursesEnrolled objectAtIndex:0];
        _courseLabel.text = [NSString stringWithFormat:@"%@ %@ \n %@ %@ - %@ \n %@", course.course, course.num, course.day1, course.timeBegin1, course.timeEnd1, course.location1];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Not a Class" message:@"Please enter another CRN" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        [self.CRN resignFirstResponder];
    }

}


/*Resign the keyboard with this line of code*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
