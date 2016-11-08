//
//  MenuAdminViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/5/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "MenuAdminViewController.h"
#import "NewsViewController.h"

@interface MenuAdminViewController ()

- (IBAction)menuAction:(UIButton *)sender;



@end

@implementation MenuAdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)menuAction:(UIButton *)sender {
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewsViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"newsVc"];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
