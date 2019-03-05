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
 (Can be thought of as the height of this view at rest.) Defaults to 65.
 */
@property (nonatomic, assign) CGFloat overlayOffset;
/**
 Denotes the height of the bar at the top or the bottom of the screen lying opposite of this 
 view (i.e. if this was a pull down view, this corresponds to the toolbar height at the bottom
 of the screen, and in the event this view is a pull up view, it would correspond to the height
 of the navigation bar).
 */
// TODO: This should be auto calculated from a passed in toolbar reference. Rename to opposingToolbarHeight.
//       Calc using [self.toolbar topmostEdge] and [self.toolbar bottommostEdge]
@property (nonatomic, assign) CGFloat toolbarHeight;
/**
 Denotes if the pullable view is to conceal opposingBar.
 */
@property (nonatomic, assign) BOOL overlapsOpposingBar;
/**
 Opposing tool bar or navigation bar. Used to determine toolbarHeight.
 */
@property (nullable, nonatomic, weak) UIView *opposingBar;
/**
 Denotes the amount of space to stop short by when dragged. In other words, padding above or below
 the normal endpoint denoted by toolbarHeight. This is useful when attempting to avoid concealing 
 an ad bar above the toolbar, for instance.
 */
@property (nonatomic, assign) CGFloat slideInset;
@property (nonatomic, assign) CGFloat autoSlideCompletionThreshold;
@property (nonatomic, assign) BOOL originatingAtTop;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) BOOL isPullDownView;
@property (nonatomic, assign) BOOL prevHasPassedAutoSlideThresholdValue;
/**
 Layout margins that override the window's layout margins.
 */
@property (nonatomic, assign) UIEdgeInsets overriddenLayoutMargins;

@property (nonatomic, assign, readonly) CGFloat initialYPosition;
@property (nonatomic, assign, readonly) CGFloat restingBottomYPos;
@property (nonatomic, assign, readonly) CGFloat restingTopYPos;
/**
 The distance the view travels when moving to/from its resting position.
 */
@property (nonatomic, assign, readonly) CGFloat slideDistance;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *holdGestureRecognizer;

@property (nullable, nonatomic, weak) id delegate;

- (void)setupFrame;
- (void)setupWithController:(STAPullDownViewController * _Nonnull)controller;

- (void)setupView;

/**
 Animates view down if up and vice versa.
 */
- (void)toggleView;

- (void)viewDraggedTo:(CGFloat)yPos;

- (BOOL)hasPassedAutoSlideThreshold;

- (CGRect)animateViewMoveUp;

- (CGRect)animateViewMoveDown;

- (void)reachedTop;

- (void)reachedBottom;

@end

@protocol STAPullableViewDelegate <NSObject>

@optional
- (void)view:(STAPullableView * _Nonnull)view draggedTo:(CGFloat)yPos;
- (void)view:(STAPullableView * _Nonnull)view reachedTop:(CGFloat)yPos;
- (void)view:(STAPullableView * _Nonnull)view reachedBottom:(CGFloat)yPos;

@end
