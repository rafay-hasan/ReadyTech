//
//  LoginViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 10/27/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "RHWebServiceManager.h"
#import "User Details.h"
#import "MenuAdminViewController.h"
@interface LoginViewController ()<RHWebServiceDelegate>

@property(strong,nonatomic) RHWebServiceManager *myWebService;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfiled;

- (IBAction)loginButtonAction:(id)sender;



@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
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


- (IBAction)loginButtonAction:(id)sender {
    
    if(self.userNameTextfield.text.length > 0 && self.passwordTextfiled.text.length > 0)
    {
        [self callLoginWebservice];
    }
    else
    {
        NSString *message;
        
        if(self.userNameTextfield.text.length == 0)
            message = @"Inserisci il tuo username e password.";
        else
            message = @"Inserisci il tuo username e password.";
        
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }

    
}

#pragma mark login Webservice methods

-(void) callLoginWebservice
{
    [SVProgressHUD show];
    
    self.view.userInteractionEnabled = NO;

    NSString *urlStr = [NSString stringWithFormat:@"%@app_ios_login_auth",BASE_URL_API];
    
    NSString *bbs_device_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"bbs_device_token"];
    
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:self.userNameTextfield.text,@"user_name",self.passwordTextfiled.text,@"password",@"12345",@"ios_device_id",@"123456789",@"ios_push_id",nil];
    
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypLogin Delegate:self];
    
    [self.myWebService getPostDataFromWebURLWithUrlString:urlStr dictionaryData:postData];
    
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    
    self.view.userInteractionEnabled = YES;
    
    if(self.myWebService.requestType == HTTPRequestypLogin)
    {
        NSLog(@"response is %@",responseObj);
        
        NSDictionary *tempDic = (NSDictionary *)responseObj;
        
        if([[tempDic valueForKey:@"login_status"] isEqualToNumber:[NSNumber numberWithInt:1]])
        {
            User_Details *user = [User_Details sharedInstance];
            
            if(![[tempDic valueForKey:@"user_details_id"] isKindOfClass:[NSNull class]])
            {
                user.userDetailsId = [NSString stringWithFormat:@"%@",[tempDic valueForKey:@"user_details_id"]];
                
                user.studio_Details_ID = [NSString stringWithFormat:@"%@",[tempDic valueForKey:@"studio_details_id"]];
                
                user.userTypeId = [NSString stringWithFormat:@"%@",[tempDic valueForKey:@"ref_user_details_user_type_id"]];
                user.groupId = [NSString stringWithFormat:@"%@",[tempDic valueForKey:@"user_group_id"]];
                user.profileName = [NSString stringWithFormat:@"%@",[tempDic valueForKey:@"studio_details_name"]];
                
                user.userName = [NSString stringWithFormat:@"%@",[tempDic valueForKey:@"user_details_user_name"]];
            }
            
            
            if([user.userTypeId isEqualToString:@"1"])
            {
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MenuAdminViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"adminMenu"];
                [self.navigationController pushViewController:controller animated:YES];
            }
            else
            {
               // UserTypeViewController *vc = [[UserTypeViewController alloc]initWithNibName:[[User_Details sharedInstance]loadXibFile:@"UserTypeViewController"] bundle:nil];
                
               // [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:@"Username o password sbagliata prova di nuovo." preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
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
