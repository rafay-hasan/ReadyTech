//
//  TicketDetailsViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 12/3/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "TicketDetailsViewController.h"
#import "TicketDetailsHeaderView.h"
#import "TicketDetailsTableViewCell.h"
#import "TicketDetailsObject.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"

@interface TicketDetailsViewController ()<RHWebServiceDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) NSArray *ticketDetailsArray;
@property (strong,nonatomic)TicketDetailsObject *replyObject;
@property (weak, nonatomic) IBOutlet UITableView *ticketDetailsTableview;

@end

@implementation TicketDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    
    self.ticketDetailsTableview.estimatedRowHeight = 60;
    self.ticketDetailsTableview.estimatedSectionHeaderHeight = 90;
    self.ticketDetailsTableview.estimatedSectionFooterHeight = 1.0;
    self.ticketDetailsTableview.rowHeight = UITableViewAutomaticDimension;
    self.ticketDetailsTableview.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.ticketDetailsTableview.sectionFooterHeight = UITableViewAutomaticDimension;
    self.ticketDetailsTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.ticketDetailsTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UINib *ticketHeaderNib = [UINib nibWithNibName:@"TicketDetailsHeaderView" bundle:nil];
    [self.ticketDetailsTableview registerNib:ticketHeaderNib forHeaderFooterViewReuseIdentifier:@"ticketHeader"];
    
    [self CallTickeDetailsWebservice];
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


-(void) CallTickeDetailsWebservice
{
    
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@app_ticket_details/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,self.tickerObject.ticketId];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypTicketDetails Delegate:self];
    [self.myWebService getDataFromWebURL:urlStr];
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestypTicketDetails)
    {
        self.ticketDetailsArray = [[NSArray alloc]initWithArray:responseObj];
    }
    [self.ticketDetailsTableview reloadData];
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
    
    if (self.ticketDetailsArray.count > 0)
    {
        self.ticketDetailsTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        numOfSections                 = self.ticketDetailsArray.count;
        
        self.ticketDetailsTableview.backgroundView   = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(self.ticketDetailsTableview.frame.origin.x, self.ticketDetailsTableview.frame.origin.y, self.ticketDetailsTableview.bounds.size.width, self.ticketDetailsTableview.bounds.size.height)];
        
        noDataLabel.text             = NSLocalizedString(@"No reply available.", Nil);
        
        noDataLabel.textColor        = [UIColor grayColor];
        
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        
        self.ticketDetailsTableview.backgroundView = noDataLabel;
        
        self.ticketDetailsTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ticketDetailsCell";
    TicketDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    self.replyObject = [self.ticketDetailsArray objectAtIndex:indexPath.section];
    
    cell.replyDateLabel.text = self.replyObject.replyDate;
    cell.replyTypeLabel.text = self.replyObject.replyType;
    cell.replyMessageLabe.text = self.replyObject.replyMessage;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
    {
        TicketDetailsHeaderView *ticketHeaderView = [self.ticketDetailsTableview dequeueReusableHeaderFooterViewWithIdentifier:@"ticketHeader"];
        
        ticketHeaderView.ticketdLabel.text = self.tickerObject.ticketId;
        ticketHeaderView.ticketCreationDateLabel.text = self.tickerObject.statusChangedDate;
        ticketHeaderView.ticketCurrentStatusLabel.text = self.tickerObject.currentStatus;
        ticketHeaderView.ticketDescriptionLabel.text = self.tickerObject.ticketDescription;
        
        return ticketHeaderView;

    }
    else
    {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor clearColor];
        return headerView;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}


@end
