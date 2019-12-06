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
#import "TRUCompanyAPI.h"
#import "TRUAddPersonalInfoViewController.h"
#import "TRUPushAuthModel.h"
#import "TRUPushingViewController.h"
//#import "TRUUserAPI.h"
#import "TRUSubUserModel.h"
#import "TRUMultipleAccountsSchemeViewController.h"
@interface TRUSchemeTokenViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, assign) int64_t delayTime;
@property (nonatomic, copy) void (^pushCompletion)();
@end

@implementation TRUSchemeTokenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YCLog(@"TRUSchemeTokenViewController viewDidLoad");
//    [self setupRightItem];
    self.delayTime = 0.1;
    // Do any additional setup after loading the view.
//    self.loadingView = [[UIActivityIndicatorView alloc] init];
    CGFloat w = 30.0;
    CGFloat h = w;
    CGFloat x = [UIScreen mainScreen].bounds.size.width/2 - w/2;
    CGFloat y = [UIScreen mainScreen].bounds.size.height/2-h/2;
    if(self.schemetype==5){
    }else{
//        self.loadingView.frame = CGRectMake(x, y, w, h);
//        [self.view addSubview:self.loadingView];
//        [self.loadingView startAnimating];
//        self.loadingView.color = [UIColor blackColor];
//        self.loadingView.userInteractionEnabled = NO;
        
    }
//    self.loadingView = nil;
    __weak typeof(self) weakSelf = self;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.thirdAwakeTokenStatus==2) {
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPushToken) name:@"TRUEnterAPPAuthViewSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSelf) name:TRUEnterBackgroundKey object:nil];
    [self getToken];
}

- (void)setupRightItem{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70,100, 50, 50)];
    [rightButton setTitle:@"邀请记录" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}



- (void)dismissSelf{
    [HAMLogOutputWindow printLog:@"scheme控制器消失"];
//    exit(0);
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)cleanSchemeStatus{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.soureSchme = nil;
    delegate.thirdAwakeTokenStatus = 0;
    delegate.isNeedPush = YES;
    delegate.appid = nil;
    delegate.isFromSDK = NO;
    delegate.isMainSDK = NO;
    delegate.tokenCompletionBlock = nil;
    delegate.appCompletionBlock = nil;
    delegate.appPushVC = nil;
    delegate.phone = nil;
    delegate.token = nil;
}

- (void)showPushToken{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if(!delegate.isMainSDK){
        return;
    }
    if([TRUUserAPI haveSubUser]){
        [HAMLogOutputWindow printLog:@"有子账号"];
        __weak typeof(self) weakSelf = self;
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSString *userid = [TRUUserAPI getUser].userId;
        NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
        NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
            [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"getuserinfo error =%d",errorno]];
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
                        [HAMLogOutputWindow printLog:@"1"];
                    }else{
                        TRUMultipleAccountsSchemeViewController *pushvc = [[TRUMultipleAccountsSchemeViewController alloc] init];
                        [mutarray insertObject:model.accounts[0] atIndex:0];
                        pushvc.multipleAccountsArray = mutarray;
                        pushvc.backBlock = ^(NSString * _Nonnull userId) {
                            [HAMLogOutputWindow printLog:userId];
                            [weakSelf getTokenWithRefreshTokenAndTokenByUserid:userId];
                        };
                        [weakSelf.navigationController pushViewController:pushvc animated:YES];
                        if (weakSelf.navigationController==nil) {
                            [HAMLogOutputWindow printLog:@"3"];
                        }
                        [HAMLogOutputWindow printLog:@"2"];
                    }
                }
            }else if(9008 == errorno){
                //秘钥失效
                [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
                [TRUUserAPI deleteUser];
                [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
                [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
                !weakSelf.completionBlock ? : weakSelf.completionBlock(nil);
                AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                if (delegate.isFromSDK) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    dic[@"tokenerror"] = @(9008);
                    __weak typeof(delegate) weakDelegate = delegate;
                    [weakSelf dismissViewControllerAnimated:NO completion:^{
                        if (weakDelegate.appCompletionBlock) {
                            weakDelegate.appCompletionBlock(dicc);
                        }
                    }];
                }else{
                    
                }
            }else if (9019 == errorno){
                //用户被禁用 取本地
                TRUUserModel *model = [TRUUserAPI getUser];
                !weakSelf.completionBlock ? : weakSelf.completionBlock(model);
                AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"tokenerror"] = @(9019);
                __weak typeof(delegate) weakDelegate = delegate;
                [weakSelf dismissViewControllerAnimated:NO completion:^{
                    if (weakDelegate.appCompletionBlock) {
                        weakDelegate.appCompletionBlock(dicc);
                    }
                }];
            }else{
                AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                if (delegate.isFromSDK) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    dic[@"tokenerror"] = @(errorno);
                    __weak typeof(delegate) weakDelegate = delegate;
                    [weakSelf dismissViewControllerAnimated:NO completion:^{
                        if (weakDelegate.appCompletionBlock) {
                            weakDelegate.appCompletionBlock(dicc);
                        }
                    }];
                }else{
                    
                }
                
                TRUUserModel *model = [TRUUserAPI getUser];
                !weakSelf.completionBlock ? : weakSelf.completionBlock(model);
            }
        }];
    }else{
        [HAMLogOutputWindow printLog:@"没有子账号"];
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
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/token/gen"] withParts:dictt onResult:^(int errorno, id responseBody){
        YCLog(@"111111111111111+");
        [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"refreshtoken error = %d",errorno]];
        if(errorno==0){
            YCLog(@"%@",responseBody);
            if (responseBody!=nil) {
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                if([dic[@"code"] intValue]==0){
                    dic = dic[@"resp"];
                    NSString *refreshToken = dic[@"refresh_token"];
                    [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:@"refresh_token"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                    __weak typeof(delegate) weakDelegate = delegate;
                    [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"appid=%@,refreshtoken=%@",delegate.appid,refreshToken]];
                    NSString *sign = [NSString stringWithFormat:@"%@%@%@",userid,refreshToken,delegate.appid];
                    if (delegate.appid.length==0) {
                        [HAMLogOutputWindow printLog:@"appid 不存在"];
//                        NSAssert(delegate.appid.length==0,@"appid 不存在");
                        
                    }
                    if (userid.length==0||refreshToken.length==0||delegate.appid.length==0) {
                        return;
                    }
                    NSArray *ctxx = @[@"userId",userid,@"refreshToken",refreshToken,@"appId",delegate.appid];
                    NSString *paras = [xindunsdk encryptByUkey:mainuserid ctx:ctxx signdata:sign isDeviceType:NO];
                    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
                    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/token/refresh"] withParts:dictt onResult:^(int errorno, id responseBody){
                        YCLog(@"errorno = %d",errorno);
                        [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"token error = %d",errorno]];
                        if (errorno==0) {
                            if (responseBody!=nil) {
                                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                                if ([dic[@"code"] intValue]==0) {
                                    dic = dic[@"resp"];
                                    NSString *token = dic[@"access_token"];
                                    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
                                    dicc[@"token"] = token;
                                    [weakSelf dismissViewControllerAnimated:NO completion:^{
                                        if (weakDelegate.appCompletionBlock) {
                                            weakDelegate.appCompletionBlock(dicc);
                                        }
                                    }];
                                    
                                }
                            }
                        }else{
                            if (weakDelegate.isFromSDK) {
                                NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
                                dicc[@"tokenerror"]=@(errorno);
                                [weakSelf dismissViewControllerAnimated:NO completion:^{
                                    if (weakDelegate.appCompletionBlock) {
                                        weakDelegate.appCompletionBlock(dicc);
                                    }
                                }];
                            }else{
                                weakDelegate.soureSchme = nil;
                                weakDelegate.thirdAwakeTokenStatus = 0;
                                weakDelegate.isFromSDK = NO;
                                [weakSelf showHudWithText:[NSString stringWithFormat:@"%d错误",errorno]];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    if ([weakDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                                        UINavigationController *rootnav = weakDelegate.window.rootViewController;
                                        [rootnav popViewControllerAnimated:YES];
                                    }
                                });
                            }
                            
                        }
                    }];
                }
            }
        }else{
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            __weak typeof(delegate) weakDelegate = delegate;
            if (delegate.isFromSDK) {
                if (delegate.appCompletionBlock) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    dic[@"tokenerror"]=@(errorno);
                    [weakSelf dismissViewControllerAnimated:NO completion:^{
                        if (weakDelegate.appCompletionBlock) {
                            weakDelegate.appCompletionBlock(dic);
                        }
                    }];
                }
            }else{
                delegate.soureSchme = nil;
                delegate.thirdAwakeTokenStatus = 0;
                delegate.isFromSDK = NO;
                delegate.isNeedPush = NO;
            }
            
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }
    }];
}

- (void)getAppTokenWithUserid:(NSString *)userid{
    NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"refresh_token"];
    if (refreshToken.length) {
        //        refreshToken = [xindunsdk decryptText:refreshToken];
        [HAMLogOutputWindow printLog:@"有refreshtoken"];
        [self refreshTokenwithRefreshToken:refreshToken];
    }else{
        [HAMLogOutputWindow printLog:@"没有refreshtoken"];
        [TRUEnterAPPAuthView showAuthView];
        //        [self getAppAuthToken];
    }
    //    [self getAppAuthToken];
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
    __weak AppDelegate *weakDelegate = delegate;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *userid = [TRUUserAPI getUser].userId;
//    NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
//    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    NSString *sign = [NSString stringWithFormat:@"%@%@%@",userid,refreshToken,delegate.appid];
    NSArray *ctxx = @[@"userId",userid,@"refreshToken",refreshToken,@"appId",delegate.appid];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/token/refresh"] withParts:dictt onResult:^(int errorno, id responseBody){
        YCLog(@"errorno = %d",errorno);
        [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"第一次刷token error = %d",errorno]];
        if (errorno==0) {
            if (responseBody!=nil) {
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                if ([dic[@"code"] intValue]==0) {
                    dic = dic[@"resp"];
                    NSString *token = dic[@"access_token"];
                    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
                    dicc[@"token"] = token;
                    if([TRUUserAPI haveSubUser]){
                        TRUUserModel *model = [TRUUserAPI getUser];
                        //                                    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                        NSMutableArray *mutarray = [NSMutableArray array];
                        for (int i = 0; i<model.accounts.count; i++) {
                            TRUSubUserModel *submodel = model.accounts[i];
                            if ([submodel.appId isEqualToString:weakDelegate.appid]) {
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
                                [HAMLogOutputWindow printLog:userId];
                                [weakSelf getTokenWithRefreshTokenAndTokenByUserid:userId];
                            };
                            [weakSelf.navigationController pushViewController:pushvc animated:YES];
                        }
                    }else{
                        if (weakDelegate.isFromSDK) {
                            
                        }else{
                            weakDelegate.soureSchme = dic[@"schema"];
                        }
                        if (weakDelegate.appCompletionBlock) {
                            weakDelegate.appCompletionBlock(dicc);
                        }
                    }
                }
            }
        }else if(errorno==-5004){
            [weakSelf showHudWithText:@"网络错误"];
            [weakSelf hideHudDelay:2.0];
            if (weakDelegate.isFromSDK) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"tokenerror"] = @(errorno);
                if (weakDelegate.appCompletionBlock) {
                    weakDelegate.appCompletionBlock(dic);
                }
            }else{
                if ([weakDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *rootnav = weakDelegate.window.rootViewController;
                    [rootnav popViewControllerAnimated:YES];
                }
            }
            
        }else if(errorno ==90037){
            [HAMLogOutputWindow printLog:@"show2"];
            [TRUEnterAPPAuthView showAuthView];
            //            [self getAppAuthToken];
        }else{
            //            [weakSelf getAppAuthToken];
            if (weakDelegate.isFromSDK) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"tokenerror"] = @(errorno);
                if (weakDelegate.appCompletionBlock) {
                    weakDelegate.appCompletionBlock(dic);
                }
            }else{
                weakDelegate.soureSchme = nil;
                weakDelegate.thirdAwakeTokenStatus = 0;
                weakDelegate.isFromSDK = NO;
                [weakSelf showHudWithText:[NSString stringWithFormat:@"%d",errorno]];
                [weakSelf hideHudDelay:2.0];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([weakDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                        UINavigationController *rootnav = weakDelegate.window.rootViewController;
                        [rootnav popViewControllerAnimated:YES];
                    }
                });
            }
            
        }
    }];
    
    
}

- (void)pushVCCompletion{
    if (self.pushCompletion) {
        self.pushCompletion();
        self.pushCompletion = nil;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [HAMLogOutputWindow printLog:@"scheme控制器释放内存"];
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
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.loadingView stopAnimating];
}

- (void)getToken{
    __weak typeof(self) weakSelf = self;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    switch (delegate.thirdAwakeTokenStatus) {
        case 1:
        {
            if (delegate.isMainSDK) {
                if ([TRUFingerGesUtil getLoginAuthFingerType]==TRULoginAuthFingerTypeNone&&[TRUFingerGesUtil getLoginAuthGesType]==TRULoginAuthGesTypeNone) {
                }else{
                    if (delegate.isNeedPush) {
                        //                    NSString *userid = [TRUUserAPI getUser].userId;
                        //                    [self getAppTokenWithUserid:userid];
                        NSString *userid = [TRUUserAPI getUser].userId;
                        [self showPushToken];
                    }else{
                        if (self.isNeedpush) {
                            NSString *userid = [TRUUserAPI getUser].userId;
                            [self getAppTokenWithUserid:userid];
                        }
                    }
                }
            }else{
                NSString *tokenStr = [TRUTokenUtil getLocalToken];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"type"]=@"getLocalToken";
                if(tokenStr==nil||tokenStr.length==0){
                    dic[@"status"] = @(5004);
                }else{
                    dic[@"status"] = @(0);
                    dic[@"token"] = tokenStr;
                }
                NSString *userid = [TRUUserAPI getUser].userId;
                NSString *phone = [TRUUserAPI getUser].phone;
                if(userid.length && [xindunsdk userInitializedInfo:userid] && phone.length){
                    dic[@"phone"] = [TRUUserAPI getUser].phone;
                }
                //!self.completionBlock ? : self.completionBlock(dic);
                if (self.completionBlock) {
                    // 延迟的时间
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        weakSelf.completionBlock(dic);
                    });
                }
            }
        }
            break;
        case 2:
        {
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            if (delegate.isMainSDK) {
                [self unbind];
            }else{
                if ([TRUFingerGesUtil getLoginAuthFingerType]==TRULoginAuthFingerTypeNone&&[TRUFingerGesUtil getLoginAuthGesType]==TRULoginAuthGesTypeNone) {
                    YCLog(@"TRUSchemeTokenViewController   111111");
                }else{
                    if (delegate.isNeedPush) {
                        [self getNetToken];
                    }else{
                        if (self.isNeedpush) {
                            [self getNetToken];
                        }
                    }
                }
            }
            
            break;
        }
        case 3:
        {
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            if (delegate.isMainSDK) {
                [self unbindwithback];
            }else{
                [TRUTokenUtil cleanLocalToken];
                NSString *tokenStr = [TRUTokenUtil getLocalToken];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"type"] = @"logout";
                if(tokenStr==nil||tokenStr.length==0){
                    dic[@"status"] = @(0);
                }else{
                    dic[@"status"] = @(5004);
                }
                NSString *userid = [TRUUserAPI getUser].userId;
                NSString *phone = [TRUUserAPI getUser].phone;
                
                if(userid.length && [xindunsdk userInitializedInfo:userid] && phone.length){
                    dic[@"phone"] = [TRUUserAPI getUser].phone;
                }
                if (self.completionBlock) {
                    // 延迟的时间
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        weakSelf.completionBlock(dic);
                    });
                }
            }
            break;
        }
        case 4:
        {
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            if (delegate.isMainSDK) {
                [self scanQrcodeWithToken:delegate.token];
            }else{
                NSString *userid = [TRUUserAPI getUser].userId;
                if(userid==nil){
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    dic[@"type"] = @"unBind";
                    dic[@"status"] = @(0);
                    if (self.completionBlock) {
                        // 延迟的时间
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            weakSelf.completionBlock(dic);
                        });
                    }
                    return;
                }
                //__weak typeof(self) weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf unbindwithback];
                });
            }
            break;
        }
        case 5:
        {
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            NSURL *url = [NSURL URLWithString:[delegate fullSoureSchme]];
            NSString *str = [NSString stringWithFormat:@"%@",url.query];
            NSArray *queryArr = [str componentsSeparatedByString:@"&"];
//            NSString *qrcode = [[[queryArr lastObject] componentsSeparatedByString:@"qrcode="] lastObject];
            NSString *lastStr = [queryArr lastObject];
            NSRange qrcodeRange = NSMakeRange(7, lastStr.length - 7);
            NSString *qrcode = [lastStr substringWithRange:qrcodeRange];
            NSString *qrcode1 = [self base64DecodeString:qrcode];
            [self scanQRCode:qrcode1];
            break;
        }
        case 11:
        {
            if ([TRUFingerGesUtil getLoginAuthFingerType]==TRULoginAuthFingerTypeNone&&[TRUFingerGesUtil getLoginAuthGesType]==TRULoginAuthGesTypeNone) {
            }else{
                if (delegate.isNeedPush) {
                    NSString *userid = [TRUUserAPI getUser].userId;
//                    [self pushAuth1];
                }else if (self.isNeedpush){
                    [self pushAuth1];
                }
            }
            break;
        }
        default:
            break;
    }
}

- (void)pushAuth1{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    NSArray *ctx = @[@"userid",userid,@"appid",appdelegate.appid,@"apid",appdelegate.apid];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@",userid,appdelegate.appid,appdelegate.apid];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctx signdata:sign isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/getcode"] withParts:dictt onResultWithMessage:^(int errorno, id responseBody,NSString *message){
//        YCLog(@"verify/getcode = %d",errorno);
        NSDictionary *dic;
        if (errorno == 0 && responseBody) {
            dic = [xindunsdk decodeServerResponse:responseBody];
            int code = [dic[@"code"] intValue];
            if (code == 0) {
                dic = dic[@"resp"];
                NSString *code = dic[@"code"];
                NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
                dicc[@"code"] = code;
                dicc[@"codeerror"] = @"0";
                dicc[@"message"] = message;
                if (appdelegate.appCompletionBlock) {
                    appdelegate.appCompletionBlock(dicc);
                }
            }
            NSLog(@"");
        }
    }];
}

-(NSString *)base64DecodeString:(NSString *)string{
    //注意：该字符串是base64编码后的字符串
    //1、转换为二进制数据（完成了解码的过程）
    NSData *data=[[NSData alloc]initWithBase64EncodedString:string options:0];
    //2、把二进制数据转换成字符串
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
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
        
        if (errorno == 0) {
            [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
            [TRUUserAPI deleteUser];
            //清除APP解锁方式
            [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
            [TRUTokenUtil cleanLocalToken];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            id delegate = [UIApplication sharedApplication].delegate;
            if ([delegate respondsToSelector:@selector(changeAvtiveRootVC)]) {
                [delegate performSelector:@selector(changeAvtiveRootVC) withObject:nil];
                AppDelegate *delegate1 = [UIApplication sharedApplication].delegate;
                if (delegate1.thirdAwakeTokenStatus==2) {
                    delegate1.thirdAwakeTokenStatus=1;
                }
            }
#pragma clang diagnostic pop
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
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}

- (void)unbindwithback{
    __weak typeof(self) weakSelf = self;
    [weakSelf showHudWithText:@"正在解除绑定..."];
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *uuid = [xindunsdk getCIMSUUID:userid];
    NSString *phone = [TRUUserAPI getUser].phone;
    NSArray *deleteDevices = @[uuid];
    NSString *deldevs = nil;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    __weak typeof(delegate) weakDelegate = delegate;
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
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"type"] = @"unBind";
        dic[@"status"] = @(errorno);
        
        if(userid.length && [xindunsdk userInitializedInfo:userid] && phone.length){
            dic[@"phone"] = [TRUUserAPI getUser].phone;
        }
        if (errorno == 0) {
            [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
            [TRUUserAPI deleteUser];
            //清除APP解锁方式
            [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
            [TRUTokenUtil cleanLocalToken];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            id delegate = [UIApplication sharedApplication].delegate;
            if ([delegate respondsToSelector:@selector(changeAvtiveRootVC)]) {
                [delegate performSelector:@selector(changeAvtiveRootVC) withObject:nil];
            }
#pragma clang diagnostic pop
        }else if (-5004 == errorno){
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
        }else if (9008 == errorno){
            [weakSelf deal9008Error];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
        }
        
        if (weakSelf.completionBlock) {
            // 延迟的时间
            weakSelf.completionBlock(dic);
            
        }else if(weakDelegate.appCompletionBlock){
            weakDelegate.appCompletionBlock(dic);
        }
        
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
        if (delegate.tokenCompletionBlock) {
//            [HAMLogOutputWindow printLog:@"getNetToken dic1111"];
            delegate.tokenCompletionBlock(dic);
        }else if(weakSelf.completionBlock){
            weakSelf.completionBlock(dic);
        }
    }];
}

- (void)scanQrcodeWithToken:(NSString *)token{
    NSString *userNo = [TRUUserAPI getUser].userId;
    if (userNo){
        __weak typeof(self) weakSelf = self;
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSString *sign = token;
        NSArray *ctxx = @[@"token",sign];
        NSString *para = [xindunsdk encryptByUkey:userNo ctx:ctxx signdata:sign isDeviceType:YES];
        NSDictionary *paramsDic = @{@"params" : para};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/push/fetch"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
            [weakSelf hideHudDelay:0.0];
            NSDictionary *dic = nil;
            NSMutableDictionary *backDic = [NSMutableDictionary dictionary];
            backDic[@"type"] = @"qrcode";
            NSString *userid = [TRUUserAPI getUser].userId;
            NSString *phone = [TRUUserAPI getUser].phone;
//            if(userid.length && [xindunsdk userInitializedInfo:userid] && phone.length){
//                backDic[@"phone"] = [TRUUserAPI getUser].phone;
//            }
            if (errorno == 0 && responseBody) {
                dic = [xindunsdk decodeServerResponse:responseBody];
                if ([dic[@"code"] intValue] == 0) {
                    dic = dic[@"resp"];
                    TRUPushAuthModel *model = [TRUPushAuthModel modelWithDic:dic];
                    model.token = token;
                    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                    [weakSelf popAuthViewVCWithPushModel:model userNo:userNo];
                }
            }else if (errorno == 9008){
                backDic[@"status"] = @(errorno);
            }else if (9019 == errorno){
                backDic[@"status"] = @(errorno);
            }else if (errorno == -5004){
                [weakSelf showHudWithText:@"网络错误 请稍后重试"];
                [weakSelf hideHudDelay:2.0];
                backDic[@"status"] = @(errorno);
            }else if (errorno == 9002){
                backDic[@"status"] = @(errorno);
            }else{
                NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
                [weakSelf showHudWithText:err];
                [weakSelf hideHudDelay:2.0];
                backDic[@"status"] = @(errorno);
            }
            if (errorno!=0) {
                AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                if (delegate.tokenCompletionBlock) {
                    delegate.tokenCompletionBlock(backDic);
                }
            }
        }];
    }
}

- (void)scanQRCode:(NSString *)result{
    if (result.length >0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSArray *arr = [result componentsSeparatedByString:@"?"];
        NSString *str;
        if (arr.count>0) {
            str = [arr lastObject];
        }
        arr = [str componentsSeparatedByString:@"&"];
        if (arr.count >0) {
            for (NSString *str in arr) {
                NSArray *tmp = [str componentsSeparatedByString:@"="];
                NSString *key = [tmp firstObject];
                NSArray *value = [tmp lastObject];
                if (key && value) {
                    dic[key] = value;
                }
            }
        }
        
        NSString *op = dic[@"op"];
        NSString *authcode = dic[@"authcode"];
        
        
        if ([op isEqualToString:@"login"]) {
            NSString *userNo = [TRUUserAPI getUser].userId;
            if (userNo){
                __weak typeof(self) weakSelf = self;
                NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
                NSString *sign = authcode;
                NSArray *ctxx = @[@"token",sign];
                NSString *para = [xindunsdk encryptByUkey:userNo ctx:ctxx signdata:sign isDeviceType:YES];
                NSDictionary *paramsDic = @{@"params" : para};
                [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/push/fetch"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
                    [weakSelf hideHudDelay:0.0];
                    NSDictionary *dic = nil;
                    NSMutableDictionary *backDic = [NSMutableDictionary dictionary];
                    backDic[@"type"] = @"qrcode";
                    NSString *userid = [TRUUserAPI getUser].userId;
                    NSString *phone = [TRUUserAPI getUser].phone;
                    if(userid.length && [xindunsdk userInitializedInfo:userid] && phone.length){
                        backDic[@"phone"] = [TRUUserAPI getUser].phone;
                    }
                    if (errorno == 0 && responseBody) {
                        dic = [xindunsdk decodeServerResponse:responseBody];
                        if ([dic[@"code"] intValue] == 0) {
                            dic = dic[@"resp"];
                            TRUPushAuthModel *model = [TRUPushAuthModel modelWithDic:dic];
                            model.token = authcode;
                            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                            });
                            [weakSelf popAuthViewVCWithPushModel:model userNo:userNo];
//                            weakSelf.pushCompletion = ^{
//                                [delegate.window.rootViewController dismissViewControllerAnimated:NO completion:^{
//                                    [weakSelf popAuthViewVCWithPushModel:model userNo:userNo];
//                                }];
//                            };
                        }
                    }else if (errorno == 9008){
//                        [weakSelf deal9008Error];
                        backDic[@"status"] = @(errorno);
                    }else if (9019 == errorno){
//                        [weakSelf deal9019Error];
                        backDic[@"status"] = @(errorno);
                    }else if (errorno == -5004){
                        [weakSelf showHudWithText:@"网络错误 请稍后重试"];
                        [weakSelf hideHudDelay:2.0];
                        backDic[@"status"] = @(errorno);
//                        [weakSelf performSelector:@selector(restartScan)  withObject:nil afterDelay:2.1];
                    }else if (errorno == 9002){
//                        [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"二维码过期，请刷新二维码重新扫描" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
////                            [weakSelf restartScan];
//                        } cancelBlock:nil];
                        backDic[@"status"] = @(2010);
                    }else{
                        NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
                        [weakSelf showHudWithText:err];
                        [weakSelf hideHudDelay:2.0];
//                        [weakSelf performSelector:@selector(restartScan)  withObject:nil afterDelay:2.1];
                        backDic[@"status"] = @(errorno);
                    }
                    if (errorno!=0) {
                        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                        if (delegate.tokenCompletionBlock) {
                            delegate.tokenCompletionBlock(backDic);
                        }
                    }
                }];
                
                
            }else{
                [self showHudWithText:@"无效二维码"];
                [self hideHudDelay:2.0];
//                [self performSelector:@selector(restartScan)  withObject:nil afterDelay:2.1];
                AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                if (delegate.tokenCompletionBlock) {
                    NSMutableDictionary *backDic = [NSMutableDictionary dictionary];
                    backDic[@"type"] = @"qrcode";
                    NSString *userid = [TRUUserAPI getUser].userId;
                    NSString *phone = [TRUUserAPI getUser].phone;
                    if(userid.length && [xindunsdk userInitializedInfo:userid] && phone.length){
                        backDic[@"phone"] = [TRUUserAPI getUser].phone;
                    }
                    backDic[@"status"] = @(4);
                    delegate.tokenCompletionBlock(backDic);
                }
            }
            
        }else{
//            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"无效二维码，请确认二维码来源！" confrimTitle:@"确认" cancelTitle:@"" confirmRight:YES confrimBolck:^{
//
//            } cancelBlock:nil];
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            if (delegate.tokenCompletionBlock) {
                NSMutableDictionary *backDic = [NSMutableDictionary dictionary];
                backDic[@"type"] = @"qrcode";
                NSString *userid = [TRUUserAPI getUser].userId;
                NSString *phone = [TRUUserAPI getUser].phone;
                if(userid.length && [xindunsdk userInitializedInfo:userid] && phone.length){
                    backDic[@"phone"] = [TRUUserAPI getUser].phone;
                }
                backDic[@"status"] = @(2001);
                delegate.tokenCompletionBlock(backDic);
            }
        }
    }
}

- (void)popAuthViewVCWithPushModel:(TRUPushAuthModel*)pushModel userNo:(NSString *)userNo{
//    [self.scanView stopScaning];
//    [self.scanView stopAnimation];
//    self.canSacn = NO;
    
    __weak typeof(self) weakSelf = self;
    TRUPushingViewController *authVC = [[TRUPushingViewController alloc] init];
    authVC.pushModel = pushModel;
    authVC.userNo = userNo;
    [authVC setDismissStatusBlock:^(int status) {
        [weakSelf dismissViewControllerAnimated:NO completion:^{
                AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                if (delegate.tokenCompletionBlock) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    dic[@"type"] = @"qrcode";
                    NSString *userid = [TRUUserAPI getUser].userId;
                    NSString *phone = [TRUUserAPI getUser].phone;
                    if(userid.length && [xindunsdk userInitializedInfo:userid] && phone.length){
                        dic[@"phone"] = [TRUUserAPI getUser].phone;
                    }
                    dic[@"status"] = @(status);
                    delegate.tokenCompletionBlock(dic);
                }
        }];
    }];
    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:authVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)scanMessage:(NSString *)result{
    NSArray *arr = [result componentsSeparatedByString:@"download"];
    
    NSString *currentCims;
    //兼容主线和永辉
    if (arr.count>0) {
        currentCims = arr[0];
    }
    
    NSString *cimsStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pushID = [stdDefaults objectForKey:@"TRUPUSHID"];
    
    if (0) {
        
        // http://ip:port/app/download?op=active&authcode=263439&userno=liurunxin@trusfort.com
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        NSArray *arr = [result componentsSeparatedByString:@"?"];
//        NSString *str = [arr lastObject];
//        arr = [str componentsSeparatedByString:@"&"];
//        for (NSString *str in arr) {
//            NSArray *tmp = [str componentsSeparatedByString:@"="];
//            NSString *key = [tmp firstObject];
//            NSArray *value = [tmp lastObject];
//            if (key && value) {
//                dic[key] = value;
//            }
//        }
//
//        NSString *userNo = dic[@"userno"];
//        NSString *op = dic[@"op"];
//        NSString *authcode = dic[@"authcode"];
//
//        if ([op isEqualToString:@"active"]) {
//            [self showActivityWithText:@"正在激活..."];
//            if (userNo && userNo.length > 0) {
//                [self activeWith:userNo andtype:@"email" authCode:authcode pushid:pushID];
//
//            }else{//如果userno不存在 二维码来源不对
//
//                [self showConfrimCancelDialogViewWithTitle:@"" msg:@"无效二维码，请确认二维码来源！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
//                    [weakSelf performSelectorOnMainThread:@selector(restartScan) withObject:nil waitUntilDone:3];
//                } cancelBlock:nil];
//            }
//
//        }else if ([op isEqualToString:@"login"]){
//            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"该终端还未激活，请尝试自注册激活或联系管理员" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
//                [weakSelf dismissViewControllerAnimated:NO completion:^{
//                    if (weakSelf.backBlock) {
//                        weakSelf.backBlock(YES);
//                    }
//                }];
//            } cancelBlock:nil];
//
//        }else{//不是login 也不是active 无效二维码，请确认二维码来源！
//
//            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"无效二维码，请确认二维码来源！" confrimTitle:@"确认" cancelTitle:nil confirmRight:YES confrimBolck:^{
//                [weakSelf performSelectorOnMainThread:@selector(restartScan) withObject:nil waitUntilDone:3];
//            } cancelBlock:nil];
//
//        }
    }else{//获取多租户信息后的逻辑
        //1.获取多租户信息
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSArray *arr = [result componentsSeparatedByString:@"?"];
        NSString *str = [arr lastObject];
        arr = [str componentsSeparatedByString:@"&"];
        for (NSString *str in arr) {
            NSArray *tmp = [str componentsSeparatedByString:@"="];
            NSString *key = [tmp firstObject];
            NSArray *value = [tmp lastObject];
            if (key && value) {
                dic[key] = value;
            }
        }
        NSString *userNo = dic[@"userno"];
        NSString *op = dic[@"op"];
        NSString *authcode = dic[@"authcode"];
        NSString *spcode = dic[@"spcode"];
        if (spcode.length>0){//
            [xindunsdk initEnv:@"com.example.demo" url:currentCims];
            NSString *para = [xindunsdk encryptByUkey:spcode];
            NSDictionary *dic = @{@"params" : [NSString stringWithFormat:@"%@",para]};
            __weak typeof(self) weakSelf = self;
            [TRUhttpManager sendCIMSRequestWithUrl:[currentCims stringByAppendingString:@"mapi/01/verify/getspinfo"] withParts:dic onResult:^(int errorno, id responseBody) {
                [weakSelf hideHudDelay:0.0];
                NSMutableDictionary *backDic = [NSMutableDictionary dictionary];
                backDic[@"type"] = @"qrcode";
                NSString *userid = [TRUUserAPI getUser].userId;
                NSString *phone = [TRUUserAPI getUser].phone;
                if(userid.length && [xindunsdk userInitializedInfo:userid] && phone.length){
                    backDic[@"phone"] = [TRUUserAPI getUser].phone;
                }
                YCLog(@"--%d-->%@",errorno,responseBody);
                if (errorno == 0 && responseBody) {
                    NSDictionary *dict = [xindunsdk decodeServerResponse:responseBody];
                    YCLog(@"--->%@",dict);
                    if ([dict[@"code"] intValue] == 0) {
                        NSDictionary *dicc = dict[@"resp"];
                        TRUCompanyModel *companyModel = [TRUCompanyModel modelWithDic:dicc];
                        companyModel.desc = dic[@"description"];
                        [TRUCompanyAPI saveCompany:companyModel];
                        if (companyModel.cims_server_url.length>0) {
                            if((op == nil || op.length == 0)&&(authcode == nil || authcode.length == 0)){
                                [weakSelf showHudWithText:@"切换服务器成功"];
                                [weakSelf hideHudDelay:2.0];
                                [[NSUserDefaults standardUserDefaults] setObject:spcode forKey:@"CIMSURL_SPCODE"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                bool res = [xindunsdk initEnv:@"com.example.demo" url:companyModel.cims_server_url];
                                YCLog(@"initXdSDK %d",res);
                                [[NSUserDefaults standardUserDefaults] setObject:companyModel.cims_server_url forKey:@"CIMSURL"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                [weakSelf dismissViewControllerAnimated:NO completion:^{
                                    if (weakSelf.completionBlock) {
                                        backDic[@"status"] = @(0);
                                        weakSelf.completionBlock(backDic);
                                    }
                                }];
                                return;
                            }
                            [weakSelf showHudWithText:@"切换用户成功"];
                            [weakSelf hideHudDelay:2.0];
                            [[NSUserDefaults standardUserDefaults] setObject:spcode forKey:@"CIMSURL_SPCODE"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            bool res = [xindunsdk initEnv:@"com.example.demo" url:companyModel.cims_server_url];
                            YCLog(@"initXdSDK %d",res);
                            [[NSUserDefaults standardUserDefaults] setObject:companyModel.cims_server_url forKey:@"CIMSURL"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            if ([op isEqualToString:@"active"]) {//激活
                                if (userNo && userNo.length > 0) {
//                                    [weakSelf activeWith:userNo andtype:@"email" authCode:authcode pushid:pushID];
                                }
                            }else if ([op isEqualToString:@"login"]){
                                [weakSelf dismissViewControllerAnimated:NO completion:^{
//                                    if (weakSelf.completionBlock) {
//                                        weakSelf.completionBlock(backDic);
//                                    }
                                }];
                                
                            }else{//不是login 也不是active 无效二维码，请确认二维码来源！
                                [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"无效二维码，请确认二维码来源！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
//                                    [weakSelf performSelectorOnMainThread:@selector(restartScan) withObject:nil waitUntilDone:3];
                                    if (weakSelf.completionBlock) {
                                        backDic[@"status"] = @(2001);
                                        weakSelf.completionBlock(backDic);
                                    }
                                } cancelBlock:nil];
                                
                            }
                            
                            
                        }else{//服务器地址为空
                            [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"服务地址有误" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
//                                [weakSelf performSelectorOnMainThread:@selector(restartScan) withObject:nil waitUntilDone:3];
                                if (weakSelf.completionBlock) {
                                    backDic[@"status"] = @(2002);
                                    weakSelf.completionBlock(backDic);
                                }
                            } cancelBlock:nil];
                        }
                    }
                }else if (-5004 == errorno){
                    [weakSelf showHudWithText:@"网络错误，请稍后重试"];
                    [weakSelf hideHudDelay:2.0];
//                    [weakSelf performSelectorOnMainThread:@selector(restartScan) withObject:nil waitUntilDone:3];
                    backDic[@"status"] = @(-5004);
                    weakSelf.completionBlock(backDic);
                }else if (9019 == errorno){
                    [weakSelf dele9019ErrorWithBlock:^{
//                        [weakSelf restartScan];
                        backDic[@"status"] = @(9019);
                        weakSelf.completionBlock(backDic);
                    }];;
                }else if (9026 == errorno){
                    [weakSelf deal9026ErrorWithBlock:^{
//                        [weakSelf restartScan];
                        backDic[@"status"] = @(9026);
                        weakSelf.completionBlock(backDic);
                    }];
                }else{
                    [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"该二维码已失效，请尝试自注册或联系管理员" confrimTitle:@"自注册" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
//                        [weakSelf pinBtnClick];
                        
                    } cancelBlock:^{
                        [weakSelf dismissViewControllerAnimated:NO completion:nil];
                    }];
                    backDic[@"status"] = @(errorno);
                    weakSelf.completionBlock(backDic);
                }
            }];
            
        }else{
            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"无效二维码，请确认二维码来源！" confrimTitle:@"确认" cancelTitle:nil confirmRight:YES confrimBolck:^{
//                [weakSelf performSelectorOnMainThread:@selector(restartScan) withObject:nil waitUntilDone:3];
            } cancelBlock:nil];
            NSMutableDictionary *backDic = [NSMutableDictionary dictionary];
            backDic[@"type"] = @"qrcode";
            NSString *userid = [TRUUserAPI getUser].userId;
            NSString *phone = [TRUUserAPI getUser].phone;
            if(userid.length && [xindunsdk userInitializedInfo:userid] && phone.length){
                backDic[@"phone"] = [TRUUserAPI getUser].phone;
            }
            backDic[@"status"] = @(2001);
            self.completionBlock(backDic);
        }
    }
}

-(void)activeWith:(NSString *)userno andtype:(NSString *)type authCode:(NSString *)authCode pushid:(NSString *)pushid{
    __weak typeof(self) weakSelf = self;
    NSString *singStr = [NSString stringWithFormat:@",\"userno\":\"%s\",\"pushid\":\"%s\",\"type\":\"%s\",\"authcode\":\"%s\"", [userno UTF8String],[pushid UTF8String], [type UTF8String],[authCode UTF8String]];
    NSString *para = [xindunsdk encryptBySkey:userno ctx:singStr isType:YES];
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/active"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
        if (errorno == 0) {
            NSString *userId = nil;
            int err = [xindunsdk privateVerifyCIMSInitForUserNo:userno response:dic[@"resp"] userId:&userId];
            //            NSLog(@"---11111111111--->%d---->%@",err,userId);
            if (err == 0) {
                //同步用户信息
                NSString *paras = [xindunsdk encryptByUkey:userId ctx:nil signdata:nil isDeviceType:NO];
                NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
                [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
                    [weakSelf hideHudDelay:0.0];
                    NSDictionary *dicc = nil;
                    if (errorno == 0 && responseBody) {
                        dicc = [xindunsdk decodeServerResponse:responseBody];
                        if ([dicc[@"code"] intValue] == 0) {
                            dicc = dicc[@"resp"];
                            //                            NSLog(@"-dic->%@",dicc);
                            //用户信息同步成功
                            TRUUserModel *model = [TRUUserModel modelWithDic:dicc];
                            model.userId = userId;
                            [TRUUserAPI saveUser:model];
                            if ([weakSelf checkPersonInfoVC:model]) {//yes 表示需要完善信息
                                TRUAddPersonalInfoViewController *infoVC = [[TRUAddPersonalInfoViewController alloc] init];
                                infoVC.userNo = userno;
                                infoVC.email = model.email;
                                infoVC.isScan = YES;
                                infoVC.backBlocked=^(){
                                    [weakSelf cancelBtnClick];
                                };
                                [weakSelf.navigationController pushViewController:infoVC animated:YES];
                            }else{//同步信息成功，信息完整，跳转页面
#pragma clang diagnostic ignored "-Wundeclared-selector"
                                YCLog(@"跳转");
                                id delegate = [UIApplication sharedApplication].delegate;
                                if ([delegate respondsToSelector:@selector(changeRootVC)]) {
                                    [delegate performSelector:@selector(changeRootVC)];
                                }
                            }
                        }
                    }
                }];
            }
        }else if (-5004 == errorno){
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
//            [weakSelf performSelectorOnMainThread:@selector(restartScan) withObject:nil waitUntilDone:3];
            
        }else if (9019 == errorno){
            [weakSelf dele9019ErrorWithBlock:^{
//                [weakSelf restartScan];
            }];;
        }else if (9026 == errorno){
            [weakSelf deal9026ErrorWithBlock:^{
//                [weakSelf restartScan];
            }];
        }else{
            [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"该二维码已失效，请尝试联系管理员！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                [weakSelf dismissViewControllerAnimated:NO completion:^{
                    if (weakSelf.completionBlock) {
                        NSMutableDictionary *dic;
                        weakSelf.completionBlock(dic);
                    }
                }];
                
            } cancelBlock:nil];
        }
    }];
    
    
}

- (BOOL)checkPersonInfoVC:(TRUUserModel *)model{
    NSString *activeStr = [TRUCompanyAPI getCompany].activation_mode;
    if (activeStr.length == 3) {
        if ([activeStr containsString:@","]) {
            NSArray *arr = [activeStr componentsSeparatedByString:@","];
            NSString *modestr = arr[1];
            if ([modestr isEqualToString:@"1"]) {
                if (model.email.length >0) {
                    return NO;
                }else{
                    return YES;
                }
            }else if ([modestr isEqualToString:@"2"]){
                if (model.phone.length >0) {
                    return NO;
                }else{
                    return YES;
                }
            }else if ([modestr isEqualToString:@"0"]){
                return NO;
            }else{
                return NO;
                //                if (model.employeenum.length >0) {
                //                    return NO;
                //                }else{
                //                    return YES;
                //                }
            }
        }else{
            return NO;
        }
        
    }else if (activeStr.length == 1){
        return NO;
    }else{
        return NO;
    }
}

- (void)cancelBtnClick{
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:NO completion:^{
        if (weakSelf.completionBlock) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"type"] = @"qrcode";
            dic[@"status"] = @(1);
            weakSelf.completionBlock(dic);
        }
    }];
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
