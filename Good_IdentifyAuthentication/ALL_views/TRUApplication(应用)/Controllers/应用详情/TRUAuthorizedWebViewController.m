//
//  TRUAuthorizedWebViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/16.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUAuthorizedWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "UIWebView+TS_JavaScriptContext.h"
@protocol JS_ViewController <JSExport>
- (void) CloseWebView;
@end
@interface TRUAuthorizedWebViewController ()<UIWebViewDelegate,NSURLConnectionDataDelegate,TSWebViewDelegate,JS_ViewController>
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, assign) SSLAuthenticate authenticated;
@property (nonatomic, strong) NSURL *myRequestUrl;
@property (nonatomic, strong) NSURLConnection *myConnection;
@property (nonatomic,strong) JSContext *context;
@property (nonatomic,strong) UIView *statusBar;
@end

@implementation TRUAuthorizedWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    [self setStatusBarBackgroundColor:DefaultGreenColor];
    // Do any additional setup after loading the view.
    if (!self.urlStr || self.urlStr.length == 0) {
        [self showHudWithText:@"网页请求错误，请稍后重试"];
        [self hideHudDelay:2.0];
        return;
    }
//    [self deleteCookies];
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
        webView.frame = CGRectMake(0, kStatusBarHeight, SCREENW, SCREENH-kStatusBarHeight);
    }else{
        webView.frame = CGRectMake(0, kStatusBarHeight, SCREENW, SCREENH-kStatusBarHeight);
    }
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar;
    if (!IS_IPAD) {
        if(@available(iOS 13.0,*)){
            if (!_statusBar) {
                self.statusBar = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
                
                [[[UIApplication sharedApplication].delegate window] addSubview:_statusBar];
                self.statusBar.backgroundColor = color;
//                [[[UIApplication sharedApplication].windows objectAtIndex:1] addSubview:_statusBar];
                
            }else{
                self.statusBar.backgroundColor = color;
                if (CGColorEqualToColor(color.CGColor,[UIColor clearColor].CGColor)) {
                    [self.statusBar removeFromSuperview];
                }
            }
        }else{
            statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        }
    }
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
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
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context[@"thirdPartyApp"] = self;
}

- (void)CloseWebView{
    [self.navigationController popViewControllerAnimated:YES];
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
