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
@interface ProfileViewController ()<RHWebServiceDelegate>

@property (strong,nonatomic) RHWebServiceManager *myWebserviceManager;
@property (strong,nonatomic) UserInfoObject *profile;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        /*
        self.profileName.text = [User_Details sharedInstance].profileName;
        
        self.pivaLabel.text = [responseObj valueForKey:@"studio_details_license_piva"];
        
        self.emailLabel.text = [responseObj valueForKey:@"studio_details_all_email_address"];
        
        self.totalUserLabel.text = [responseObj valueForKey:@"total_users"];
        
        self.totalServiceLabel.text = [responseObj valueForKey:@"total_services"];
        
        self.codeLabel.text = [responseObj valueForKey:@"studio_details_all_services_list"];
        
        CGRect frame = self.emailLabel.frame;
        
        frame.size.height = [self heightForText:self.emailLabel.text font:self.emailLabel.font withinWidth:self.emailLabel.frame.size.width];
        
        self.emailLabel.frame = frame;
        
        frame = self.codeLabel.frame;
        
        frame.size.height = [self heightForText:self.codeLabel.text font:self.codeLabel.font withinWidth:self.codeLabel.frame.size.width];
        
        self.codeLabel.frame = frame;
        
        
        self.emailView.frame = CGRectMake(self.emailView.frame.origin.x, self.emailView.frame.origin.y, self.emailView.frame.size.width, [self heightForText:self.emailLabel.text font:self.emailLabel.font withinWidth:self.emailLabel.frame.size.width] + 16);
        
        self.totalUserView.frame = CGRectMake(self.totalUserView.frame.origin.x, self.emailView.frame.origin.y + self.emailView.frame.size.height + 8, self.totalUserView.frame.size.width, self.totalUserView.frame.size.height);
        
        self.totalServiceView.frame = CGRectMake(self.totalServiceView.frame.origin.x, self.totalUserView.frame.origin.y + self.totalUserView.frame.size.height + 8, self.totalServiceView.frame.size.width, self.totalServiceView.frame.size.height);
        
        self.serviceCodeView.frame = CGRectMake(self.serviceCodeView.frame.origin.x, self.totalServiceView.frame.origin.y + self.totalServiceView.frame.size.height + 8, self.serviceCodeView.frame.size.width,[self heightForText:self.codeLabel.text font:self.codeLabel.font withinWidth:self.codeLabel.frame.size.width] + 16);
        
        self.userScollView.contentSize = CGSizeMake(self.userScollView.frame.size.width, self.serviceCodeView.frame.origin.y + self.serviceCodeView.frame.size.height + 10);
        */
    }
    else if(self.myWebserviceManager.requestType == HTTPRequestypeUserProfile)
    {
        
        self.profile = (UserInfoObject *)responseObj;
        
        //[self ShowProfileInfo];
        
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
