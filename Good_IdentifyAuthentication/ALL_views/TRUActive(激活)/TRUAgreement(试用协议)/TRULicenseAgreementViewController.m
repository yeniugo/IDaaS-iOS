//
//  TRULicenseAgreementViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/11.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRULicenseAgreementViewController.h"
#import "TRUCompanyAPI.h"
//#import <svnsdk/secbrowhttpprotocol.h>
@interface TRULicenseAgreementViewController ()

@end

@implementation TRULicenseAgreementViewController
{
    UIWebView *webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}
- (void)setupViews {
    [self setTitle:@"软件许可协议"];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    NSString *str;
    NSString *urlstr = @"";
    if (urlstr.length>0) {
//        UILabel *testLabel = [[UILabel alloc] init];
//        testLabel.text = urlstr;
        NSURL *httpURL = [NSURL URLWithString:urlstr];
//        [NSURLProtocol registerClass:[SecBrowHttpProtocol class]];
        webView = [[UIWebView alloc] init];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:httpURL];
        [webView loadRequest:request];
        if (kDevice_Is_iPhoneX) {
            webView.frame = CGRectMake(0, 83, SCREENW, SCREENH - 83);
        }else{
            webView.frame = CGRectMake(0, 64, SCREENW, SCREENH - 64);
        }
//        testLabel.frame = webView.frame;
        [self.view addSubview:webView];
//        [self.view addSubview:testLabel];
    }else{
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"Lisence" withExtension:@"txt"];
        str = [NSString stringWithContentsOfURL:fileUrl encoding:NSUTF8StringEncoding error:nil];
        UITextView *textView = [[UITextView alloc] init];
        textView.editable = NO;
        textView.bounces = NO;
        textView.text = str;
        if (kDevice_Is_iPhoneX) {
            textView.frame = CGRectMake(0, 85, SCREENW, SCREENH - 85);
        }else{
            textView.frame = CGRectMake(0, 64, SCREENW, SCREENH - 64);
        }
        [self.view addSubview:textView];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *urlstr = [TRUCompanyAPI getCompany].user_agreement_url;
    if (urlstr.length>0) {
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
