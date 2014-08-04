////
////  AnimatedTransitioning.m
////  CustomTransitionExample
////
////  Created by Blanche Faur on 10/24/13.
////  Copyright (c) 2013 Blanche Faur. All rights reserved.
////
//
//#import "AnimatedTransitioning.h"
//#import "DayViewController.h"
//#import "LoadingViewController.h"
//
//@implementation AnimatedTransitioning
//
////===================================================================
//// - UIViewControllerAnimatedTransitioning
////===================================================================
//
//- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
//    return 0.25f;
//}
//
//- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
//    
//    UIView *inView = [transitionContext containerView];
//    LoadingViewController *toVC = (LoadingViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    DayViewController *fromVC = (DayViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    
//    [inView addSubview:toVC.view];
//    
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    [toVC.view setFrame:CGRectMake(0, screenRect.size.height, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
//    
//    [UIView animateWithDuration:0.25f
//                     animations:^{
//                         
//                         [toVC.view setFrame:CGRectMake(0, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
//                     }
//                     completion:^(BOOL finished) {
//                         [transitionContext completeTransition:YES];
//                     }];
//}
//
//- (void)animationEnded:(BOOL)transitionCompleted {
//    
//    
//}
//

//@end
