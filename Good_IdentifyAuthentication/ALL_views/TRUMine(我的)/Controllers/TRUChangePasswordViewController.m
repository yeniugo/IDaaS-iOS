//
//  TRUChangePasswordViewController.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/16.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "TRUChangePasswordViewController.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "TRUhttpManager.h"
@interface TRUChangePasswordViewController ()
@property (nonatomic,weak) UITextField *oldpasswordTF;
@property (nonatomic,weak) UITextField *firstpasswordTF;
@property (nonatomic,weak) UITextField *secondpasswordTF;
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
    oldpasswordTF.placeholder = @"请输入旧密码";
    UIButton *oldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *oldLine = [[UIView alloc] init];
    oldLine.backgroundColor = RGBCOLOR(224, 224, 224);
    
    UILabel *firstpasswordLB = [[UILabel alloc] init];
    firstpasswordLB.text = @"新密码";
    UITextField *firstpasswordTF = [[UITextField alloc] init];
    firstpasswordTF.placeholder = @"请输入新密码";
    UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *firstLine = [[UIView alloc] init];
    firstLine.backgroundColor = RGBCOLOR(224, 224, 224);
    
    UILabel *secondpasswordLB = [[UILabel alloc] init];
    secondpasswordLB.text = @"再次输入新密码";
    UITextField *secondpasswordTF = [[UITextField alloc] init];
    secondpasswordTF.placeholder = @"请再次输入新密码";
    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *secondLine = [[UIView alloc] init];
    secondLine.backgroundColor = RGBCOLOR(224, 224, 224);
    
    [oldBtn setImage:[UIImage imageNamed:@"addappeyeclose"] forState:UIControlStateNormal];
    [oldBtn setImage:[UIImage imageNamed:@"addappeye"] forState:UIControlStateSelected];
    [firstBtn setImage:[UIImage imageNamed:@"addappeyeclose"] forState:UIControlStateNormal];
    [firstBtn setImage:[UIImage imageNamed:@"addappeye"] forState:UIControlStateSelected];
    [secondBtn setImage:[UIImage imageNamed:@"addappeyeclose"] forState:UIControlStateNormal];
    [secondBtn setImage:[UIImage imageNamed:@"addappeye"] forState:UIControlStateSelected];
    [oldBtn addTarget:self action:@selector(oldBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [firstBtn addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [secondBtn addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.oldpasswordTF = oldpasswordTF;
    self.firstpasswordTF = firstpasswordTF;
    self.secondpasswordTF = secondpasswordTF;
    oldpasswordTF.secureTextEntry = YES;
    firstpasswordTF.secureTextEntry = YES;
    secondpasswordTF.secureTextEntry = YES;
    
    UILabel *messageLB = [[UILabel alloc] init];
    messageLB.text = @"密码由6-16位数字、字母或符号组成，至少包含两种字符。";
    messageLB.numberOfLines = 0;
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.backgroundColor = DefaultGreenColor;
    okBtn.layer.cornerRadius = 5;
    okBtn.layer.masksToBounds = YES;
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
        make.height.equalTo(@(1));
        make.top.equalTo(oldBtn.mas_bottom).offset(10);
    }];
    [firstpasswordLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oldpasswordLB);
        make.top.equalTo(oldLine.mas_bottom).offset(10);
    }];
    [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.right.equalTo(oldBtn);
        make.top.equalTo(firstpasswordLB.mas_bottom).offset(20);
    }];
    [firstpasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(oldpasswordTF);
        make.centerY.equalTo(firstBtn);
    }];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(oldLine);
        make.top.equalTo(firstBtn.mas_bottom).offset(10);
    }];
    [secondpasswordLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oldpasswordLB);
        make.top.equalTo(firstLine.mas_bottom).offset(10);
    }];
    [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(firstBtn);
        make.top.equalTo(secondpasswordLB.mas_bottom).offset(20);
    }];
    [secondpasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(firstpasswordTF);
        make.centerY.equalTo(secondBtn);
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
        make.height.equalTo(@(50));
        make.top.equalTo(messageLB.mas_bottom).offset(50);
    }];
    
}

- (void)oldBtnClick:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    self.oldpasswordTF.secureTextEntry = !btn.isSelected;
}

- (void)firstBtnClick:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    self.firstpasswordTF.secureTextEntry = !btn.isSelected;
}

- (void)secondBtnClick:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    self.secondpasswordTF.secureTextEntry = !btn.isSelected;
}

- (void)okBtnClick:(UIButton *)btn{
    if (self.oldpasswordTF.text.length && self.firstpasswordTF.text.length && [self.firstpasswordTF.text isEqualToString:self.secondpasswordTF.text]) {
        
    }else{
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *sign = [NSString stringWithFormat:@"%@%@",self.oldpasswordTF.text,self.firstpasswordTF.text];
    NSArray *ctxx = @[@"oldPassword",self.oldpasswordTF.text,@"newPassword",self.firstpasswordTF.text];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/user/editPassword"] withParts:dictt onResultWithMessage:^(int errorno, id responseBody, NSString *message) {
        if (errorno == 0) {
            [weakSelf showHudWithText:@"修改密码成功"];
            [weakSelf hideHudDelay:2.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            
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
