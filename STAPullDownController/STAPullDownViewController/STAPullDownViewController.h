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

@property (nonatomic, strong) id mainViewController; // must either be UIViewController or UITableViewController
@property (nonatomic, strong) IBOutlet STAPullableView *pullDownView;
@property (nonatomic, assign) CGFloat pullDownViewOffsetOverlap;
@property (nonatomic, strong) IBOutlet STAPullableView *pullUpView;
@property (nonatomic, assign) CGFloat pullUpViewOffsetOverlap;
@property (nonatomic, weak) UIToolbar *toolbar;

@end
