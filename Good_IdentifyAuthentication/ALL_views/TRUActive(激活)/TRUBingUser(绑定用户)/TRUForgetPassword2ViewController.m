//
//  TRUForgetPassword2ViewController.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/16.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "TRUForgetPassword2ViewController.h"

@interface TRUForgetPassword2ViewController ()

@end

@implementation TRUForgetPassword2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *lable1 = [[UILabel alloc] init];
    lable1.text = @"1.输入账号";
    UILabel *lable2 = [[UILabel alloc] init];
    lable2.text = @">";
    lable2.textAlignment = NSTextAlignmentCenter;
    UILabel *lable3 = [[UILabel alloc] init];
    lable3.text = @"2.安全验证";
    UILabel *lable4 = [[UILabel alloc] init];
    lable4.text = @">";
    lable4.textAlignment = NSTextAlignmentCenter;
    UILabel *lable5 = [[UILabel alloc] init];
    lable5.text = @"3.重置密码";
    
    [self.view addSubview:lable1];
    [self.view addSubview:lable2];
    [self.view addSubview:lable3];
    [self.view addSubview:lable4];
    [self.view addSubview:lable5];
    
    [lable1 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(self.view.mas_topMargin).offset(10);
    }];
    
    [lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(lable1);
    }];
    
    [lable5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(lable1);
    }];
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lable1.mas_right);
        make.right.equalTo(lable3.mas_left);
        make.top.equalTo(lable1);
    }];
    [lable4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lable3.mas_right);
        make.right.equalTo(lable5.mas_left);
        make.top.equalTo(lable1);
    }];
    
    UILabel *showLB = [[UILabel alloc] init];
    showLB.text = @"请为账号设置新密码";
    showLB.font = [UIFont boldSystemFontOfSize:14.0];
    UITextField *firstPasswordTF = [[UITextField alloc] init];
    firstPasswordTF.placeholder = @"请输入密码";
    UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *firstLine = [[UIView alloc] init];
    UITextField *secondPasswordTF = [[UITextField alloc] init];
    secondPasswordTF.placeholder = @"请再次确认密码";
    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *secondLine = [[UIView alloc] init];
    UILabel *messageLB = [[UILabel alloc] init];
    messageLB.text = @"密码由6-16位数字、字母或符号组成，至少包含两种字符。";
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"提交" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showLB];
    [self.view addSubview:firstPasswordTF];
    [self.view addSubview:firstBtn];
    [self.view addSubview:firstLine];
    [self.view addSubview:secondPasswordTF];
    [self.view addSubview:secondBtn];
    [self.view addSubview:secondLine];
    [self.view addSubview:messageLB];
    [self.view addSubview:okBtn];
    
    [showLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(lable1.mas_bottom).offset(40);
    }];
    [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(21));
        make.height.equalTo(@(15));
        make.right.equalTo(self.view).offset(-44);
        make.centerY.equalTo(firstPasswordTF);
        make.left.equalTo(firstPasswordTF.mas_right).offset(10);
    }];
    [firstPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(showLB.mas_bottom).offset(20);
    }];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(firstPasswordTF);
        make.right.equalTo(firstBtn);
        make.top.equalTo(firstPasswordTF.mas_bottom).offset(5);
        make.height.equalTo(@(1));
    }];
    [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.right.left.equalTo(firstBtn);
        make.top.equalTo(firstBtn.mas_bottom).offset(40);
    }];
    [secondPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(firstPasswordTF);
        make.centerY.equalTo(secondBtn);
    }];
    [secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(firstLine);
        make.top.equalTo(secondPasswordTF.mas_bottom).offset(5);
    }];
    [messageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(firstLine);
        make.top.equalTo(secondLine.mas_bottom).offset(10);
    }];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(firstLine);
        make.top.equalTo(messageLB.mas_bottom).offset(50);
        make.height.equalTo(@(50));
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
