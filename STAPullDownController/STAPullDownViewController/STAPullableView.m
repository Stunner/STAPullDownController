//
//  STAPullableView.m
//  STAPullDownController
//
//  Created by Aaron Jubbal on 4/8/17.
//  Copyright © 2017 STA. All rights reserved.
//

#import "STAPullableView.h"
#import "STAPullDownViewController.h"
#import "UIView+STAUtils.h"

@interface STAPullableView ()

@property (nonatomic, assign, readwrite) CGFloat initialYPosition;
@property (nonatomic, assign, readwrite) CGFloat restingBottomYPos;
@property (nonatomic, assign, readwrite) CGFloat restingTopYPos;

@property (nonatomic, weak) STAPullDownViewController *controller;
@property (nonatomic, assign) BOOL setupComplete;
@property (nonatomic, assign) BOOL interactionOccurred;

@end

@implementation STAPullableView

- (void)commonInit {
    self.toolbarHeight = 0;
    self.overlayOffset = 65;
    self.autoSlideCompletionThreshold = 30;
    self.setupComplete = NO;
    self.interactionOccurred = NO;
}

- (instancetype)init {
    if ([super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)didMoveToSuperview {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
}

- (void)didMoveToWindow {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.window != nil) {
        [self setupFrame];
    }
}

#pragma mark - Getters

- (CGFloat)slideDistance {
    if (self.isPullDownView) {
        return self.restingBottomYPos - self.initialYPosition;
    } else {
        return self.initialYPosition - self.restingTopYPos;
    }
}

#pragma mark Setters

- (void)setSlideInset:(CGFloat)slideInset {
    _slideInset = slideInset;
    if (self.setupComplete) {
        [self setupFrame];
    }
}

- (void)setIsPullDownView:(BOOL)isPullDownView {
    self.originatingAtTop = isPullDownView;
    _isPullDownView = isPullDownView;
}

#pragma mark -

- (void)layoutMarginsDidChange {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
}

- (void)setupFrame {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    CGRect pullableViewFrame = self.controller.view.bounds;
    
    // Only specify flexible height mask when view is at least as tall as controller so as to avoid
    // view growing absurdly tall. In addition, view will shrink if flexible height mask is specified
    // on a view that is not as tall as controller's view.
    if (pullableViewFrame.size.height >= self.controller.view.bounds.size.height) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    } else {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    
    UIEdgeInsets layoutMargins = self.controller.view.window.layoutMargins;
    if (@available(iOS 11.0, *)) {
        layoutMargins = UIApplication.sharedApplication.keyWindow.safeAreaInsets;
    }
    if (self.isPullDownView) {
        
        if (self.opposingBar) {
            self.toolbarHeight = [UIScreen mainScreen].bounds.size.height - [self.opposingBar topmostEdgePosition];
        }
        self.initialYPosition = 0 - pullableViewFrame.size.height + self.overlayOffset + layoutMargins.top;
        
        self.restingBottomYPos = self.initialYPosition + pullableViewFrame.size.height - self.overlayOffset - layoutMargins.top;
        // if pull down view is tall enough to conceal bottom bar...
        CGFloat notOpposingBarOffset = (!self.opposingBar) ? layoutMargins.bottom : 0;
        if (self.restingBottomYPos + pullableViewFrame.size.height >
            self.controller.view.frame.size.height - self.toolbarHeight - self.slideInset - notOpposingBarOffset)
        {
            // ...dont let it overlap
            self.restingBottomYPos = self.controller.view.bounds.size.height - self.toolbarHeight -
                pullableViewFrame.size.height - self.slideInset - notOpposingBarOffset;
        }
        
        if (!self.originatingAtTop) { // has been pulled down
            pullableViewFrame.origin.y = self.restingBottomYPos;
        } else {
            pullableViewFrame.origin.y = self.initialYPosition;
        }
    } else {
        
        if (self.opposingBar) {
            self.toolbarHeight = self.opposingBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height - layoutMargins.top;
        }        
        self.initialYPosition = self.controller.view.bounds.size.height - self.overlayOffset - layoutMargins.bottom;
        
        self.restingTopYPos = self.initialYPosition - pullableViewFrame.size.height + self.overlayOffset + layoutMargins.bottom;
        if (self.restingTopYPos < self.toolbarHeight + self.slideInset + layoutMargins.top) { // if pull up view is tall enough to conceal top bar...
            self.restingTopYPos = self.toolbarHeight + self.slideInset + layoutMargins.top; // ...dont let it overlap
        }
        
        if (self.originatingAtTop) { // has been pulled up
            pullableViewFrame.origin.y = self.restingTopYPos;
        } else {
            pullableViewFrame.origin.y = self.initialYPosition;
        }
    }
    
    self.frame = pullableViewFrame;
}

- (void)setupWithController:(STAPullDownViewController * _Nonnull)controller {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.controller = controller;
    [self setupFrame];
    
    self.holdGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:controller
                                                                               action:@selector(viewHeld:)];
    self.holdGestureRecognizer.delegate = controller;
    self.holdGestureRecognizer.minimumPressDuration = 0.0;
    [self addGestureRecognizer:self.holdGestureRecognizer];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:controller action:@selector(moveView:)];
    self.panGestureRecognizer.delegate = controller;
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    self.setupComplete = YES;
}

- (void)setupView {
    // empty method meant to be subclassed
}

- (void)userInteractionOccurred {
    self.interactionOccurred = YES;
}

- (void)toggleView {
    [self userInteractionOccurred];
    [UIView animateWithDuration:0.43 delay:0.0 usingSpringWithDamping:0.85 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.isMoving = YES;
        if (self.originatingAtTop) {
            [self animateViewMoveDown];
        } else { // bottom
            [self animateViewMoveUp];
        }
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.originatingAtTop) {
                [self animateViewMoveDown];
                [self reachedBottom];
            } else { // bottom
                [self animateViewMoveUp];
                [self reachedTop];
            }
            self.isMoving = NO;
        }
    }];
}

- (void)viewDraggedTo:(CGFloat)yPos {
    [self userInteractionOccurred];
    if ([self.delegate respondsToSelector:@selector(view:draggedTo:)]) {
        [self.delegate view:self draggedTo:yPos];
    }
}

- (BOOL)hasPassedAutoSlideThreshold {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    BOOL returnable = NO;
    
    if (self.isPullDownView) {
        if (self.originatingAtTop) {
            CGFloat yDelta = self.frame.origin.y - self.initialYPosition;
            returnable = (yDelta >= self.autoSlideCompletionThreshold);
        } else {
            CGFloat yDelta = 0 - self.frame.origin.y;
            returnable = (yDelta >= self.autoSlideCompletionThreshold);
        }
    } else {
        if (self.originatingAtTop) {
            CGFloat yDelta = self.frame.origin.y - self.restingTopYPos;
            returnable = (yDelta >= self.autoSlideCompletionThreshold);
        } else {
            CGFloat yDelta = self.initialYPosition - self.frame.origin.y;
            returnable = (yDelta >= self.autoSlideCompletionThreshold);
        }
    }
    self.prevHasPassedAutoSlideThresholdValue = returnable;
    return returnable;
}

- (CGRect)animateViewMoveUp {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    CGRect newFrame = self.frame;
    if (self.isPullDownView) {
        newFrame.origin.y = self.initialYPosition;
    } else {
        newFrame.origin.y = self.restingTopYPos;
    }
    self.frame = newFrame;
    return newFrame;
}

- (CGRect)animateViewMoveDown {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    CGRect newFrame = self.frame;
    if (self.isPullDownView) {
        newFrame.origin.y = self.restingBottomYPos;
    } else {
        newFrame.origin.y = self.initialYPosition;
    }
    self.frame = newFrame;
    return newFrame;
}

- (void)reachedTop {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.originatingAtTop = YES;
    if (self.isPullDownView) {
        [self addGestureRecognizer:self.holdGestureRecognizer];
    } else {
        [self removeGestureRecognizer:self.holdGestureRecognizer];
    }
    if ([self.delegate respondsToSelector:@selector(view:reachedTop:)]) {
        [self.delegate view:self reachedTop:self.frame.origin.y];
    }
}

- (void)reachedBottom {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.originatingAtTop = NO;
    if (self.isPullDownView) {
        [self removeGestureRecognizer:self.holdGestureRecognizer];
    } else {
        [self addGestureRecognizer:self.holdGestureRecognizer];
    }
    if ([self.delegate respondsToSelector:@selector(view:reachedBottom:)]) {
        [self.delegate view:self reachedBottom:self.frame.origin.y];
    }
}

@end
