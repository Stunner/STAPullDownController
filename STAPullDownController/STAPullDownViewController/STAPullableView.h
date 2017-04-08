//
//  STAPullableView.h
//  STAPullDownController
//
//  Created by Aaron Jubbal on 4/8/17.
//  Copyright © 2017 STA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STAPullableView : UIView

@property (nonatomic, assign) CGFloat overlayOffset;
@property (nonatomic, assign) CGFloat toolbarHeight;
@property (nonatomic, assign, readonly) CGFloat initialYPosition;

- (void)setupWithBounds:(CGRect)bounds;

- (void)viewDragged:(CGFloat)yPos;

- (void)animateViewMoveUp;

- (void)animateViewMoveDown;

@end
