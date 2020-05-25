//
//  TRUAuthWKWebViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2020/5/21.
//  Copyright © 2020 zyc. All rights reserved.
//

#import "TRUAuthWKWebViewController.h"
#import <WebKit/WebKit.h>
@interface TRUAuthWKWebViewController ()<WKUIDelegate>
@property (nonatomic,strong) WKWebView *webView;
@end

@implementation TRUAuthWKWebViewController

-(void)loadView{
    WKWebViewConfiguration *webConfiguration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH) configuration:webConfiguration];
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *myURL = [NSURL URLWithString:self.urlStr];
    NSURLRequest *myRequest = [[NSURLRequest alloc] initWithURL:myURL];
    [self.webView loadRequest:myRequest];
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
