//
//  TRUPushingViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/30.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUPushingViewController.h"
#import "YCDownSlider.h"
#import "xindunsdk.h"
#import "JPUSHService.h"
#import "TRUAuthModel.h"
#import "TRUUserAPI.h"
#import "TRUIflyMSCUtil.h"
#import "TRUActiveAppViewController.h"
#import <Lottie/Lottie.h>
#import "TRUVoiceVerifyViewController.h"
#import "TRUFaceVerifyViewController.h"
#import "TRUThirdFaceVerifyViewController.h"
#import "TRUThirdVoiceVerifyViewController.h"
#import <YYWebImage.h>
#import "TRUCompanyAPI.h"
#import "TRUhttpManager.h"
@interface TRUPushingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *accountLB;
@property (weak, nonatomic) IBOutlet UILabel *ipLB;
@property (weak, nonatomic) IBOutlet UILabel *localLB;
@property (weak, nonatomic) IBOutlet UILabel *TimeLB;
@property (weak, nonatomic) IBOutlet UILabel *titleAuthLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmButtonTopConstraint;//确认按钮到登录信息的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logLBTopConstraint;//登录账户距离顶部的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logLBLeftConstraint;//"登录账户"按钮左边距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logDetailsLBRightConstraint;//『登录账户』内容详情右边距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigTitleTopConstraint;//"您正在通过**登录"到顶部边距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logLBTopToBigTitleConstraint;//登录账户距离主标题的距离

@property (weak, nonatomic) NSTimer *pushTimer;
@end

@implementation TRUPushingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
    if (self.pushModel) {
        [self commonInit];
    }else{
        [self requestPushModelFromServerWithToken:self.token];
    }
    
}


- (void)setPushModel:(TRUPushAuthModel *)pushModel{
    _pushModel = pushModel;
}

#pragma mark 从服务器获取push模型
- (void)requestPushModelFromServerWithToken:(NSString *)stoken{
    
    [self showActivityWithText:@""];
    [xindunsdk getCIMSUUID:self.userNo];
    __weak typeof(self) weakSelf = self;
    if (self.userNo) {
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSString *sign = stoken;
        NSArray *ctxx = @[@"token",sign];
        NSString *para = [xindunsdk encryptByUkey:self.userNo ctx:ctxx signdata:sign isDeviceType:YES];
        NSDictionary *paramsDic = @{@"params" : para};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/push/fetch"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
            [weakSelf hideHudDelay:0.0];
            NSLog(@"-Push->%d-->%@",errorno,responseBody);
            NSDictionary *dic = nil;
            if (errorno == 0 && responseBody) {
                dic = [xindunsdk decodeServerResponse:responseBody];
                if ([dic[@"code"] intValue] == 0) {
                    dic = dic[@"resp"];
                    TRUPushAuthModel *model = [TRUPushAuthModel modelWithDic:dic];
                    model.token = stoken;
                    weakSelf.pushModel = model;
                    [weakSelf commonInit];
                }
            }else if (9008 == errorno){
                [weakSelf deal9008Error];
            }else if (9019 == errorno){
                [weakSelf deal9019Error];
            }else if (-5004 == errorno){
                [weakSelf showHudWithText:@"网络错误 请稍后重试"];
                [weakSelf hideHudDelay:2.0];
                [weakSelf performSelector:@selector(dismissVC:)  withObject:@"0" afterDelay:2.0];
            }else{
                NSString *err = [NSString stringWithFormat:@"其他错误（%d）and%@",errorno,stoken];
                [weakSelf showHudWithText:err];
                [weakSelf hideHudDelay:2.0];
                [weakSelf performSelector:@selector(dismissVC:) withObject:@"0" afterDelay:2.0];
            }
        }];
        
    }
}


- (void)commonInit{
    [self startCounter];
    self.ipLB.text = self.pushModel.ip;
    self.localLB.text = self.pushModel.location;
    self.TimeLB.text = self.pushModel.dateTime;
    NSString *userName = self.pushModel.username;
    self.titleAuthLB.text = [NSString stringWithFormat:@"您正在通过【%@】登录",self.pushModel.appname];
    if (!userName || userName.length == 0) {
        TRUUserModel *model = [TRUUserAPI getUser];
        if (model.phone.length>0) {
            userName = model.phone;
        }else if (model.email.length>0){
            userName = model.email;
        }else if (model.employeenum.length>0){
            userName = model.employeenum;
        }
    }
    self.accountLB.text = userName;
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefresh3DataNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.dismissBlock) {
            self.dismissBlock(YES);
        }
        if (self.dismissStatusBlock) {
            self.dismissStatusBlock(2);
        }
    }];
}

- (IBAction)cancleBtnClick:(UIButton *)sender {
    
    //    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"OAuthVerify"];
    //    if (str.length > 0 && [str isEqualToString:@"yes"]) {
    ////        [self showHudWithText:@"取消认证"];
    ////        [self hideHudDelay:2.0];
    //        [weakSelf dismissVC:@"0"];
    //    }
    
    __weak typeof(self) weakSelf = self;
    NSString *authtype = self.pushModel.authtype;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [self showHudWithText:@""];
    NSString *user = [TRUUserAPI getUser].userId;
    NSString *sign = [NSString stringWithFormat:@"%@%@", self.pushModel.token,@"2"];
    NSArray *ctxx = @[@"token",self.pushModel.token,@"confirm",@"2"];
    NSString *para = [xindunsdk encryptByUkey:user ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *paramsDic = @{@"params" : para};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/checktoken"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        if (errorno == 0) {
            //结束后调用动画
            [weakSelf post3DataNoti];
            [weakSelf dismissVC:@"0"];
            
        }else if (9002 == errorno){
            [weakSelf showHudWithText:@"已验证"];
            [weakSelf hideHudDelay:2.0];
            [weakSelf performSelector:@selector(dismissVC:)  withObject:@"0" afterDelay:2.5];
        }else if (9008 == errorno){
            [weakSelf deal9008Error];
        }else if (9010 == errorno){
            if ([authtype isEqualToString:@"10"]) {
                [weakSelf show9010Error];
            }else{
                [weakSelf showHudWithText:@"登录失败，系统没有认证"];
                [weakSelf hideHudDelay:2.0];
                [weakSelf performSelector:@selector(dismissVC:) withObject:@"0" afterDelay:2.5];
            }
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"授权错误（%d）",errorno];
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
            [weakSelf performSelector:@selector(dismissVC:) withObject:@"0" afterDelay:2.5];
        }
        if (errorno==0) {
            if(self.dismissStatusBlock){
                self.dismissStatusBlock(1);
            }
            
        }else{
            if (self.dismissStatusBlock) {
                self.dismissStatusBlock(errorno);
            }
        }
    }];
}
//音频或者人脸
- (void)authTimeOut{
    __weak typeof(self) weakSelf = self;
    NSString *authtype = self.pushModel.authtype;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [self showHudWithText:@""];
    NSString *user = [TRUUserAPI getUser].userId;
    NSString *sign = [NSString stringWithFormat:@"%@%@", self.pushModel.token,@"4"];
    NSArray *ctxx = @[@"token",self.pushModel.token,@"confirm",@"4"];
    NSString *para = [xindunsdk encryptByUkey:user ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *paramsDic = @{@"params" : para};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/checktoken"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        if (errorno == 0) {
            
        }else if (9002 == errorno){
            [weakSelf showHudWithText:@"已验证"];
            [weakSelf hideHudDelay:2.0];
            [weakSelf performSelector:@selector(dismissVC:)  withObject:@"0" afterDelay:2.5];
        }else if (9008 == errorno){
            [weakSelf deal9008Error];
        }else if (9010 == errorno){
            if ([authtype isEqualToString:@"10"]) {
                [weakSelf show9010Error];
            }else{
                [weakSelf showHudWithText:@"登录失败，系统没有认证"];
                [weakSelf hideHudDelay:2.0];
                [weakSelf performSelector:@selector(dismissVC:) withObject:@"0" afterDelay:2.5];
            }
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"授权错误（%d）",errorno];
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
            [weakSelf performSelector:@selector(dismissVC:) withObject:@"0" afterDelay:2.5];
        }
    }];
}
- (IBAction)confirm:(id)sender {
    [self downBtnDone];
}

//同意允许登录
-(void)downBtnDone{
    __weak typeof(self) weakSelf = self;
    NSString *facestr = [TRUUserAPI getUser].faceinfo;
    BOOL isInitFace;
    if ([facestr isEqualToString:@"0"]) {
        isInitFace = NO;
    }else{
        isInitFace = YES;
    }
    NSString *authtype = self.pushModel.authtype;
    //    YCLog(@"----->%@",authtype);
    
    if ([authtype containsString:@"&"]) {//多重认证
        NSArray * arr = [authtype componentsSeparatedByString:@"&"];
        if (arr.count >0) {
            if ([arr[0] isEqualToString:@"6"]) {//先人脸 后声纹
                
                if (isInitFace) {
                    TRUThirdFaceVerifyViewController *faceVC = [[TRUThirdFaceVerifyViewController alloc] init];
                    faceVC.facetoken = self.pushModel.token;
                    faceVC.isMoreVerify = YES;
                    
                    faceVC.popThirdFaceBlock =^(){
                        [weakSelf performSelector:@selector(dismissVC:) withObject:@"0" afterDelay:0.5];
                        
                    };
                    [self.navigationController pushViewController:faceVC animated:YES];
                }else{
                    [self showHudWithText:@"您未初始化人脸，请选择其他方式认证"];
                    [self hideHudDelay:2.0];
                    [self performSelector:@selector(cancleBtnClick:) withObject:nil afterDelay:2.0];
                }
                
            }else if ([arr[0] isEqualToString:@"7"]){//先声纹后人脸
                BOOL result = [TRUIflyMSCUtil checkIFlyModel];
                if (result == YES) {
                    TRUThirdVoiceVerifyViewController *vocieVC = [[TRUThirdVoiceVerifyViewController alloc] init];
                    vocieVC.voicetoken = self.pushModel.token;
                    vocieVC.isMoreVerify = YES;
                    
                    vocieVC.popThirdVoiceBlock =^(){
                        [weakSelf performSelector:@selector(dismissVC:) withObject:@"0" afterDelay:0.5];
                    };
                    [self.navigationController pushViewController:vocieVC animated:YES];
                }else{
                    [self showHudWithText:@"您未初始化声纹，请选择其他方式认证"];
                    [self hideHudDelay:2.0];
                    [self performSelector:@selector(cancleBtnClick:) withObject:nil afterDelay:2.0];
                }
                
            }
        }
    }
    if ([authtype containsString:@"|"]) {
        
    }
    
    //认证类型为 一键认证:1 声纹:7 人脸:6
    if ([authtype isEqualToString:@"1"] || [authtype isEqualToString:@"0"] || [authtype isEqualToString:@"10"]) {
        __weak typeof(self) weakSelf = self;
        NSString *authtype = self.pushModel.authtype;
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        [self showHudWithText:@""];
        NSString *sign = [NSString stringWithFormat:@"%@%@", self.pushModel.token,@"1"];
        NSArray *ctxx = @[@"token",self.pushModel.token,@"confirm",@"1"];
        NSString *para = [xindunsdk encryptByUkey:self.userNo ctx:ctxx signdata:sign isDeviceType:NO];
        NSDictionary *paramsDic = @{@"params" : para};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/checktoken"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
            [weakSelf hideHudDelay:0.0];
            
            if (weakSelf.dismissStatusBlock) {
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    int backNO = errorno;
                    if (backNO == 9002) {
                        backNO = 2010;
                    }else if (backNO == 9010){
                        backNO = 2011;
                    }
                    weakSelf.dismissStatusBlock(backNO);
                }];
            }else{
                if (errorno == 0) {
                    //结束后调用动画
                    [weakSelf post3DataNoti];
                    [weakSelf performSelector:@selector(dismissVC:) withObject:@"1" afterDelay:0.5];
                }else if (9002 == errorno){
                    [weakSelf showHudWithText:@"信息已失效"];
                    [weakSelf hideHudDelay:2.0];
                    [weakSelf performSelector:@selector(dismissVC:)  withObject:@"0" afterDelay:2.5];
                }else if (9008 == errorno){
                    [weakSelf deal9008Error];
                }else if (9010 == errorno){
                    
                    if ([authtype isEqualToString:@"10"]) {
                        [weakSelf show9010Error];
                    }else{
                        [weakSelf showHudWithText:@"登录失败，系统没有认证"];
                        [weakSelf hideHudDelay:2.0];
                        [weakSelf performSelector:@selector(dismissVC:) withObject:@"0" afterDelay:2.5];
                    }
                    
                }else if (9019 == errorno){
                    [weakSelf deal9019Error];
                }else{
                    NSString *err = [NSString stringWithFormat:@"获取验证请求失败，请稍后重试（%d）",errorno];
                    [weakSelf showHudWithText:err];
                    [weakSelf hideHudDelay:2.0];
                    [weakSelf performSelector:@selector(dismissVC:) withObject:@"0" afterDelay:2.5];
                }
            }
            
        }];
        
    }else if ([self.pushModel.authtype isEqualToString:@"6"] || [self.pushModel.authtype isEqualToString:@"7"]){//人脸
        __weak typeof(self) weakSelf = self;
        NSString *token = self.pushModel.token;
        
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"OAuthVerify"];
        if (str.length > 0 && [str isEqualToString:@"yes"]) {//第三方认证
            
            if ([self.pushModel.authtype isEqualToString:@"6"]) {//人脸
                
                if (isInitFace) {
                    TRUThirdFaceVerifyViewController *faceVC = [[TRUThirdFaceVerifyViewController alloc] init];
                    faceVC.facetoken = self.pushModel.token;
                    faceVC.popThirdFaceBlock =^(){
                        [weakSelf performSelector:@selector(dismissVC:) withObject:@"0" afterDelay:0.5];
                    };
                    [self.navigationController pushViewController:faceVC animated:YES];
                }else{
                    [self showHudWithText:@"您未初始化人脸，请选择其他方式认证"];
                    [self hideHudDelay:2.0];
                    [self performSelector:@selector(cancleBtnClick:) withObject:nil afterDelay:2.0];
                }
                
            }
            if ([self.pushModel.authtype isEqualToString:@"7"]) {//声纹
                
                BOOL result = [TRUIflyMSCUtil checkIFlyModel];
                if (result == YES) {
                    TRUThirdVoiceVerifyViewController *vocieVC = [[TRUThirdVoiceVerifyViewController alloc] init];
                    vocieVC.voicetoken = self.pushModel.token;
                    vocieVC.popThirdVoiceBlock =^(){
                        [self performSelector:@selector(dismissVC:) withObject:@"0" afterDelay:0.5];
                    };
                    [weakSelf.navigationController pushViewController:vocieVC animated:YES];
                    
                }else{
                    [weakSelf showHudWithText:@"您未初始化声纹，请选择其他方式认证"];
                    [weakSelf hideHudDelay:2.0];
                    [weakSelf performSelector:@selector(cancleBtnClick:) withObject:nil afterDelay:2.0];
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"OAuthVerify"];
        }else{
            if ([self.pushModel.authtype isEqualToString:@"6"]) {//人脸
                NSString *currentTimeStr = [self getCurrentTimes];
//                int dd = [self compareDate:currentTimeStr withDate:@"2019-03-30"];
                int dd = 1;
                if (dd >= 0) {
                    [self setDismissBlock:^(BOOL confirm){
                        if (confirm) {
                            [weakSelf popFaceAuthViewToken:token];
                        }
                    }];
                    [self performSelector:@selector(dismissVC:) withObject:@"1" afterDelay:0.4];
                    
                }else{
                    [self showHudWithText:@"您所使用的人脸认证服务已到期，即将更新，请耐心等待。"];
                    [self hideHudDelay:2.0];
                    [self performSelector:@selector(dismissVC:) withObject:@"1" afterDelay:2.5];
                }
            }
            if ([self.pushModel.authtype isEqualToString:@"7"]) {//声纹
                [self checkIFlyModel];
            }
        }
        
    }
}

- (void)post3DataNoti{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefresh3DataNotification object:nil];
    
}
- (void)dismissVC:(NSString *)confrim{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [JPUSHService setBadge:0];
        if (self.dismissBlock) {
            BOOL res = [confrim isEqualToString:@"1"] ? YES : NO;
            self.dismissBlock(res);
        }
//        if (self.dismissStatusBlock) {
//            int status = [confrim isEqualToString:@"1"] ? 0 : 1;
//            self.dismissStatusBlock(status);
//        }
        [self.pushTimer invalidate];
        self.pushTimer = nil;
        [self showTimeoutTip];
    }];
}
- (void)checkIFlyModel{
    __weak typeof(self) weakSelf = self;
    BOOL result = [TRUIflyMSCUtil checkIFlyModel];
    if (result == YES) {
        [self performSelector:@selector(dismissVC:) withObject:@"1" afterDelay:0.25];
        [self setDismissBlock:^(BOOL confirm){
            if (confirm) {
                [weakSelf popVoiceAuthViewToken:weakSelf.pushModel.token];
            }
        }];
        
    }else{
        [self showHudWithText:@"您未初始化声纹，请选择其他认证"];
        [self hideHudDelay:2.0];
        [self performSelector:@selector(cancleBtnClick:) withObject:nil afterDelay:2.0];
    }
    
}
#pragma mark - 声纹验证
-(void)popVoiceAuthViewToken:(NSString *)token{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    TRUVoiceVerifyViewController *vocieVC = [[TRUVoiceVerifyViewController alloc] init];
    vocieVC.voicetoken = token;
    vocieVC.isTest = NO;
    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:vocieVC];
    if (rootVC.presentedViewController) {
        [rootVC.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [rootVC presentViewController:nav animated:YES completion:nil];
        }];
    }else{
        [rootVC presentViewController:nav animated:YES completion:nil];
    }
}
- (void)popFaceAuthViewToken:(NSString *)token{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    TRUFaceVerifyViewController *faceVC = [[TRUFaceVerifyViewController alloc] init];
    faceVC.facetoken = token;
    faceVC.isTest = NO;
    if (rootVC.presentedViewController) {
        [rootVC.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [rootVC presentViewController:faceVC animated:YES completion:nil];
        }];
    }else{
        [rootVC presentViewController:faceVC animated:YES completion:nil];
    }
}


- (void)startCounter{
    
    pushCount = self.pushModel.ttl;
    if (pushCount == 0) pushCount = 0;
    __weak typeof(self) weakSelf = self;
    if (!self.pushTimer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:weakSelf selector:@selector(timeselector) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [timer fire];
        self.pushTimer = timer;
    }
    
}
static NSInteger pushCount = 0;
-(void)timeselector{
    pushCount --;
    YCLog(@"push1----");
    if (pushCount <= 0) {
        YCLog(@"push2----");
        [self.pushTimer invalidate];
        self.pushTimer = nil;
        [self showTimeoutTip];
    }
}

- (void)show9010Error{
    
    [self showConfrimCancelDialogViewWithTitle:@"" msg:@"该应用还未激活，无法完成认证操作，请返回原APP或完成应用激活" confrimTitle:@"激活应用" cancelTitle:@"返回" confirmRight:YES confrimBolck:^{
        TRUAuthModel *model = [[TRUAuthModel alloc] init];
        model.appid = self.pushModel.appid;
        TRUActiveAppViewController *activeVC = [[TRUActiveAppViewController alloc] init];
        activeVC.authModel = model;
        activeVC.isFromAuthView = YES;
        [self.navigationController pushViewController:activeVC animated:YES];
        
    } cancelBlock:^{
        [self dismissVC:@"0"];
    }];
}
- (void)showTimeoutTip{
    __weak typeof(self) weakSelf = self;
    if (self.dismissStatusBlock) {
        return;
    }
    [self showConfrimCancelDialogViewWithTitle:@"请求超时" msg:@"由于您的认证请求已超时，蓝证无法确认您的身份，请重新发起认证请求" confrimTitle:@"OK" cancelTitle:nil confirmRight:NO confrimBolck:^{
        [weakSelf authTimeOut];
        [weakSelf post3DataNoti];
        [weakSelf dismissVC:nil];
    } cancelBlock:nil];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = YES;
    //北明项目
//    _logoImgView.hidden = YES;
//    NSString *spName = [TRUCompanyAPI getCompany].icon_url;
//    if ([spName isEqualToString:@"湖南高招"]) {
//        _logoImgView.image = [UIImage imageNamed:@"HNGZlogo"];
//        _Imgwidth.constant = 120.f;
//    }else if ([spName isEqualToString:@"成都银行"]){
//        _logoImgView.image = [UIImage imageNamed:@"CDYHlogo"];
//        _Imgwidth.constant = 120.f;
//    }else{
//        _logoImgView.image = [UIImage imageNamed:@"pushicon"];
//        _Imgwidth.constant = 120.f;
//    }
    
    //实现背景渐变
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
//    gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = CGRectMake(0, 0, SCREENW, SCREENH);
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
//    [self.bgview.layer addSublayer:gradientLayer];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组
//    gradientLayer.colors = @[(__bridge id)startColor.CGColor,
//                             (__bridge id)endColor.CGColor];
    
    //设置颜色分割点（范围：0-1）
//    gradientLayer.locations = @[@(0.f), @(1.0f)];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)customUI{
    self.linelabel.hidden = YES;
    self.view.backgroundColor = DefaultGreenColor;
    self.bigTitleTopConstraint.constant = 118*PointHeightPointRatio6;
    if(IS_IPHONE_5||IS_IPHONE_4_OR_LESS){
        self.confirmButtonTopConstraint.constant = 10;
        self.logLBLeftConstraint.constant = 20;
        self.logDetailsLBRightConstraint.constant = 20;
    }
    if(IS_IPHONE_4_OR_LESS){
        self.logLBTopConstraint.constant = 120;
        self.logLBTopToBigTitleConstraint.constant = 10;
    }
//    self.cancleBtn.layer.masksToBounds = YES;
//    self.cancleBtn.layer.cornerRadius = 10;
//    self.cancleBtn.layer.borderWidth = 1.f;
//    self.cancleBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.cancleBtn.backgroundColor = RGBCOLOR(249, 134, 103);
//
//    myslider = [[YCDownSlider alloc] initWithFrame:CGRectMake(SCREENW/2.f - 35,0, 70, 220)];
//    if (SCREENW == 320) {
//        myslider.centerY = self.view.centerY -30;
//    }else if (kDevice_Is_iPhoneX){
//        myslider.centerY = self.view.centerY +60;
//    }else if (IS_IPHONE_6P){
//        myslider.centerY = self.view.centerY +40;
//    }else{
//        myslider.centerY = self.view.centerY;
//    }
//    [self.view addSubview:myslider];
    
//    _lotview = [LOTAnimationView animationNamed:@"pushDone"];
//    [self.view addSubview:_lotview];
//    _lotview.frame = CGRectMake(SCREENW/2.f - 80, 0, 160, 140);
//    _lotview.hidden = YES;
//
//    _canclelotview = [LOTAnimationView animationNamed:@"pushcanale"];
//    [self.view addSubview:_canclelotview];
//    _canclelotview.frame = CGRectMake(SCREENW/2.f - 75, 0, 160, 155);
//    _canclelotview.hidden = YES;
//
//
//    if (kDevice_Is_iPhoneX){
//        _canclelotview.centerY = self.view.centerY + 60;
//        _lotview.centerY = self.view.centerY + 60;
//    }else{
//        _canclelotview.centerY = self.view.centerY-20;
//        _lotview.centerY = self.view.centerY-20;
//    }
    
//    startColor = [UIColor colorWithRed:255.0/255 green:102/255.0 blue:51/255.0 alpha:1];
//    endColor = [UIColor colorWithRed:235.0/255 green:99/255.0 blue:99/255.0 alpha:1];
//    __weak typeof(self) weakSelf = self;
//    myslider.sliderValueChanged = ^(CGFloat Value){
//        [weakSelf setchanged:Value];
//    };
//    myslider.sliderValueEnd = ^(CGFloat Value){
//        [weakSelf isDone:Value];
//    };
//
//    if (kDevice_Is_iPhoneX) {
//        _imgY.constant = 25;
//        _cancleBtnY.constant = 50;
//        _backBtnY.constant = 40;
//        _titleY.constant = 45;
//        _labelY.constant = 40;
//    }
    
}
//-(void)isDone:(CGFloat)value{
//    CGFloat Rate = (value - 0.083799)/(1-0.083799);
//    if (Rate >= 0.878048) {
//        __weak typeof(self) weakSelf = self;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            //结束后调用动画
//            myslider.hidden = YES;
//            weakSelf.lotview.hidden = NO;
//            [weakSelf.lotview playWithCompletion:^(BOOL animationFinished){
//                [weakSelf downBtnDone];
//            }];
//        });
//    }
//}

-(void)setchanged:(CGFloat)value{
    /**
     *顶端*R 255->0 *G 102->195 *B 51->104
     */
    /**
     *底端 *R 235->0 *G 99->161 *B 99->121
     */
    
    CGFloat Rate = (value - 0.083799)/(1-0.083799);
    CGFloat topR = 255 - 255 *Rate;
    CGFloat topG = 102 + (195 - 102) *Rate;
    CGFloat topB = 51 + (104 - 51) *Rate;
    
    UIColor *topColor = [UIColor colorWithRed:topR/255.0 green:topG/255.0 blue:topB/255.0 alpha:1];
    
    CGFloat bottomR = 235 - 235 *Rate;
    CGFloat bottomG = 99 + (161- 99) *Rate;
    CGFloat bottomB = 99 + (121- 99) *Rate;
    
    UIColor *bottomColor = [UIColor colorWithRed:bottomR/255.0 green:bottomG/255.0 blue:bottomB/255.0 alpha:1];
    
    
    //设置颜色数组
//    gradientLayer.colors = @[(__bridge id)topColor.CGColor,
//                             (__bridge id)bottomColor.CGColor];
    
}


-(NSString*)getCurrentTimes{
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
    return currentDateStr;
}

//比较两个日期大小
-(int)compareDate:(NSString*)startDate withDate:(NSString*)endDate{
    
    int comparisonResult;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:startDate];
    date2 = [formatter dateFromString:endDate];
    NSComparisonResult result = [date1 compare:date2];
    //    NSLog(@"result==%ld",(long)result);
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            comparisonResult = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            comparisonResult = -1;
            break;
            //date02=date01
        case NSOrderedSame:
            comparisonResult = 0;
            break;
        default:
            //NSLog(@"erorr dates %@, %@", date1, date2);
            break;
    }
    return comparisonResult;
}

@end
