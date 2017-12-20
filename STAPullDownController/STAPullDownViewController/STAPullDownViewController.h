//
//  STAPullDownViewController.h
//  STAPullDownController
//
//  Created by Aaron Jubbal on 3/27/17.
//  Copyright © 2017 STA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STAPullableView.h"

@interface STAPullDownViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonnull, nonatomic, strong) id mainViewController; // must either be UIViewController or UITableViewController
@property (nullable, nonatomic, strong) IBOutlet STAPullableView *pullDownView;
@property (nullable, nonatomic, strong) IBOutlet STAPullableView *pullUpView;
//@property (nullable, nonatomic, weak) UIToolbar *toolbar;

- (void)moveGestureBegan:(UIGestureRecognizer  * _Nonnull )recognizer;
- (void)moveGestureChanged:(UIGestureRecognizer * _Nonnull)recognizer;
- (void)moveGestureEnded:(UIGestureRecognizer * _Nonnull)recognizer;

- (void)moveView:(UIPanGestureRecognizer *)recognizer;
- (void)viewHeld:(UILongPressGestureRecognizer *)recognizer;

@end
