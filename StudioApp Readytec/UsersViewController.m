//
//  UsersViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/23/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "UsersViewController.h"
#import "UsersTableViewCell.h"
#import "DEMONavigationController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "UserInfoObject.h"
#import "User Details.h"
#import "UserDetailsViewController.h"

@interface UsersViewController ()<UITableViewDataSource,UIAlertViewDelegate,RHWebServiceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *usertableView;
@property (strong,nonatomic) RHWebServiceManager *myWebservice;
@property (strong,nonatomic) UserInfoObject *userObject;
@property (strong,nonatomic) NSMutableArray *userDataArray;

- (IBAction)slideMenuAction:(id)sender;

@end

@implementation UsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    
    self.usertableView.estimatedRowHeight = 70;
    self.usertableView.rowHeight = UITableViewAutomaticDimension;
    
    self.usertableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.usertableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.userDataArray = [NSMutableArray new];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self CallUserInfoWebservice];
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
    NSInteger numOfSections = 0;
    
    if (self.userDataArray.count > 0)
    {
        self.usertableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        numOfSections                 = 1;
        
        self.usertableView.backgroundView   = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(self.usertableView.frame.origin.x, self.usertableView.frame.origin.y, self.usertableView.bounds.size.width, self.usertableView.bounds.size.height)];
        
        noDataLabel.text             = NSLocalizedString(@"No user available.", Nil);
        
        noDataLabel.textColor        = [UIColor grayColor];
        
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        
        self.usertableView.backgroundView = noDataLabel;
        
        self.usertableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"userCell";
    UsersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    self.userObject = [self.userDataArray objectAtIndex:indexPath.row];
    cell.userNameLabel.text = self.userObject.userName;
    cell.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@",self.userObject.firstName,self.userObject.lastName];
    cell.userLocationNameLabel.text = self.userObject.country;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserDetailsViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"userDetails"];
    UserInfoObject *obj = [self.userDataArray objectAtIndex:indexPath.row];
    controller.object = obj;
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

-(void) CallUserInfoWebservice
{
    
    [SVProgressHUD show];
    
    self.view.userInteractionEnabled = NO;
    
    if(!self.userDataArray)
        self.userDataArray = [NSMutableArray new];
    
    
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.userDataArray.count];
    
    NSString *str = [NSString stringWithFormat:@"%@app_studio_users/%@/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,[User_Details sharedInstance].studio_Details_ID,startingLimit];
    
    
    self.myWebservice = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeUsersWebService Delegate:self];
    
    [self.myWebservice getDataFromWebURL:str];
    
    
    
}


-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    
    if (self.myWebservice.requestType == HTTPRequestypeUsersWebService)
    {
        [self.userDataArray addObjectsFromArray:(NSArray *)responseObj];
        [self.usertableView reloadData];
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


- (IBAction)slideMenuAction:(id)sender {
    
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];

}
@end
