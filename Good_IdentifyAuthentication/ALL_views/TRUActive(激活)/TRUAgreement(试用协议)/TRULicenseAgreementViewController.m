//
//  TRULicenseAgreementViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/11.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRULicenseAgreementViewController.h"

@interface TRULicenseAgreementViewController ()

@end

@implementation TRULicenseAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}
- (void)setupViews {
    [self setTitle:@"软件许可协议"];
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"Lisence" withExtension:@"txt"];
    NSString *str = [NSString stringWithContentsOfURL:fileUrl encoding:NSUTF8StringEncoding error:nil];
    
    UITextView *textView = [[UITextView alloc]init];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
