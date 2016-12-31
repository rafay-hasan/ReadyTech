//
//  MessageDetailsViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 12/23/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "MessageDetailsViewController.h"

@interface MessageDetailsViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *titleWebView;
@property (weak, nonatomic) IBOutlet UIWebView *detailsWebView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWebViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailsWebViewHeight;


@end

@implementation MessageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleWebView.layer.masksToBounds =YES;
    self.titleWebView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.titleWebView.layer.borderWidth = 1;
    [self loadTitleWebview];
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

-(void) loadDetailsWebview
{
    self.detailsWebView.opaque = NO;
    self.detailsWebView.backgroundColor = [UIColor clearColor];
    NSString *detailsWebStrstr = [NSString stringWithFormat:@"<div style='font-family:Helvetica Neue;color:#000000;'>%@",self.object.messageDetails];
    [self.detailsWebView loadHTMLString:[NSString stringWithFormat:@"<style type='text/css'>img { display: inline;height: auto;max-width: 100%%; }</style>%@",detailsWebStrstr] baseURL:nil];
    self.detailsWebView.delegate = self;
    self.detailsWebView.scrollView.scrollEnabled = NO;
    
}


-(void) loadTitleWebview
{
    
    self.titleWebView.opaque = NO;
    self.titleWebView.backgroundColor = [UIColor clearColor];
    NSString *titleWebStrstr = [NSString stringWithFormat:@"<div style='font-family:HelveticaNeue-Bold;color:#0733A9;'>%@",self.object.messageTitle];
    [self.titleWebView loadHTMLString:[NSString stringWithFormat:@"<style type='text/css'>img { display: inline;height: auto;max-width: 100%%; }</style>%@",titleWebStrstr] baseURL:nil];
    self.titleWebView.delegate = self;
    self.titleWebView.scrollView.scrollEnabled = NO;
    
}


- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    aWebView.scrollView.scrollEnabled = NO;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    
    if(aWebView == self.titleWebView)
    {
        self.titleWebViewHeight.constant = fittingSize.height;//aWebView.scrollView.contentSize.height;
        [self loadDetailsWebview];
    }
    else if (aWebView == self.detailsWebView)
    {
        self.detailsWebViewHeight.constant = fittingSize.height;//aWebView.scrollView.contentSize.height;
        self.dateLabel.text = self.object.messageDate;
        self.timeLabel.text = self.object.messageTime;
    }
    
    
    self.scrollContainerHeight.constant = aWebView.frame.origin.y + aWebView.frame.size.height + 50;
    [self.view setNeedsLayout];
    
}


@end
