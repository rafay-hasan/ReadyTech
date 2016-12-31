//
//  MessageViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/29/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "MessageObject.h"
#import "User Details.h"
#import "DEMONavigationController.h"
#import "MessageDetailsViewController.h"

@interface MessageViewController ()<RHWebServiceDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) MessageObject *object;
@property (strong,nonatomic) RHWebServiceManager *myWebService;
- (IBAction)slideMenuAction:(id)sender;

@property (strong,nonatomic) NSMutableArray *stdioMessageArray,*generalMessageArray;

- (IBAction)messageSegmentAction:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *messageSegmentControl;
@property (weak, nonatomic) IBOutlet UITableView *messageTableview;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.messageSegmentControl setTitle:NSLocalizedString(@"GENERAL", Nil) forSegmentAtIndex:0];
    [self.messageSegmentControl setTitle:NSLocalizedString(@"STUDIO", Nil) forSegmentAtIndex:1];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.messageTableview.estimatedRowHeight = 44;
    self.messageTableview.rowHeight = UITableViewAutomaticDimension;
    self.messageTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.messageTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.generalMessageArray = [NSMutableArray new];
    self.stdioMessageArray = [NSMutableArray new];
    [self CallGeneralMessageWebservice];
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
    
    if([segue.identifier isEqualToString:@"messageDetails"])
    {
        NSIndexPath *indexpath = [self.messageTableview indexPathForSelectedRow];
        MessageDetailsViewController *controller = segue.destinationViewController;
        if(self.messageSegmentControl.selectedSegmentIndex == 0)
            controller.object = [self.generalMessageArray objectAtIndex:indexpath.section];
        else
            controller.object = [self.stdioMessageArray objectAtIndex:indexpath.section];

    }
}


- (IBAction)messageSegmentAction:(UISegmentedControl *)sender {
    
    [self.messageTableview reloadData];
    if(self.messageSegmentControl.selectedSegmentIndex == 0)
        [self CallGeneralMessageWebservice];
    else
        [self CallStdioMessageWebservice];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    NSArray *tempArray;
    
    if(self.messageSegmentControl.selectedSegmentIndex == 0)
        tempArray = self.generalMessageArray;
    else
        tempArray = self.stdioMessageArray;
    
    if (tempArray.count > 0)
    {
        self.messageTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                 = tempArray.count;
        self.messageTableview.backgroundView   = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(self.messageTableview.frame.origin.x, self.messageTableview.frame.origin.y, self.messageTableview.bounds.size.width, self.messageTableview.bounds.size.height)];
        noDataLabel.text             = NSLocalizedString(@"No message available.", Nil);
        noDataLabel.textColor        = [UIColor grayColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        self.messageTableview.backgroundView = noDataLabel;
        self.messageTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"messageCell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(self.messageSegmentControl.selectedSegmentIndex == 0)
        self.object = [self.generalMessageArray objectAtIndex:indexPath.section];
    else
        self.object = [self.stdioMessageArray objectAtIndex:indexPath.section];
    
    cell.messageDateLabel.text = self.object.messageDate;
    cell.messageTimeLabel.text = self.object.messageTime;
    cell.messageTitleLabel.text = self.object.messageTitle;
    cell.messageDescriptionLabel.text = self.object.messageDetails;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- ( UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    
    
    if (maximumOffset - currentOffset <= -40) {
        
        if(self.messageSegmentControl.selectedSegmentIndex == 0)
            [self CallGeneralMessageWebservice];
        else
            [self CallStdioMessageWebservice];
        
        
    }
    
}


#pragma mark Webservice Method Call



-(void) CallGeneralMessageWebservice
{
    
    [SVProgressHUD show];
    
    self.view.userInteractionEnabled = NO;
    
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.generalMessageArray.count];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@app_all_general_messages/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,startingLimit];
    
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeGeneralMessages Delegate:self];
    
    [self.myWebService getDataFromWebURL:urlStr];
    
}

-(void) CallStdioMessageWebservice
{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.stdioMessageArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@app_studio_messages/%@/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,[User_Details sharedInstance].studio_Details_ID,startingLimit];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeStudioMessages Delegate:self];
    [self.myWebService getDataFromWebURL:urlStr];
    
}


-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if (self.myWebService.requestType == HTTPRequestTypeGeneralMessages)
    {
        [self.generalMessageArray addObjectsFromArray:(NSArray *)responseObj];
    }
    else if (self.myWebService.requestType == HTTPRequestTypeStudioMessages)
    {
        [self.stdioMessageArray addObjectsFromArray:(NSArray *)responseObj];
    }
    [self.messageTableview reloadData];
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
