//
//  ViewController.m
//  STAPullDownController
//
//  Created by Aaron Jubbal on 3/26/17.
//  Copyright © 2017 STA. All rights reserved.
//

#import "ViewController.h"
#import "STAPullDownViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // create ivar pullUpView programmatically
    STAPullableView *pullUpView = [[STAPullableView alloc] init];
//    pullUpView.frame = CGRectZero;
    //    pullUpView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 667);
    pullUpView.backgroundColor = [UIColor blueColor];
    pullUpView.overlayOffset = 45;
//    pullUpView.slideInset = 65;
    AppDelegate *appDelegate = (AppDelegate  *)[[UIApplication sharedApplication] delegate];
    appDelegate.pullDownViewController.pullUpView = pullUpView;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
