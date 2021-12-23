//
//  TRUForgetPasswordViewController.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/16.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "TRUForgetPasswordViewController.h"
#import "TRUForgetPassword1ViewController.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
@interface TRUForgetPasswordViewController ()
@property (nonatomic,weak) UITextField *accountTF;
@end

@implementation TRUForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"输入账号";
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
    
    UITextField *accountTF = [[UITextField alloc] init];
    accountTF.placeholder = @"请输入账号";
    [self.view addSubview:accountTF];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBCOLOR(224, 224, 224);
    [self.view addSubview:lineView];
    self.accountTF = accountTF;
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn.layer setMasksToBounds:YES];
    [nextBtn.layer setCornerRadius:5.0];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitle:@"下一步" forState:UIControlStateHighlighted];
    nextBtn.backgroundColor = DefaultGreenColor;
    [self.view addSubview:nextBtn];
    
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
    
    [accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(lable1.mas_bottom).offset(40);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(accountTF);
        make.top.equalTo(accountTF.mas_bottom).offset(10);
        make.height.equalTo(@(1));
    }];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(accountTF);
        make.top.equalTo(lineView.mas_bottom).offset(40);
        make.height.equalTo(@(50));
    }];
//    self.accountTF.text = @"10191103";
}

- (void)nextBtnClick:(UIButton *)btn{
    if (self.accountTF.text.length) {
        
    }else{
        [self showHudWithText:@"请输入账号"];
        [self hideHudDelay:2.0];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSString *signStr;
    NSString *para;
    signStr = [NSString stringWithFormat:@",\"account\":\"%@\"}", self.accountTF.text];
    para = [xindunsdk encryptBySkey:self.accountTF.text ctx:signStr isType:NO];
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/user/enterAccount"] withParts:paramsDic onResultWithMessage:^(int errorno, id responseBody, NSString *message) {
        if (errorno == 0) {
            NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
            NSString *emailStr = dic[@"resp"][@"phone"];
            NSString *phoneStr = dic[@"resp"][@"email"];
            NSString *accountStr;
            NSString *type;
            if (phoneStr.length) {
                accountStr = phoneStr;
                type = @"phone";
            }else{
                accountStr = emailStr;
                type = @"email";
            }
            TRUForgetPassword1ViewController *vc = [[TRUForgetPassword1ViewController alloc] init];
            vc.accountStr = accountStr;
            vc.type = type;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            [weakSelf showHudWithText:message];
            [weakSelf hideHudDelay:2.0];
        }
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
