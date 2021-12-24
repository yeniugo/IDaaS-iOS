//
//  TRUBingViewController.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/11/30.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "TRUBingViewController.h"
//#import "Masonry/Masonry.h"
#import "TRURegisterViewController.h"
#import "TRUForgetPasswordViewController.h"
#import "NSString+Regular.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
#import "NSString+Trim.h"
#import "TRUUserAPI.h"
#import "TRUMTDTool.h"
#import "AppDelegate.h"
#import "ZKVerifyAlertView.h"
@interface TRUBingViewController ()
@property (nonatomic,weak) UIView *accountBGView;
@property (nonatomic,weak) UIView *phoneBGView;
@property (nonatomic,weak) UIButton *accountBtn;
@property (nonatomic,weak) UIButton *phoneBtn;
@property (nonatomic,weak) NSTimer *timer;
@property (nonatomic,weak) UIButton *verifyBtn;
@property (nonatomic,weak) UITextField *accountTF;
@property (nonatomic,weak) UITextField *passwordTF;
@property (nonatomic,weak) UITextField *phoneTF;
@property (nonatomic,weak) UITextField *verifyTF;
@property (nonatomic,assign) int totalTime;
@end

@implementation TRUBingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationBar.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *welcomeView = [[UIView alloc] init];
    welcomeView.backgroundColor = RGBCOLOR(227, 232, 247);
    [self.view addSubview:welcomeView];
    
    UILabel *welcomeLB = [[UILabel alloc] init];
    welcomeLB.text = @"欢迎使用中煤ida";
    welcomeLB.textColor = RGBCOLOR(150, 167, 217);
    welcomeLB.font = [UIFont systemFontOfSize:12];
    [welcomeView addSubview:welcomeLB];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"welcomeicon"];
    UILabel *iconLB = [[UILabel alloc] init];
    iconLB.font = [UIFont systemFontOfSize:42];
    iconLB.text = @"中煤IDA";
    
    UIView *iconBG = [[UIView alloc] init];
    [iconBG addSubview:iconView];
    [iconBG addSubview:iconLB];
    
    [self.view addSubview:iconBG];
//    [self.view addSubview:iconLB];
    
    UIButton *accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [accountBtn addTarget:self action:@selector(accountClick:) forControlEvents:UIControlEventTouchUpInside];
    [accountBtn setTitle:@"账户密码登录" forState:UIControlStateNormal];
    [accountBtn setTitle:@"账户密码登录" forState:UIControlStateSelected];
    [accountBtn setTitleColor:RGBCOLOR(51, 51, 51) forState:UIControlStateNormal];
    [accountBtn setTitleColor:DefaultGreenColor forState:UIControlStateSelected];
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn addTarget:self action:@selector(phoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [phoneBtn setTitle:@"手机号登录" forState:UIControlStateNormal];
    [phoneBtn setTitle:@"手机号登录" forState:UIControlStateSelected];
    [phoneBtn setTitleColor:RGBCOLOR(51, 51, 51) forState:UIControlStateNormal];
    [phoneBtn setTitleColor:DefaultGreenColor forState:UIControlStateSelected];
    
    self.accountBtn = accountBtn;
    self.phoneBtn = phoneBtn;
    
    
    [self.view addSubview:accountBtn];
    [self.view addSubview:phoneBtn];
    
    UIView *accountBGView = [[UIView alloc] init];
    self.accountBGView = accountBGView;
    [self.view addSubview:accountBGView];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = DefaultGreenColor;
    
    UIImageView *accountIcon = [[UIImageView alloc] init];
    accountIcon.image = [UIImage imageNamed:@"account"];
    UITextField *accountTF = [[UITextField alloc] init];
    accountTF.placeholder = @"账号";
//    accountTF.backgroundColor = [UIColor redColor];
    UIView *accountLine = [[UIView alloc] init];
    accountLine.backgroundColor = RGBCOLOR(224, 224, 224);
    
    UIImageView *passwordtIcon = [[UIImageView alloc] init];
    passwordtIcon.image = [UIImage imageNamed:@"password"];
    UITextField *passwordTF = [[UITextField alloc] init];
    passwordTF.secureTextEntry = YES;
    passwordTF.placeholder = @"密码";
//    passwordTF.backgroundColor = [UIColor yellowColor];
    UIButton *passwordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [passwordBtn addTarget:self action:@selector(passwordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [passwordBtn setImage:[UIImage imageNamed:@"addappeyeclose"] forState:UIControlStateNormal];
    [passwordBtn setImage:[UIImage imageNamed:@"addappeye"] forState:UIControlStateSelected];
    UIView *passwordLine = [[UIView alloc] init];
    passwordLine.backgroundColor = RGBCOLOR(224, 224, 224);
    
    [accountBGView addSubview:lineView1];
    [accountBGView addSubview:accountIcon];
    [accountBGView addSubview:accountTF];
    [accountBGView addSubview:accountLine];
    [accountBGView addSubview:passwordtIcon];
    [accountBGView addSubview:passwordTF];
    [accountBGView addSubview:passwordBtn];
    [accountBGView addSubview:passwordLine];
    
    self.accountTF = accountTF;
    self.passwordTF = passwordTF;
    
    UIView *phoneBGView = [[UIView alloc] init];
    self.phoneBGView = phoneBGView;
    [self.view addSubview:phoneBGView];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = DefaultGreenColor;
    
    UILabel *countryLB = [[UILabel alloc] init];
    countryLB.text = @"+86";
    countryLB.textColor = RGBCOLOR(58, 58, 58);
    UIImageView *phoneIcon = [[UIImageView alloc] init];
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.placeholder = @"请输入手机号";
//    phoneTF.backgroundColor = [UIColor blueColor];
    UIView *phoneLine = [[UIView alloc] init];
    phoneLine.backgroundColor = RGBCOLOR(224, 224, 224);
    
//    UIImageView *verifytIcon = [[UIImageView alloc] init];
    UITextField *verifyTF = [[UITextField alloc] init];
    verifyTF.placeholder = @"请输入验证码";
//    verifyTF.backgroundColor = [UIColor orangeColor];
    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    verifyBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [verifyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [verifyBtn setTitle:@"发送验证码" forState:UIControlStateDisabled];
    [verifyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [verifyBtn addTarget:self action:@selector(verifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [verifyBtn.layer setMasksToBounds:YES];
    [verifyBtn.layer setCornerRadius:5.0];
    verifyBtn.backgroundColor = DefaultGreenColor;
    self.verifyBtn = verifyBtn;
//    [verifyBtn setImage:nil forState:UIControlStateNormal];
//    [verifyBtn setImage:nil forState:UIControlStateSelected];
    UIView *verifyLine = [[UIView alloc] init];
    verifyLine.backgroundColor = RGBCOLOR(224, 224, 224);
    
    self.phoneTF = phoneTF;
    self.verifyTF = verifyTF;
    
    [phoneBGView addSubview:lineView2];
    [phoneBGView addSubview:countryLB];
    [phoneBGView addSubview:phoneIcon];
    [phoneBGView addSubview:phoneTF];
    [phoneBGView addSubview:phoneLine];
//    [phoneBGView addSubview:verifytIcon];
    [phoneBGView addSubview:verifyTF];
    [phoneBGView addSubview:verifyBtn];
    [phoneBGView addSubview:verifyLine];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateHighlighted];
//    loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    loginBtn.backgroundColor = DefaultGreenColor;
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:5.0];
    [self.view addSubview:loginBtn];
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn addTarget:self action:@selector(registBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [registBtn setTitle:@"注册账户" forState:UIControlStateNormal];
    [registBtn setTitle:@"注册账户" forState:UIControlStateHighlighted];
    [registBtn setTitleColor:DefaultGreenColor forState:UIControlStateNormal];
    [registBtn setTitleColor:DefaultGreenColor forState:UIControlStateHighlighted];
    [self.view addSubview:registBtn];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn addTarget:self action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateHighlighted];
    [forgetBtn setTitleColor:DefaultGreenColor forState:UIControlStateNormal];
    [forgetBtn setTitleColor:DefaultGreenColor forState:UIControlStateHighlighted];
    [self.view addSubview:forgetBtn];
    
    [welcomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.top.equalTo(@(56));
    }];
    [welcomeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(welcomeView).offset(6);
        make.bottom.equalTo(welcomeView).offset(-6);
        make.left.equalTo(welcomeView).offset(11);
        make.right.equalTo(welcomeView);
    }];
    [iconBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(welcomeView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        
    }];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconBG);
        make.width.height.equalTo(iconLB.mas_height);
        make.right.equalTo(iconLB.mas_left).offset(-10);
        make.left.equalTo(iconBG);
        make.bottom.equalTo(iconBG);
    }];
    [iconLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(iconBG);
        make.right.equalTo(iconBG);
        make.centerY.equalTo(iconBG);
    }];
    [accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconBG.mas_bottom).offset(43);
        make.centerX.equalTo(self.view.mas_centerX).dividedBy(2);
    }];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountBtn);
        make.centerX.equalTo(self.view.mas_centerX).dividedBy(2.0/3);
    }];
    [accountBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountBtn.mas_bottom);
        make.left.right.equalTo(self.view);
//        make.height.equalTo(@(200));
    }];
    [phoneBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(accountBGView);
    }];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountBGView).offset(7);
        make.height.equalTo(@(1));
        make.left.equalTo(accountBGView).offset(44);
        make.right.equalTo(accountBGView.mas_centerX).offset(-20);
    }];
    [accountIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountBGView).offset(52);
        make.width.equalTo(@(17.5));
        make.height.equalTo(@(20));
        make.top.equalTo(lineView1.mas_bottom).offset(40);
    }];
    [accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountIcon.mas_right).offset(12);
        make.right.equalTo(accountBGView).offset(-40);
        make.centerY.equalTo(accountIcon);
    }];
    [accountLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountBGView).offset(47.5);
        make.top.equalTo(accountIcon.mas_bottom).offset(10);
        make.right.equalTo(accountBGView).offset(-40);
        make.height.equalTo(@(1));
        
    }];
    [passwordtIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountIcon);
        make.width.equalTo(@(17.5));
        make.height.equalTo(@(21.5));
        make.top.equalTo(accountIcon.mas_bottom).offset(45);
    }];
    [passwordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordtIcon);
        make.width.equalTo(@(21));
        make.height.equalTo(@(17));
        make.right.equalTo(accountBGView).offset(-42);
    }];
    [passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordtIcon.mas_right).offset(12);
        make.right.equalTo(passwordBtn.mas_left).offset(-10);
        make.centerY.equalTo(passwordtIcon);
    }];
    [passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountBGView).offset(47.5);
        make.top.equalTo(passwordtIcon.mas_bottom).offset(10);
        make.right.equalTo(accountBGView).offset(-40);
        make.height.equalTo(@(1));
        make.bottom.equalTo(accountBGView.mas_bottom).offset(-20);
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView1);
        make.height.equalTo(lineView1.mas_height);
        make.right.equalTo(phoneBGView).offset(-44);
        make.left.equalTo(phoneBGView.mas_centerX).offset(20);
    }];
    [countryLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneBGView).offset(46);
        make.centerY.equalTo(accountIcon);
        
    }];
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(countryLB.mas_right).offset(10);
        make.right.equalTo(phoneBGView).offset(-40);
        make.centerY.equalTo(countryLB);
    }];
    [phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(accountLine);
    }];
    [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(phoneBGView).offset(-40);
        make.width.equalTo(@(150));
        make.height.equalTo(@(40));
        make.top.equalTo(phoneLine.mas_bottom).offset(20);
    }];
    [verifyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneBGView).offset(50);
        make.right.equalTo(verifyBtn.mas_left).offset(-6);
        make.centerY.equalTo(passwordtIcon);
    }];
    [verifyLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(passwordLine);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(45);
        make.right.equalTo(self.view).offset(-45);
        make.top.equalTo(accountBGView.mas_bottom).offset(10);
        make.height.equalTo(@(50));
    }];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginBtn);
        make.top.equalTo(loginBtn.mas_bottom).offset(10);
    }];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loginBtn);
        make.top.equalTo(registBtn);
    }];
    [self accountClick:nil];
//    self.accountTF.text = @"10191103";
//    self.passwordTF.text = @"111111";
//    self.phoneTF.text = @"18671280320";
//    self.verifyTF.text = @"1111";
}

- (void)passwordBtnClick:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    self.passwordTF.secureTextEntry = !btn.isSelected;
}

- (void)verifyBtnClick:(UIButton *)btn{
    if (self.phoneTF.text.length && [self.phoneTF.text isPhone]) {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        __weak typeof(self) weakSelf = self;
        
        ZKVerifyAlertView *verifyView = [[ZKVerifyAlertView alloc] initWithMaximumVerifyNumber:100 results:^(ZKVerifyState state) {
            if(state == ZKVerifyStateSuccess){
                [weakSelf sendVerifyCode];
            }
        }];
        [verifyView show];
    }else{
        [self showHudWithText:@"请输入手机号"];
        [self hideHudDelay:2.0];
    }
}

- (void)sendVerifyCode{
    
    [self apply4activeWithType:@"phone"];
}

- (void)loginBtnClick:(UIButton *)btn{
    // 账号密码登陆
    if (self.accountBtn.selected) {
        if (self.accountTF.text.length && self.passwordTF.text.length) {
            
        }else{
            [self showHudWithText:@"请输入账号/密码"];
            [self hideHudDelay:2.0];
            return;
        }
        [self apply4activeWithType:@"employeenum"];
    }else{
        //手机号登陆
        if (self.phoneTF.text.length && self.verifyTF.text.length) {
            
        }else{
            [self showHudWithText:@"请输入手机号/验证码"];
            [self hideHudDelay:2.0];
            return;
        }
        [self activeWithType:@"phone"];
    }
}

- (void)apply4activeWithType:(NSString *)type{
    NSString *signStr;
    NSString *para;
    // 账号密码登陆
    __weak typeof(self) weakSelf = self;
    if (self.accountBtn.selected) {
        signStr = [NSString stringWithFormat:@",\"userno\":\"%@\",\"type\":\"%s\"}", self.accountTF.text, [type UTF8String]];
        para = [xindunsdk encryptBySkey:self.accountTF.text ctx:signStr isType:NO];
    }else{
        //手机号登陆
        signStr = [NSString stringWithFormat:@",\"userno\":\"%@\",\"type\":\"%s\"}", self.phoneTF.text, [type UTF8String]];
        para = [xindunsdk encryptBySkey:self.phoneTF.text ctx:signStr isType:NO];
    }
    
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [self showHudWithText:nil];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/apply4active"] withParts:paramsDic onResultWithMessage:^(int errorno, id responseBody, NSString *message) {
        if (errorno == 0) {
            if ([type isEqualToString:@"phone"]) {
                [weakSelf showHudWithText:@"发送验证码成功"];
                [weakSelf hideHudDelay:2.0];
                [weakSelf startBtncountdown];
            }else{
                [weakSelf activeWithType:@"employeenum"];
            }
        }else{
            if ([type isEqualToString:@"phone"]) {
                [weakSelf showHudWithText:message];
                [weakSelf hideHudDelay:2.0];
            }else{
                [weakSelf showHudWithText:message];
                [weakSelf hideHudDelay:2.0];
            }
        }
    }];
}

- (void)startBtncountdown{
    [self startTimer];
    self.verifyBtn.enabled = NO;
}

- (void)activeWithType:(NSString *)type{
    NSString *signStr;
    NSString *para;
    NSString *userno;
    BOOL isPassword;
    __weak typeof(self) weakSelf = self;
    // 账号密码登陆
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pushID = [stdDefaults objectForKey:@"TRUPUSHID"];
    if (pushID.length == 0) {
        pushID = @"1234567890";
    }
    
    if (self.accountBtn.selected) {
        signStr = [NSString stringWithFormat:@",\"userno\":\"%s\",\"pushid\":\"%s\",\"type\":\"%s\",\"authcode\":\"%s\"", [self.accountTF.text.trim UTF8String],[pushID UTF8String], [type UTF8String],[self.passwordTF.text UTF8String]];
        para = [xindunsdk encryptBySkey:self.accountTF.text.trim ctx:signStr isType:YES];
        userno = self.accountTF.text.trim;
        isPassword = YES;
    }else{
        //手机号登陆
        signStr = [NSString stringWithFormat:@",\"userno\":\"%s\",\"pushid\":\"%s\",\"type\":\"%s\",\"authcode\":\"%s\"", [self.phoneTF.text.trim UTF8String],[pushID UTF8String], [type UTF8String],[self.verifyTF.text.trim UTF8String]];
        para = [xindunsdk encryptBySkey:self.phoneTF.text.trim ctx:signStr isType:YES];
        userno = self.phoneTF.text.trim;
        isPassword = NO;
    }
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [self showHudWithText:nil];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/active"] withParts:paramsDic onResultWithMessage:^(int errorno, id responseBody, NSString *message) {
        [weakSelf hideHudDelay:0.0];
//        errorno = 90041;
        NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
        if (errorno == 0) {
            NSString *userId = nil;
            int err = [xindunsdk privateVerifyCIMSInitForUserNo:userno response:dic[@"resp"] userId:&userId];
            
            if (err == 0) {
                //同步用户信息
                [weakSelf showHudWithText:@"正在激活"];
                NSString *paras = [xindunsdk encryptByUkey:userId ctx:nil signdata:nil isDeviceType:NO];
                NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
//                NSString *baseUrl1 = @"http://192.168.1.150:8004";
                [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
                    [weakSelf hideHudDelay:0.0];
                    NSDictionary *dicc = nil;
                    if (errorno == 0 && responseBody) {
                        dicc = [xindunsdk decodeServerResponse:responseBody];
                        if ([dicc[@"code"] intValue] == 0) {
//                            [TRUMTDTool uploadDevInfo];
                            dicc = dicc[@"resp"];
//                            NSString *oldStr = dicc[@"accounts"];
//                            NSString *replaceOld = @"\"";
//                            NSString *replaceNew = @"\"";
//                            NSString *strUrl = [oldStr stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
//                            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dicc];
//                            dicc[@"accounts"] = strUrl;
                            //用户信息同步成功
                            TRUUserModel *model = [TRUUserModel yy_modelWithDictionary:dicc];
                            NSString *json = [weakSelf toReadableJSONStringWithDic:dicc];
                            model.userId = userId;
                            [TRUUserAPI saveUser:model];
                            [TRUMTDTool uploadDevInfo];
                            AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
                            appdelegate.isNeedPush = YES;
                            if (0) {//yes 表示需要完善信息
                                
                            }else{//同步信息成功，信息完整，跳转页面
#pragma clang diagnostic ignored "-Wundeclared-selector"
                                id delegate = [UIApplication sharedApplication].delegate;
                                if ([delegate respondsToSelector:@selector(changeRootVC)]) {
                                    [delegate performSelector:@selector(changeRootVC)];
                                }
                            }
                        }
                    }
                }];
            }
        }else if(-5004 == errorno){
            [self showHudWithText:@"网络错误，请稍后重试"];
            [self hideHudDelay:2.0];
        }else if(9001 == errorno){
            if (isPassword){
                [self showHudWithText:@"请输入正确的账号/密码"];
                [self hideHudDelay:2.0];
            }else{
                [self showHudWithText:@"请输入正确的账号/验证码"];
                [self hideHudDelay:2.0];
            }
        }else if(9002 == errorno){
            if(isPassword){
                [self showHudWithText:@"密码错误"];
                [self hideHudDelay:2.0];
            }else{
                [self showHudWithText:@"验证码错误"];
                [self hideHudDelay:2.0];
            }
        }else if (9019 == errorno){
            [self deal9019Error];
        }else if (9016 == errorno){
            [self showHudWithText:@"验证码失效"];
            [self hideHudDelay:2.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self resetUI];
            });
        }else if(90041==errorno){
            [self showHudWithText:@"token失效"];
            [self hideHudDelay:2.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self resetUI];
            });
            
        }else if (9036 == errorno){
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"trurestartQRscan" object:nil];
        }else{
            NSString *err = [NSString stringWithFormat:@"%@",message];
            [self showHudWithText:@"激活失败"];
            [self hideHudDelay:2.0];
        }
    }];
}

- (NSString *)toReadableJSONStringWithDic:(NSDictionary *)dic {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

- (void)registBtnClick:(UIButton *)btn{
    TRURegisterViewController *vc = [[TRURegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)forgetBtnClick:(UIButton *)btn{
    TRUForgetPasswordViewController *vc = [[TRUForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)accountClick:(UIButton *)btn{
    self.accountBGView.hidden = NO;
    self.phoneBGView.hidden = YES;
    self.accountBtn.selected = YES;
    self.phoneBtn.selected = NO;
}

- (void)phoneClick:(UIButton *)btn{
    self.accountBGView.hidden = YES;
    self.phoneBGView.hidden = NO;
    self.accountBtn.selected = NO;
    self.phoneBtn.selected = YES;
}

- (void)startTimer{
    __weak typeof(self) weakSelf = self;
    [weakSelf stopTimer];
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:weakSelf selector:@selector(startButtonCount) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.timer = timer;
    self.totalTime = 60;
    [timer fire];
    
}
- (void)stopTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        self.totalTime = 60;
    }
}

- (void)startButtonCount{
    
    if (self.totalTime >= 1) {
        self.totalTime -- ;
        NSString *leftTitle  = [NSString stringWithFormat:@"已发送(%ds)",self.totalTime];
        [self.verifyBtn setTitle:leftTitle forState:UIControlStateDisabled];
    }else{
        self.totalTime = 60;
        [self.verifyBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        self.verifyBtn.enabled = YES;
        [self stopTimer];
    }
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
