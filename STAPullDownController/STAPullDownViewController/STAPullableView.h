//
//  STAPullableView.h
//  STAPullDownController
//
//  Created by Aaron Jubbal on 4/8/17.
//  Copyright © 2017 STA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STAPullDownViewController;

@interface STAPullableView : UIView

/**
 Denotes how much space the pull up/down view should overlap the underlying view as a bar.
 (Can be thought of as tool bar or navigation bar height.) Defaults to 65.
 */
@property (nonatomic, assign) CGFloat overlayOffset;
@property (nonatomic, assign) CGFloat toolbarHeight;
@property (nonatomic, assign, readonly) CGFloat initialYPosition;
@property (nonatomic, assign) CGFloat autoSlideCompletionThreshold;
@property (nonatomic, assign) BOOL originatingAtTop;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) BOOL isPullDownView;
@property (nonatomic, assign) BOOL prevHasPassedAutoSlideThresholdValue;
@property (nonatomic, assign) CGFloat restingTopYPos;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *holdGestureRecognizer;


- (void)setupFrame;
- (void)setupWithController:(STAPullDownViewController *)controller;

- (void)viewDragged:(CGFloat)yPos;

- (BOOL)hasPassedAutoSlideThreshold;

- (void)animateViewMoveUp;

- (void)animateViewMoveDown;

- (void)reachedTop;

- (void)reachedBottom;

@end
