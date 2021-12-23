//
//  TRULoginDefaultViewController.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/20.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "TRULoginDefaultViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "TRUFingerGesUtil.h"
#import "TRUGestureSettingViewController.h"
#import "TRUGestureVerifyViewController.h"
#import "TRUVerifyFaceViewController.h"
#import "TRUVerifyFingerprintViewController.h"
#import "TRULoginPasswordViewController.h"
#import "ZKVerifyAlertView.h"
#import "TRUUserAPI.h"
#import "TRUhttpManager.h"
#import "xindunsdk.h"
#import "TRUEnterAPPAuthView.h"
@interface TRULoginDefaultViewController ()
@property (nonatomic,weak) UITextField *verifyTF;
@end

@implementation TRULoginDefaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *showLB = [[UILabel alloc] init];
    showLB.text = [NSString stringWithFormat:@"欢迎回来 "];
    showLB.textAlignment = NSTextAlignmentCenter;
    UITextField *verifyTF = [[UITextField alloc] init];
    verifyTF.placeholder = @"请输入验证码";
    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifyTF addTarget:self action:@selector(verifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    verifyBtn.layer.cornerRadius = 5;
    verifyBtn.layer.masksToBounds = YES;
    verifyBtn.backgroundColor = DefaultGreenColor;
    [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    UIView *verifyLine = [[UIView alloc] init];
    verifyLine.backgroundColor = RGBCOLOR(224, 224, 224);
    self.verifyTF = verifyTF;
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    okBtn.layer.cornerRadius = 5;
    okBtn.layer.masksToBounds = YES;
    [okBtn setTitle:@"开始" forState:UIControlStateNormal];
    okBtn.backgroundColor = DefaultGreenColor;
    UIButton *passwordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [passwordBtn addTarget:self action:@selector(passwordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [passwordBtn setTitle:@"切换密码验证" forState:UIControlStateNormal];
    [passwordBtn setTitleColor:DefaultGreenColor forState:UIControlStateNormal];
    UILabel *otherLB = [[UILabel alloc] init];
    otherLB.text = @"其他验证方式";
//    UIButton *gestureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:showLB];
    [self.view addSubview:verifyTF];
    [self.view addSubview:verifyBtn];
    [self.view addSubview:verifyLine];
    [self.view addSubview:okBtn];
    [self.view addSubview:passwordBtn];
    [self.view addSubview:otherLB];
//    [self.view addSubview:gestureBtn];
    
    [showLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_topMargin).offset(40);
    }];
    [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showLB.mas_bottom).offset(50);
        make.right.equalTo(self.view).offset(-40);
        make.width.equalTo(@(150));
        make.height.equalTo(@(40));
    }];
    [verifyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.centerY.equalTo(verifyBtn);
        make.right.equalTo(verifyBtn.mas_left).offset(-10);
    }];
    [verifyLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.height.equalTo(@(1));
        make.top.equalTo(verifyBtn.mas_bottom).offset(10);
    }];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.height.equalTo(@(50));
        make.top.equalTo(verifyLine.mas_bottom).offset(40);
    }];
    [passwordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(okBtn.mas_bottom).offset(10);
        make.right.equalTo(self.view).offset(-50);
    }];
    [otherLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
//        make.width.height.equalTo(@(35));
        make.top.equalTo(passwordBtn.mas_bottom).offset(30);
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
        [gestureBtn setImage:[UIImage imageNamed:@"touchidNew"] forState:UIControlStateNormal];
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

- (void)verifyBtnClick:(UIButton *)btn{
    __weak typeof(self) weakSelf = self;
    ZKVerifyAlertView *verifyView = [[ZKVerifyAlertView alloc] initWithMaximumVerifyNumber:100 results:^(ZKVerifyState state) {
        [weakSelf sendMessage];
    }];
    [verifyView show];
}

- (void)sendMessage{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *phoneStr = [TRUUserAPI getUser].phone;
    NSString *sign = [NSString stringWithFormat:@"%@",phoneStr];
    NSArray *ctxx = @[@"phone",phoneStr];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/user/getAuthcodeToNewPhone"] withParts:dictt onResultWithMessage:^(int errorno, id responseBody, NSString *message) {
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

- (void)okBtnClick:(UIButton *)btn{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *sign = [NSString stringWithFormat:@"%@",self.verifyTF.text];
    NSArray *ctxx = @[@"authcode",self.verifyTF.text];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/user/checkAuthcode"] withParts:dictt onResultWithMessage:^(int errorno, id responseBody, NSString *message) {
        if (errorno == 0) {
            [weakSelf showHudWithText:@"修改密码成功"];
            [weakSelf hideHudDelay:2.0];
            [TRUEnterAPPAuthView dismissAuthView];
        }else{
            
        }
    }];
}

- (void)passwordBtnClick:(UIButton *)btn{
    TRULoginPasswordViewController *vc = [[TRULoginPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
