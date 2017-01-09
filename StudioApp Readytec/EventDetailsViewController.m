//
//  EventDetailsViewController.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 12/21/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "SVProgressHUD.h"

@interface EventDetailsViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *eventTitleWebView;
@property (weak, nonatomic) IBOutlet UILabel *eventStartDateLabel;
@property (weak, nonatomic) IBOutlet UIWebView *eventDescriptionWebView;
@property (weak, nonatomic) IBOutlet UILabel *eventEndDateLabel;
@property (weak, nonatomic) IBOutlet UIView *topDividerView;
@property (weak, nonatomic) IBOutlet UIWebView *eventWebLinkWebView;
@property (weak, nonatomic) IBOutlet UIView *bottomDividerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titileWebViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionWebViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventLinkWebViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;


@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if(self.object.eventWebLink.length == 0)
    {
        self.topDividerView.hidden = YES;
        self.bottomDividerView.hidden = YES;
    }
    
    self.eventStartDateLabel.text = self.object.eventStartDate;
    self.eventEndDateLabel.text = self.object.eventEndDate;
    
    [self loadTitleWebview];
}

-(void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    self.navigationItem.title = NSLocalizedString(@"Event Details", Nil);

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

-(void) loadTitleWebview
{
    self.eventTitleWebView.opaque = NO;
    self.eventTitleWebView.backgroundColor = [UIColor clearColor];
    NSString *titleWebStrstr = [NSString stringWithFormat:@"<div style='font-family:HelveticaNeue-Bold;color:#0733A9;'>%@",self.object.eventName];
    [self.eventTitleWebView loadHTMLString:[NSString stringWithFormat:@"<style type='text/css'>img { display: inline;height: auto;max-width: 100%%; }</style>%@",titleWebStrstr] baseURL:nil];
    self.eventTitleWebView.delegate = self;
    self.eventTitleWebView.scrollView.scrollEnabled = NO;
    
}

-(void) loadDetailsWebview
{
    
    self.eventDescriptionWebView.opaque = NO;
    self.eventDescriptionWebView.backgroundColor = [UIColor clearColor];
    NSString *titleWebStrstr = [NSString stringWithFormat:@"<div style='font-family:HelveticaNeue-Bold;color:#000000;'>%@",self.object.eventDescription];
    [self.eventDescriptionWebView loadHTMLString:[NSString stringWithFormat:@"<style type='text/css'>img { display: inline;height: auto;max-width: 100%%; }</style>%@",titleWebStrstr] baseURL:nil];
    self.eventDescriptionWebView.delegate = self;
    self.eventDescriptionWebView.scrollView.scrollEnabled = NO;
    
}

-(void) loadLinkWebview
{
    self.eventWebLinkWebView.opaque = NO;
    self.eventWebLinkWebView.backgroundColor = [UIColor clearColor];
    [self.eventWebLinkWebView loadHTMLString:self.object.eventWebLink baseURL:nil];
    self.eventWebLinkWebView.delegate = self;
    self.eventWebLinkWebView.scrollView.scrollEnabled = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
    if(aWebView == self.eventTitleWebView)
    {
        [self loadDetailsWebview];
    }
    else if (aWebView == self.eventDescriptionWebView)
    {
        [self loadLinkWebview];
    }

}


- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    aWebView.scrollView.scrollEnabled = NO;
    
    if(aWebView == self.eventTitleWebView)
    {
        self.titileWebViewHeight.constant = aWebView.scrollView.contentSize.height;
        [self loadDetailsWebview];
    }
    else if (aWebView == self.eventDescriptionWebView)
    {
        self.descriptionWebViewHeight.constant = aWebView.scrollView.contentSize.height;
        [self loadLinkWebview];
    }
    else if (aWebView == self.eventWebLinkWebView)
    {
        self.eventLinkWebViewHeight.constant = aWebView.scrollView.contentSize.height;
    }

    self.scrollHeight.constant = aWebView.frame.origin.y + aWebView.frame.size.height + 16;
    [self.view setNeedsLayout];
    
}

- (void)orientationChanged:(NSNotification *)notification
{
    [self loadTitleWebview];
}

@end
