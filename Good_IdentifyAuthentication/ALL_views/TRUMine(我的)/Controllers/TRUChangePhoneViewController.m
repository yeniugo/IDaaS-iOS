//
//  TRUChangePhoneViewController.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/16.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "TRUChangePhoneViewController.h"

@interface TRUChangePhoneViewController ()

@end

@implementation TRUChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITextField *oldTF = [[UITextField alloc] init];
    oldTF.placeholder = @"请输入旧手机号";
    UIView *oldLine = [[UIView alloc] init];
    oldLine.backgroundColor = RGBCOLOR(224, 224, 224);
    UITextField *firstTF = [[UITextField alloc] init];
    firstTF.placeholder = @"请输入新手机号";
    UIView *firstLine = [[UIView alloc] init];
    firstTF.backgroundColor = RGBCOLOR(224, 224, 224);
    UITextField *verifyTF = [[UITextField alloc] init];
    verifyTF.placeholder = @"请输入验证码";
    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    UIView *verifyLine = [[UIView alloc] init];
    verifyLine.backgroundColor = RGBCOLOR(224, 224, 224);
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"提交" forState:UIControlStateNormal];
    [okBtn setTitle:@"提交" forState:UIControlStateHighlighted];
    okBtn.backgroundColor = DefaultGreenColor;
    
    [self.view addSubview:oldTF];
    [self.view addSubview:oldLine];
    [self.view addSubview:firstTF];
    [self.view addSubview:firstLine];
    [self.view addSubview:verifyTF];
    [self.view addSubview:verifyBtn];
    [self.view addSubview:verifyLine];
    [self.view addSubview:okBtn];
    
    [oldTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(self.view.mas_topMargin).offset(50);
        
    }];
    [oldLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(oldTF);
        make.top.equalTo(oldTF.mas_bottom).offset(10);
        make.height.equalTo(@(1));
    }];
    [firstTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(oldTF);
        make.top.equalTo(oldLine.mas_bottom).offset(20);
    }];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(oldTF);
        make.top.equalTo(firstTF.mas_bottom).offset(10);
    }];
    [verifyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oldTF);
        make.top.equalTo(firstLine.mas_bottom).offset(20);
        make.right.equalTo(verifyBtn.mas_left).offset(-10);
        make.centerY.equalTo(verifyBtn);
    }];
    [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100));
        make.height.equalTo(@(50));
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(firstLine.mas_bottom).offset(20);
    }];
    [verifyLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(oldLine);
        make.top.equalTo(verifyBtn.mas_bottom).offset(10);
    }];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(oldTF);
        make.height.equalTo(@(50));
        make.top.equalTo(verifyLine);
    }];
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
