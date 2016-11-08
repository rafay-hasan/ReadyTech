//
//  NewsViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/5/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "NewsViewController.h"
#import "DEMONavigationController.h"
#import "NewsTableViewCell.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "NewsObject.h"

@interface NewsViewController ()<RHWebServiceDelegate>

@property(strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) NSMutableArray *newsDataArray;
@property (weak, nonatomic) IBOutlet UITableView *newsTableview;


- (IBAction)menuAction:(id)sender;


@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    
    self.newsTableview.estimatedRowHeight = 95;
    self.newsTableview.rowHeight = UITableViewAutomaticDimension;
    
    
    self.newsTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.newsTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.newsDataArray = [NSMutableArray new];
    [self CallNewsWebservice];
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

- (IBAction)menuAction:(id)sender {
    
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];

}
-(void) CallNewsWebservice
{
    
    [SVProgressHUD show];
    
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.newsDataArray.count];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@app_all_news/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,startingLimit];
    
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeNews Delegate:self];
    
    [self.myWebService getDataFromWebURL:urlStr];
    
}



-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    
    self.view.userInteractionEnabled = YES;
    
    if(self.myWebService.requestType == HTTPRequestypeNews)
    {
        
        [self.newsDataArray addObjectsFromArray:(NSArray *)responseObj];
        NSLog(@"total is %@",self.newsDataArray);
        
        [self.newsTableview reloadData];
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


#pragma mark table view Delegate Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    
    if (self.newsDataArray.count > 0)
    {
        self.newsTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        numOfSections                 = 1;
        
        self.newsTableview.backgroundView   = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(self.newsTableview.frame.origin.x, self.newsTableview.frame.origin.y, self.newsTableview.bounds.size.width, self.newsTableview.bounds.size.height)];
        
        noDataLabel.text             = NSLocalizedString(@"No news available.", Nil);
        
        noDataLabel.textColor        = [UIColor grayColor];
        
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        
        self.newsTableview.backgroundView = noDataLabel;
        
        self.newsTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"newsCell";
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    
    NewsObject *object = [self.newsDataArray objectAtIndex:indexPath.row];
    cell.newsDateLabel.text = object.newsDateTime;
    cell.newsTitleLAbel.text = object.newsTitle;
    cell.newsDescriptionLabel.attributedText = object.newsDescription;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
