//
//  TRUSchemeToken.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/16.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUSchemeTokenViewController.h"
#import "TRUUserAPI.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
#import "TRUFingerGesUtil.h"
#import "TRUTokenUtil.h"
#import "TRUEnterAPPAuthView.h"
#import "AppDelegate.h"
#import "TRUMultipleAccountsSchemeViewController.h"
#import "TRUSubUserModel.h"
#import "HAMLogOutputWindow.h"
@interface TRUSchemeTokenViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, assign) int64_t delayTime;
@end

@implementation TRUSchemeTokenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YCLog(@"TRUSchemeTokenViewController viewDidLoad");
//    [HAMLogOutputWindow printLog:@"scheme加载"];
    self.delayTime = 0.1;
    // Do any additional setup after loading the view.
//    self.loadingView = [[UIActivityIndicatorView alloc] init];
//    CGFloat w = 30.0;
//    CGFloat h = w;
//    CGFloat x = [UIScreen mainScreen].bounds.size.width/2 - w/2;
//    CGFloat y = [UIScreen mainScreen].bounds.size.height/2-h/2;
//    self.loadingView.frame = CGRectMake(x, y, w, h);
//    [self.view addSubview:self.loadingView];
//    [self.loadingView startAnimating];
//    self.loadingView.color = [UIColor blackColor];
//    self.loadingView.userInteractionEnabled = NO;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNetToken) name:TRUGetNetTokenKey object:nil];
    __weak typeof(self) weakSelf = self;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.thirdAwakeTokenStatus==1) {
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPushToken) name:@"TRUEnterAPPAuthViewSuccess" object:nil];
    [self getToken];
    NSString *log = [NSString stringWithFormat:@"SchemeTokenViewController viewDidLoad,vc = %@",self];
    DDLogError(log);
}

- (void)showPushToken{
    NSString *log = [NSString stringWithFormat:@"SchemeTokenViewController showPushToken 1,vc = %@",self];
    DDLogError(log);
    if([TRUUserAPI haveSubUser]){
//        [HAMLogOutputWindow printLog:@"有子账号"];
        __weak typeof(self) weakSelf = self;
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSString *userid = [TRUUserAPI getUser].userId;
        NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
        NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
        NSString *log1 = [NSString stringWithFormat:@"SchemeTokenViewController showPushToken 2,vc = %@",self];
        DDLogError(log1);
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
            NSString *log2 = [NSString stringWithFormat:@"SchemeTokenViewController showPushToken 3,vc = %@,error = %d",self,errorno];
            DDLogError(log2);
//            [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"getuserinfo error =%d",errorno]];
            [weakSelf hideHudDelay:0.0];
            NSDictionary *dicc = nil;
            if (errorno == 0 && responseBody) {
                dicc = [xindunsdk decodeServerResponse:responseBody];
                if ([dicc[@"code"] intValue] == 0) {
                    dicc = dicc[@"resp"];
                    //用户信息同步成功
                    TRUUserModel *model = [TRUUserModel modelWithDic:dicc];
                    model.userId = userid;
                    [TRUUserAPI saveUser:model];
                    //同步信息成功，信息完整，跳转页面
                    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                    NSMutableArray *mutarray = [NSMutableArray array];
                    for (int i = 0; i<model.accounts.count; i++) {
                        TRUSubUserModel *submodel = model.accounts[i];
                        if ([submodel.appId isEqualToString:delegate.appid]) {
                            [mutarray addObject:submodel];
                        }
                    }
                    if (mutarray.count==0) {
                        NSString *userid = [TRUUserAPI getUser].userId;
                        [weakSelf getTokenWithRefreshTokenAndTokenByUserid:userid];
//                        [HAMLogOutputWindow printLog:@"1"];
                    }else{
                        TRUMultipleAccountsSchemeViewController *pushvc = [[TRUMultipleAccountsSchemeViewController alloc] init];
                        [mutarray insertObject:model.accounts[0] atIndex:0];
                        pushvc.multipleAccountsArray = mutarray;
                        pushvc.backBlock = ^(NSString * _Nonnull userId) {
//                            [HAMLogOutputWindow printLog:userId];
                            [weakSelf getTokenWithRefreshTokenAndTokenByUserid:userId];
                        };
                        [self.navigationController pushViewController:pushvc animated:YES];
                        if (self.navigationController==nil) {
//                            [HAMLogOutputWindow printLog:@"3"];
                        }
//                        [HAMLogOutputWindow printLog:@"2"];
                    }
//                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                    dic[@"token"] = @"12313123131231";
//                    delegate.appCompletionBlock(dic);
//                    TRUMultipleAccountsSchemeViewController *pushvc = [[TRUMultipleAccountsSchemeViewController alloc] init];
//                    pushvc.backBlock = ^(NSString * _Nonnull userId) {
//                        NSString *userid = [TRUUserAPI getUser].userId;
//                        [self getTokenWithRefreshTokenAndTokenByUserid:userid];
//                    };
//                    [self.navigationController pushViewController:pushvc animated:YES];
                }
            }else if(9008 == errorno){
                //秘钥失效
                [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
                [TRUUserAPI deleteUser];
                [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
                [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
                !weakSelf.completionBlock ? : weakSelf.completionBlock(nil);
            }else if (9019 == errorno){
                //用户被禁用 取本地
                AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                if (delegate.isFromSDK) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    dic[@"tokenerror"] = @(9019);
                    if (delegate.appCompletionBlock) {
//                        delegate.appCompletionBlock(dic);
                    }
                }else{
                    [self deal9019Error];
                }
                
                TRUUserModel *model = [TRUUserAPI getUser];
                !weakSelf.completionBlock ? : weakSelf.completionBlock(model);
            }else{
                AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                if (delegate.isFromSDK) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    dic[@"tokenerror"] = @(errorno);
                    if (delegate.appCompletionBlock) {
//                        delegate.appCompletionBlock(dic);
                    }
                }else{
                    delegate.soureSchme = nil;
                    delegate.thirdAwakeTokenStatus = 0;
                    delegate.isFromSDK = NO;
                    delegate.isNeedPush = NO;
                }
                TRUUserModel *model = [TRUUserAPI getUser];
                !weakSelf.completionBlock ? : weakSelf.completionBlock(model);
            }
        }];
    }else{
//        [HAMLogOutputWindow printLog:@"没有子账号"];
        NSString *userid = [TRUUserAPI getUser].userId;
        [self getTokenWithRefreshTokenAndTokenByUserid:userid];
    }
}

- (void)getTokenWithRefreshTokenAndTokenByUserid:(NSString *)userid{
    __weak typeof(self) weakSelf = self;
    NSString *mainuserid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *paras = [xindunsdk encryptByUkey:mainuserid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    YCLog(@"111111111111111");
    NSString *log = [NSString stringWithFormat:@"SchemeTokenViewController getTokenWithRefreshTokenAndTokenByUserid 1,vc = %@,userid = %@",self,userid];
    DDLogError(log);
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/token/gen"] withParts:dictt onResult:^(int errorno, id responseBody){
        YCLog(@"111111111111111+");
//        [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"refreshtoken error = %d",errorno]];
        NSString *log1 = [NSString stringWithFormat:@"SchemeTokenViewController getTokenWithRefreshTokenAndTokenByUserid 2,vc = %@,error = %d",self,errorno];
        DDLogError(log1);
        if(errorno==0){
            YCLog(@"%@",responseBody);
            if (responseBody!=nil) {
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                if([dic[@"code"] intValue]==0){
                    dic = dic[@"resp"];
                    NSString *refreshToken = dic[@"refresh_token"];
                    [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:@"refresh_token"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    YCLog(@"refresh_token = 1 %@",refreshToken);
                    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                    NSString *sign = [NSString stringWithFormat:@"%@%@%@",userid,refreshToken,delegate.appid];
                    NSArray *ctxx = @[@"userId",userid,@"refreshToken",refreshToken,@"appId",delegate.appid];
                    NSString *paras = [xindunsdk encryptByUkey:mainuserid ctx:ctxx signdata:sign isDeviceType:NO];
                    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
                    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/token/refresh"] withParts:dictt onResult:^(int errorno, id responseBody){
                        YCLog(@"errorno = %d",errorno);
//                        [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"token error = %d",errorno]];
                        NSString *log1 = [NSString stringWithFormat:@"SchemeTokenViewController getTokenWithRefreshTokenAndTokenByUserid 3,vc = %@,error = %d",self,errorno];
                        DDLogError(log1);
                        if (errorno==0) {
                            if (responseBody!=nil) {
                                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                                if ([dic[@"code"] intValue]==0) {
                                    dic = dic[@"resp"];
                                    NSString *token = dic[@"access_token"];
                                    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
                                    dicc[@"token"] = token;
                                    NSString *log2 = [NSString stringWithFormat:@"SchemeTokenViewController getTokenWithRefreshTokenAndTokenByUserid 4,vc = %@,token = %@",self,token];
                                    DDLogError(log2);
                                    if (delegate.isFromSDK) {
                                        
                                    }else{
                                        delegate.soureSchme = dic[@"iosScheme"];
                                    }
                                    if (delegate.appCompletionBlock) {
                                        delegate.appCompletionBlock(dicc);
                                    }
                                }
                            }
                        }else{
                            delegate.soureSchme = nil;
                            delegate.thirdAwakeTokenStatus = 0;
                            delegate.isFromSDK = NO;
                            delegate.isNeedPush = NO;
//                            [weakSelf showHudWithText:[NSString stringWithFormat:@"%d错误",errorno]];
                            [weakSelf showHudWithText:@"刷新refresthtoken失败"];
                            [weakSelf hideHudDelay:2.0];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                if ([delegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                                    UINavigationController *rootnav = delegate.window.rootViewController;
                                    [rootnav popViewControllerAnimated:YES];
                                }
                            });
                        }
                    }];
                }
            }
        }else{
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            delegate.soureSchme = nil;
            delegate.thirdAwakeTokenStatus = 0;
            delegate.isFromSDK = NO;
            delegate.isNeedPush = NO;
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }
    }];
}


- (void)dealloc{
    YCLog(@"scheme vc dealloc");
//    [HAMLogOutputWindow printLog:@"scheme内存释放"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSString *log = [NSString stringWithFormat:@"TRUSchemeTokenViewController,vc = %@",self];
    DDLogError(log);
}

- (void)showFingerWithCompletionBlock:(void (^)(void))success{
    
    if ([TRUFingerGesUtil getLoginAuthType] != TRULoginAuthTypeNone) {
        if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeFinger) {
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFinger];
        }else if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeFace){
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFace];
        }else if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeGesture){
            [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeture];
        }
        [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
//        [TRUEnterAPPAuthView showAuthViewWithCompletionBlock:^{
//            success();
//        }];
    }else{
        if ([TRUFingerGesUtil getLoginAuthGesType] != TRULoginAuthGesTypeNone || [TRUFingerGesUtil getLoginAuthFingerType] != TRULoginAuthFingerTypeNone) {
//            [TRUEnterAPPAuthView showAuthViewWithCompletionBlock:^{
//                success();
//            }];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    __weak typeof(self) weakSelf = self;
//    switch (self.schemetype) {
//        case 1:
//            self.title = @"获取token";
//            break;
//        case 2:
//            self.title = @"获取token";
//            break;
//        case 3:
//            self.title = @"正在登出";
//            break;
//        case 4:
//            self.title = @"登出";
//            break;
//        default:
//            self.title = @"获取token";
//            break;
//    }
    //[self performSelector:@selector(getToken) withObject:nil afterDelay:0.5];
//    [self getToken];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [HAMLogOutputWindow printLog:@"viewWillDisappear"];
}

- (void)getToken{
    __weak typeof(self) weakSelf = self;
    //int64_t delayInSeconds = 1.0;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    switch (delegate.thirdAwakeTokenStatus) {
        case 1:
        {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            NSString *userid = [TRUUserAPI getUser].userId;
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            
            if ([TRUFingerGesUtil getLoginAuthFingerType]==TRULoginAuthFingerTypeNone&&[TRUFingerGesUtil getLoginAuthGesType]==TRULoginAuthGesTypeNone) {
            }else{
                if (delegate.isNeedPush) {
//                    NSString *userid = [TRUUserAPI getUser].userId;
//                    [self getAppTokenWithUserid:userid];
                    NSString *userid = [TRUUserAPI getUser].userId;
                    [self showPushToken];
//                    [HAMLogOutputWindow printLog:@"showpushtoken"];
                }else{
                    if (self.isNeedpush) {
                        NSString *userid = [TRUUserAPI getUser].userId;
                        [self getAppTokenWithUserid:userid];
//                        [HAMLogOutputWindow printLog:@"getAppTokenWithUserid"];
                    }
                }
            }
        }
            break;
        case 2:
        {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf unbind];
//            });
            [self unbind];
            break;
        }
        default:
            break;
    }
}

- (void)getToken2{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = @"12313123131231";
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.appCompletionBlock(dic);
}

- (void)unbind{
    __weak typeof(self) weakSelf = self;
    [weakSelf showHudWithText:@"正在解除绑定..."];
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *uuid = [xindunsdk getCIMSUUID:userid];
//    NSString *phone = [TRUUserAPI getUser].phone;
    NSArray *deleteDevices = @[uuid];
    NSString *deldevs = nil;
    if (!deleteDevices || deleteDevices.count == 0) {
        deldevs = @"";
    }else{
        deldevs = [deleteDevices componentsJoinedByString:@","];
    }
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSArray *ctx = @[@"del_uuids",deldevs];
    NSString *sign = [NSString stringWithFormat:@"%@",deldevs];
    NSString *params = [xindunsdk encryptByUkey:userid ctx:ctx signdata:sign isDeviceType:NO];
    NSDictionary *paramsDic = @{@"params" : params};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/device/delete"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
//        sleep(2);
        if (errorno == 0) {
            [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
            [TRUUserAPI deleteUser];
            //清除APP解锁方式
            [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
            [TRUTokenUtil cleanLocalToken];
            [self.navigationController popViewControllerAnimated:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
//                [HAMLogOutputWindow printLog:@"登出1"];
                id delegate = [UIApplication sharedApplication].delegate;
                if ([delegate respondsToSelector:@selector(changeAvtiveRootVC)]) {
//                    [HAMLogOutputWindow printLog:@"登出2"];
                    [delegate performSelector:@selector(changeAvtiveRootVC) withObject:nil];
                    AppDelegate *delegate1 = [UIApplication sharedApplication].delegate;
                    if (delegate1.thirdAwakeTokenStatus==2) {
                        delegate1.thirdAwakeTokenStatus=1;
                    }
                }
#pragma clang diagnostic pop
            });
        }else if (-5004 == errorno){
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
        }else if (9008 == errorno){
            [weakSelf deal9008Error];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else{
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            delegate.soureSchme = nil;
            delegate.thirdAwakeTokenStatus = 0;
            delegate.isFromSDK = NO;
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
//            [weakSelf showHudWithText:err];
            [weakSelf showHudWithText:@"解绑失败"];
            [weakSelf hideHudDelay:2.0];
        }
        
//        if (weakSelf.completionBlock) {
//            // 延迟的时间
//            weakSelf.completionBlock(dic);
//
//        }
        
    }];
}

- (void)getNetToken{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *phone = [TRUUserAPI getUser].phone;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/getoauth"] withParts:dictt onResult:^(int errorno, id responseBody){
        NSDictionary *dicc = nil;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"type"] = @"getNetToken";
        if(userid.length && [xindunsdk userInitializedInfo:userid] && phone.length){
            dic[@"phone"] = [TRUUserAPI getUser].phone;
        }
        if (errorno == 0 && responseBody) {
            dicc = [xindunsdk decodeServerResponse:responseBody];
            if ([dicc[@"code"] intValue] == 0) {
                dicc = dicc[@"resp"];
                //同步信息成功，信息完整，跳转页面
                NSString *tokenStr = dicc[@"access_token"];
                [TRUTokenUtil saveLocalToken:tokenStr];
                dic[@"status"] = @(errorno);
                dic[@"token"] = tokenStr;
                //!weakSelf.completionBlock ? : weakSelf.completionBlock(dic);
            }
        }else if(-5004 == errorno){
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
            return;
        }else if(9008 == errorno){
            //秘钥失效
            [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
            [TRUUserAPI deleteUser];
            [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
            dic[@"status"] = @(errorno);
            //!weakSelf.completionBlock ? : weakSelf.completionBlock(dic);
        }else if (9019 == errorno){
            dic[@"status"] = @(errorno);
            //!weakSelf.completionBlock ? : weakSelf.completionBlock(dic);
        }else{
            dic[@"status"] = @(errorno);
            //!weakSelf.completionBlock ? : weakSelf.completionBlock(dic);
        }
//        [HAMLogOutputWindow printLog:@"getNetToken dic"];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        if (delegate.appCompletionBlock) {
//            [HAMLogOutputWindow printLog:@"getNetToken dic1111"];
            delegate.appCompletionBlock(dic);
        }else if(weakSelf.completionBlock){
            weakSelf.completionBlock(dic);
        }
    }];
}

- (void)getAppTokenWithUserid:(NSString *)userid{
    NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"refresh_token"];
    if (refreshToken.length) {
//        refreshToken = [xindunsdk decryptText:refreshToken];
//        [HAMLogOutputWindow printLog:@"有refreshtoken"];
        [self refreshTokenwithRefreshToken:refreshToken];
    }else{
//        [HAMLogOutputWindow printLog:@"没有refreshtoken"];
//        [TRUEnterAPPAuthView showAuthView];
//        [HAMLogOutputWindow printLog:@"test5"];
        [TRULockSWindow showAuthView];
//        [self getAppAuthToken];
    }
//    [self getAppAuthToken];
}

- (void)syncUserInfo{
    __weak typeof(self) weakSelf = self;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        NSDictionary *dicc = nil;
        if (errorno == 0 && responseBody) {
            dicc = [xindunsdk decodeServerResponse:responseBody];
            if ([dicc[@"code"] intValue] == 0) {
                dicc = dicc[@"resp"];
                //用户信息同步成功
                TRUUserModel *model = [TRUUserModel modelWithDic:dicc];
                model.userId = userid;
                [TRUUserAPI saveUser:model];
                //同步信息成功，信息完整，跳转页面
                if([TRUUserAPI haveSubUser]){
//                    TRUMultipleAccountsSchemeViewController *pushvc = [[TRUMultipleAccountsSchemeViewController alloc] init];
//                    pushvc.backBlock = ^(NSString * _Nonnull userId) {
//                        [weakSelf getTokenWithRefreshTokenAndTokenByUserid:userId];
//                    };
//                    [weakSelf.navigationController pushViewController:pushvc animated:YES];
                    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                    NSMutableArray *mutarray = [NSMutableArray array];
                    for (int i = 0; i<model.accounts.count; i++) {
                        TRUSubUserModel *submodel = model.accounts[i];
                        if ([submodel.appId isEqualToString:delegate.appid]) {
                            [mutarray addObject:submodel];
                        }
                    }
                    if (mutarray.count==0) {
                        NSString *userid = [TRUUserAPI getUser].userId;
                        [weakSelf getTokenWithRefreshTokenAndTokenByUserid:userid];
                    }else{
                        TRUMultipleAccountsSchemeViewController *pushvc = [[TRUMultipleAccountsSchemeViewController alloc] init];
                        [mutarray insertObject:model.accounts[0] atIndex:0];
                        pushvc.multipleAccountsArray = mutarray;
                        pushvc.backBlock = ^(NSString * _Nonnull userId) {
//                            [HAMLogOutputWindow printLog:userId];
                            [weakSelf getTokenWithRefreshTokenAndTokenByUserid:userId];
                        };
                        [weakSelf.navigationController pushViewController:pushvc animated:YES];
                    }
                }else{
                    NSString *userid = [TRUUserAPI getUser].userId;
                    [weakSelf getAppTokenWithUserid:userid];
                }
            }
        }else if(9008 == errorno){
            //秘钥失效
            [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
            [TRUUserAPI deleteUser];
            [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
            !weakSelf.completionBlock ? : weakSelf.completionBlock(nil);
        }else if (9019 == errorno){
            //用户被禁用 取本地
            TRUUserModel *model = [TRUUserAPI getUser];
            !weakSelf.completionBlock ? : weakSelf.completionBlock(model);
        }else{
            TRUUserModel *model = [TRUUserAPI getUser];
            !weakSelf.completionBlock ? : weakSelf.completionBlock(model);
        }
    }];
}

- (void)getAppAuthToken{
//    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    delegate.soureSchme = @"authdemo://";
//    dic[@"token"] = @"abc";
//    if (delegate.appCompletionBlock) {
//        delegate.appCompletionBlock(dic);
//    }
    
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
//    NSString *phone = [TRUUserAPI getUser].phone;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    NSString *uuid = [xindunsdk getCIMSUUID:userid];
    
//    NSString *sign = [NSString stringWithFormat:@"%@%@",refreshToken,delegate.appid];
//    NSArray *ctxx = @[@"refreshToken",refreshToken,@"appId",delegate.appid];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    YCLog(@"111111111111111");
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/token/gen"] withParts:dictt onResult:^(int errorno, id responseBody){
        YCLog(@"111111111111111+");
        if(errorno==0){
            YCLog(@"%@",responseBody);
            if (responseBody!=nil) {
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                if([dic[@"code"] intValue]==0)
                    dic = dic[@"resp"];
                NSString *refreshToken = dic[@"refresh_token"];
                [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:@"refresh_token"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                YCLog(@"refresh_token = %d",refreshToken);
//                AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//                if (delegate.thirdAwakeTokenStatus) {
//                    if ([delegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
//                        UINavigationController *rootnav = delegate.window.rootViewController;
//                        [rootnav popToRootViewControllerAnimated:NO];
//                        TRUSchemeTokenViewController *pushvc = [[TRUSchemeTokenViewController alloc] init];
//                        pushvc.isNeedpush = YES;
//                        [rootnav pushViewController:pushvc animated:YES];
//                    }
//                }
                NSString *userid = [TRUUserAPI getUser].userId;
                [weakSelf refreshTokenwithRefreshToken:refreshToken withUserid:userid];
            }
        }else if(errorno==-5004){
            [weakSelf showHudWithText:@"网络错误"];
            [weakSelf hideHudDelay:2.0];
            if ([delegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *rootnav = delegate.window.rootViewController;
                [rootnav popViewControllerAnimated:YES];
            }
        }else{
//            [weakSelf showHudWithText:[NSString stringWithFormat:@"%d",errorno]];
            [weakSelf showHudWithText:@"刷新refreshtoken错误"];
            [weakSelf hideHudDelay:2.0];
            if ([delegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *rootnav = delegate.window.rootViewController;
                [rootnav popViewControllerAnimated:YES];
            }
        }
    }];
}



/**
 已经激活有refreshtoken的流程

 @param refreshToken 当前refreshToken
 @param myUserid 使用主账号刷新
 */
- (void)refreshTokenwithRefreshToken:(NSString *)refreshToken{
    //90037 refreshtoken过期
    __weak typeof(self) weakSelf = self;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    //        NSString *uuid = [xindunsdk getCIMSUUID:userid];
    __weak AppDelegate *weakdelegate = delegate;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    NSString *log = [NSString stringWithFormat:@"SchemeTokenViewController refreshTokenwithRefreshToken: 1,vc = %@,refreshToken = %@",self,refreshToken];
    DDLogError(log);
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
//        [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"getuserinfo error =%d",errorno]];
        [weakSelf hideHudDelay:0.0];
        NSDictionary *dicc = nil;
        NSString *log1 = [NSString stringWithFormat:@"SchemeTokenViewController refreshTokenwithRefreshToken: 2,vc = %@,error = %d",self,errorno];
        DDLogError(log1);
        if (errorno == 0 && responseBody) {
            dicc = [xindunsdk decodeServerResponse:responseBody];
            if ([dicc[@"code"] intValue] == 0) {
                dicc = dicc[@"resp"];
                //用户信息同步成功
                TRUUserModel *model = [TRUUserModel modelWithDic:dicc];
                model.userId = userid;
                [TRUUserAPI saveUser:model];
                
                NSString *sign = [NSString stringWithFormat:@"%@%@%@",userid,refreshToken,delegate.appid];
                NSArray *ctxx = @[@"userId",userid,@"refreshToken",refreshToken,@"appId",delegate.appid];
                NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
                NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
                NSString *log2 = [NSString stringWithFormat:@"SchemeTokenViewController refreshTokenwithRefreshToken: 3,vc = %@,userId = %@,refreshToken = %@,appId =%@",self,userid,refreshToken,delegate.appid];
                DDLogError(log2);
                [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/token/refresh"] withParts:dictt onResult:^(int errorno, id responseBody){
                    YCLog(@"errorno = %d",errorno);
                    NSString *log3 = [NSString stringWithFormat:@"SchemeTokenViewController refreshTokenwithRefreshToken: 4,vc = %@,errorno = %d",self,errorno];
                    DDLogError(log3);
//                    [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"第一次刷token error = %d",errorno]];
                    if (errorno==0) {
                        if (responseBody!=nil) {
                            NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                            if ([dic[@"code"] intValue]==0) {
                                dic = dic[@"resp"];
                                NSString *token = dic[@"access_token"];
                                NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
                                dicc[@"token"] = token;
                                NSString *log3 = [NSString stringWithFormat:@"SchemeTokenViewController refreshTokenwithRefreshToken: 5,vc = %@,token = %@",self,token];
                                DDLogError(log3);
                                if([TRUUserAPI haveSubUser]){
                                    TRUUserModel *model = [TRUUserAPI getUser];
                                    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                                    NSMutableArray *mutarray = [NSMutableArray array];
                                    for (int i = 0; i<model.accounts.count; i++) {
                                        TRUSubUserModel *submodel = model.accounts[i];
                                        if ([submodel.appId isEqualToString:delegate.appid]) {
                                            [mutarray addObject:submodel];
                                        }
                                    }
                                    if (mutarray.count==0) {
                                        NSString *userid = [TRUUserAPI getUser].userId;
                                        [weakSelf getTokenWithRefreshTokenAndTokenByUserid:userid];
                                    }else{
                                        TRUMultipleAccountsSchemeViewController *pushvc = [[TRUMultipleAccountsSchemeViewController alloc] init];
                                        [mutarray insertObject:model.accounts[0] atIndex:0];
                                        pushvc.multipleAccountsArray = mutarray;
                                        pushvc.backBlock = ^(NSString * _Nonnull userId) {
//                                            [HAMLogOutputWindow printLog:userId];
                                            [weakSelf getTokenWithRefreshTokenAndTokenByUserid:userId];
                                        };
                                        [weakSelf.navigationController pushViewController:pushvc animated:YES];
                                    }
                                }else{
                                    if (weakdelegate.isFromSDK) {
                                        
                                    }else{
                                        weakdelegate.soureSchme = dic[@"iosScheme"];
                                    }
                                    if (weakdelegate.appCompletionBlock) {
                                        weakdelegate.appCompletionBlock(dicc);
                                    }
                                }
                            }
                        }
                    }else if(errorno==-5004){
                        [weakSelf showHudWithText:@"网络错误"];
                        [weakSelf hideHudDelay:2.0];
                        if ([weakdelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                            UINavigationController *rootnav = delegate.window.rootViewController;
                            [rootnav popViewControllerAnimated:YES];
                        }
                    }else if(errorno ==90037){
//                        [HAMLogOutputWindow printLog:@"show2"];
//                        [TRUEnterAPPAuthView showAuthView];
                        [HAMLogOutputWindow printLog:@"test6"];
                        [TRULockSWindow showAuthView];
                        //            [self getAppAuthToken];
                    }else if(errorno ==9024){
                        [weakSelf showHudWithText:@"用户没有应用权限"];
                        [weakSelf hideHudDelay:2.0];
                    }else if(errorno ==9019){
                        [weakSelf showHudWithText:@"用户禁用或者过期"];
                        [weakSelf hideHudDelay:2.0];
                    }else if(errorno ==9025){
                        [weakSelf showHudWithText:@"用户没有公共账号权限"];
                        [weakSelf hideHudDelay:2.0];
                    }else if(errorno ==9001){
                        [weakSelf showHudWithText:@"签名错误"];
                        [weakSelf hideHudDelay:2.0];
                    }else if(errorno ==9008){
                        [weakSelf showHudWithText:@"密钥失效"];
                        [weakSelf hideHudDelay:2.0];
                    }else if(errorno ==9011){
                        [weakSelf showHudWithText:@"应用不存在"];
                        [weakSelf hideHudDelay:2.0];
                    }else if(errorno ==90039){
                        [weakSelf showHudWithText:@"用户不匹配"];
                        [weakSelf hideHudDelay:2.0];
                    }else{
                        //            [weakSelf getAppAuthToken];
                        weakdelegate.soureSchme = nil;
                        weakdelegate.thirdAwakeTokenStatus = 0;
                        weakdelegate.isFromSDK = NO;
//                        [weakSelf showHudWithText:[NSString stringWithFormat:@"%d",errorno]];
                        [weakSelf showHudWithText:[NSString stringWithFormat:@"token生成失败,错误代码为%d",errorno]];
                        [weakSelf hideHudDelay:2.0];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if ([weakdelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                                UINavigationController *rootnav = weakdelegate.window.rootViewController;
                                [rootnav popViewControllerAnimated:YES];
                            }
                        });
                    }
                }];
            }
        }else if(errorno == -5004){
            [self showHudWithText:@"网络错误"];
            [self hideHudDelay:2.0];
        }
    }];
    
    
}

- (void)refreshTokenwithRefreshToken:(NSString *)refreshToken withUserid:(NSString *)myUserid{
    
}

- (void)getAuthToken{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf getDisAuthToken];
    });
}

- (void)getDisAuthToken{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
//    NSString *phone = [TRUUserAPI getUser].phone;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    //    NSString *uuid = [xindunsdk getCIMSUUID:userid];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@",delegate.appid,delegate.apid,userid];
    NSArray *ctxx = @[@"appid",delegate.appid,@"apid",delegate.apid,@"userid",userid];
    //    NSString *sign = [NSString stringWithFormat:@"%@%@",delegate.appid,delegate.apid];
    //    NSArray *ctxx = @[@"appid",delegate.appid,@"apid",delegate.apid];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/getcode"] withParts:dictt onResult:^(int errorno, id responseBody){
//        [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"%@/mapi/01/verify/getcode,error = %d",baseUrl,errorno]];
        YCLog(@"error = %d",errorno);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"status"] = @(errorno);
        if (errorno == 0 || responseBody != nil) {
            NSString *code = responseBody;
            if(code.length>0){
                NSDictionary *resDic = [xindunsdk decodeServerResponse:responseBody];
                if ([resDic[@"code"] intValue] == 0) {
                    dic[@"code"] = resDic[@"resp"][@"code"];
                }
            }else{
                dic[@"code"] = @"";
            }
        }else{
            dic[@"code"] = @"";
        }
        YCLog(@"dic = %@",dic[@"code"]);
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        if (delegate.appCompletionBlock) {
            //            [HAMLogOutputWindow printLog:@"getNetToken dic1111"];
            delegate.appCompletionBlock(dic);
        }else if(weakSelf.completionBlock){
            weakSelf.completionBlock(dic);
        }
        
    }];
}

- (NSString *)base64EncodeString:(NSString *)string{
    //1、先转换成二进制数据
    NSData *data =[string dataUsingEncoding:NSUTF8StringEncoding];
    //2、对二进制数据进行base64编码，完成后返回字符串
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodeString:(NSString *)string{
    //注意：该字符串是base64编码后的字符串
    //1、转换为二进制数据（完成了解码的过程）
    NSData *data=[[NSData alloc]initWithBase64EncodedString:string options:0];
    //2、把二进制数据转换成字符串
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
