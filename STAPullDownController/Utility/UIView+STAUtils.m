//
//  UIView+STAUtils.m
//  STAUtils
//
//  Created by Aaron Jubbal on 2/5/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "UIView+STAUtils.h"

@implementation UIView (STAUtils)

CGRect STA_CGRectSetWidth(CGRect rect, CGFloat width) {
    return CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height);
}

CGRect STA_CGRectSetHeight(CGRect rect, CGFloat height) {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height);
}

CGRect STA_CGRectSetSize(CGRect rect, CGSize size) {
    return CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height);
}

CGRect STA_CGRectSetX(CGRect rect, CGFloat x) {
    return CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height);
}

CGRect STA_CGRectSetY(CGRect rect, CGFloat y) {
    return CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height);
}

CGRect STA_CGRectSetOrigin(CGRect rect, CGPoint origin) {
    return CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height);
}

CGPoint STA_CGPointSetCenterX(CGFloat xPos, CGPoint center) {
    return CGPointMake(xPos, center.y);
}

CGPoint STA_CGPointSetCenterY(CGFloat yPos, CGPoint center) {
    return CGPointMake(center.x, yPos);
}

// PUBLIC

// frame manipulation

- (void)setFrameX:(CGFloat)xPos {
    self.frame = STA_CGRectSetX(self.frame, xPos);
}

- (void)setFrameY:(CGFloat)yPos {
    self.frame = STA_CGRectSetY(self.frame, yPos);
}

- (void)setFrameWidth:(CGFloat)width {
    self.frame = STA_CGRectSetWidth(self.frame, width);
}

- (void)setFrameHeight:(CGFloat)height {
    self.frame = STA_CGRectSetHeight(self.frame, height);
}

- (void)shrinkFrameHeightBy:(CGFloat)height {
    CGFloat newHeight = self.frame.size.height - height;
    [self setFrameHeight:newHeight];
}

- (void)expandFrameHeightBy:(CGFloat)height {
    CGFloat newHeight = self.frame.size.height + height;
    [self setFrameHeight:newHeight];
}

- (void)setFrameOrigin:(CGPoint)origin {
    self.frame = STA_CGRectSetOrigin(self.frame, origin);
}

- (void)setFrameSize:(CGSize)size {
    self.frame = STA_CGRectSetSize(self.frame, size);
}

- (void)setCenterX:(CGFloat)xPos {
    self.center = STA_CGPointSetCenterX(xPos, self.center);
}

- (void)setCenterY:(CGFloat)yPos {
    self.center = STA_CGPointSetCenterY(yPos, self.center);
}

// information retrieval

- (CGFloat)leftmostEdgePosition {
    return self.frame.origin.x;
}

- (CGFloat)rightmostEdgePosition {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)topmostEdgePosition {
    return self.frame.origin.y;
}

- (CGFloat)bottommostEdgePosition {
    return self.frame.origin.y + self.frame.size.height;
}
// TODO: place this in NSNumber category instead?
- (CGFloat)heightFromBottomEdgeToBottomOfScreen {
    CGFloat bottomEdgeYPos = [self bottommostEdgePosition];
    CGFloat returnable = [UIScreen mainScreen].bounds.size.height - bottomEdgeYPos;
    if (![UIApplication sharedApplication].isStatusBarHidden) {
        returnable = returnable - [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return returnable;
}

// reference: http://stackoverflow.com/a/30167390/347339
- (UIView *)firstResponder {
    if ([self isFirstResponder]) {
        return self;
    }

    for (UIView *view in self.subviews) {
        UIView *firstResponder = [view firstResponder];
        if (firstResponder) {
            return firstResponder;
        }
    }

    return nil;
}

@end
