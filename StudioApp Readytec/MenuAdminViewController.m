//
//  MenuAdminViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/5/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "MenuAdminViewController.h"
#import "NewsViewController.h"
#import "ViewController.h"
#import "ProfileViewController.h"
#import "UsersViewController.h"
#import "EventsViewController.h"
#import "TrainingViewController.h"
#import "MessageViewController.h"
#import "OffersViewController.h"

@interface MenuAdminViewController ()

- (IBAction)menuAction:(UIButton *)sender;

- (IBAction)logoutAction:(id)sender;


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
    
    if(sender.tag == 1000)
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProfileViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"profile"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(sender.tag == 2000)
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EventsViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"events"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(sender.tag == 3000)
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NewsViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"newsVc"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(sender.tag == 4000)
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OffersViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"offers"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(sender.tag == 5000)
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"message"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(sender.tag == 7000)
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TrainingViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"training"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(sender.tag == 9000)
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UsersViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"usersVc"];
        [self.navigationController pushViewController:controller animated:YES];
    }

}

- (IBAction)logoutAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
