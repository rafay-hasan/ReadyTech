//
//  EditUserViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 12/31/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "EditUserViewController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "DEMONavigationController.h"
@interface EditUserViewController ()<RHWebServiceDelegate>

@property (strong,nonatomic) RHWebServiceManager *myWebservice;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

- (IBAction)submitButtonAction:(id)sender;
- (IBAction)slideMenuAction:(id)sender;


@end

@implementation EditUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(makeKeyBoardDismiss)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self makeViewLocalized];
    
    if(self.addUser)
    {
        [self makeViewForAdd];
        self.title = NSLocalizedString(@"Add User", Nil);

    }
    else
    {
        [self makeViewForEdit];
         self.title = NSLocalizedString(@"Edit User", Nil);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) makeViewForEdit
{
    
    self.firstNameTextField.text = self.userObject.firstName;
    self.lastNameTextField.text = self.userObject.lastName;
    self.userNameTextField.text = self.userObject.userName;
    self.passwordTextField.text = self.userObject.password;
    self.rePasswordTextField.text = self.userObject.password;
    self.emailTextField.text = self.userObject.Email;
    
    self.userNameTextField.enabled = NO;
    
    if([self.userObject.userAddedByAdmin isEqualToString:@"1"])
    {
        self.passwordTextField.enabled = YES;
        self.rePasswordTextField.enabled = YES;
        self.firstNameTextField.tag = 1000;
        self.lastNameTextField.tag = 2000;
        self.passwordTextField.tag = 3000;
        self.rePasswordTextField.tag = 4000;
        self.emailTextField.tag = 5000;
    }
    else
    {
        self.passwordTextField.enabled = NO;
        self.rePasswordTextField.enabled = NO;
        self.firstNameTextField.tag = 1000;
        self.lastNameTextField.tag = 2000;
        self.emailTextField.tag = 3000;
        
    }

}

-(void) makeViewForAdd
{
    self.firstNameTextField.tag = 1000;
    self.lastNameTextField.tag = 2000;
    self.userNameTextField.tag = 3000;
    self.passwordTextField.tag = 4000;
    self.rePasswordTextField.tag = 5000;
    self.emailTextField.tag = 6000;
}

-(void) makeViewLocalized
{
    
    UILabel *firstName = (UILabel *)[self.view viewWithTag:1001];
    
    firstName.text = NSLocalizedString(@"First Name", Nil);
    
    UILabel *lastName = (UILabel *)[self.view viewWithTag:1002];
    
    lastName.text = NSLocalizedString(@"Last Name", Nil);
    
    UILabel *username = (UILabel *)[self.view viewWithTag:1003];
    
    username.text = NSLocalizedString(@"UserName", Nil);
    
    UILabel *password = (UILabel *)[self.view viewWithTag:1004];
    
    password.text = NSLocalizedString(@"Password", Nil);
    
    UILabel *rePassword = (UILabel *)[self.view viewWithTag:1005];
    
    rePassword.text = NSLocalizedString(@"Re Password", Nil);
    
    UILabel *email = (UILabel *)[self.view viewWithTag:1006];
    
    email.text = NSLocalizedString(@"Email", Nil);
    
    UIButton *random = (UIButton *)[self.view viewWithTag:1007];
    
    [random setTitle:NSLocalizedString(@"SAVE", Nil) forState:UIControlStateNormal];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    if(textField.returnKeyType==UIReturnKeyNext)
    {
        UITextField *textFieldd = (UITextField*)[self.view viewWithTag:textField.tag + 1000];
        
        [textFieldd becomeFirstResponder];
        
    } else if (textField.returnKeyType==UIReturnKeyDone)
    {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void) makeKeyBoardDismiss
{
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField resignFirstResponder];
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.rePasswordTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
}

#pragma mark WebService 

-(void) saveUserDetailsInfo
{
    [SVProgressHUD show];
    
    NSString *str = [NSString stringWithFormat:@"%@app_studio_edit_user/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,self.userObject.targetUserDetailsId];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.firstNameTextField.text,@"firstName",self.lastNameTextField.text,@"lastName",self.passwordTextField.text,@"password",self.emailTextField.text,@"email", nil];
    
    self.myWebservice = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeEditUsersWebService Delegate:self];
    
    [self.myWebservice getPostDataFromWebURLWithUrlString:str dictionaryData:dic];
    
    
}

-(void) AddUserInfo
{
    [SVProgressHUD show];
    
    NSString *str = [NSString stringWithFormat:@"%@app_studio_add_new_user/%@/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,[User_Details sharedInstance].studio_Details_ID,[User_Details sharedInstance].groupId];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.firstNameTextField.text,@"firstName",self.lastNameTextField.text,@"lastName",self.passwordTextField.text,@"password",self.emailTextField.text,@"email",self.userNameTextField.text,@"userName", nil];
    
    self.myWebservice = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeEditUsersWebService Delegate:self];
    
    [self.myWebservice getPostDataFromWebURLWithUrlString:str dictionaryData:dic];

}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    
    self.view.userInteractionEnabled = YES;
    
    
    if (self.myWebservice.requestType == HTTPRequestypeEditUsersWebService)
    {
        if([[responseObj valueForKey:@"success_status"] isEqualToNumber:[NSNumber numberWithInt:1]])
        {
            NSString *msg;
            
            if(self.addUser)
                msg = NSLocalizedString(@"User added successfully.", Nil);
            else
                msg = NSLocalizedString(@"User edited successfully.", Nil);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:msg preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                
                [alert dismissViewControllerAnimated:YES completion:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", Nil) message:NSLocalizedString(@"Something went wrong.Please try again later.", Nil) preferredStyle:UIAlertControllerStyleAlert];
            
            
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



- (IBAction)submitButtonAction:(id)sender {
    
    if(self.addUser)
    {
        if([self.passwordTextField.text isEqualToString:self.rePasswordTextField.text])
            [self AddUserInfo];
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:@"Password and re-password doesn't match" preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];

        }
    }
    else
    {
        [self saveUserDetailsInfo];
    }
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
