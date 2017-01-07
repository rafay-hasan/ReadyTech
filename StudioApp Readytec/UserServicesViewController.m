//
//  UserServicesViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 1/1/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "UserServicesViewController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "ServiceObject.h"
#import "ServicesTableViewCell.h"

@interface UserServicesViewController ()<RHWebServiceDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) RHWebServiceManager *myWebservice;
@property (strong,nonatomic) NSMutableArray *adminServicelistArray,*flagArray;
@property (strong,nonatomic) ServiceObject *object;


@property (weak, nonatomic) IBOutlet UITableView *adminServiceTableview;
- (IBAction)serviceAddButtonAction:(id)sender;

@end

@implementation UserServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.adminServiceTableview.estimatedRowHeight = 80;
    self.adminServiceTableview.rowHeight = UITableViewAutomaticDimension;
    self.adminServiceTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.adminServiceTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = NSLocalizedString(@"Services", Nil);
}


-(void) viewDidAppear:(BOOL)animated
{
    [self CallAllServiceWebservice];
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

-(void) CallAllServiceWebservice
{
    
    
    [SVProgressHUD show];
    
    if(!self.adminServicelistArray)
        self.adminServicelistArray = [NSMutableArray new];
    
    if(!self.flagArray)
        self.flagArray = [NSMutableArray new];
    
    
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.adminServicelistArray.count];
    
    NSString *str = [NSString stringWithFormat:@"%@app_studio_user_services/%@/%@/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,[User_Details sharedInstance].studio_Details_ID,self.userObject.targetUserDetailsId,startingLimit];
    
    self.myWebservice = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeUserAllWebservice Delegate:self];
    
    [self.myWebservice getDataFromWebURL:str];
    
    
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    
    self.view.userInteractionEnabled = YES;
    
    if (self.myWebservice.requestType == HTTPRequestypeUserAllWebservice)
    {
        
        NSArray *tempArray = (NSArray *)responseObj;
        
        [self.adminServicelistArray addObjectsFromArray:tempArray];
        
        for(ServiceObject *objectt in tempArray)
        {
            
            if([[objectt valueForKey:@"refUserServiceUserDetailsId"] isEqualToString:@"-"])
            {
                [self.flagArray addObject:@"0"];
            }
            else
            {
                [self.flagArray addObject:@"1"];
            }
        }
        
        [self.adminServiceTableview reloadData];
    }
    else
    {
        NSString *status = [NSString stringWithFormat:@"%@",[responseObj valueForKey:@"success_status"]];
        if([status isEqualToString:@"1"])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:@"Successfully Done." preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                
                [alert dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];

        }
        NSLog(@"response is %@",responseObj);
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    
    if (self.adminServicelistArray.count > 0)
    {
        self.adminServiceTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        numOfSections                 = 1;
        
        self.adminServiceTableview.backgroundView   = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(self.adminServiceTableview.frame.origin.x, self.adminServiceTableview.frame.origin.y, self.adminServiceTableview.bounds.size.width, self.adminServiceTableview.bounds.size.height)];
        
        noDataLabel.text             = NSLocalizedString(@"No service available.", Nil);
        
        noDataLabel.textColor        = [UIColor grayColor];
        
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        
        self.adminServiceTableview.backgroundView = noDataLabel;
        
        self.adminServiceTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return self.adminServicelistArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"serviceCell";
    
    ServicesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    self.object = [self.adminServicelistArray objectAtIndex:indexPath.row];
    cell.serviceCodeNameLabel.text = self.object.serviceCode;
    cell.serviceNameLabel.text = self.object.serviceName;
    cell.serviceAccessoryButton.backgroundColor = [UIColor clearColor];
    if([[self.flagArray objectAtIndex:indexPath.row] isEqualToString:@"1"])
         [cell.serviceAccessoryButton setImage:[UIImage imageNamed:@"serviceAdd"] forState:UIControlStateNormal];
    else
        [cell.serviceAccessoryButton setImage:[UIImage imageNamed:@"serviceRemove"] forState:UIControlStateNormal];
    
    cell.serviceAccessoryButton.tag = 1000 + indexPath.row;
    [cell.serviceAccessoryButton addTarget:self action:@selector(selectServiceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([[self.flagArray objectAtIndex:indexPath.row] isEqualToString:@"1"])
        [self.flagArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
    else
        [self.flagArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    
    [self.adminServiceTableview reloadData];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= -40)
    {
        
        if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
        {
            [self CallAllServiceWebservice];
            
        }
        
    }
    
    
    
}

-(void) selectServiceButtonAction:(UIButton *)sender
{
    if([[self.flagArray objectAtIndex:sender.tag - 1000] isEqualToString:@"1"])
        [self.flagArray replaceObjectAtIndex:sender.tag - 1000 withObject:@"0"];
    else
        [self.flagArray replaceObjectAtIndex:sender.tag - 1000 withObject:@"1"];
    
    [self.adminServiceTableview reloadData];
}




- (IBAction)serviceAddButtonAction:(id)sender {
    
    [SVProgressHUD show];
    
    NSInteger totalSelected = 0;
    NSString *allServiceId;
    
    for(NSInteger i=0; i< self.flagArray.count; i++)
    {
        if([[self.flagArray objectAtIndex:i] isEqualToString:@"1"])
        {
            self.object = [self.adminServicelistArray objectAtIndex:i];
            
            if(totalSelected == 0)
                allServiceId = self.object.serviceId;
            else
                allServiceId = [NSString stringWithFormat:@"%@,%@",allServiceId,self.object.serviceId];
            
            totalSelected = totalSelected + 1;
            
        }
    }
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)totalSelected];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:allServiceId,@"selected_services_id", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@app_studio_add_users_services/%@/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,self.userObject.targetUserDetailsId,str];
    
    self.myWebservice = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeAddRemoveService Delegate:self];
    
    [self.myWebservice getPostDataFromWebURLWithUrlString:urlStr dictionaryData:dic];
}
@end
