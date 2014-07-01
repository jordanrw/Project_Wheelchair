//
//  AddGroupViewController.m
//  Group_Project
//
//  Created by White, Jordan on 6/30/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "AddGroupViewController.h"
#import "CreateViewController.h"
#import "JoinViewController.h"

@interface AddGroupViewController ()

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSArray *vcs;

@end

@implementation AddGroupViewController

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
    //self.delegate = self;
    self.dataSource = self;
    
    CreateViewController *createVC = [self.storyboard instantiateViewControllerWithIdentifier:@"create"];
    CreateViewController *joinVC = [self.storyboard instantiateViewControllerWithIdentifier:@"join"];
    
    self.vcs = @[joinVC, createVC];
    self.index = 0;
    [self setViewControllers:@[joinVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    return self.vcs[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if (self.index == 0) {
        return nil;
    }
    self.index--;
    return [self viewControllerAtIndex:self.index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if (self.index > [self.vcs count]) {
        return nil;
    }
    return [self viewControllerAtIndex:self.index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [self.vcs count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
