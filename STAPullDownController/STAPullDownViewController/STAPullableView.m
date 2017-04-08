//
//  STAPullableView.m
//  STAPullDownController
//
//  Created by Aaron Jubbal on 4/8/17.
//  Copyright © 2017 STA. All rights reserved.
//

#import "STAPullableView.h"

@interface STAPullableView ()

@property (nonatomic, assign, readwrite) CGFloat initialYPosition;

@end

@implementation STAPullableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        self.toolbarHeight = 0;
        self.overlayOffset = 65;
    }
    return self;
}

- (void)setupWithBounds:(CGRect)bounds {
    
    CGRect pullDownViewFrame = bounds;
    self.initialYPosition = pullDownViewFrame.origin.y - pullDownViewFrame.size.height + self.overlayOffset;
    pullDownViewFrame.origin.y = self.initialYPosition;
    self.frame = pullDownViewFrame;
}

- (void)viewDragged:(CGFloat)yPos {
    CGFloat slideDistance = 0 - self.initialYPosition - self.toolbarHeight;
}

//- (BOOL)hasPassedAutoSlideThreshold {
//    if (self.pullDownViewOriginatingAtTop) {
//        CGFloat yDelta = self.frame.origin.y - self.initialYPosition;
//        return yDelta >= kAutoSlideCompletionThreshold;
//    } else {
//        //        CGFloat adBannerHeight = [(AppDelegate *)[[UIApplication sharedApplication] delegate] bannerViewHeight];
//        CGFloat yDelta = 0 - self.frame.origin.y/* - adBannerHeight*/;
//        return yDelta >= kAutoSlideCompletionThreshold;
//    }
//}

- (void)animateViewMoveUp {
    CGRect newFrame = self.frame;
    newFrame.origin.y = self.initialYPosition;
    self.frame = newFrame;
}

- (void)animateViewMoveDown {
    CGRect newFrame = self.frame;
    newFrame.origin.y = 0 - /*adBannerHeight -*/ self.toolbarHeight;
    self.frame = newFrame;
}

@end
