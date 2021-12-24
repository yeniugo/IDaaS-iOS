//
//  TRULoginPasswordViewController.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/20.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "TRULoginPasswordViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "TRUFingerGesUtil.h"
#import "TRUGestureSettingViewController.h"
#import "TRUGestureVerifyViewController.h"
#import "TRUVerifyFaceViewController.h"
#import "TRUVerifyFingerprintViewController.h"
#import "TRULoginPasswordViewController.h"
#import "TRUUserAPI.h"
#import "TRUhttpManager.h"
#import "xindunsdk.h"
#import "TRUEnterAPPAuthView.h"
@interface TRULoginPasswordViewController ()
@property (nonatomic,weak) UITextField *passwordTF;
@end

@implementation TRULoginPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码登陆";
    // Do any additional setup after loading the view.
    UILabel *showLB = [[UILabel alloc] init];
    showLB.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"欢迎回来 %@",[TRUUserAPI getUser].realname]];
    showLB.textAlignment = NSTextAlignmentCenter;
    showLB.font = [UIFont boldSystemFontOfSize:14];
    UITextField *passwordTF = [[UITextField alloc] init];
    passwordTF.secureTextEntry = YES;
    passwordTF.placeholder = @"请输入密码";
    UIButton *passwordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [passwordBtn addTarget:self action:@selector(passwordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [passwordBtn setImage:[UIImage imageNamed:@"addappeyeclose"] forState:UIControlStateNormal];
    [passwordBtn setImage:[UIImage imageNamed:@"addappeye"] forState:UIControlStateSelected];
//    [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    UIView *verifyLine = [[UIView alloc] init];
    verifyLine.backgroundColor = RGBCOLOR(224, 224, 224);
    self.passwordTF = passwordTF;
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"开始" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    okBtn.backgroundColor = DefaultGreenColor;
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [phoneBtn setTitleColor:DefaultGreenColor forState:UIControlStateNormal];
    [phoneBtn setTitle:@"手机号登陆" forState:UIControlStateNormal];
    UILabel *otherLB = [[UILabel alloc] init];
    otherLB.text = @"其他验证方式";
//    UIButton *gestureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:showLB];
    [self.view addSubview:passwordTF];
    [self.view addSubview:passwordBtn];
    [self.view addSubview:verifyLine];
    [self.view addSubview:okBtn];
    [self.view addSubview:phoneBtn];
    [self.view addSubview:otherLB];
//    [self.view addSubview:gestureBtn];
    
    [showLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_topMargin).offset(40);
    }];
    [passwordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showLB.mas_bottom).offset(50);
        make.right.equalTo(self.view).offset(-40);
        make.width.equalTo(@(20));
        make.height.equalTo(@(17));
    }];
    [passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.centerY.equalTo(passwordBtn);
        make.right.equalTo(passwordBtn.mas_left).offset(-10);
    }];
    [verifyLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.height.equalTo(@(1));
        make.top.equalTo(passwordBtn.mas_bottom).offset(10);
    }];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.height.equalTo(@(50));
        make.top.equalTo(verifyLine.mas_bottom).offset(40);
    }];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(okBtn.mas_bottom).offset(10);
        make.right.equalTo(self.view).offset(-50);
    }];
    [otherLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
//        make.width.height.equalTo(@(35));
        make.top.equalTo(phoneBtn.mas_bottom).offset(30);
    }];
    if ([self checkFaceIDAvailable]) {
        UIButton *gestureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [gestureBtn setImage:[UIImage imageNamed:@"gestureNew"] forState:UIControlStateNormal];
        [gestureBtn addTarget:self action:@selector(gestureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:gestureBtn];
        [gestureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(80);
            make.width.height.equalTo(@(35));
            make.top.equalTo(otherLB.mas_bottom).offset(80);
        }];
        UIButton *faceidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [faceidBtn setImage:[UIImage imageNamed:@"gestureNew"] forState:UIControlStateNormal];
        [faceidBtn addTarget:self action:@selector(faceidBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:faceidBtn];
        [faceidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-80);
            make.width.height.equalTo(gestureBtn);
            make.top.equalTo(gestureBtn);
        }];
    }else if([self checkFingerAvailable]){
        UIButton *gestureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [gestureBtn setImage:[UIImage imageNamed:@"gestureNew"] forState:UIControlStateNormal];
        [gestureBtn addTarget:self action:@selector(gestureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:gestureBtn];
        [gestureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(80);
            make.width.height.equalTo(@(35));
            make.top.equalTo(otherLB.mas_bottom).offset(80);
        }];
        UIButton *fingerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [fingerBtn setImage:[UIImage imageNamed:@"gestureNew"] forState:UIControlStateNormal];
        [fingerBtn addTarget:self action:@selector(fingerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:fingerBtn];
        [fingerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-80);
            make.width.height.equalTo(gestureBtn);
            make.top.equalTo(gestureBtn);
        }];
    }else{
        UIButton *gestureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [gestureBtn setImage:[UIImage imageNamed:@"gestureNew"] forState:UIControlStateNormal];
        [gestureBtn addTarget:self action:@selector(gestureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:gestureBtn];
        [gestureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(80);
            make.width.height.equalTo(@(35));
            make.top.equalTo(otherLB.mas_bottom).offset(80);
        }];
    }
}

- (void)phoneBtnClick:(UIButton *)btn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)passwordBtnClick:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    self.passwordTF.secureTextEntry = !btn.isSelected;
}

- (void)gestureBtnClick:(UIButton *)btn{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSNumber *printNum = [def objectForKey:@"VerifyFingerNumber"];
    if (printNum.intValue == 5) {
        [self showConfrimCancelDialogAlertViewWithTitle:@"手势错误次数过多，不能使用手势解锁" msg:nil confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:nil cancelBlock:nil];
        return;
    }
    if ([TRUFingerGesUtil getLoginAuthGesType] == TRULoginAuthGesTypeNone) {
        [self showConfrimCancelDialogAlertViewWithTitle:@"没有设置手势" msg:nil confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:nil cancelBlock:nil];
    }else{
        TRUGestureVerifyViewController *vc = [[TRUGestureVerifyViewController alloc] init];
        vc.isDoingAuth = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)fingerBtnClick:(UIButton *)btn{
    if ([TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeNone) {
        [self showConfrimCancelDialogAlertViewWithTitle:@"没有设置指纹" msg:nil confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:nil cancelBlock:nil];
    }else{
        TRUVerifyFingerprintViewController *vc = [[TRUVerifyFingerprintViewController alloc] init];
        vc.isDoingAuth = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)faceidBtnClick:(UIButton *)btn{
    if ([TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeNone) {
        [self showConfrimCancelDialogAlertViewWithTitle:@"没有设置FaceID" msg:nil confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:nil cancelBlock:nil];
    }else{
        TRUVerifyFaceViewController *vc = [[TRUVerifyFaceViewController alloc] init];
        vc.isDoingAuth = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)checkFingerAvailable{
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        return NO;
    }
    LAContext *ctx = [[LAContext alloc] init];
    
    if (![ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]){
        return NO;
    }
    return YES;
}

- (BOOL)checkFaceIDAvailable{
    
    LAContext *ctx = [[LAContext alloc] init];
    if (@available(iOS 11.0, *)) {
        if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]){
            if (ctx.biometryType == LABiometryTypeFaceID) {
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
        
    } else {
        YCLog(@"系统版本低于11.0");
        return NO;
    }
}

- (void)okBtnClick:(UIButton *)btn{
    if (self.passwordTF.text.length) {
        
    }else{
        [self showHudWithText:@"请输入密码"];
        [self hideHudDelay:2.0];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *sign = [NSString stringWithFormat:@"%@",self.passwordTF.text];
    NSArray *ctxx = @[@"password",self.passwordTF.text];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [self showHudWithText:nil];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/user/checkPassword"] withParts:dictt onResultWithMessage:^(int errorno, id responseBody, NSString *message) {
        if (errorno == 0) {
            [weakSelf showHudWithText:@"修改密码成功"];
            [weakSelf hideHudDelay:2.0];
            [TRUEnterAPPAuthView dismissAuthView];
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
