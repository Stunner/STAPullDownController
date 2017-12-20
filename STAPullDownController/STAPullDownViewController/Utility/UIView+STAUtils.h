//
//  UIView+STAUtils.h
//  STAUtils
//
//  Created by Aaron Jubbal on 2/5/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (STAUtils)

// frame manipulation

- (void)setFrameX:(CGFloat)xPos;

- (void)setFrameY:(CGFloat)yPos;

- (void)setFrameWidth:(CGFloat)width;

- (void)setFrameHeight:(CGFloat)height;

- (void)shrinkFrameHeightBy:(CGFloat)height;

- (void)expandFrameHeightBy:(CGFloat)height;

- (void)setFrameOrigin:(CGPoint)origin;

- (void)setFrameSize:(CGSize)size;

- (void)setCenterX:(CGFloat)xPos;

- (void)setCenterY:(CGFloat)yPos;

// information retrieval

- (CGFloat)leftmostEdgePosition;

- (CGFloat)rightmostEdgePosition;

- (CGFloat)topmostEdgePosition;

- (CGFloat)bottommostEdgePosition;

- (CGFloat)heightFromBottomEdgeToBottomOfScreen;

- (UIView *)firstResponder;

@end
