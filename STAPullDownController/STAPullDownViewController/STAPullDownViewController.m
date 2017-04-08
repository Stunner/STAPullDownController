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

@interface STAPullDownViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat initialPullDownViewYPosition;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *holdGestureRecognizer;
@property (nonatomic, assign) BOOL moveGestureBegan;
@property (nonatomic, assign) BOOL pullDownViewOriginatingAtTop;
@property (nonatomic, assign) BOOL pullDownViewIsMoving;
@property (nonatomic, strong) UIToolbar *toolbar;

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
    
    [[NSBundle mainBundle] loadNibNamed:@"PullDownView"
                                  owner:self
                                options:nil];
    
    self.moveGestureBegan = NO;
    self.pullDownViewOriginatingAtTop = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setUpPullDownView];
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
        [self.pullDownView setupWithBounds:self.view.bounds];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        [self.pullDownView setupWithBounds:self.view.bounds];
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setUpPullDownView {
    
    [self.pullDownView setupWithBounds:self.view.bounds];
    
    self.holdGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(calculatorViewHeld:)];
    self.holdGestureRecognizer.delegate = self;
    self.holdGestureRecognizer.minimumPressDuration = 0.0;
    [self.pullDownView addGestureRecognizer:self.holdGestureRecognizer];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCalculatorView:)];
    self.panGestureRecognizer.delegate = self;
    [self.pullDownView addGestureRecognizer:self.panGestureRecognizer];
    
    [self.view addSubview:self.pullDownView];
}

#pragma mark - Pulldown Calculator Methods

// TODO: make observable
- (BOOL)hasPassedAutoSlideThreshold {
    if (self.pullDownViewOriginatingAtTop) {
        CGFloat yDelta = self.pullDownView.frame.origin.y - self.pullDownView.initialYPosition;
        return yDelta >= kAutoSlideCompletionThreshold;
    } else {
//        CGFloat adBannerHeight = [(AppDelegate *)[[UIApplication sharedApplication] delegate] bannerViewHeight];
        CGFloat yDelta = 0 - self.pullDownView.frame.origin.y/* - adBannerHeight*/;
        return yDelta >= kAutoSlideCompletionThreshold;
    }
}

// TODO: make observable
- (void)calculatorViewReachedTop {
//    LogTrace(@"%s", __PRETTY_FUNCTION__);
    
    self.pullDownViewOriginatingAtTop = YES;
    [self.pullDownView addGestureRecognizer:self.holdGestureRecognizer];
}

// TODO: make observable
- (void)calculatorViewReachedBottom {
//    LogTrace(@"%s", __PRETTY_FUNCTION__);
    
    self.pullDownViewOriginatingAtTop = NO;
    [self.pullDownView removeGestureRecognizer:self.holdGestureRecognizer];
}

- (void)moveCalculatorView:(UIPanGestureRecognizer *)recognizer {
//    LogTrace(@"%s", __PRETTY_FUNCTION__);
    
    CGPoint translation = [recognizer translationInView:self.view];
    CGFloat newCenterY = recognizer.view.center.y + translation.y;
    
    NSLog(@"recognizer center: %f self view center: %f", recognizer.view.center.y, self.view.center.y - (48/2));
//    CGFloat adBannerHeight = [(AppDelegate *)[[UIApplication sharedApplication] delegate] bannerViewHeight];
    if (recognizer.view.center.y >= self.view.center.y /*- adBannerHeight */- self.toolbarHeight && translation.y > 0) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.pullDownView setFrameY:0 -/* adBannerHeight -*/ self.toolbarHeight];
        }];
        return;
    }
    recognizer.view.center = CGPointMake(recognizer.view.center.x,
                                         newCenterY);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    [self.pullDownView viewDragged:recognizer.view.frame.origin.y];
    
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
                if ([self hasPassedAutoSlideThreshold]) {
                    if (self.pullDownViewOriginatingAtTop) { // bottom
                        [self.pullDownView animateViewMoveDown];
                    } else { // top
                        [self.pullDownView animateViewMoveUp];
                    }
                } else { // top
                    if (self.pullDownViewOriginatingAtTop) {
                        [self.pullDownView animateViewMoveUp];
                    } else { // bottom
                        [self.pullDownView animateViewMoveDown];
                    }
                }
                self.pullDownViewIsMoving = YES;
            } completion:^(BOOL finished) {
                if (finished) {
                    if ([self hasPassedAutoSlideThreshold]) {
                        if (self.pullDownViewOriginatingAtTop) { // bottom
                            [self.pullDownView animateViewMoveDown];
                            [self calculatorViewReachedBottom];
                        } else { // top
                            [self.pullDownView animateViewMoveUp];
                            [self calculatorViewReachedTop];
                        }
                    } else {
                        if (self.pullDownViewOriginatingAtTop) { // top
                            [self.pullDownView animateViewMoveUp];
                            [self.pullDownView addGestureRecognizer:self.holdGestureRecognizer];
                        } else { // bottom
                            [self.pullDownView animateViewMoveDown];
                            [self.pullDownView removeGestureRecognizer:self.holdGestureRecognizer];
                        }
                    }
                    self.pullDownViewIsMoving = NO;
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

- (void)calculatorViewHeldGestureEnded:(UILongPressGestureRecognizer *)recognizer {
    [UIView animateWithDuration:0.43 delay:0.0 usingSpringWithDamping:0.85 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect newFrame = self.pullDownView.frame;
        newFrame.origin.y -= 20;
        self.pullDownView.frame = newFrame;
        
        [self.pullDownView viewDragged:recognizer.view.frame.origin.y];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)calculatorViewHeld:(UILongPressGestureRecognizer *)recognizer  {
//    LogTrace(@"%s", __PRETTY_FUNCTION__);
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (self.pullDownViewOriginatingAtTop) {
            [UIView animateWithDuration:0.43 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                CGRect newFrame = self.pullDownView.frame;
                newFrame.origin.y += 20;
                self.pullDownView.frame = newFrame;
                
                [self.pullDownView viewDragged:recognizer.view.frame.origin.y];
            } completion:^(BOOL finished) {
                
            }];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self.pullDownView.layer removeAllAnimations];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.pullDownViewOriginatingAtTop && ![self hasPassedAutoSlideThreshold]) {
            [self calculatorViewHeldGestureEnded:recognizer];
        }
    } else {
        if (recognizer.state == UIGestureRecognizerStateCancelled
            || recognizer.state == UIGestureRecognizerStateFailed)
        {
            // Long press ended
            
            if (!self.moveGestureBegan) {
                if (self.pullDownViewOriginatingAtTop) {
                    [self calculatorViewHeldGestureEnded:recognizer];
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
