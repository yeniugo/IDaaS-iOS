//
//  TRUVerifyFaceViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/11/27.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUVerifyFaceViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "TRUFingerGesUtil.h"
#import "TRUEnterAPPAuthView.h"
#import "TRULicenseAgreementViewController.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import <Lottie/Lottie.h>
#import "TRUCompanyAPI.h"
#import <YYWebImage.h>

#import "TRUGestureVerify2ViewController.h"
#import "TRUhttpManager.h"

@interface TRUVerifyFaceViewController ()
@property (nonatomic, strong) UILabel *topLabel;
//@property (nonatomic, strong) LOTAnimationView *identifylotView;
@end

@implementation TRUVerifyFaceViewController
{
    int iunmber;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    iunmber = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startVerifyFingerprint:nil];
    });
}
- (void)customUI{
    
    self.title = @"人脸验证";
    
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
    topLabel.text = @"请验证您的Face ID";
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
    
    UIImageView *imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"faceIDbg"]];
    imgview.size = CGSizeMake(SCREENW, 220);
    imgview.x = 0;
    imgview.y = topLabel.bottom + 30;
    [self.view addSubview:imgview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [imgview addGestureRecognizer:tap];
    imgview.userInteractionEnabled = YES;
    
    
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
}

- (void)startVerifyFingerprint:(UITapGestureRecognizer *)sender{
    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        self.topLabel.text = @"该系统低于11.0，不支持人脸验证";
        return;
    }
//    iunmber++;
    __weak typeof(self) weskSelf = self;
    if (@available(iOS 11.0, *)) {
        LAContext *ctx = [[LAContext alloc] init];
        if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]) {
            
            ctx.localizedFallbackTitle = @"密码登录";
            [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"使用FaceID进行登录验证" reply:^(BOOL success, NSError * _Nullable error) {
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
                            info = @"人脸验证失败";
                            break;
                        }
                        case LAErrorSystemCancel:
                            break;
                        default:
                            info = @"再试一次";
                            break;
                    }
                    YCLog(@"fail");
                }
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    if ([@"验证成功" isEqualToString:info]) {
                        weskSelf.topLabel.text = info;
                        [weskSelf.topLabel setNeedsDisplay];
//                        _identifylotView.hidden = NO;
                        
                        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                        NSNumber *printNum = [[NSNumber alloc] initWithInt:0];
                        [def setObject:printNum forKey:@"VerifyFingerNumber"];
                        [def setObject:printNum forKey:@"VerifyFingerNumber2"];
                        if (weskSelf.completionBlock) {
                            weskSelf.completionBlock();
                        }
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"TRUEnterAPPAuthViewSuccess" object:nil];
//                        [weskSelf.identifylotView playWithCompletion:^(BOOL animationFinished) {
//                            if (animationFinished) {
//
//                            }
//                        }];
                        if (self.openFaceAuth) {
                            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFace];
                            if (_backBlocked) {
                                _backBlocked(YES);
                            }
                            [self.navigationController popViewControllerAnimated:YES];
                        }else if (self.isDoingAuth) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"TRUEnterAPPAuthViewSuccess" object:nil];
                            //                                    [TRUEnterAPPAuthView dismissAuthView];
                            [self refreshtoken];
                        }else{
                            [self.navigationController popViewControllerAnimated:YES];
                        }
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"TRUEnterAPPAuthViewSuccess" object:nil];
                    }else if ([@"再试一次" isEqualToString:info]) {
                        [weskSelf startVerifyFingerprint:nil];
                        
                    } else if ([@"取消验证" isEqualToString:info]) {
                        weskSelf.topLabel.text = @"取消验证，可点击图案重新认证";
                    }else if ([@"人脸验证失败" isEqualToString:info]){
                        weskSelf.topLabel.text = @"人脸验证失败";
                        if (weskSelf.isDoingAuth) {
                            [weskSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"验证次数过多，我们将通过重新初始化验证您的身份，点击确认将开始进行初始化" confrimTitle:@"确定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                                
                                NSString *userid = [TRUUserAPI getUser].userId;
                                [xindunsdk deactivateUser:userid];
                                [TRUUserAPI deleteUser];
//                                [TRUEnterAPPAuthView dismissAuthView];
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
                                
                            }];
                            
                        }
                    }
                });
            }];
        } else {
            weskSelf.topLabel.text = @"该设备暂时不支持FaceID验证，请去设置开启";
        }
    } else {
        self.topLabel.text = @"该系统不支持FaceID验证";
        return;
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
                    [TRULockSWindow dismissAuthView];
                }
            }
        }else if(errorno == -5004){
            [weakSelf showHudWithText:@"网络错误，稍后请重试"];
            [weakSelf hideHudDelay:2.0];
        }
    }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
