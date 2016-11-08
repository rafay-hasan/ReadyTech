//
//  DEMOMenuViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/5/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "DEMOMenuTableViewCell.h"
#import "REFrostedViewController.h"

@interface DEMOMenuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *menuItemsArray;

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@property (weak, nonatomic) IBOutlet UIView *menuTableHeaderView;

@end

@implementation DEMOMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.menuItemsArray = [[NSArray alloc]initWithObjects:NSLocalizedString(@"Profile", Nil),NSLocalizedString(@"Events", Nil),NSLocalizedString(@"News", Nil),NSLocalizedString(@"Offers",Nil),NSLocalizedString(@"Messages",Nil),NSLocalizedString(@"Services",Nil),NSLocalizedString(@"Training",Nil),NSLocalizedString(@"Tickets",Nil),NSLocalizedString(@"Users",Nil),nil];
    
    self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItemsArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"menuCell";
    
    DEMOMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    cell.slideMenuItemName.text = [self.menuItemsArray objectAtIndex:indexPath.row];
    cell.slideMenuItemImageview.image = [UIImage imageNamed:[self.menuItemsArray objectAtIndex:indexPath.row]];
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
    
    
    /*
    
    if ([[self.imageItemsArray objectAtIndex:indexPath.row] isEqualToString:@"slideEvent"])
    {
        EventViewController *vc = [[EventViewController alloc]initWithNibName:[[User_Details sharedInstance]loadXibFile:@"EventViewController"] bundle:nil];
        
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.menuVc,vc, nil];
        else
            self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.UserMneuVc,vc, nil];
        
        self.navigationController.navigationBarHidden = YES;
        
        self.frostedViewController.contentViewController = self.navigationController;
        
    }
    else if ([[self.imageItemsArray objectAtIndex:indexPath.row] isEqualToString:@"slideNews"])
    {
        NewsViewController *vc = [[NewsViewController alloc]initWithNibName:[[User_Details sharedInstance]loadXibFile:@"NewsViewController"] bundle:nil];
        
        
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.menuVc,vc, nil];
        else
            self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.UserMneuVc,vc, nil];
        
        self.navigationController.navigationBarHidden = YES;
        
        self.frostedViewController.contentViewController = self.navigationController;
        
    }
    else if ([[self.imageItemsArray objectAtIndex:indexPath.row] isEqualToString:@"slideOffer"])
    {
        OffersViewController *vc = [[OffersViewController alloc]initWithNibName:[[User_Details sharedInstance]loadXibFile:@"OffersViewController"] bundle:nil];
        
        
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.menuVc,vc, nil];
        else
            self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.UserMneuVc,vc, nil];
        
        self.navigationController.navigationBarHidden = YES;
        
        self.frostedViewController.contentViewController = self.navigationController;
        
    }
    else if ([[self.imageItemsArray objectAtIndex:indexPath.row] isEqualToString:@"slideMessage"])
    {
        MessageViewController *vc = [[MessageViewController alloc]initWithNibName:[[User_Details sharedInstance]loadXibFile:@"MessageViewController"] bundle:nil];
        
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.menuVc,vc, nil];
        else
            self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.UserMneuVc,vc, nil];
        
        self.navigationController.navigationBarHidden = YES;
        
        self.frostedViewController.contentViewController = self.navigationController;
        
    }
    else if ([[self.imageItemsArray objectAtIndex:indexPath.row] isEqualToString:@"slideService"])
    {
        ServicesViewController *vc = [[ServicesViewController alloc]initWithNibName:[[User_Details sharedInstance]loadXibFile:@"ServicesViewController"] bundle:nil];
        
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.menuVc,vc, nil];
        else
            self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.UserMneuVc,vc, nil];
        
        self.navigationController.navigationBarHidden = YES;
        
        self.frostedViewController.contentViewController = self.navigationController;
        
    }
    else if ([[self.imageItemsArray objectAtIndex:indexPath.row] isEqualToString:@"slideCourse"])
    {
        CourseViewController *vc = [[CourseViewController alloc]initWithNibName:[[User_Details sharedInstance]loadXibFile:@"CourseViewController"] bundle:nil];
        
        
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.menuVc,vc, nil];
        else
            self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.UserMneuVc,vc, nil];
        
        self.navigationController.navigationBarHidden = YES;
        
        self.frostedViewController.contentViewController = self.navigationController;
        
    }
    else if ([[self.imageItemsArray objectAtIndex:indexPath.row] isEqualToString:@"slideProfile"])
    {
        
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
        {
            ProfileViewController *vc = [[ProfileViewController alloc]initWithNibName:[[User_Details sharedInstance]loadXibFile:@"ProfileViewController"] bundle:nil];
            
            
            if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
                self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.menuVc,vc, nil];
            else
                self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.UserMneuVc,vc, nil];
            
            self.navigationController.navigationBarHidden = YES;
            
            self.frostedViewController.contentViewController = self.navigationController;
        }
        else
        {
            UserProfileViewController *vc = [[UserProfileViewController alloc]initWithNibName:[[User_Details sharedInstance]loadXibFile:@"UserProfileViewController"] bundle:nil];
            
            if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
                self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.menuVc,vc, nil];
            else
                self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.UserMneuVc,vc, nil];
            
            self.navigationController.navigationBarHidden = YES;
            
            self.frostedViewController.contentViewController = self.navigationController;
        }
        
    }
    else if ([[self.imageItemsArray objectAtIndex:indexPath.row] isEqualToString:@"slideUser"])
    {
        UsersViewController *vc =  [[UsersViewController alloc]initWithNibName:[[User_Details sharedInstance]loadXibFile:@"UsersViewController"] bundle:nil];
        
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.menuVc,vc, nil];
        else
            self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.UserMneuVc,vc, nil];
        
        self.navigationController.navigationBarHidden = YES;
        
        self.frostedViewController.contentViewController = self.navigationController;
    }
    else if ([[self.imageItemsArray objectAtIndex:indexPath.row] isEqualToString:@"slideTicket"])
    {
        TicketsViewController *vc =  [[TicketsViewController alloc]initWithNibName:[[User_Details sharedInstance]loadXibFile:@"TicketsViewController"] bundle:nil];
        
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.menuVc,vc, nil];
        else
            self.navigationController.viewControllers = [NSArray arrayWithObjects:self.loginVc,self.UserMneuVc,vc, nil];
        
        self.navigationController.navigationBarHidden = YES;
        
        self.frostedViewController.contentViewController = self.navigationController;
    }
    
    */
    
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



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    
    headerView.backgroundColor = [UIColor colorWithRed:7.0/255.0 green:51.0/255.0 blue:169.0/255.0 alpha:1];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8.0, 30.0, 142.0, 45.0)];
    
    imageView.image = [UIImage imageNamed:@"menuLogo"];
    
    [headerView addSubview:imageView];
    
    
    UILabel *userTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, imageView.frame.origin.y + imageView.frame.size.height + 15, self.menuTableView.frame.size.width, 21)];
    
    userTypeLabel.textColor = [UIColor whiteColor];
    
    userTypeLabel.font = [UIFont boldSystemFontOfSize:16.0];
    
    //if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
        userTypeLabel.text = @"Admin";
   // else
       // userTypeLabel.text = @"User";
    
    [headerView addSubview:userTypeLabel];
    
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, userTypeLabel.frame.origin.y + userTypeLabel.frame.size.height , self.menuTableView.frame.size.width, 21)];
    
    userNameLabel.textColor = [UIColor whiteColor];
    
    userNameLabel.font = [UIFont systemFontOfSize:14.0];
    
    userNameLabel.text = @"Demo UserName";//[User_Details sharedInstance].userName;
    
    [headerView addSubview:userNameLabel];
    
    UILabel *studioNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, userNameLabel.frame.origin.y + userNameLabel.frame.size.height , self.menuTableView.frame.size.width, 21)];
    
    studioNameLabel.textColor = [UIColor whiteColor];
    
    studioNameLabel.font = [UIFont systemFontOfSize:14.0];
    
    studioNameLabel.text = @"Demo Studio Name";//[User_Details sharedInstance].profileName;
    
    [headerView addSubview:studioNameLabel];
    
    
    return self.menuTableHeaderView;
}
 



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}


@end
