//
//  TRUAuthorizedWebViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/16.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUAuthorizedWebViewController.h"

@interface TRUAuthorizedWebViewController ()<UIWebViewDelegate,NSURLConnectionDataDelegate>
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, assign) SSLAuthenticate authenticated;
@property (nonatomic, strong) NSURL *myRequestUrl;
@property (nonatomic, strong) NSURLConnection *myConnection;
@end

@implementation TRUAuthorizedWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.urlStr || self.urlStr.length == 0) {
        [self showHudWithText:@"网页请求错误，请稍后重试"];
        [self hideHudDelay:2.0];
        return;
    }
    [self deleteCookies];
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"PushCancel"] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [rightBtn.widthAnchor constraintEqualToConstant:30].active = YES;
//    [rightBtn.heightAnchor constraintEqualToConstant:30].active = YES;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.leftItemBtn.hidden = YES;
//    self.title = @"111111111111111111111111111111111111111111111111111111111111111111";
    NSString *encodeStr = [self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    encodeStr = [encodeStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    self.myRequestUrl = [NSURL URLWithString:encodeStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.myRequestUrl];
    UIWebView *webView = [[UIWebView alloc] init];
    
    if (@available(iOS 11.0, *)) {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:self.webView = webView];
    if (kDevice_Is_iPhoneX) {
        webView.frame = CGRectMake(0, 85, SCREENW, SCREENH - 85);
    }else{
        webView.frame = CGRectMake(0, 64, SCREENW, SCREENH - 64);
    }
}


- (void)deleteCookies{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (self.authenticated == NO) {
        self.myConnection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:self.myRequestUrl] delegate:self];
        [self.myConnection start];
        
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showActivityWithText:@"请稍候..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHudDelay:0.0];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //    [self hideHudDelay:0.0];
    [self showHudWithText:@"网页请求错误，请稍后重试"];
    [self hideHudDelay:2.0];
    
}
#pragma mark NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    //    YCLog(@"WebController 已经得到授权正在请求 NSURLConnection");
    
    if ([challenge previousFailureCount] == 0){
        self.authenticated = kTryAuthenticate;
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        
    } else{
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //    YCLog(@"WebController 已经收到响应并通过了 NSURLConnection请求");
    
    self.authenticated = kTryAuthenticate;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.myRequestUrl]];
    [self.myConnection cancel];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
