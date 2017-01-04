//
//  ServiceDetailsViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 1/4/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "ServiceDetailsViewController.h"
#import "ServiceDetailsTableViewCell.h"

@interface ServiceDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *serviceDetailsTableview;

@end

@implementation ServiceDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.serviceDetailsTableview.estimatedRowHeight = 110;
    self.serviceDetailsTableview.rowHeight = UITableViewAutomaticDimension;
    self.serviceDetailsTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.serviceDetailsTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"serviceDetailsCell";
    ServiceDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    
    cell.itemNameLabel.text = self.detailsObject.updateTitle;
    cell.itemDateLabe.text = self.detailsObject.updateDateTime;
    cell.itemDescriptionNameLabel.text = self.detailsObject.updateDetails;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
