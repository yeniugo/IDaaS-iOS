//
//  TFVerifyFingerprintViewController.m
//  Trusfort
//
//  Created by 黄怡菲 on 16/3/30.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "TRUVerifyFingerprintViewController.h"
#import "TRUGestureVerifyViewController.h"
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
#import "TRUGestureVerify2ViewController.h"


@interface TRUVerifyFingerprintViewController ()

@property (nonatomic, strong) LOTAnimationView *identifylotView;
@property (nonatomic, strong) LOTAnimationView *fingerLotView;
@property (nonatomic, strong) UILabel *topLabel;

@end

@implementation TRUVerifyFingerprintViewController
{
    int iunmber;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

- (void)setupViews {

    self.linelabel.hidden = YES;
//    self.title = @"指纹验证";
    //iconImgview lotview
    CGFloat lastY = 100;
    
    UIImageView *iconImgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"roundicon"]];
    [self.view addSubview:iconImgview];
    iconImgview.frame = CGRectMake(SCREENW/2.f - 50, 60, 100, 100);
    
    if (kDevice_Is_iPhoneX) {
        iconImgview.frame = CGRectMake(SCREENW/2.f - 50, 100, 100, 100);
    }else{
        iconImgview.frame = CGRectMake(SCREENW/2.f - 50, 60, 100, 100);
    }
    
    _identifylotView= [LOTAnimationView animationNamed:@"GestureAppend.json"];
    _identifylotView.size = CGSizeMake(160, 160);
    _identifylotView.centerX = self.view.centerX;
    _identifylotView.centerY = iconImgview.centerY;
    [self.view addSubview:_identifylotView];
    _identifylotView.hidden = YES;
    
    
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
        [otherModeBtn setTitleColor:RGBCOLOR(32, 144, 54) forState:UIControlStateNormal];
        otherModeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [otherModeBtn addTarget:self action:@selector(otherModeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        if (kDevice_Is_iPhoneX){
            otherModeBtn.frame = CGRectMake(SCREENW/2.f -40, SCREENH - 80, 80, 30);
        }
    }else{
//        UILabel * txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENW/2.f - 122, SCREENH - 50, 165, 20)];
//        [self.view addSubview:txtLabel];
//        txtLabel.text = @"善认·一站式移动身份管理";
//        txtLabel.font = [UIFont systemFontOfSize:14];
//        UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.view addSubview:agreementBtn];
//        agreementBtn.frame = CGRectMake(SCREENW/2.f +35, SCREENH - 50, 90, 20);
//        [agreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
//        [agreementBtn setTitleColor:RGBCOLOR(32, 144, 54) forState:UIControlStateNormal];
//        agreementBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [agreementBtn addTarget:self action:@selector(lookUserAgreement) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)tapClick{
    [self startVerifyFingerprint:nil];
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
                        
                        [weskSelf.fingerLotView playWithCompletion:^(BOOL animationFinished) {
                            if (animationFinished) {
                                _identifylotView.hidden = NO;
                                [weskSelf.identifylotView playWithCompletion:^(BOOL animationFinished) {
                                    if (animationFinished) {
                                        
                                        NSLog(@"111111111111111");
                                        if (self.openFingerAuth) {
                                            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFinger];
                                            if (_backBlocked) {
                                                _backBlocked(YES);
                                            }
                                            if(self.isFirstRegist){
                                                id delegate = [UIApplication sharedApplication].delegate;
                                                if ([delegate respondsToSelector:@selector(changeRootVC)]) {
                                                    [delegate performSelector:@selector(changeRootVC)];
                                                }
                                            }else{
                                                [self.navigationController popViewControllerAnimated:YES];
                                            }
                                        }else if (self.isDoingAuth) {
                                            [TRUEnterAPPAuthView dismissAuthView];
                                        }else{
                                            if(self.isFirstRegist){
                                                id delegate = [UIApplication sharedApplication].delegate;
                                                if ([delegate respondsToSelector:@selector(changeRootVC)]) {
                                                    [delegate performSelector:@selector(changeRootVC)];
                                                }
                                            }else{
                                                [self.navigationController popViewControllerAnimated:YES];
                                            }
                                        }
                                    }
                                }];
                            }
                        }];
                        
                    }else if ([@"再试一次" isEqualToString:info]) {
                        [weskSelf startVerifyFingerprint:nil];
                        
                    }else if ([@"取消验证" isEqualToString:info]) {
                        weskSelf.topLabel.text = @"取消验证，可点击指纹重新认证";
                    } else if ([@"指纹验证失败" isEqualToString:info]){
                        weskSelf.topLabel.text = @"指纹登录失败";
                        if (weskSelf.isDoingAuth) {
                            [weskSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"验证次数过多，我们将通过重新初始化验证您的身份，点击确认将开始进行初始化" confrimTitle:@"确定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                                NSString *userid = [TRUUserAPI getUser].userId;
                                [xindunsdk deactivateUser:userid];
                                [TRUUserAPI deleteUser];
                                [TRUEnterAPPAuthView dismissAuthView];
                                //                                [TRUFingerGesUtil ];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                                id delegate = [UIApplication sharedApplication].delegate;
                                if ([delegate respondsToSelector:@selector(changeRootVCForLogin)]) {
                                    [delegate performSelector:@selector(changeRootVCForLogin) withObject:nil];
                                }
#pragma clang diagnostic pop
                            } cancelBlock:^{
                                
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
                                    if(self.isFirstRegist){
                                        id delegate = [UIApplication sharedApplication].delegate;
                                        if ([delegate respondsToSelector:@selector(changeRootVC)]) {
                                            [delegate performSelector:@selector(changeRootVC)];
                                        }
                                    }else{
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
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
                            info = @"再试一次";
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
                        [weskSelf.fingerLotView playWithCompletion:^(BOOL animationFinished) {
                            if (animationFinished) {
                                _identifylotView.hidden = NO;
                                [weskSelf.identifylotView playWithCompletion:^(BOOL animationFinished) {
                                    if (animationFinished) {
                                        NSLog(@"12121222222222");
                                        if (self.openFingerAuth) {
                                            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFinger];
                                            if (_backBlocked) {
                                                _backBlocked(YES);
                                            }
                                            if(self.isFirstRegist){
                                                id delegate = [UIApplication sharedApplication].delegate;
                                                if ([delegate respondsToSelector:@selector(changeRootVC)]) {
                                                    [delegate performSelector:@selector(changeRootVC)];
                                                }
                                            }else{
                                                [self.navigationController popViewControllerAnimated:YES];
                                            }
                                        }else if (self.isDoingAuth) {
                                            [TRUEnterAPPAuthView dismissAuthView];
                                            
                                        }else{
                                            if(self.isFirstRegist){
                                                id delegate = [UIApplication sharedApplication].delegate;
                                                if ([delegate respondsToSelector:@selector(changeRootVC)]) {
                                                    [delegate performSelector:@selector(changeRootVC)];
                                                }
                                            }else{
                                                [self.navigationController popViewControllerAnimated:YES];
                                            }
                                        }
                                    }
                                }];
                            }
                        }];
                        
                    }else if ([@"再试一次" isEqualToString:info]) {
                        [weskSelf startVerifyFingerprint:nil];
                        
                    }else if ([@"取消验证" isEqualToString:info]) {
                        weskSelf.topLabel.text = @"取消验证，可点击指纹重新认证";
                    } else if ([@"指纹验证失败" isEqualToString:info]){
                        weskSelf.topLabel.text = @"指纹登录失败";
                        if (weskSelf.isDoingAuth) {
                            [weskSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"验证次数过多，我们将通过重新初始化验证您的身份，点击确认将开始进行初始化" confrimTitle:@"确定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                                NSString *userid = [TRUUserAPI getUser].userId;
                                [xindunsdk deactivateUser:userid];
                                [TRUUserAPI deleteUser];
                                [TRUEnterAPPAuthView dismissAuthView];
                                //                                [TRUFingerGesUtil ];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                                id delegate = [UIApplication sharedApplication].delegate;
                                if ([delegate respondsToSelector:@selector(changeRootVCForLogin)]) {
                                    [delegate performSelector:@selector(changeRootVCForLogin) withObject:nil];
                                }
#pragma clang diagnostic pop
                            } cancelBlock:^{
                                
                            }];
                            
                        }
                    }
                });
                
            }];
        }
        
    } else {
        weskSelf.topLabel.text = @"该设备暂时不支持TouchID验证，请去设置开启";
        [self showConfrimCancelDialogViewWithTitle:@"" msg:@"该设备暂时不支持TouchID验证，请去设置开启" confrimTitle:@"确认" cancelTitle:@"" confirmRight:YES confrimBolck:^{
            
        } cancelBlock:nil];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    iunmber = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startVerifyFingerprint:nil];
    });
}

#pragma mark - 其他方式登录
-(void)otherModeBtnClick{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"手势登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YCLog(@"手势登录");
        TRUGestureVerify2ViewController *verifyVC =  [[TRUGestureVerify2ViewController alloc] init];
        verifyVC.isDoingAuth = YES;
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


#pragma mark - 用户协议 UserAgreement
-(void)lookUserAgreement{
    TRULicenseAgreementViewController *lisenceVC = [[TRULicenseAgreementViewController alloc] init];
    [self.navigationController pushViewController:lisenceVC animated:YES];
}

@end
