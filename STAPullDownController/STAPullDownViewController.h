//
//  STAPullDownViewController.h
//  STAPullDownController
//
//  Created by Aaron Jubbal on 3/27/17.
//  Copyright © 2017 STA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STAPullDownViewController : UIViewController

@property (nonatomic, strong) id mainViewController;
@property (nonatomic, strong) IBOutlet UIView *pullDownView;
@property (nonatomic, strong) UIView *pullUpView;

@end
