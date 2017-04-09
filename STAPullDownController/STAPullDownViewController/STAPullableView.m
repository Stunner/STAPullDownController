//
//  STAPullableView.m
//  STAPullDownController
//
//  Created by Aaron Jubbal on 4/8/17.
//  Copyright © 2017 STA. All rights reserved.
//

#import "STAPullableView.h"
#import "STAPullDownViewController.h"

@interface STAPullableView ()

@property (nonatomic, assign, readwrite) CGFloat initialYPosition;
@property (nonatomic, weak) STAPullDownViewController *controller;

@end

@implementation STAPullableView

- (void)commonInit {
    self.toolbarHeight = 0;
    self.overlayOffset = 65;
    self.autoSlideCompletionThreshold = 30;
    self.originatingAtTop = YES;
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

- (void)setupWithController:(STAPullDownViewController *)controller {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    CGRect pullableViewFrame = controller.view.bounds;
    if (self.originatingAtTop) {
        self.initialYPosition = pullableViewFrame.origin.y - pullableViewFrame.size.height + self.overlayOffset;
    } else {
        self.initialYPosition = pullableViewFrame.size.height - self.overlayOffset;
    }
    
    self.holdGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:controller
                                                                               action:@selector(viewHeld:)];
    self.holdGestureRecognizer.delegate = controller;
    self.holdGestureRecognizer.minimumPressDuration = 0.0;
    [self addGestureRecognizer:self.holdGestureRecognizer];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:controller action:@selector(moveView:)];
    self.panGestureRecognizer.delegate = controller;
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    pullableViewFrame.origin.y = self.initialYPosition;
    self.frame = pullableViewFrame;
}

- (void)viewDragged:(CGFloat)yPos {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    CGFloat slideDistance = 0 - self.initialYPosition - self.toolbarHeight;
}

- (BOOL)hasPassedAutoSlideThreshold {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    BOOL returnable = NO;
    
    if (self.isPullDownView) {
        if (self.originatingAtTop) {
            CGFloat yDelta = self.frame.origin.y - self.initialYPosition;
            returnable = (yDelta >= self.autoSlideCompletionThreshold);
        } else {
            //        CGFloat adBannerHeight = [(AppDelegate *)[[UIApplication sharedApplication] delegate] bannerViewHeight];
            CGFloat yDelta = 0 - self.frame.origin.y/* - adBannerHeight*/;
            returnable = (yDelta >= self.autoSlideCompletionThreshold);
        }
    } else {
        if (self.originatingAtTop) {
            CGFloat yDelta = self.frame.origin.y/* - adBannerHeight*/;
            returnable = (yDelta >= self.autoSlideCompletionThreshold);
        } else {
            CGFloat yDelta = self.initialYPosition - self.frame.origin.y;
            returnable = (yDelta >= self.autoSlideCompletionThreshold);
        }
    }
    self.prevHasPassedAutoSlideThresholdValue = returnable;
    return returnable;
}

- (void)animateViewMoveUp {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    CGRect newFrame = self.frame;
    if (self.isPullDownView) {
        newFrame.origin.y = self.initialYPosition;
    } else {
        newFrame.origin.y = 0;
    }
    self.frame = newFrame;
}

- (void)animateViewMoveDown {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    CGRect newFrame = self.frame;
    if (self.isPullDownView) {
        newFrame.origin.y = 0 - /*adBannerHeight -*/ self.toolbarHeight;
    } else {
        newFrame.origin.y = self.initialYPosition;
    }
    self.frame = newFrame;
}

- (void)reachedTop {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.originatingAtTop = YES;
}

- (void)reachedBottom{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.originatingAtTop = NO;
}

@end
