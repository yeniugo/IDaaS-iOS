//
//  TFVerifyFingerprintViewController.m
//  Trusfort
//
//  Created by 黄怡菲 on 16/3/30.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "TRUVerifyFingerprintViewController.h"
#import "TRUGestureVerify2ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "AppDelegate.h"
#import "TRUFingerGesUtil.h"
#import "UINavigationBar+BackgroundColor.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "TRUBaseNavigationController.h"
#import "TRUEnterAPPAuthView.h"
#import <Lottie/Lottie.h>
#import "TRULicenseAgreementViewController.h"
#import "TRUCompanyAPI.h"
#import <YYWebImage.h>
#import "TRUhttpManager.h"

@interface TRUVerifyFingerprintViewController ()

//@property (nonatomic, strong) LOTAnimationView *identifylotView;
@property (nonatomic, strong) LOTAnimationView *fingerLotView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, assign) CGFloat lasttime;
@end

@implementation TRUVerifyFingerprintViewController
{
    int iunmber;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

- (void)setupViews {
    
    self.title = @"指纹验证";

    self.linelabel.hidden = YES;
    
    //iconImgview lotview
    CGFloat lastY = 100;
    
    UIImageView *iconImgview = [[UIImageView alloc] init];
    [self.view addSubview:iconImgview];
    NSString *imgurlstr = [TRUCompanyAPI getCompany].logo_url;
    [iconImgview yy_setImageWithURL:[NSURL URLWithString:imgurlstr] placeholder:[UIImage imageNamed:@"ges_bg"]];
    iconImgview.frame = CGRectMake(SCREENW/2.f - 50, 65, 100, 100);
    
    if (kDevice_Is_iPhoneX) {
        iconImgview.frame = CGRectMake(SCREENW/2.f - 50, 105, 100, 100);
    }else{
        iconImgview.frame = CGRectMake(SCREENW/2.f - 50, 65, 100, 100);
    }
    
//    _identifylotView= [LOTAnimationView animationNamed:@"GestureAppend.json"];
//    _identifylotView.size = CGSizeMake(160, 160);
//    _identifylotView.centerX = self.view.centerX;
//    _identifylotView.centerY = iconImgview.centerY;
//    [self.view addSubview:_identifylotView];
//    _identifylotView.hidden = YES;
    
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.font = [UIFont systemFontOfSize:15];
    topLabel.text = @"请验证您的指纹";
    topLabel.textColor = [UIColor darkGrayColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.frame = CGRectMake(0, lastY + 75, SCREEN_WIDTH, 20);
    [self.view addSubview:topLabel];
    self.topLabel = topLabel;
    
    if (kDevice_Is_iPhoneX) {
        topLabel.frame = CGRectMake(0, lastY + 115, SCREEN_WIDTH, 20);
    }else{
        topLabel.frame = CGRectMake(0, lastY + 75, SCREEN_WIDTH, 20);
    }
    
    _fingerLotView = [LOTAnimationView animationNamed:@"fingerprint.json"];
    _fingerLotView.size = CGSizeMake(100, 112);
    _fingerLotView.centerX = self.view.width / 2.f;
    _fingerLotView.centerY = self.view.height/2.f +20;
//    _fingerLotView.y = topLabel.bottom + 50;
    [self.view addSubview:_fingerLotView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [_fingerLotView addGestureRecognizer:tap];
    _fingerLotView.userInteractionEnabled = YES;
    
    
    if (self.isDoingAuth && [TRUFingerGesUtil getLoginAuthGesType] == TRULoginAuthGesTypeture) {
        //忘记手势
        UIButton *otherModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:otherModeBtn];
        otherModeBtn.frame = CGRectMake(SCREENW/2.f -60, SCREENH - 60, 120, 30);
        [otherModeBtn setTitle:@"其他方式登录" forState:UIControlStateNormal];
        [otherModeBtn setTitleColor:RGBCOLOR(247, 153, 15) forState:UIControlStateNormal];
        otherModeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [otherModeBtn addTarget:self action:@selector(otherModeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        if (kDevice_Is_iPhoneX){
            otherModeBtn.frame = CGRectMake(SCREENW/2.f -40, SCREENH - 80, 80, 30);
        }
    }else{
        //用户协议
        UILabel * txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENW/2.f - 115, SCREENH - 40, 160, 20)];
        [self.view addSubview:txtLabel];
        txtLabel.text = @"使用此App,即表示同意该";
        txtLabel.font = [UIFont systemFontOfSize:14];
        txtLabel.hidden = YES;
        UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:agreementBtn];
        agreementBtn.frame = CGRectMake(SCREENW/2.f +35, SCREENH - 40, 90, 20);
        [agreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
        [agreementBtn setTitleColor:RGBCOLOR(247, 153, 15) forState:UIControlStateNormal];
        agreementBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [agreementBtn addTarget:self action:@selector(lookUserAgreement) forControlEvents:UIControlEventTouchUpInside];
        agreementBtn.hidden = YES;
    }
    
}

-(void)tapClick{
    [self startVerifyFingerprint:nil];
//    _fingerLotView.userInteractionEnabled = NO;
}

- (void)startVerifyFingerprint:(UITapGestureRecognizer *)sender{
    
    iunmber++;
    __weak typeof(self) weskSelf = self;
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        self.topLabel.text = @"该系统不支持指纹验证";
        return;
    }
    LAContext *ctx = [[LAContext alloc] init];
    if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]) {
        if (@available(iOS 9.0, *)) {
            ctx.localizedFallbackTitle = @"密码登录";
            
            [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"使用指纹进行登录验证" reply:^(BOOL success, NSError * _Nullable error) {
//                NSLog(@"error = %@", error);
                NSString *info = nil;
                if (success) {
                    info = @"验证成功";
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRUEnterAPPAuthViewSuccess" object:nil];
                }else{
                    switch (error.code) {
                        case LAErrorUserFallback:
                            info = @"再试一次";
                            break;
                        case LAErrorUserCancel:
                        {
                            if (weskSelf.isDoingAuth) {
                                info = @"取消验证";
                            }else{
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    if (_backBlocked) {
                                        _backBlocked(NO);
                                    }
                                    [self.navigationController popViewControllerAnimated:YES];
                                });
                            }
                            break;
                        }
                        case LAErrorTouchIDLockout:{
                            info = @"指纹验证失败";
                            break;
                        }
                        default:
                        {
                            if (iunmber <= 3) {
                                info = @"再试一次";
                            }else{
                                info = @"指纹验证失败";
                            }
                            break;
                        }
                    }
                    YCLog(@"fail");
                }
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    if ([@"验证成功" isEqualToString:info]) {
                        weskSelf.topLabel.text = info;
                        [weskSelf.topLabel setNeedsDisplay];
                        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                        NSNumber *printNum = [[NSNumber alloc] initWithInt:0];
                        [def setObject:printNum forKey:@"VerifyFingerNumber"];
                        [def setObject:printNum forKey:@"VerifyFingerNumber2"];
                        if (weskSelf.completionBlock) {
                            weskSelf.completionBlock();
                        }
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"TRUEnterAPPAuthViewSuccess" object:nil];
                        [weskSelf.fingerLotView playWithCompletion:^(BOOL animationFinished) {
                            if (animationFinished) {
//                                _identifylotView.hidden = NO;
//                                [weskSelf.identifylotView playWithCompletion:^(BOOL animationFinished) {
//                                    if (animationFinished) {
//
//                                    }
////                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRUEnterAPPAuthViewSuccess" object:nil];
//                                }];
                                if (self.openFingerAuth) {
                                    [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFinger];
                                    if (_backBlocked) {
                                        _backBlocked(YES);
                                    }
                                    [self.navigationController popViewControllerAnimated:YES];
                                }else if (self.isDoingAuth) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRUEnterAPPAuthViewSuccess" object:nil];
                                    //                                            [TRUEnterAPPAuthView dismissAuthView];
                                    [self refreshtoken];
                                    //                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"TRUEnterAPPAuthViewSuccess" object:nil];
                                }else{
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            }
                        }];
                        
                    }else if ([@"再试一次" isEqualToString:info]) {
                        [weskSelf startVerifyFingerprint:nil];
                        
                    }else if ([@"取消验证" isEqualToString:info]) {
                        weskSelf.topLabel.text = @"取消验证，可点击指纹重新认证";
                    } else if ([@"指纹验证失败" isEqualToString:info]){
                        weskSelf.topLabel.text = @"指纹登录失败";
                        if (weskSelf.isDoingAuth) {
                            [weskSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"验证次数过多，我们将通过重新初始化验证您的身份，点击确认将开始进行初始化" confrimTitle:@"确定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                                _fingerLotView.userInteractionEnabled = YES;
                                NSString *userid = [TRUUserAPI getUser].userId;
                                [xindunsdk deactivateUser:userid];
                                [TRUUserAPI deleteUser];
//                                [TRUEnterAPPAuthView dismissAuthView];
//                                [HAMLogOutputWindow printLog:@"test10"];
                                [TRULockSWindow dismissAuthView];
                                //                                [TRUFingerGesUtil ];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                                id delegate = [UIApplication sharedApplication].delegate;
                                if ([delegate respondsToSelector:@selector(changeRootVCForLogin)]) {
                                    [delegate performSelector:@selector(changeRootVCForLogin) withObject:nil];
                                }
#pragma clang diagnostic pop
                            } cancelBlock:^{
                                _fingerLotView.userInteractionEnabled = YES;
                            }];
                            
                        }
                    }
                });
            }];
        }else{
            ctx.localizedFallbackTitle = @"密码登录";
            [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"使用指纹进行登录验证" reply:^(BOOL success, NSError * _Nullable error) {
                NSString *info = nil;
                if (success) {
                    info = @"验证成功";
                }else{
                    switch (error.code) {
                        case LAErrorUserFallback:
                            info = @"再试一次";
                            break;
                        case LAErrorUserCancel:
                        {
                            if (weskSelf.isDoingAuth) {
                                info = @"取消验证";
                            }else{
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    if (_backBlocked) {
                                        _backBlocked(NO);
                                    }
                                    [self.navigationController popViewControllerAnimated:YES];
                                });
                            }
                            break;
                        }
                        case LAErrorTouchIDLockout:{
                            info = @"指纹验证失败";
                            break;
                        }
                        default:
                        {
                            if (iunmber <= 3) {
                                info = @"再试一次";
                            }else{
                                info = @"指纹验证失败";
                            }
                            break;
                        }
                    }
                    YCLog(@"fail");
                }
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    if ([@"验证成功" isEqualToString:info]) {
                        weskSelf.topLabel.text = info;
                        [weskSelf.topLabel setNeedsDisplay];
                        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                        NSNumber *printNum = [[NSNumber alloc] initWithInt:0];
                        [def setObject:printNum forKey:@"VerifyFingerNumber"];
                        [def setObject:printNum forKey:@"VerifyFingerNumber2"];
                        if (weskSelf.completionBlock) {
                            weskSelf.completionBlock();
                        }
                        [weskSelf.fingerLotView playWithCompletion:^(BOOL animationFinished) {
                            if (animationFinished) {
//                                _identifylotView.hidden = NO;
//                                [weskSelf.identifylotView playWithCompletion:^(BOOL animationFinished) {
//                                    if (animationFinished) {
//
//                                    }
//                                }];
                                if (self.openFingerAuth) {
                                    [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFinger];
                                    if (_backBlocked) {
                                        _backBlocked(YES);
                                    }
                                    [self.navigationController popViewControllerAnimated:YES];
                                }else if (self.isDoingAuth) {
                                    //                                            [TRUEnterAPPAuthView dismissAuthView];
                                    [self refreshtoken];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRUEnterAPPAuthViewSuccess" object:nil];
                                }else{
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            }
                        }];
                        
                    }else if ([@"再试一次" isEqualToString:info]) {
                        [weskSelf startVerifyFingerprint:nil];
                        
                    }else if ([@"取消验证" isEqualToString:info]) {
                        weskSelf.topLabel.text = @"取消验证，可点击指纹重新认证";
                    } else if ([@"指纹验证失败" isEqualToString:info]){
                        weskSelf.topLabel.text = @"指纹登录失败";
                        if (weskSelf.isDoingAuth) {
                            [weskSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"验证次数过多，我们将通过重新初始化验证您的身份，点击确认将开始进行初始化" confrimTitle:@"确定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                                _fingerLotView.userInteractionEnabled = YES;
                                NSString *userid = [TRUUserAPI getUser].userId;
                                [xindunsdk deactivateUser:userid];
                                [TRUUserAPI deleteUser];
//                                [TRUEnterAPPAuthView dismissAuthView];
//                                [HAMLogOutputWindow printLog:@"test11"];
                                [TRULockSWindow dismissAuthView];
                                //                                [TRUFingerGesUtil ];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                                id delegate = [UIApplication sharedApplication].delegate;
                                if ([delegate respondsToSelector:@selector(changeRootVCForLogin)]) {
                                    [delegate performSelector:@selector(changeRootVCForLogin) withObject:nil];
                                }
#pragma clang diagnostic pop
                            } cancelBlock:^{
                                _fingerLotView.userInteractionEnabled = YES;
                            }];
                            
                        }
                    }
                });
                
            }];
        }

    } else {
        weskSelf.topLabel.text = @"该设备暂时不支持TouchID验证，请去设置开启";
        [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"该设备暂时不支持TouchID验证，请去设置开启" confrimTitle:@"确认" cancelTitle:@"" confirmRight:YES confrimBolck:^{
            
        } cancelBlock:nil];
    }
}

- (void)refreshtoken{
    __weak typeof(self) weakSelf = self;
    NSString *mainuserid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *paras = [xindunsdk encryptByUkey:mainuserid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/token/gen"] withParts:dictt onResult:^(int errorno, id responseBody){
        YCLog(@"111111111111111+");
        //        [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"refreshtoken error = %d",errorno]];
        if(errorno==0){
            YCLog(@"%@",responseBody);
            if (responseBody!=nil) {
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                if([dic[@"code"] intValue]==0){
                    dic = dic[@"resp"];
                    NSString *refreshToken = dic[@"refresh_token"];
                    [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:@"refresh_token"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRUEnterAPPAuthViewSuccess" object:nil];
//                    [HAMLogOutputWindow printLog:@"test12"];
                    [TRULockSWindow dismissAuthView];
                }
            }
        }else if(errorno == -5004){
            [weakSelf showHudWithText:@"网络错误，稍后请重试"];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startVerifyFingerprint:nil];
    });
}
#pragma mark - 用户协议 UserAgreement
-(void)lookUserAgreement{
    TRULicenseAgreementViewController *lisenceVC = [[TRULicenseAgreementViewController alloc] init];
    [self.navigationController pushViewController:lisenceVC animated:YES];
}
#pragma mark - 其他方式登录
-(void)otherModeBtnClick{
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"手势登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YCLog(@"手势登录");
        TRUGestureVerify2ViewController *verifyVC =  [[TRUGestureVerify2ViewController alloc] init];
        verifyVC.isDoingAuth = YES;
        verifyVC.completionBlock = weakSelf.completionBlock;
        [self.navigationController pushViewController:verifyVC animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    // 出现
    [self presentViewController:alertController animated:YES completion:^{
    }];
    
}

@end
