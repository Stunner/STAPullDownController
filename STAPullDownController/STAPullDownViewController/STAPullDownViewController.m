//
//  STAPullDownViewController.m
//  STAPullDownController
//
//  Created by Aaron Jubbal on 3/27/17.
//  Copyright © 2017 STA. All rights reserved.
//

#import "STAPullDownViewController.h"
#import "UIView+STAUtils.h"
#import "UIView+STAOrientation.h"

@interface STAPullDownViewController () {
    dispatch_once_t _once;
}

@property (nonatomic, assign) BOOL moveGestureBegan;

@end

@implementation STAPullDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.mainViewController) {
        [self addChildViewController:self.mainViewController];
        if ([self.mainViewController isKindOfClass:[UIViewController class]]) {
            ((UIViewController *)self.mainViewController).view.frame = self.view.bounds;
            [self.view addSubview:((UIViewController *)self.mainViewController).view];
        } else if ([self.mainViewController isKindOfClass:[UITableViewController class]]) {
            ((UITableViewController *)self.mainViewController).tableView.frame = self.view.bounds;
            [self.view addSubview:((UITableViewController *)self.mainViewController).tableView];
        }
        [self.mainViewController didMoveToParentViewController:self];
    }
    self.view.autoresizesSubviews = YES;
    self.moveGestureBegan = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // runs once per instance of controller
    dispatch_once(&_once, ^ {
        //--------------------------------------------------------------------------------
        // setup for both requires on each others toolbarHeight value, so set them up here
        if (self.pullDownView.toolbarHeight == 0) { // hasn't been set
            self.pullDownView.toolbarHeight = self.pullUpView.overlayOffset;
        }
        if (self.pullUpView.toolbarHeight == 0) { // hasn't been set
            self.pullUpView.toolbarHeight = self.pullDownView.overlayOffset;
        }
        //--------------------------------------------------------------------------------
        
        if (self.pullDownView) {
            self.pullDownView.isPullDownView = YES;
            [self setUpPullDownView];
        }
        if (self.pullUpView) {
            self.pullUpView.isPullDownView = NO;
            [self setUpPullUpView];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        [self.pullDownView setupFrame];
        [self.pullUpView setupFrame];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        [self.pullDownView setupFrame];
        [self.pullUpView setupFrame];
        
    }];
}

- (void)setUpPullDownView {
    
    [self.pullDownView setupWithController:self];
    
    [self.view addSubview:self.pullDownView];
}

- (void)setUpPullUpView {
    
    [self.pullUpView setupWithController:self];
    
    [self.view addSubview:self.pullUpView];
}

#pragma mark - Pulldown Calculator Methods

- (void)moveGestureBegan:(UIGestureRecognizer *)recognizer {
    self.moveGestureBegan = YES;
}

- (void)moveGestureChanged:(UIGestureRecognizer *)recognizer {
    STAPullableView *view = (STAPullableView *)recognizer.view;
    [view viewDraggedTo:view.frame.origin.y];
}

- (void)moveGestureEnded:(UIGestureRecognizer *)recognizer {
    STAPullableView *view = (STAPullableView *)recognizer.view;
    [UIView animateWithDuration:0.43 delay:0.0 usingSpringWithDamping:0.85 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        if ([view hasPassedAutoSlideThreshold]) {
            // opposites here!
            if (view.originatingAtTop) {
                [view animateViewMoveDown];
            } else { // bottom
                [view animateViewMoveUp];
            }
        } else { // revert to same values here!
            if (view.originatingAtTop) {
                [view animateViewMoveUp];
            } else { // bottom
                [view animateViewMoveDown];
            }
        }
        view.isMoving = YES;
    } completion:^(BOOL finished) {
        if (finished) {
            if (view.prevHasPassedAutoSlideThresholdValue) {
                // opposites here!
                if (view.originatingAtTop) {
                    [view animateViewMoveDown];
                    [view reachedBottom];
                } else { // bottom
                    [view animateViewMoveUp];
                    [view reachedTop];
                }
            } else { // revert to same values here!
                if (view.originatingAtTop) {
                    [view animateViewMoveUp];
                } else { // bottom
                    [view animateViewMoveDown];
                }
            }
            view.isMoving = NO;
        }
    }];
    [self performSelector:@selector(setMoveGestureBegan:) withObject:@NO afterDelay:0.01];
}

- (void)moveView:(UIPanGestureRecognizer *)recognizer {
    
    STAPullableView *view;
    if ([recognizer.view isKindOfClass:[STAPullableView class]]) {
        view = (STAPullableView *)recognizer.view;
    } else {
        NSLog(@"NOT STAPULLABLEVIEW!!!");
        return;
    }
    
    CGPoint translation = [recognizer translationInView:self.view];
    CGFloat newCenterY = view.center.y + translation.y;
    
    if (view.isPullDownView) {
        if (view.frame.origin.y >= view.restingBottomYPos && translation.y > 0) {
            [view reachedBottom];
            [UIView animateWithDuration:0.2 animations:^{
                [view setFrameY:view.restingBottomYPos];
            }];
            return;
        }
    } else {
        if (view.frame.origin.y <= view.restingTopYPos && translation.y < 0) {
            [view reachedTop];
            [UIView animateWithDuration:0.2 animations:^{
                [view setFrameY:view.restingTopYPos];
            }];
            return;
        }
    }
    view.center = CGPointMake(view.center.x, newCenterY);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self moveGestureBegan:recognizer];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self moveGestureChanged:recognizer];
    } else {
        if (recognizer.state == UIGestureRecognizerStateCancelled
            || recognizer.state == UIGestureRecognizerStateFailed
            || recognizer.state == UIGestureRecognizerStateEnded)
        {
            [self moveGestureEnded:recognizer];
        }
    }
}

- (void)viewHeldGestureEnded:(UILongPressGestureRecognizer *)recognizer {
    
    STAPullableView *view;
    if ([recognizer.view isKindOfClass:[STAPullableView class]]) {
        view = (STAPullableView *)recognizer.view;
    } else {
        NSLog(@"NOT STAPULLABLEVIEW!!!");
        return;
    }
    
    [UIView animateWithDuration:0.43 delay:0.0 usingSpringWithDamping:0.85 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect newFrame = view.frame;
        if (view.isPullDownView) {
            newFrame.origin.y -= 20;
        } else {
            newFrame.origin.y += 20;
        }
        view.frame = newFrame;
        
        [view viewDraggedTo:recognizer.view.frame.origin.y];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewHeld:(UILongPressGestureRecognizer *)recognizer  {
    
    STAPullableView *view;
    if ([recognizer.view isKindOfClass:[STAPullableView class]]) {
        view = (STAPullableView *)recognizer.view;
    } else {
        NSLog(@"NOT STAPULLABLEVIEW!!!");
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (view.isPullDownView) {
            if (view.originatingAtTop) {
                [UIView animateWithDuration:0.43 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                    CGRect newFrame = view.frame;
                    newFrame.origin.y += 20;
                    view.frame = newFrame;
                    
                    [view viewDraggedTo:recognizer.view.frame.origin.y];
                } completion:^(BOOL finished) {
                    
                }];
            }
        } else {
            if (!view.originatingAtTop) {
                [UIView animateWithDuration:0.43 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                    CGRect newFrame = view.frame;
                    newFrame.origin.y -= 20;
                    view.frame = newFrame;
                    
                    [view viewDraggedTo:recognizer.view.frame.origin.y];
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [view.layer removeAllAnimations];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (view.isPullDownView) {
            if (view.originatingAtTop && ![view hasPassedAutoSlideThreshold]) {
                [self viewHeldGestureEnded:recognizer];
            }
        } else {
            if (!view.originatingAtTop && ![view hasPassedAutoSlideThreshold]) {
                [self viewHeldGestureEnded:recognizer];
            }
        }
    } else {
        if (recognizer.state == UIGestureRecognizerStateCancelled
            || recognizer.state == UIGestureRecognizerStateFailed)
        {
            // Long press ended -- i.e. converted to a move gesture
            
            if (!self.moveGestureBegan) {
                if (view.originatingAtTop) {
                    [self viewHeldGestureEnded:recognizer];
                }
            }
        }
    }
} // viewHeld:

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    if (![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] &&
        ![otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        return YES;
    }
    
    return NO;
}

@end
