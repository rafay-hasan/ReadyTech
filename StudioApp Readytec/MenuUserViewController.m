//
//  MenuUserViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/20/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "MenuUserViewController.h"
#import "ProfileViewController.h"
@interface MenuUserViewController ()


- (IBAction)logoutButtonAction:(id)sender;

- (IBAction)menuButtonAction:(UIButton *)sender;

@end

@implementation MenuUserViewController

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

- (IBAction)logoutButtonAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)menuButtonAction:(UIButton *)sender {
    
    if(sender.tag == 1000)
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProfileViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"profile"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
@end
