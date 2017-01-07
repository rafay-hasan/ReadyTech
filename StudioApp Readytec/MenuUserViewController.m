//
//  MenuUserViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/20/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "MenuUserViewController.h"
#import "ProfileViewController.h"
#import "NewsViewController.h"
#import "EventsViewController.h"
#import "TrainingViewController.h"
#import "TicketsViewController.h"
#import "ServicesViewController.h"

@interface MenuUserViewController ()


- (IBAction)logoutButtonAction:(id)sender;

- (IBAction)menuButtonAction:(UIButton *)sender;

@end

@implementation MenuUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    
    [self makeViewLocalized];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = NSLocalizedString(@"Menu", Nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) makeViewLocalized
{
    UILabel *profile = (UILabel *)[self.view viewWithTag:1001];
    profile.text = NSLocalizedString(@"Profile", Nil);
    
    UILabel *Events = (UILabel *)[self.view viewWithTag:1002];
    Events.text = NSLocalizedString(@"Events", Nil);
    
    UILabel *news = (UILabel *)[self.view viewWithTag:1003];
    news.text = NSLocalizedString(@"News", Nil);
    
    UILabel *service = (UILabel *)[self.view viewWithTag:1004];
    service.text = NSLocalizedString(@"Services", Nil);
    
    UILabel *training = (UILabel *)[self.view viewWithTag:1005];
    training.text = NSLocalizedString(@"Training", Nil);
    
    UILabel *tickets = (UILabel *)[self.view viewWithTag:1006];
    tickets.text = NSLocalizedString(@"Tickets", Nil);
    
    self.navigationItem.title = NSLocalizedString(@"Menu", Nil);
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
    else if(sender.tag == 2000)
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EventsViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"events"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (sender.tag == 3000)
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NewsViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"newsVc"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(sender.tag == 4000)
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ServicesViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"services"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(sender.tag == 5000)
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TrainingViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"training"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(sender.tag == 6000)
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TicketsViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"ticket"];
        [self.navigationController pushViewController:controller animated:YES];
    }

}
@end
