//
//  EventsViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/27/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "EventsViewController.h"
#import "EventsTableViewCell.h"
#import "DEMONavigationController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "EventObject.h"
#import "User Details.h"

@interface EventsViewController ()<RHWebServiceDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSMutableArray *onGoingDataArray,*upcomingDataArray;
@property(strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) EventObject *object;

@property (weak, nonatomic) IBOutlet UISegmentedControl *eventsSegment;
- (IBAction)eventSegmentButtonAction:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UITableView *eventsTableview;
- (IBAction)slideMenuAction:(id)sender;

@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.eventsSegment setTitle:NSLocalizedString(@"ONGOING", Nil) forSegmentAtIndex:0];
    [self.eventsSegment setTitle:NSLocalizedString(@"UPCOMING", Nil) forSegmentAtIndex:1];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.eventsTableview.estimatedRowHeight = 60;
    self.eventsTableview.rowHeight = UITableViewAutomaticDimension;
    self.eventsTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.eventsTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.onGoingDataArray = [NSMutableArray new];
    self.upcomingDataArray = [NSMutableArray new];
    [self CallOnGoingEventWebservice];

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

- (IBAction)eventSegmentButtonAction:(UISegmentedControl *)sender {
    
    [self.eventsTableview reloadData];
    
    if(sender.selectedSegmentIndex == 0)
    {
        [self CallOnGoingEventWebservice];
    }
    else
    {
        [self CallUpComingEventWebservice];
    }
}

-(void) CallOnGoingEventWebservice
{
    [SVProgressHUD show];
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.onGoingDataArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@app_all_ongoing_events/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,startingLimit];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeOngoingEvents Delegate:self];
    [self.myWebService getDataFromWebURL:urlStr];
    
}


-(void) CallUpComingEventWebservice
{
    [SVProgressHUD show];
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.upcomingDataArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@app_all_upcoming_events/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,startingLimit];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypUpcomingEvents Delegate:self];
    [self.myWebService getDataFromWebURL:urlStr];
    
}



-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeOngoingEvents)
    {
        [self.onGoingDataArray addObjectsFromArray:(NSArray *)responseObj];
    }
    else if (self.myWebService.requestType == HTTPRequestTypUpcomingEvents)
    {
        [self.upcomingDataArray addObjectsFromArray:(NSArray *)responseObj];
    }
    [self.eventsTableview reloadData];
    
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

#pragma mark table view Delegate Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    NSArray *tempArray;
    
    if(self.eventsSegment.selectedSegmentIndex == 0)
        tempArray = self.onGoingDataArray;
    else
        tempArray = self.upcomingDataArray;

    if (tempArray.count > 0)
    {
        self.eventsTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections = 1;
        self.eventsTableview.backgroundView   = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(self.eventsTableview.frame.origin.x, self.eventsTableview.frame.origin.y, self.eventsTableview.bounds.size.width, self.eventsTableview.bounds.size.height)];
        noDataLabel.text             = NSLocalizedString(@"No events available.", Nil);
        noDataLabel.textColor        = [UIColor grayColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        self.eventsTableview.backgroundView = noDataLabel;
        self.eventsTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.eventsSegment.selectedSegmentIndex == 0)
        return self.onGoingDataArray.count;
    else
        return self.upcomingDataArray.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"eventCell";
    EventsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    
    if(self.eventsSegment.selectedSegmentIndex == 0)
    {
        self.object = [self.onGoingDataArray objectAtIndex:indexPath.row];
        cell.eventTitleLabel.text = @"ONGOING";
    }
    else
    {
        self.object = [self.upcomingDataArray objectAtIndex:indexPath.row];
        cell.eventTitleLabel.text = @"UPCOMING";
    }
    
    cell.eventDescriptionLabel.text = self.object.eventName;
    cell.eventDateLabel.text = self.object.eventStartDate;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
