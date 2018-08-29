//
//  STAPullDownViewController.h
//  STAPullDownController
//
//  Created by Aaron Jubbal on 3/27/17.
//  Copyright © 2017 STA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STAPullableView.h"

/**
 Intended to be subclassed.
 */
@interface STAPullDownViewController : UIViewController <UIGestureRecognizerDelegate>

/**
 Must be an instance of UIViewController or UITableViewController.
 */
@property (nonnull, nonatomic, strong) id mainViewController;
/**
 View that hangs from the top of the screen and can be pulled down.
 
 IBOutlet placed here for convenience.
 */
@property (nullable, nonatomic, strong) IBOutlet STAPullableView *pullDownView;
/**
 View that hangs from the bottom of the screen and can be pulled up.
 
 IBOutlet placed here for convenience.
 */
@property (nullable, nonatomic, strong) IBOutlet STAPullableView *pullUpView;

//////////////////////////////////////////////////////////////////////
/**
 Overridable methods. Must call super's implementation at some point.
 */
- (void)moveGestureBegan:(UIGestureRecognizer  * _Nonnull )recognizer;
- (void)moveGestureChanged:(UIGestureRecognizer * _Nonnull)recognizer;
- (void)moveGestureEnded:(UIGestureRecognizer * _Nonnull)recognizer;

- (void)moveView:(UIPanGestureRecognizer *)recognizer;
- (void)viewHeld:(UILongPressGestureRecognizer *)recognizer;
//////////////////////////////////////////////////////////////////////

@end
