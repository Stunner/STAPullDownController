//
//  RootTableViewController.m
//  STAPullDownController
//
//  Created by Aaron Jubbal on 2/6/18.
//  Copyright © 2018 STA. All rights reserved.
//

#import "RootTableViewController.h"
#import "ViewController.h"
#import "STAPullDownViewController.h"

@interface RootTableViewController ()

@property (strong, nonatomic) STAPullDownViewController *pullDownViewController;
@property (strong, nonatomic) STAPullDownViewController *pullDownAndToolbarController;
@property (strong, nonatomic) STAPullDownViewController *pullUpAndNavController;

@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rootCellReuseID" forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Pull Down & Pull Up";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Pull Down & Toolbar";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Navigation Bar & Pull Up";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (!self.pullDownViewController) {
            ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
            self.pullDownViewController = [[STAPullDownViewController alloc] init];
            self.pullDownViewController.mainViewController = viewController;
            
            // ivar pullDownView has been connected via IBOutlet, load that here
            [[NSBundle mainBundle] loadNibNamed:@"PullDownView"
                                          owner:self.pullDownViewController
                                        options:nil];
            // specify any additional options for the pull down view...
            self.pullDownViewController.pullDownView.slideInset = 45;
            
            // create ivar pullUpView programmatically
            STAPullableView *pullUpView = [[STAPullableView alloc] init];
            pullUpView.frame = CGRectZero; // pull up view should be sized to that of parent view controller view
            pullUpView.backgroundColor = [UIColor blueColor];
            pullUpView.overlayOffset = 45;
            self.pullDownViewController.pullUpView = pullUpView;
        }

        [self presentViewController:self.pullDownViewController animated:YES completion:nil];
    } else if (indexPath.row == 1) {
        if (!self.pullDownAndToolbarController) {
            ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
            viewController.showsToolbar = YES;
            self.pullDownAndToolbarController = [[STAPullDownViewController alloc] init];
            self.pullDownAndToolbarController.mainViewController = viewController;
            
            // ivar pullDownView has been connected via IBOutlet, load that here
            [[NSBundle mainBundle] loadNibNamed:@"PullDownView"
                                          owner:self.pullDownAndToolbarController
                                        options:nil];
//            STAPullableView *pullDownView = [[STAPullableView alloc] init];
//            pullDownView.frame = CGRectZero; // pull up view should be sized to that of parent view controller view
//            pullDownView.backgroundColor = [UIColor redColor];
            self.pullDownAndToolbarController.pullDownView.overlayOffset = 70;
            self.pullDownAndToolbarController.pullDownView.toolbarHeight = 42;
//            self.pullDownAndToolbarController.pullDownView = pullDownView;
            
            
//            self.navigationController.toolbarHidden = NO;
            
        }
        
        [self.navigationController pushViewController:self.pullDownAndToolbarController animated:YES];
    } else if (indexPath.row == 2) {
        if (!self.pullUpAndNavController) {
            ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
            self.pullUpAndNavController = [[STAPullDownViewController alloc] init];
            self.pullUpAndNavController.mainViewController = viewController;
            
            // create ivar pullUpView programmatically
            STAPullableView *pullUpView = [[STAPullableView alloc] init];
            pullUpView.frame = CGRectZero; // pull up view should be sized to that of parent view controller view
            pullUpView.backgroundColor = [UIColor blueColor];
            pullUpView.overlayOffset = 45;
            pullUpView.toolbarHeight = 36;
            self.pullUpAndNavController.pullUpView = pullUpView;
            
            
//            self.navigationController.toolbarHidden = YES;
            
        }
        
        [self.navigationController pushViewController:self.pullUpAndNavController animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
