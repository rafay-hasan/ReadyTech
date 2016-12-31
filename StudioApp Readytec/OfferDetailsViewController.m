//
//  OfferDetailsViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 12/22/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "OfferDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface OfferDetailsViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;
@property (weak, nonatomic) IBOutlet UITextView *offerTitleTextView;

@property (weak, nonatomic) IBOutlet UILabel *offerStartingDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerEndingDateLabel;
@property (weak, nonatomic) IBOutlet UIWebView *offerDetailsWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ScrollContainerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerDetailsWebViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTextViewHeight;


@end

@implementation OfferDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadDetailaView];

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

-(void) loadDetailaView
{
//    if(self.object.offerImageUrlStr.length == 0)
//    {
//        self.imageViewHeight.constant = 0;
//    }
//    else
//    {
//        [self.offerImageView setImageWithURL:[NSURL URLWithString:self.object.offerImageUrlStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    }
    [self.offerImageView setImageWithURL:[NSURL URLWithString:self.object.offerImageUrlStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.offerTitleTextView.scrollEnabled = NO;
    self.offerTitleTextView.text = self.object.offerTitle;
    CGSize sizeThatFitsTextView = [self.offerTitleTextView sizeThatFits:CGSizeMake(self.offerTitleTextView.frame.size.width, MAXFLOAT)];
    self.titleTextViewHeight.constant = sizeThatFitsTextView.height;
    
    self.offerStartingDateLabel.text  = self.object.offerStartingDate;
    self.offerEndingDateLabel.text = self.object.offerEndDate;
    
    self.offerDetailsWebView.opaque = NO;
    self.offerDetailsWebView.backgroundColor = [UIColor clearColor];
    NSString *detailsWebStrstr = [NSString stringWithFormat:@"<div style='font-family:Helvetica Neue;color:#000000;'>%@",self.object.offerDetails];
    [self.offerDetailsWebView loadHTMLString:[NSString stringWithFormat:@"<style type='text/css'>img { display: inline;height: auto;max-width: 100%%; }</style>%@",detailsWebStrstr] baseURL:nil];
    self.offerDetailsWebView.delegate = self;
    self.offerDetailsWebView.scrollView.scrollEnabled = NO;

}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    aWebView.scrollView.scrollEnabled = NO;
    self.offerDetailsWebViewHeight.constant = aWebView.scrollView.contentSize.height;
    self.ScrollContainerViewHeight.constant = aWebView.frame.origin.y + aWebView.frame.size.height + 26;
    [self.view setNeedsLayout];
    
}


@end
