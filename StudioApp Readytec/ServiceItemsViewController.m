//
//  ServiceItemsViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 1/4/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "ServiceItemsViewController.h"
#import "SVProgressHUD.h"
#import "RHWebServiceManager.h"
#import "User Details.h"
#import "ServiceDetailsObject.h"
#import "ServiceItemTableViewCell.h"
#import "ServiceItemHeaderView.h"
#import "ServiceDetailsViewController.h"

@interface ServiceItemsViewController ()<RHWebServiceDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray *serviceDetailsArray;
@property (strong,nonatomic) RHWebServiceManager *mywebService;
@property (strong,nonatomic) ServiceDetailsObject *detailsObject;


@property (weak, nonatomic) IBOutlet UITableView *serviceItemTableView;
@property (weak, nonatomic) IBOutlet UIButton *totalNumberOfUpdateButton;

@end

@implementation ServiceItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self CallServiceDetailsWebService];
    
    [self.totalNumberOfUpdateButton setTitle:self.service.totalUpdateCount forState:UIControlStateNormal];
    self.totalNumberOfUpdateButton.clipsToBounds = YES;
    self.totalNumberOfUpdateButton.layer.cornerRadius = 15.0;
    
    self.serviceItemTableView.estimatedRowHeight = 55;
    self.serviceItemTableView.rowHeight = UITableViewAutomaticDimension;
    self.serviceItemTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.serviceItemTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UINib *HeaderNib = [UINib nibWithNibName:@"ServiceItemHeaderView" bundle:nil];
    [self.serviceItemTableView registerNib:HeaderNib forHeaderFooterViewReuseIdentifier:@"itemHeader"];
    self.serviceItemTableView.estimatedSectionHeaderHeight = 30.0;
    self.serviceItemTableView.sectionHeaderHeight = UITableViewAutomaticDimension;
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
    
    if([segue.identifier isEqualToString:@"detaails"])
    {
        NSIndexPath *indexPath = [self.serviceItemTableView indexPathForSelectedRow];
        ServiceDetailsViewController *vc = segue.destinationViewController;
        vc.detailsObject = [self.serviceDetailsArray objectAtIndex:indexPath.row];
    }
}


#pragma mark Webservice Method Call

-(void) CallServiceDetailsWebService
{
    
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    
    if(!self.serviceDetailsArray)
        self.serviceDetailsArray = [NSMutableArray new];
    
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.serviceDetailsArray.count];
    self.urlString = [NSString stringWithFormat:@"%@%@",self.urlString,startingLimit];
    self.mywebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeServiceDetails Delegate:self];
    [self.mywebService getDataFromWebURL:self.urlString];
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    
    if (self.mywebService.requestType == HTTPRequestypeServiceDetails)
    {
        [self.serviceDetailsArray addObjectsFromArray:(NSArray *)responseObj];
    }
    
    [self.serviceItemTableView reloadData];
}

-(void) dataFromWebReceiptionFailed:(NSError*) error
{
    [SVProgressHUD dismiss];
    
    self.view.userInteractionEnabled = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:error.debugDescription preferredStyle:UIAlertControllerStyleAlert];
    
    
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
    
    if (self.serviceDetailsArray.count > 0)
    {
        self.serviceItemTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        numOfSections                 = 1;
        
        self.serviceItemTableView.backgroundView   = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(self.serviceItemTableView.frame.origin.x, self.serviceItemTableView.frame.origin.y, self.serviceItemTableView.bounds.size.width, self.serviceItemTableView.bounds.size.height)];
        
        noDataLabel.text             = NSLocalizedString(@"No services available.", Nil);
        
        noDataLabel.textColor        = [UIColor grayColor];
        
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        
        self.serviceItemTableView.backgroundView = noDataLabel;
        
        self.serviceItemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.serviceDetailsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"itemCell";
    ServiceItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    
    self.detailsObject = [self.serviceDetailsArray objectAtIndex:indexPath.row];
    cell.itemDateLabel.text = self.detailsObject.updateDateTime;
    cell.itemNameLabel.text = self.detailsObject.updateTitle;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ServiceItemHeaderView *headerView = [self.serviceItemTableView dequeueReusableHeaderFooterViewWithIdentifier:@"itemHeader"];
    headerView.serviceNameLabel.text = self.service.serviceCode;
    return headerView;
}


- ( UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= -40)
    {
        [self CallServiceDetailsWebService];
        
    }
}


@end
