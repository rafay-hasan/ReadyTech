//
//  DEMOMenuViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/5/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "DEMOMenuTableViewCell.h"
#import "DEMONavigationController.h"
#import "REFrostedViewController.h"
#import "menuHeaderView.h"
#import "ProfileViewController.h"
#import "NewsViewController.h"
#import "EventsViewController.h"
#import "OffersViewController.h"
#import "MessageViewController.h"
#import "ServicesViewController.h"
#import "TrainingViewController.h"
#import "TicketsViewController.h"
#import "UsersViewController.h"
#import "User Details.h"
#import "LoginViewController.h"
#import "MenuAdminViewController.h"
#import "MenuUserViewController.h"


static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@interface DEMOMenuViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic,strong) NSArray *menuItemsArray;


@property (strong,nonatomic) LoginViewController *loginVc;
@property (strong,nonatomic) DEMONavigationController *navigationController;
@property (strong,nonatomic) MenuAdminViewController *menuVc;
@property (strong,nonatomic) MenuUserViewController *UserMneuVc;
@end

@implementation DEMOMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.loginVc = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    self.menuVc = [self.storyboard instantiateViewControllerWithIdentifier:@"adminMenu"];
    self.UserMneuVc = [self.storyboard instantiateViewControllerWithIdentifier:@"userMenu"];
    
    self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"View" bundle:nil];
    [self.menuTableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    self.menuTableView.sectionHeaderHeight = 175.0;
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


#pragma mark table view Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [User_Details sharedInstance].menuItemsArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"menuCell";
    
    DEMOMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    cell.slideMenuItemName.text = [[User_Details sharedInstance].menuItemsArray objectAtIndex:indexPath.row];
    cell.slideMenuItemImageview.image = [UIImage imageNamed:[[User_Details sharedInstance].imageArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}


//NewsViewController *vc = [[NewsViewController alloc] init];
//
//DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:vc];
//navigationController.navigationBarHidden = YES;
//
//self.frostedViewController.contentViewController = navigationController;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([[[User_Details sharedInstance].imageArray objectAtIndex:indexPath.row] isEqualToString:@"News"])
    {
        NewsViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"newsVc"];
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = @[self.loginVc,self.menuVc,controller];
        else
            self.navigationController.viewControllers = @[self.loginVc,self.UserMneuVc,controller];
    }
    else if ([[[User_Details sharedInstance].imageArray objectAtIndex:indexPath.row] isEqualToString:@"Profile"])
    {
        ProfileViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"profile"];
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = @[self.loginVc,self.menuVc,controller];
        else
            self.navigationController.viewControllers = @[self.loginVc,self.UserMneuVc,controller];
    }
    else if ([[[User_Details sharedInstance].imageArray objectAtIndex:indexPath.row] isEqualToString:@"Events"])
    {
        EventsViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"events"];
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = @[self.loginVc,self.menuVc,controller];
        else
            self.navigationController.viewControllers = @[self.loginVc,self.UserMneuVc,controller];
    }
    else if ([[[User_Details sharedInstance].imageArray objectAtIndex:indexPath.row] isEqualToString:@"Offers"])
    {
        OffersViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"offers"];
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = @[self.loginVc,self.menuVc,controller];
        else
            self.navigationController.viewControllers = @[self.loginVc,self.UserMneuVc,controller];
    }
    else if ([[[User_Details sharedInstance].imageArray objectAtIndex:indexPath.row] isEqualToString:@"Messages"])
    {
        MessageViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"message"];
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = @[self.loginVc,self.menuVc,controller];
        else
            self.navigationController.viewControllers = @[self.loginVc,self.UserMneuVc,controller];
    }
    else if ([[[User_Details sharedInstance].imageArray objectAtIndex:indexPath.row] isEqualToString:@"Services"])
    {
        ServicesViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"services"];
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = @[self.loginVc,self.menuVc,controller];
        else
            self.navigationController.viewControllers = @[self.loginVc,self.UserMneuVc,controller];
    }
    else if ([[[User_Details sharedInstance].imageArray objectAtIndex:indexPath.row] isEqualToString:@"Training"])
    {
        TrainingViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"training"];
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = @[self.loginVc,self.menuVc,controller];
        else
            self.navigationController.viewControllers = @[self.loginVc,self.UserMneuVc,controller];
    }
    else if ([[[User_Details sharedInstance].imageArray objectAtIndex:indexPath.row] isEqualToString:@"Tickets"])
    {
        TicketsViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"ticket"];
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = @[self.loginVc,self.menuVc,controller];
        else
            self.navigationController.viewControllers = @[self.loginVc,self.UserMneuVc,controller];
    }
    else if ([[[User_Details sharedInstance].imageArray objectAtIndex:indexPath.row] isEqualToString:@"Users"])
    {
        UsersViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"usersVc"];
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = @[self.loginVc,self.menuVc,controller];
        else
            self.navigationController.viewControllers = @[self.loginVc,self.UserMneuVc,controller];
    }
   
    self.frostedViewController.contentViewController = self.navigationController;
    [self.frostedViewController hideMenuViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.00;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 175.00;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.00;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    menuHeaderView *sectionHeaderView = [self.menuTableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
        sectionHeaderView.userTypeLabel.text = @"Admin";
    else
        sectionHeaderView.userTypeLabel.text = @"User";
    sectionHeaderView.userANmeLabel.text =  [User_Details sharedInstance].userName;;
    sectionHeaderView.profileNameLAbel.text =  [User_Details sharedInstance].profileName;
    
    return sectionHeaderView;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}


@end
