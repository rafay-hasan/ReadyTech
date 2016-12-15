//
//  OffersViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/30/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "OffersViewController.h"
#import "DEMONavigationController.h"
#import "OfferTableViewCell.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "OfferObject.h"
#import "UIImageView+AFNetworking.h"

@interface OffersViewController ()<RHWebServiceDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray *offersArray;
@property (strong,nonatomic) RHWebServiceManager *myWebService;
- (IBAction)slideMenuAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *offerTableView;

@end

@implementation OffersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    
    self.offerTableView.estimatedRowHeight = 86;
    self.offerTableView.rowHeight = UITableViewAutomaticDimension;
    self.offerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.offerTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.offersArray = [NSMutableArray new];
    [self CallOfferWebservice];
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

#pragma mark table view Delegate Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    
    if (self.offersArray.count > 0)
    {
        self.offerTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections = 1;
        self.offerTableView.backgroundView   = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(self.offerTableView.frame.origin.x, self.offerTableView.frame.origin.y, self.offerTableView.bounds.size.width, self.offerTableView.bounds.size.height)];
        
        noDataLabel.text             = NSLocalizedString(@"No offer available.", Nil);
        
        noDataLabel.textColor        = [UIColor grayColor];
        
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        
        self.offerTableView.backgroundView = noDataLabel;
        
        self.offerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.offersArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"offerCell";
    OfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    
    OfferObject *object = [self.offersArray objectAtIndex:indexPath.row];
    cell.offerTitleLabel.text = object.offerTitle;
    cell.offerDescriptionLabel.text = object.offerDetails;
    [cell.offerImageView setImageWithURL:[NSURL URLWithString:object.offerImageUrlStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.offerStartDateLabel.text = object.offerStartingDate;
    cell.offerEndDateLabel.text = object.offerEndDate;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;

    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark All Web service

-(void) CallOfferWebservice
{
    [SVProgressHUD show];
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.offersArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@app_all_offers/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,startingLimit];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeOffer Delegate:self];
    [self.myWebService getDataFromWebURL:urlStr];
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestypeOffer)
    {
        [self.offersArray addObjectsFromArray:(NSArray *)responseObj];
        
    }
    [self.offerTableView reloadData];
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


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= -40) {
        
        [self CallOfferWebservice];
        
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
