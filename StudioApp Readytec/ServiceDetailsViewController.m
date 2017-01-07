//
//  ServiceDetailsViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 1/4/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "ServiceDetailsViewController.h"
#import "ServiceDetailsTableViewCell.h"
#import <MessageUI/MessageUI.h>

@interface ServiceDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>
{
    MFMailComposeViewController *mailComposer;
}

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

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Service details";
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
    [cell.detailsEmailButton setTitle:NSLocalizedString(@"Email", Nil) forState:UIControlStateNormal];
    [cell.detailsCopyButton setTitle:NSLocalizedString(@"Copy", Nil) forState:UIControlStateNormal];
    [cell.detailsEmailButton addTarget:self action:@selector(mailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.detailsCopyButton addTarget:self action:@selector(copyButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void) copyButtonAction:(UIButton *)sender
{
    
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    
    NSString *messageBody;
    
    messageBody = [NSString stringWithFormat:@"%@\n%@\n%@/n",self.detailsObject.updateTitle,self.detailsObject.updateDetails,self.detailsObject.updateWeblink];
    
    [pb setString:messageBody];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Copied" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) mailButtonAction:(UIButton *)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        mailComposer = [[MFMailComposeViewController alloc]init];
        mailComposer.mailComposeDelegate = self;
        [mailComposer setSubject:@"BBS"];
        
        NSString *mailMessageBody;
        
        mailMessageBody = [NSString stringWithFormat:@"<p>%@</p><br><p>%@</p><br><p>%@</p>",self.detailsObject.updateTitle,self.detailsObject.updateDetails,self.detailsObject.updateWeblink];
        
        [mailComposer setMessageBody:mailMessageBody isHTML:YES];
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
    else
    {
         NSLog(@"This device cannot send email");
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    NSString *message;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            message = @"Email Cancelled";
            break;
        case MFMailComposeResultSaved:
            message = @"Email Saved";
            break;
        case MFMailComposeResultSent:
            message = @"Email Sent";
            break;
        case MFMailComposeResultFailed:
            message = @"Email Failed";
            break;
        default:
            message = @"Email Not Sent";
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
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
