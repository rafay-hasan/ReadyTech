//
//  ProfileViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/8/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "ProfileViewController.h"
#import "DEMONavigationController.h"
#import "User Details.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "UserInfoObject.h"
#import "ProfileHeaderview.h"
#import "ProfileTableViewCell.h"
@interface ProfileViewController ()<RHWebServiceDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) RHWebServiceManager *myWebserviceManager;
@property (strong,nonatomic) UserInfoObject *profile;
@property (strong,nonatomic) NSMutableArray *profileKeyArray,*profileValueArray;



@property (weak, nonatomic) IBOutlet UITableView *profileTableview;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
- (IBAction)editButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editButtonTopSpace;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
    {
        self.editButton.hidden = YES;
        self.editButtonTopSpace.constant = 0;
        [self.view setNeedsLayout];
    }
    else
    {
        self.editButton.hidden = NO;
        self.editButtonTopSpace.constant = 10;
        [self.view setNeedsLayout];
    }
    
    self.profileTableview.estimatedRowHeight = 50;
    self.profileTableview.rowHeight = UITableViewAutomaticDimension;
    self.profileTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.profileTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UINib *profileHeaderNib = [UINib nibWithNibName:@"profileHeaderView" bundle:nil];
    [self.profileTableview registerNib:profileHeaderNib forHeaderFooterViewReuseIdentifier:@"profileHeader"];
    self.profileTableview.sectionHeaderHeight = 130.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
    {
        [self CallAdminProfileWebservice];
    }
    else
    {
        [self CalluserProfileWebservice];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) CalluserProfileWebservice
{
    
    [SVProgressHUD show];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@app_user_profile/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,[User_Details sharedInstance].studio_Details_ID];
    
    self.myWebserviceManager = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeUserProfile Delegate:self];
    
    [self.myWebserviceManager getDataFromWebURL:urlStr];
    
}


-(void) CallAdminProfileWebservice
{
    
    [SVProgressHUD show];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@app_studio_profile/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,[User_Details sharedInstance].studio_Details_ID];
    
    self.myWebserviceManager = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeAdminProfile Delegate:self];
    
    [self.myWebserviceManager getDataFromWebURL:urlStr];
    
}


-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    
    self.view.userInteractionEnabled = YES;
    
    if(self.myWebserviceManager.requestType == HTTPRequestypeAdminProfile)
    {
        
        self.profileKeyArray = [NSMutableArray new];
        self.profileValueArray = [NSMutableArray new];
        
        [self.profileKeyArray addObject:NSLocalizedString(@"P.IVA", Nil)];
        [self.profileValueArray addObject:[responseObj valueForKey:@"studio_details_license_piva"]];
        
        [self.profileKeyArray addObject:NSLocalizedString(@"Email", Nil)];
        [self.profileValueArray addObject:[responseObj valueForKey:@"studio_details_all_email_address"]];
        
        [self.profileKeyArray addObject:NSLocalizedString(@"Total Users", Nil)];
        [self.profileValueArray addObject:[responseObj valueForKey:@"total_users"]];

        [self.profileKeyArray addObject:NSLocalizedString(@"Total Services", Nil)];
        [self.profileValueArray addObject:[responseObj valueForKey:@"total_services"]];

        [self.profileKeyArray addObject:NSLocalizedString(@"Service Codes", Nil)];
        [self.profileValueArray addObject:[responseObj valueForKey:@"studio_details_all_services_list"]];

         [self.profileTableview reloadData];
    }
    else if(self.myWebserviceManager.requestType == HTTPRequestypeUserProfile)
    {
        
        self.profile = (UserInfoObject *)responseObj;
        
        self.profileKeyArray = [NSMutableArray new];
        self.profileValueArray = [NSMutableArray new];
        
        [self.profileKeyArray addObject:NSLocalizedString(@"First Name", Nil)];
        [self.profileValueArray addObject:self.profile.firstName];
        
        [self.profileKeyArray addObject:NSLocalizedString(@"Last Name", Nil)];
        [self.profileValueArray addObject:self.profile.lastName];
        
        [self.profileKeyArray addObject:NSLocalizedString(@"UserName", Nil)];
        [self.profileValueArray addObject:self.profile.userName];
        
        [self.profileKeyArray addObject:NSLocalizedString(@"Password", Nil)];
        [self.profileValueArray addObject:self.profile.password];
        
        [self.profileKeyArray addObject:NSLocalizedString(@"Email", Nil)];
        [self.profileValueArray addObject:self.profile.Email];
        
        [self.profileKeyArray addObject:NSLocalizedString(@"User Total Services", Nil)];
        [self.profileValueArray addObject:self.profile.totalUserService];
        
        [self.profileKeyArray addObject:NSLocalizedString(@"Studio Total Services", Nil)];
        [self.profileValueArray addObject:self.profile.totalStudioService];
        
        [self.profileTableview reloadData];
        
    }
}


-(void) dataFromWebReceiptionFailed:(NSError*) error
{
    [SVProgressHUD dismiss];
    
    self.view.userInteractionEnabled = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

#pragma mark table view Delegate Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    
    if (self.profileKeyArray.count > 0)
    {
        self.profileTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        numOfSections                 = 1;
        
        self.profileTableview.backgroundView   = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(self.profileTableview.frame.origin.x, self.profileTableview.frame.origin.y, self.profileTableview.bounds.size.width, self.profileTableview.bounds.size.height)];
        
        noDataLabel.text             = NSLocalizedString(@"No data available.", Nil);
        
        noDataLabel.textColor        = [UIColor grayColor];
        
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        
        self.profileTableview.backgroundView = noDataLabel;
        
        self.profileTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.profileKeyArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"profileCell";
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    
    cell.keyLabel.text = [self.profileKeyArray objectAtIndex:indexPath.row];
    cell.valueLabel.text = [self.profileValueArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 130.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.00;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ProfileHeaderview *profileHeaderView = [self.profileTableview dequeueReusableHeaderFooterViewWithIdentifier:@"profileHeader"];
    profileHeaderView.profileName.text = [User_Details sharedInstance].profileName;
    profileHeaderView.locationName.text = NSLocalizedString(@"ITALY", Nil);
    
    return profileHeaderView;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}


- (IBAction)editButtonAction:(id)sender {
}
@end
