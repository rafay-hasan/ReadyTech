//
//  TrainingDetailsViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 12/28/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "TrainingDetailsViewController.h"
#import "TrainingDetailsHeaderView.h"
#import "TrainingDetailsFooterView.h"
#import "TrainingDetailsTableViewCell.h"

@interface TrainingDetailsViewController ()<UITableViewDataSource,UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray *customCourseArray;
@property (strong,nonatomic) NSMutableDictionary *valueDic;
@property (weak, nonatomic) IBOutlet UITableView *trainingDetailsTableView;


@end

@implementation TrainingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.customCourseArray = [NSMutableArray new];
    self.valueDic = [NSMutableDictionary new];
    
    self.trainingDetailsTableView.estimatedRowHeight = 55;
    self.trainingDetailsTableView.rowHeight = UITableViewAutomaticDimension;
    self.trainingDetailsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UINib *headerNib = [UINib nibWithNibName:@"TrainingDetailsHeaderView" bundle:nil];
    [self.trainingDetailsTableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:@"header"];
    self.trainingDetailsTableView.estimatedSectionHeaderHeight = 110.0;
    self.trainingDetailsTableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    
    UINib *footerNib = [UINib nibWithNibName:@"TrainingDetailsFooterView" bundle:nil];
    [self.trainingDetailsTableView registerNib:footerNib forHeaderFooterViewReuseIdentifier:@"footer"];
    self.trainingDetailsTableView.estimatedSectionFooterHeight = 170.0;
    self.trainingDetailsTableView.sectionFooterHeight = UITableViewAutomaticDimension;
    
    [self loadDataForTrainingTable];

}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = NSLocalizedString(@"Training Details", Nil);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadDataForTrainingTable
{
    if(self.object.courseOutline.length > 0)
    {
        [self.customCourseArray addObject:@"COURSE OUTLINE"];
        [self.valueDic setObject:self.object.courseOutline forKey:@"COURSE OUTLINE"];
    }
    
    if(self.object.coursedaysInWeek.length > 0)
    {
        [self.customCourseArray addObject:@"COURSE DAYS IN WEEK"];
        [self.valueDic setObject:self.object.coursedaysInWeek forKey:@"COURSE DAYS IN WEEK"];
    }
    
    if(self.object.coursesStartingDate.length > 0)
    {
        [self.customCourseArray addObject:@"COURSE STARTING DATE"];
        [self.valueDic setObject:self.object.coursesStartingDate forKey:@"COURSE STARTING DATE"];
    }
    
    if(self.object.coursesEndingDate.length > 0)
    {
        [self.customCourseArray addObject:@"COURSE ENDING DATE"];
        [self.valueDic setObject:self.object.coursesEndingDate forKey:@"COURSE ENDING DATE"];
    }
    
    if(self.object.classStartTime.length > 0)
    {
        [self.customCourseArray addObject:@"CLASS START TIME"];
        [self.valueDic setObject:self.object.classStartTime forKey:@"CLASS START TIME"];
    }
    
    if(self.object.classEndTime.length > 0)
    {
        [self.customCourseArray addObject:@"CLASS END TIME"];
        [self.valueDic setObject:self.object.classEndTime forKey:@"CLASS END TIME"];
    }
    
    if(self.object.perClassDuration.length > 0)
    {
        [self.customCourseArray addObject:@"PER CLASS DURATION"];
        [self.valueDic setObject:self.object.perClassDuration forKey:@"PER CLASS DURATION"];
    }
    [self.trainingDetailsTableView reloadData];
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
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.customCourseArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"trainingDetailsCell";
    TrainingDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    
    NSString *str = [self.customCourseArray objectAtIndex:indexPath.row];
    cell.headerNameLabel.text = NSLocalizedString(str, Nil);
    cell.headerValueLabel.text = [self.valueDic valueForKey: [self.customCourseArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TrainingDetailsHeaderView *headerView = [self.trainingDetailsTableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    headerView.trainingTypeLabel.text = self.object.courseType;
    headerView.trainingNameLabel.text = self.object.courseTitle;
    if([self.object.numberOfLessons integerValue] > 0)
    {
        headerView.numberOfLessonsLabel.text = [NSString stringWithFormat:@"%@ %@",self.object.numberOfLessons,NSLocalizedString(@"LESSONS", Nil)];
        
        headerView.numberOfLessonsLabel.hidden = NO;
    }
    else
    {
        headerView.numberOfLessonsLabel.hidden = YES;
        
    }
    headerView.courseOverviewLabel.text  = self.object.courseOverView;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    TrainingDetailsFooterView *footerView = [self.trainingDetailsTableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    footerView.orientationHeaderLabel.text = NSLocalizedString(@"ORIENTATION", Nil);
    footerView.locationHeaderLabel.text = NSLocalizedString(@"LOCATION", Nil);
    footerView.registrationHeaderLabel.text = NSLocalizedString(@"LAST DATE OF REGISTRATION", Nil);
    footerView.orientationLabel.text = self.object.orientationDateTime;
    footerView.locationLabel.text = self.object.orientationLocation;
    footerView.registrationDateLabel.text = self.object.lastDateOfRegistration;
    if(self.object.webLink.length > 0)
    {
        [footerView.moreButton setTitle:NSLocalizedString(@"MORE", Nil) forState:UIControlStateNormal];
        footerView.moreButton.hidden = NO;
        [footerView.moreButton addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        footerView.moreButton.hidden = YES;
    }
    return footerView;
}


-(void) moreButtonAction
{
    NSURL *url = [NSURL URLWithString:self.object.webLink];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];

}

@end
