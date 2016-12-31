//
//  UserDetailsViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/25/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "UserDetailsViewController.h"
#import "ProfileTableViewCell.h"
#import "ProfileHeaderview.h"
#import "EditUserViewController.h"
#import "User Details.h"
#import "SVProgressHUD.h"
#import "RHWebServiceManager.h"

@interface UserDetailsViewController ()<RHWebServiceDelegate>

@property (strong,nonatomic) RHWebServiceManager *myWebservice;

@property (weak, nonatomic) IBOutlet UITableView *userDetailsTableview;
@property (weak, nonatomic) IBOutlet UIButton *deactivateButton;

- (IBAction)deactivateButtonAction:(id)sender;

@end

@implementation UserDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userDetailsTableview.estimatedRowHeight = 50;
    self.userDetailsTableview.rowHeight = UITableViewAutomaticDimension;
    self.userDetailsTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.userDetailsTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UINib *profileHeaderNib = [UINib nibWithNibName:@"profileHeaderView" bundle:nil];
    [self.userDetailsTableview registerNib:profileHeaderNib forHeaderFooterViewReuseIdentifier:@"profileHeader"];
    self.userDetailsTableview.sectionHeaderHeight = 130.0;
    
    if([self.object.userAddedByAdmin isEqualToString:@"1"])
    {
        self.deactivateButton.hidden = NO;
    
        if([self.object.userActive isEqualToString:@"1"])
        {
            [self.deactivateButton setTitle:NSLocalizedString(@"Deactivate", Nil) forState:UIControlStateNormal];
        }
        else
        {
            [self.deactivateButton setTitle:NSLocalizedString(@"Activate", Nil) forState:UIControlStateNormal];
            
        }
    }
    else
    {
        self.deactivateButton.hidden = YES;
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"userEdit"])
    {
        EditUserViewController *vc = segue.destinationViewController;
        vc.userObject = self.object;
        vc.addUser = NO;
    }
}


#pragma mark table view Delegate Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"profileCell";
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    
    if(indexPath.row == 0)
    {
        cell.keyLabel.text = NSLocalizedString(@"First Name", Nil);
        cell.valueLabel.text = self.object.firstName;
    }
    else if (indexPath.row == 1)
    {
        cell.keyLabel.text = NSLocalizedString(@"Last Name", Nil);
        cell.valueLabel.text = self.object.lastName;

    }
    else if (indexPath.row == 2)
    {
        cell.keyLabel.text = NSLocalizedString(@"UserName", Nil);
        cell.valueLabel.text = self.object.userName;

    }
    else if (indexPath.row == 3)
    {
        cell.keyLabel.text = NSLocalizedString(@"Password", Nil);
        cell.valueLabel.text = self.object.password;

    }
    else if (indexPath.row == 4)
    {
        cell.keyLabel.text = NSLocalizedString(@"Cell Phone", Nil);
        cell.valueLabel.text = self.object.Email;

    }
    else if (indexPath.row == 5)
    {
        cell.keyLabel.text = NSLocalizedString(@"Email", Nil);
        cell.valueLabel.text = self.object.cellPhone;

    }
    else if (indexPath.row == 6)
    {
        cell.keyLabel.text = NSLocalizedString(@"City", Nil);
        cell.valueLabel.text = self.object.city;

    }
    else if (indexPath.row == 7)
    {
        cell.keyLabel.text = NSLocalizedString(@"Country", Nil);
        cell.valueLabel.text = self.object.country;

    }
    
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
    
    ProfileHeaderview *profileHeaderView = [self.userDetailsTableview dequeueReusableHeaderFooterViewWithIdentifier:@"profileHeader"];
    profileHeaderView.profileName.text = self.object.userName;
    profileHeaderView.locationName.text = self.object.country;

    
    return profileHeaderView;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}


- (IBAction)deactivateButtonAction:(id)sender
{
    NSString *urlStr;
    
    if([self.object.userActive isEqualToString:@"1"])
    {
        urlStr = [NSString stringWithFormat:@"%@app_studio_deactivate_user/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,self.object.targetUserDetailsId];
        
    }
    else
    {
        urlStr = [NSString stringWithFormat:@"%@app_studio_activate_user/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,self.object.targetUserDetailsId];
    }
    
    [self MakeUserActiveDeactivateWebservice:urlStr];
}

-(void) MakeUserActiveDeactivateWebservice:(NSString *)urlStr
{
    [SVProgressHUD show];
    self.myWebservice = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeUserActiveDeactivateWebService Delegate:self];
    [self.myWebservice getDataFromWebURL:urlStr];
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    
    self.view.userInteractionEnabled = YES;
    
    if (self.myWebservice.requestType == HTTPRequestypeUserActiveDeactivateWebService)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:NSLocalizedString(@"Successfully done.", Nil) preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            [alert dismissViewControllerAnimated:YES completion:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
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

@end
