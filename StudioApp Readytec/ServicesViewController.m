//
//  ServicesViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 12/4/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "ServicesViewController.h"
#import "ServicesTableViewCell.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "ServiceObject.h"
#import "User Details.h"
#import "DEMONavigationController.h"

@interface ServicesViewController ()<RHWebServiceDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegmentControl;
- (IBAction)mySegmentControlButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *serviceAddButton;
- (IBAction)serviceAddButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceOfSegmentControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfSegmentControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfServiceAddButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceOfTableview;
- (IBAction)slideMenuAction:(id)sender;


@property (strong,nonatomic) NSMutableArray *allAdminServicesArray,*myServicesArray,*allUserServicesArray,*allUserFlagArray;
@property (strong,nonatomic) RHWebServiceManager *myWebservice;
@property (strong,nonatomic) ServiceObject *object;

@property (weak, nonatomic) IBOutlet UITableView *serviceTableView;

@end

@implementation ServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.serviceAddButton.hidden = YES;
    
    if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
    {
        self.mySegmentControl.hidden = YES;
        self.topSpaceOfSegmentControl.constant = 0;
        self.heightOfSegmentControl.constant = 0;
        self.heightOfServiceAddButton.constant = 0;
        self.topSpaceOfTableview.constant = 0;
        [self.view setNeedsLayout];
    }
    else
    {
        self.mySegmentControl.hidden = NO;
        self.heightOfServiceAddButton.constant = 0;
        [self.view setNeedsLayout];
        
    }
    [self.serviceTableView reloadData];
    self.serviceTableView.rowHeight = UITableViewAutomaticDimension;
    self.serviceTableView.estimatedRowHeight = 55;
    self.serviceTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self makeRequiredWebServices];
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

-(void) makeRequiredWebServices
{
    if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
    {
        [self CallAllServicesWithUrl];
    }
    else
    {
        [self CallMyServicesWebservices];
    }
    
}



#pragma mark Webservice Method Call



-(void) CallAllServicesWithUrl
{
    
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    
    if(!self.allAdminServicesArray)
        self.allAdminServicesArray = [NSMutableArray new];
    
    NSString *str = [NSString stringWithFormat:@"%@app_studio_services_list_update_counting/%@/%@/",BASE_URL_API,[User_Details sharedInstance].userDetailsId,[User_Details sharedInstance].studio_Details_ID];
    
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.allAdminServicesArray.count];
    str = [NSString stringWithFormat:@"%@%@",str,startingLimit];
    self.myWebservice = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeAllWebservice Delegate:self];
    [self.myWebservice getDataFromWebURL:str];
    
}

-(void) CallMyServicesWebservices
{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    
    if(!self.myServicesArray)
        self.myServicesArray = [NSMutableArray new];
    
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.myServicesArray.count];
    NSString *str = [NSString stringWithFormat:@"%@app_user_services_list_update_counting/%@/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,[User_Details sharedInstance].studio_Details_ID,startingLimit];
    self.myWebservice = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeMyWebservice Delegate:self];
    [self.myWebservice getDataFromWebURL:str];
    
}


-(void) CallUserAllServiceWebservice
{
    
    
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    
    if(!self.allUserServicesArray)
        self.allUserServicesArray = [NSMutableArray new];
    
    if(!self.allUserFlagArray)
        self.allUserFlagArray = [NSMutableArray new];
    
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.allUserServicesArray.count];
    NSString *str = [NSString stringWithFormat:@"%@app_studio_user_services/%@/%@/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,[User_Details sharedInstance].studio_Details_ID,[User_Details sharedInstance].userDetailsId,startingLimit];
    self.myWebservice = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeUserAllWebservice Delegate:self];
    [self.myWebservice getDataFromWebURL:str];
    
    
    
}


-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    
    self.view.userInteractionEnabled = YES;
    
    if (self.myWebservice.requestType == HTTPRequestypeAllWebservice)
    {
        [self.allAdminServicesArray addObjectsFromArray:(NSArray *)responseObj];
        [self.serviceTableView reloadData];
    }
    else if (self.myWebservice.requestType == HTTPRequestypeMyWebservice)
    {
        [self.myServicesArray addObjectsFromArray:(NSArray *)responseObj];
        [self.serviceTableView reloadData];
    }
    else if (self.myWebservice.requestType == HTTPRequestypeUserAllWebservice)
    {
        [self.allUserServicesArray addObjectsFromArray:(NSArray *)responseObj];
        
        
        if(self.allUserFlagArray.count > 0)
        {
            [self.allUserFlagArray removeAllObjects];
            
            self.allUserFlagArray = nil;
            
            self.allUserFlagArray = [NSMutableArray  new];
        }
        
        for(ServiceObject *objectt in self.allUserServicesArray)
        {
            if([[objectt valueForKey:@"refUserServiceUserDetailsId"] isEqualToString:@"-"])
            {
                [self.allUserFlagArray addObject:@"0"];
            }
            else
            {
                [self.allUserFlagArray addObject:@"1"];
            }
        }
        
        [self.serviceTableView reloadData];
    }
    else if (self.myWebservice.requestType == HTTPRequestypeAddRemoveService)
    {
        if([[responseObj valueForKey:@"success_status"] isEqualToNumber:[NSNumber numberWithInt:1]])
        {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:@"Successfully done." preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                
                [alert dismissViewControllerAnimated:YES completion:nil];
                
                //self.serviceSegmentControl.selectedSegmentIndex = 0;
                
                [self CallMyServicesWebservices];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    
    NSArray *tempArray;
    
    if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
    {
        tempArray = self.allAdminServicesArray;
    }
    else
    {
        if(self.mySegmentControl.selectedSegmentIndex == 0)
            tempArray = self.myServicesArray;
        else
            tempArray = self.allUserServicesArray;
    }
    
    
    if (tempArray.count > 0)
    {
        self.serviceTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        numOfSections                 = 1;
        
        self.serviceTableView.backgroundView   = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(self.serviceTableView.frame.origin.x, self.serviceTableView.frame.origin.y, self.serviceTableView.bounds.size.width, self.serviceTableView.bounds.size.height)];
        
        noDataLabel.text             = NSLocalizedString(@"No service available.", Nil);
        
        noDataLabel.textColor        = [UIColor grayColor];
        
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        
        self.serviceTableView.backgroundView = noDataLabel;
        
        self.serviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
    {
        return self.allAdminServicesArray.count;
    }
    else
    {
        if(self.mySegmentControl.selectedSegmentIndex == 0)
            return self.myServicesArray.count;
        else
            return self.allUserServicesArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"serviceCell";
    
    ServicesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
    {
        self.object = [self.allAdminServicesArray objectAtIndex:indexPath.row];
        [cell.serviceAccessoryButton setTitle:self.object.totalUpdateCount forState:UIControlStateNormal];
    }
    else
    {
        if(self.mySegmentControl.selectedSegmentIndex == 0)
        {
            self.object = [self.myServicesArray objectAtIndex:indexPath.row];
            [cell.serviceAccessoryButton setTitle:self.object.totalUpdateCount forState:UIControlStateNormal];
            
        }
        else
        {
            self.object = [self.allUserServicesArray objectAtIndex:indexPath.row];
            cell.serviceAccessoryButton.backgroundColor = [UIColor whiteColor];
            
            if([[self.allUserFlagArray objectAtIndex:indexPath.row] isEqualToString:@"1"])
                [cell.serviceAccessoryButton setImage:[UIImage imageNamed:@"serviceAdd"] forState:UIControlStateNormal];
            else
                [cell.serviceAccessoryButton setImage:[UIImage imageNamed:@"serviceRemove"] forState:UIControlStateNormal];
            
//            cell.totalUpdateLabel.hidden = YES;serviceRemove
//            
//            cell.addremoveView.hidden = NO;
//            
//            cell.addRemoveImageVew.hidden = NO;
//            
//            cell.addRemoveButton.hidden = NO;
//            
//            if([[self.allUserFlagArray objectAtIndex:indexPath.row] isEqualToString:@"1"])
//                cell.addRemoveImageVew.image = [UIImage imageNamed:@"serviceAdd"];
//            else
//                cell.addRemoveImageVew.image = [UIImage imageNamed:@"serviceRemove"];
//            
//            cell.addRemoveButton.tag = 1000 + indexPath.row;
//            
//            [cell.addRemoveButton addTarget:self action:@selector(serviceAddRemoveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                if(self.mySegmentControl.selectedSegmentIndex == 1)
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                else
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
    }
    
    cell.serviceCodeNameLabel.text = self.object.serviceCode;
    cell.serviceNameLabel.text = self.object.serviceName;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
            [self CallAllServicesWithUrl];
            
        }
        else
        {
//            if(self.serviceSegmentControl.selectedSegmentIndex == 0)
//            {
//                [self CallMyServicesWebservices];
//            }
//            else
//            {
//                [self CallUserAllServiceWebservice];
//            }
        }
        
    }
    
    
    
}


- (IBAction)mySegmentControlButtonAction:(id)sender {
    
    if(self.mySegmentControl.selectedSegmentIndex == 0)
    {
        self.serviceAddButton.hidden = YES;
        self.heightOfServiceAddButton.constant = 0;
        [self.view setNeedsLayout];
    }
    else
    {
        self.serviceAddButton.hidden = NO;
        self.heightOfServiceAddButton.constant = 50;
        [self.view setNeedsLayout];
    }
    [self.serviceTableView reloadData];
}
- (IBAction)serviceAddButtonAction:(id)sender {
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
