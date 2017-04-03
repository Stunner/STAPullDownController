//
//  STAPullDownViewController.m
//  STAPullDownController
//
//  Created by Aaron Jubbal on 3/27/17.
//  Copyright © 2017 STA. All rights reserved.
//

#import "STAPullDownViewController.h"
#import "UIView+STAUtils.h"

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setUpPullDownView {
    CGRect pullDownViewFrame = self.pullDownView.bounds;
    self.initialPullDownViewYPosition = pullDownViewFrame.origin.y - pullDownViewFrame.size.height + 65;
    pullDownViewFrame.origin.y = self.initialPullDownViewYPosition;
    self.pullDownView.frame = pullDownViewFrame;
    
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

- (void)adjustContentFadingForYPosition:(CGFloat)yPos {
//    LogTrace(@"%s", __PRETTY_FUNCTION__);
    
    CGFloat toolbarHeight = self.toolbar.frame.size.height;
    CGFloat slideDistance = 0 - self.initialPullDownViewYPosition - toolbarHeight;
//    self.calculatorKeyboard.alpha = (yPos - self.initialPullDownViewYPosition) / slideDistance;
//    self.titleLabel.alpha = self.hamburgerButton.alpha = self.settingsButton.alpha = 1 - self.calculatorKeyboard.alpha;
}

- (BOOL)hasPassedAutoSlideThreshold {
    if (self.pullDownViewOriginatingAtTop) {
        CGFloat yDelta = self.pullDownView.frame.origin.y - self.initialPullDownViewYPosition;
        return yDelta >= kAutoSlideCompletionThreshold;
    } else {
//        CGFloat adBannerHeight = [(AppDelegate *)[[UIApplication sharedApplication] delegate] bannerViewHeight];
        CGFloat yDelta = 0 - self.pullDownView.frame.origin.y/* - adBannerHeight*/;
        return yDelta >= kAutoSlideCompletionThreshold;
    }
}

- (void)calculatorViewReachedTop {
//    LogTrace(@"%s", __PRETTY_FUNCTION__);
    
    self.pullDownViewOriginatingAtTop = YES;
    [self.pullDownView addGestureRecognizer:self.holdGestureRecognizer];
}

- (void)calculatorViewReachedBottom {
//    LogTrace(@"%s", __PRETTY_FUNCTION__);
    
    self.pullDownViewOriginatingAtTop = NO;
    [self.pullDownView removeGestureRecognizer:self.holdGestureRecognizer];
}

- (void)calculatorViewMovingUp {
//    LogTrace(@"%s", __PRETTY_FUNCTION__);
    
    CGRect newFrame = self.pullDownView.frame;
    newFrame.origin.y = self.initialPullDownViewYPosition;
    self.pullDownView.frame = newFrame;
//    self.calculatorKeyboard.alpha = 0.0;
//    self.titleLabel.alpha = self.hamburgerButton.alpha = self.settingsButton.alpha = self.detailLabel1.alpha = self.detailLabel2.alpha = self.pulldownBar.alpha = 1.0;
}

- (void)calculatorViewMovingDown {
//    LogTrace(@"%s", __PRETTY_FUNCTION__);
    
//    CGFloat adBannerHeight = [(AppDelegate *)[[UIApplication sharedApplication] delegate] bannerViewHeight];
    CGRect newFrame = self.pullDownView.frame;
    CGFloat toolbarHeight = self.toolbar.frame.size.height;
    newFrame.origin.y = 0 - /*adBannerHeight -*/ toolbarHeight;
    self.pullDownView.frame = newFrame;
//    self.calculatorKeyboard.alpha = 1.0;
//    self.titleLabel.alpha = self.hamburgerButton.alpha = self.settingsButton.alpha = self.detailLabel1.alpha = self.detailLabel2.alpha = self.pulldownBar.alpha = 0.0;
}

- (void)moveCalculatorView:(UIPanGestureRecognizer *)recognizer {
//    LogTrace(@"%s", __PRETTY_FUNCTION__);
    
    CGPoint translation = [recognizer translationInView:self.view];
    CGFloat newCenterY = recognizer.view.center.y + translation.y;
    
    NSLog(@"recognizer center: %f self view center: %f", recognizer.view.center.y, self.view.center.y - (48/2));
//    CGFloat adBannerHeight = [(AppDelegate *)[[UIApplication sharedApplication] delegate] bannerViewHeight];
    CGFloat toolbarHeight = self.toolbar.frame.size.height;
    if (recognizer.view.center.y >= self.view.center.y /*- adBannerHeight */- toolbarHeight - (48/2) && translation.y > 0) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.pullDownView setFrameY:0 -/* adBannerHeight -*/ toolbarHeight];
        }];
        return;
    }
    recognizer.view.center = CGPointMake(recognizer.view.center.x,
                                         newCenterY);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    [self adjustContentFadingForYPosition:recognizer.view.frame.origin.y];
    
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
                        [self calculatorViewMovingDown];
                    } else { // top
                        [self calculatorViewMovingUp];
                    }
                } else { // top
                    if (self.pullDownViewOriginatingAtTop) {
                        [self calculatorViewMovingUp];
                    } else { // bottom
                        [self calculatorViewMovingDown];
                    }
                }
                self.pullDownViewIsMoving = YES;
            } completion:^(BOOL finished) {
                if (finished) {
                    if ([self hasPassedAutoSlideThreshold]) {
                        if (self.pullDownViewOriginatingAtTop) { // bottom
                            [self calculatorViewMovingDown];
                            [self calculatorViewReachedBottom];
                        } else { // top
                            [self calculatorViewMovingUp];
                            [self calculatorViewReachedTop];
                        }
                    } else {
                        if (self.pullDownViewOriginatingAtTop) { // top
                            [self calculatorViewMovingUp];
                            [self.pullDownView addGestureRecognizer:self.holdGestureRecognizer];
                        } else { // bottom
                            [self calculatorViewMovingDown];
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

- (void)calculatorViewHeld:(UILongPressGestureRecognizer *)recognizer  {
//    LogTrace(@"%s", __PRETTY_FUNCTION__);
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (self.pullDownViewOriginatingAtTop) {
            [UIView animateWithDuration:0.43 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                CGRect newFrame = self.pullDownView.frame;
                newFrame.origin.y += 20;
                self.pullDownView.frame = newFrame;
                
                [self adjustContentFadingForYPosition:recognizer.view.frame.origin.y];
            } completion:^(BOOL finished) {
                
            }];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self.pullDownView.layer removeAllAnimations];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.pullDownViewOriginatingAtTop && ![self hasPassedAutoSlideThreshold]) {
            [UIView animateWithDuration:0.43 delay:0.0 usingSpringWithDamping:0.85 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                CGRect newFrame = self.pullDownView.frame;
                newFrame.origin.y -= 20;
                self.pullDownView.frame = newFrame;
                
                [self adjustContentFadingForYPosition:recognizer.view.frame.origin.y];
            } completion:^(BOOL finished) {
                
            }];
        }
    } else {
        if (recognizer.state == UIGestureRecognizerStateCancelled
            || recognizer.state == UIGestureRecognizerStateFailed)
        {
            // Long press ended
            
            if (!self.moveGestureBegan) {
                if (self.pullDownViewOriginatingAtTop) {
                    [UIView animateWithDuration:0.43 delay:0.0 usingSpringWithDamping:0.85 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                        CGRect newFrame = self.pullDownView.frame;
                        newFrame.origin.y -= 20;
                        self.pullDownView.frame = newFrame;
                        
                        [self adjustContentFadingForYPosition:recognizer.view.frame.origin.y];
                    } completion:^(BOOL finished) {
                        
                    }];
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
