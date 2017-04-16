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
/**
 Denotes the height of the bar at the top or the bottom of the screen lying opposite of this 
 view (i.e. if this was a pull down view, this corresponds to the toolbar height at the bottom
 of the screen, and in the event this view is a pull up view, it would correspond to the height
 of the navigation bar).
 */
@property (nonatomic, assign) CGFloat toolbarHeight;
/**
 Denotes the amount of space to stop short by when dragged. In other words, padding above or below
 the normal endpoint denoted by toolbarHeight. This is useful when attempting to avoid concealing 
 an ad bar above the toolbar, for instance.
 */
@property (nonatomic, assign) CGFloat slideInset;
@property (nonatomic, assign, readonly) CGFloat initialYPosition;
@property (nonatomic, assign) CGFloat autoSlideCompletionThreshold;
@property (nonatomic, assign) BOOL originatingAtTop;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) BOOL isPullDownView;
@property (nonatomic, assign) BOOL prevHasPassedAutoSlideThresholdValue;
@property (nonatomic, assign) CGFloat restingBottomYPos;
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
