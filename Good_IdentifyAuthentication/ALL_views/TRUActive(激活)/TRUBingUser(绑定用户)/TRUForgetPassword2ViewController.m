//
//  TRUForgetPassword2ViewController.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/16.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "TRUForgetPassword2ViewController.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
#import "NSString+Regular.h"
@interface TRUForgetPassword2ViewController ()
@property (nonatomic,weak) UITextField *firstPasswordTF;
@property (nonatomic,weak) UITextField *secondPasswordTF;

@end

@implementation TRUForgetPassword2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"重置密码";
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
    firstPasswordTF.secureTextEntry = YES;
    firstPasswordTF.placeholder = @"请输入密码";
    UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [firstBtn addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *firstLine = [[UIView alloc] init];
    firstLine.backgroundColor = RGBCOLOR(224, 224, 224);
    UITextField *secondPasswordTF = [[UITextField alloc] init];
    secondPasswordTF.secureTextEntry = YES;
    secondPasswordTF.placeholder = @"请再次确认密码";
    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [secondBtn addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *secondLine = [[UIView alloc] init];
    secondLine.backgroundColor = RGBCOLOR(224, 224, 224);
    self.firstPasswordTF = firstPasswordTF;
    self.secondPasswordTF = secondPasswordTF;
    [firstBtn setImage:[UIImage imageNamed:@"addappeyeclose"] forState:UIControlStateNormal];
    [firstBtn setImage:[UIImage imageNamed:@"addappeye"] forState:UIControlStateSelected];
    [secondBtn setImage:[UIImage imageNamed:@"addappeyeclose"] forState:UIControlStateNormal];
    [secondBtn setImage:[UIImage imageNamed:@"addappeye"] forState:UIControlStateSelected];
    
    UILabel *messageLB = [[UILabel alloc] init];
    messageLB.text = @"密码由6-16位数字、字母或符号组成，至少包含两种字符。";
    messageLB.numberOfLines = 0;
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"提交" forState:UIControlStateNormal];
    [okBtn.layer setMasksToBounds:YES];
    [okBtn.layer setCornerRadius:5.0];
    okBtn.backgroundColor = DefaultGreenColor;
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
//    self.firstPasswordTF.text = @"11111";
//    self.secondPasswordTF.text = @"11111";
}

- (void)firstBtnClick:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    self.firstPasswordTF.secureTextEntry = !btn.isSelected;
}

- (void)secondBtnClick:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    self.secondPasswordTF.secureTextEntry = !btn.isSelected;
}

- (void)okBtnClick:(UIButton *)btn{
    if (self.firstPasswordTF.text.length && self.secondPasswordTF.text.length && [self.firstPasswordTF.text isEqualToString:self.secondPasswordTF.text]) {
        if ([self.firstPasswordTF.text isPassword]) {
            
        }else{
            [self showHudWithText:@"密码不符合要求"];
            [self hideHudDelay:2.0];
            return;
        }
    }else{
        [self showHudWithText:@"请输入密码"];
        [self hideHudDelay:2.0];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSString *signStr;
    NSString *para;
    signStr = [NSString stringWithFormat:@",\"account\":\"%@\",\"password\":\"%@\"}", self.accountStr, self.firstPasswordTF.text];
    para = [xindunsdk encryptBySkey:self.accountStr ctx:signStr isType:NO];
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/user/resetPassword"] withParts:paramsDic onResultWithMessage:^(int errorno, id responseBody, NSString *message) {
        if (errorno == 0) {
            [weakSelf showHudWithText:@"修改密码成功"];
            [weakSelf hideHudDelay:2.0];
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
