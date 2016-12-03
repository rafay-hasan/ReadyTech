//
//  TicketsViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 12/3/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "TicketsViewController.h"
#import "TicketsTableViewCell.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "TicketObject.h"

@interface TicketsViewController ()<RHWebServiceDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) NSArray *ticketsArray;
@property (strong,nonatomic) TicketObject *ticket;


@property (weak, nonatomic) IBOutlet UITableView *ticketTableView;

@end

@implementation TicketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


-(void) CallTickeWebservice
{
    
    [SVProgressHUD show];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@app_user_ticket_list/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypTickets Delegate:self];
    [self.myWebService getDataFromWebURL:urlStr];
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestypTickets)
    {
        self.ticketsArray = [[NSArray alloc]initWithArray:responseObj];
        
    }
    [self.ticketTableView reloadData];
    
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
    
    if (self.ticketsArray.count > 0)
    {
        self.ticketTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        numOfSections                 = 1;
        
        self.ticketTableView.backgroundView   = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(self.ticketTableView.frame.origin.x, self.ticketTableView.frame.origin.y, self.ticketTableView.bounds.size.width, self.ticketTableView.bounds.size.height)];
        
        noDataLabel.text             = NSLocalizedString(@"No tickets available.", Nil);
        
        noDataLabel.textColor        = [UIColor grayColor];
        
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        
        self.ticketTableView.backgroundView = noDataLabel;
        
        self.ticketTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ticketsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ticketCell";
    
    TicketsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    self.ticket = [self.ticketsArray objectAtIndex:indexPath.row];
    
    cell.ticketIdLabel.text = self.ticket.ticketId;
    cell.statusChangedDateLabel.text = self.ticket.statusChangedDate;
    cell.currentStatus.text = self.ticket.currentStatus;
    
    cell.ticketDescriptionLabel.text = self.ticket.ticketDescription;
    
    cell.ticketCreationDateLabel.text = self.ticket.ticketCreationDate;
    
        cell.backgroundColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
