//
//  TrainingViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/28/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "TrainingViewController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "CourseObject.h"
#import "User Details.h"
#import "TrainingTableViewCell.h"
#import "DEMONavigationController.h"

@interface TrainingViewController ()<RHWebServiceDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) CourseObject *object;
@property (strong,nonatomic) RHWebServiceManager *myWebservice;
@property (strong,nonatomic) NSMutableArray *onGoingCoursedataArray,*upComingCoursedataArray;

@property (weak, nonatomic) IBOutlet UITableView *courseTableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *courseSegmentControl;

- (IBAction)courseSegmentButtonAction:(UISegmentedControl *)sender;

- (IBAction)slideMenuAction:(id)sender;

@end

@implementation TrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.courseSegmentControl setTitle:NSLocalizedString(@"ONGOING", Nil) forSegmentAtIndex:0];
    [self.courseSegmentControl setTitle:NSLocalizedString(@"UPCOMING", Nil) forSegmentAtIndex:1];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.courseTableview.estimatedRowHeight = 70;
    self.courseTableview.rowHeight = UITableViewAutomaticDimension;
    self.courseTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.courseTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.onGoingCoursedataArray = [NSMutableArray new];
    self.upComingCoursedataArray = [NSMutableArray new];
    [self CallOngoingCourseWebservice];
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

- (IBAction)courseSegmentButtonAction:(UISegmentedControl *)sender {
    
    [self.courseTableview reloadData];
    
    if(sender.selectedSegmentIndex == 0)
    {
        [self CallOngoingCourseWebservice];
    }
    else
    {
        [self CallUpcomingCourseWebservice];
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

#pragma mark Web service methods


-(void) CallOngoingCourseWebservice
{
    
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.onGoingCoursedataArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@app_all_ongoing_training/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,startingLimit];
    self.myWebservice = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeOngoingCourses Delegate:self];
    [self.myWebservice getDataFromWebURL:urlStr];
    
}

-(void) CallUpcomingCourseWebservice
{
    
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.upComingCoursedataArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@app_all_upcoming_training/%@/%@",BASE_URL_API,[User_Details sharedInstance].userDetailsId,startingLimit];
    self.myWebservice = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeUpComingCourses Delegate:self];
    [self.myWebservice getDataFromWebURL:urlStr];
    
}


-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebservice.requestType == HTTPRequestTypeOngoingCourses)
    {
        [self.onGoingCoursedataArray addObjectsFromArray:(NSArray *)responseObj];
    }
    else if (self.myWebservice.requestType == HTTPRequestTypeUpComingCourses)
    {
        [self.upComingCoursedataArray addObjectsFromArray:(NSArray *)responseObj];
        
    }
    [self.courseTableview reloadData];
    
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
    
    if(self.courseSegmentControl.selectedSegmentIndex == 0)
        tempArray = self.onGoingCoursedataArray;
    else
        tempArray = self.upComingCoursedataArray;
    
    if (tempArray.count > 0)
    {
        self.courseTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections = tempArray.count;
        self.courseTableview.backgroundView   = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(self.courseTableview.frame.origin.x, self.courseTableview.frame.origin.y, self.courseTableview.bounds.size.width, self.courseTableview.bounds.size.height)];
        noDataLabel.text             = NSLocalizedString(@"No training available.", Nil);
        noDataLabel.textColor        = [UIColor grayColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        self.courseTableview.backgroundView = noDataLabel;
        self.courseTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"trainingCell";
    TrainingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    
    if(self.courseSegmentControl.selectedSegmentIndex == 0)
        self.object = [self.onGoingCoursedataArray objectAtIndex:indexPath.section];
    else
        self.object = [self.upComingCoursedataArray objectAtIndex:indexPath.section];

    cell.trainingTypeLabel.text = self.object.courseType;
    cell.trainingTitleLabel.text = self.object.courseTitle;
    
    if(self.object.numberOfLessons.integerValue > 0)
    {
        cell.numberOfLessonsLabel.text = [NSString stringWithFormat:@"%@ %@",self.object.numberOfLessons,NSLocalizedString(@"LESSONS", Nil)];
        cell.numberOfLessonsLabel.hidden = NO;
    }
    else
    {
        cell.numberOfLessonsLabel.text = @"";
        cell.numberOfLessonsLabel.hidden = YES;

    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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




@end
