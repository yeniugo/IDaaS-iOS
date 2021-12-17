//
//  TRUChangePasswordViewController.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/16.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "TRUChangePasswordViewController.h"

@interface TRUChangePasswordViewController ()

@end

@implementation TRUChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *showLB = [[UILabel alloc] init];
    showLB.text = @"为了保障账户安全请按要求输入密码";
    
    UILabel *oldpasswordLB = [[UILabel alloc] init];
    oldpasswordLB.text = @"旧密码";
    UITextField *oldpasswordTF = [[UITextField alloc] init];
    oldpasswordTF.placeholder = @"";
    UIButton *oldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *oldLine = [[UIView alloc] init];
    
    UILabel *firstpasswordLB = [[UILabel alloc] init];
    firstpasswordLB.text = @"旧密码";
    UITextField *firstpasswordTF = [[UITextField alloc] init];
    firstpasswordTF.placeholder = @"";
    UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *firstLine = [[UIView alloc] init];
    
    UILabel *secondpasswordLB = [[UILabel alloc] init];
    secondpasswordLB.text = @"旧密码";
    UITextField *secondpasswordTF = [[UITextField alloc] init];
    secondpasswordTF.placeholder = @"";
    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *secondLine = [[UIView alloc] init];
    
    UILabel *messageLB = [[UILabel alloc] init];
    messageLB.text = @"密码由6-16位数字、字母或符号组成，至少包含两种字符。";
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"提交" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:showLB];
    [self.view addSubview:oldpasswordLB];
    [self.view addSubview:oldpasswordTF];
    [self.view addSubview:oldBtn];
    [self.view addSubview:oldLine];
    [self.view addSubview:firstpasswordLB];
    [self.view addSubview:firstpasswordTF];
    [self.view addSubview:firstBtn];
    [self.view addSubview:firstLine];
    [self.view addSubview:secondpasswordLB];
    [self.view addSubview:secondpasswordTF];
    [self.view addSubview:secondBtn];
    [self.view addSubview:secondLine];
    [self.view addSubview:messageLB];
    [self.view addSubview:okBtn];
    
    [showLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(self.view.mas_topMargin).offset(10);
    }];
    [oldpasswordLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showLB);
        make.top.equalTo(showLB.mas_bottom).offset(50);
    }];
    [oldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(21));
        make.height.equalTo(@(15));
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(oldpasswordLB.mas_bottom).offset(20);
    }];
    [oldpasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showLB);
        make.right.equalTo(oldBtn.mas_left).offset(-10);
        make.centerY.equalTo(oldBtn);
    }];
    [oldLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(oldBtn.mas_bottom).offset(10);
    }];
    [firstpasswordLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oldpasswordLB);
        make.top.equalTo(oldLine.mas_bottom).offset(10);
    }];
    [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.right.equalTo(oldBtn);
        make.top.equalTo(oldLine).offset(20);
    }];
    [firstpasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(oldpasswordTF);
        make.centerY.equalTo(firstBtn);
    }];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(oldLine);
        make.top.equalTo(firstBtn.mas_bottom).offset(10);
    }];
    [secondpasswordLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oldpasswordLB);
        make.top.equalTo(firstLine.mas_bottom).offset(10);
    }];
    [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.right.equalTo(firstBtn);
        make.top.equalTo(firstLine.mas_bottom).offset(20);
    }];
    [secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(firstLine);
        make.top.equalTo(secondBtn.mas_bottom).offset(10);
    }];
    [messageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(secondLine);
        make.top.equalTo(secondLine.mas_bottom).offset(40);
    }];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(secondLine);
    }];
}

- (void)okBtnClick:(UIButton *)btn{
    
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
