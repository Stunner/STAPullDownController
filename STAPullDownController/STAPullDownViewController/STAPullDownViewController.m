//
//  STAPullDownViewController.m
//  STAPullDownController
//
//  Created by Aaron Jubbal on 3/27/17.
//  Copyright © 2017 STA. All rights reserved.
//

#import "STAPullDownViewController.h"
#import "UIView+STAUtils.h"
#import "UIView+Orientation.h"

//TODO: make this configurable
#define kAutoSlideCompletionThreshold 30

@interface STAPullDownViewController ()

//@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
//@property (nonatomic, strong) UILongPressGestureRecognizer *holdGestureRecognizer;
//@property (nonatomic, strong) UIPanGestureRecognizer *pullUpViewPanGestureRecognizer;
//@property (nonatomic ,strong) UILongPressGestureRecognizer *pullUpViewHoldGestureRecognizer;
@property (nonatomic, assign) BOOL moveGestureBegan;
@property (nonatomic, weak) UIToolbar *toolbar;

@end

@implementation STAPullDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.toolbarHeight = 20;
    
    self.pullDownViewOffsetOverlap = 65;
    self.pullUpViewOffsetOverlap = 45;
    
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
    
    self.moveGestureBegan = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.pullDownView) {
        self.pullDownView.isPullDownView = YES;
        [self setUpPullDownView];
    }
    if (self.pullUpView) {
        self.pullUpView.isPullDownView = NO;
        [self setUpPullUpView];
    }
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
    
//    self.holdGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
//                                                                               action:@selector(viewHeld:)];
//    self.holdGestureRecognizer.delegate = self;
//    self.holdGestureRecognizer.minimumPressDuration = 0.0;
//    [self.pullDownView addGestureRecognizer:self.holdGestureRecognizer];
//    
//    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveView:)];
//    self.panGestureRecognizer.delegate = self;
//    [self.pullDownView addGestureRecognizer:self.panGestureRecognizer];
    
    [self.view addSubview:self.pullDownView];
}

- (void)setUpPullUpView {
    
    [self.pullUpView setupWithController:self];
    
//    self.pullUpViewHoldGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
//                                                                                                        action:@selector(viewHeld:)];
//    self.pullUpViewHoldGestureRecognizer.delegate = self;
//    self.pullUpViewHoldGestureRecognizer.minimumPressDuration = 0.0;
//    [self.pullUpView addGestureRecognizer:self.pullUpViewHoldGestureRecognizer];
//    
//    self.pullUpViewPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveView:)];
//    self.pullUpViewPanGestureRecognizer.delegate = self;
//    [self.pullUpView addGestureRecognizer:self.pullUpViewPanGestureRecognizer];
    
    [self.view addSubview:self.pullUpView];
}

#pragma mark - Pulldown Calculator Methods

- (void)viewReachedTop:(STAPullableView *)view {
    
    [view reachedTop];
    if (view.isPullDownView) {
        [view addGestureRecognizer:view.holdGestureRecognizer];
    } else {
        [view removeGestureRecognizer:view.holdGestureRecognizer];
    }
}

- (void)viewReachedBottom:(STAPullableView *)view {
    
    [view reachedBottom];
    if (view.isPullDownView) {
        [view removeGestureRecognizer:view.holdGestureRecognizer];
    } else {
        [view addGestureRecognizer:view.holdGestureRecognizer];
    }
}

- (void)moveView:(UIPanGestureRecognizer *)recognizer {
//    LogTrace(@"%s", __PRETTY_FUNCTION__);
    
    STAPullableView *view;
    if ([recognizer.view isKindOfClass:[STAPullableView class]]) {
        view = (STAPullableView *)recognizer.view;
    } else {
        NSLog(@"NOT STAPULLABLEVIEW!!!");
        return;
    }
    
    CGPoint translation = [recognizer translationInView:self.view];
    CGFloat newCenterY = view.center.y + translation.y;
    
//    NSLog(@"recognizer center: %f self view center: %f", recognizer.view.center.y, self.view.center.y - (48/2));
//    CGFloat adBannerHeight = [(AppDelegate *)[[UIApplication sharedApplication] delegate] bannerViewHeight];
    if (view.isPullDownView) {
        if (view.center.y >= self.view.center.y /*- adBannerHeight */- self.toolbarHeight && translation.y > 0) {
            [UIView animateWithDuration:0.2 animations:^{
                [view setFrameY:0 -/* adBannerHeight -*/ self.toolbarHeight];
            }];
            return;
        }
    } else {
        if (view.frame.origin.y <= self.view.center.y && translation.y < 0) {
            [UIView animateWithDuration:0.2 animations:^{
                [view setFrameY:0];
            }];
            return;
        }
    }
    view.center = CGPointMake(view.center.x,
                              newCenterY);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    [view viewDragged:view.frame.origin.y];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.moveGestureBegan = YES;
//        [self.mainViewController beganMovingPulldownCalculatorView];
//        self.feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
//        [self.feedbackGenerator prepare];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
    } else {
        if (recognizer.state == UIGestureRecognizerStateCancelled
            || recognizer.state == UIGestureRecognizerStateFailed
            || recognizer.state == UIGestureRecognizerStateEnded)
        {
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
                            [self viewReachedBottom:view];
                        } else { // bottom
                            [view animateViewMoveUp];
                            [self viewReachedTop:view];
                        }
                    } else { // revert to same values here!
                        if (view.originatingAtTop) {
                            [view animateViewMoveUp];
//                            [view addGestureRecognizer:view.holdGestureRecognizer];
                        } else { // bottom
                            [view animateViewMoveDown];
//                            [view removeGestureRecognizer:view.holdGestureRecognizer];
                        }
                    }
                    view.isMoving = NO;
//                    self.feedbackGenerator = nil;
                }
            }];
            [self performSelector:@selector(setMoveGestureBegan:) withObject:@NO afterDelay:0.01];
//            [self performSelector:@selector(impactOccurred) withObject:nil afterDelay:0.18];
        }
    } // else
}

//- (void)impactOccurred {
//    [self.feedbackGenerator impactOccurred];
//}

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
        
        [view viewDragged:recognizer.view.frame.origin.y];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewHeld:(UILongPressGestureRecognizer *)recognizer  {
//    LogTrace(@"%s", __PRETTY_FUNCTION__);
    
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
                    
                    [view viewDragged:recognizer.view.frame.origin.y];
                } completion:^(BOOL finished) {
                    
                }];
            }
        } else {
            if (!view.originatingAtTop) {
                [UIView animateWithDuration:0.43 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                    CGRect newFrame = view.frame;
                    newFrame.origin.y -= 20;
                    view.frame = newFrame;
                    
                    [view viewDragged:recognizer.view.frame.origin.y];
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
            // Long press ended
            
            if (!self.moveGestureBegan) {
                if (view.originatingAtTop) {
                    [self viewHeldGestureEnded:recognizer];
                }
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
//    LogTrace(@"%s", __PRETTY_FUNCTION__);
    
    if (![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] &&
        ![otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        return YES;
    }
    
    return NO;
}

@end
