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
    
    

}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
