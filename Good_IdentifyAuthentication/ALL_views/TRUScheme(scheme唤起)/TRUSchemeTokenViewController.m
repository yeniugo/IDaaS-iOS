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
@interface TRUSchemeTokenViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, assign) int64_t delayTime;
@end

@implementation TRUSchemeTokenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YCLog(@"TRUSchemeTokenViewController viewDidLoad");
    self.delayTime = 0.1;
    // Do any additional setup after loading the view.
    self.loadingView = [[UIActivityIndicatorView alloc] init];
    CGFloat w = 30.0;
    CGFloat h = w;
    CGFloat x = [UIScreen mainScreen].bounds.size.width/2 - w/2;
    CGFloat y = [UIScreen mainScreen].bounds.size.height/2-h/2;
    self.loadingView.frame = CGRectMake(x, y, w, h);
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimating];
    self.loadingView.color = [UIColor blackColor];
    self.loadingView.userInteractionEnabled = NO;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNetToken) name:TRUGetNetTokenKey object:nil];
    __weak typeof(self) weakSelf = self;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.thirdAwakeTokenStatus==2) {
//        if (delegate.isNeedPush) {
//            [self getNetToken];
//        }else{
//            [self showFingerWithCompletionBlock:^{
//                [weakSelf getNetToken];
//            }];
//        }
        
    }
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        [TRUEnterAPPAuthView showAuthViewWithCompletionBlock:^{
            success();
        }];
    }else{
        if ([TRUFingerGesUtil getLoginAuthGesType] != TRULoginAuthGesTypeNone || [TRUFingerGesUtil getLoginAuthFingerType] != TRULoginAuthFingerTypeNone) {
            [TRUEnterAPPAuthView showAuthViewWithCompletionBlock:^{
                success();
            }];
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
    [self getToken];
}

- (void)getToken{
    __weak typeof(self) weakSelf = self;
    //int64_t delayInSeconds = 1.0;
    switch (self.schemetype) {
        case 1:
        {
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
            break;
        case 2:
        {
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            
            if ([TRUFingerGesUtil getLoginAuthFingerType]==TRULoginAuthFingerTypeNone&&[TRUFingerGesUtil getLoginAuthGesType]==TRULoginAuthGesTypeNone) {
                YCLog(@"TRUSchemeTokenViewController   111111");
            }else{
//                if (self.isShowAuth) {
//                    [self showFingerWithCompletionBlock:^{
//                        [weakSelf getNetToken];
//                    }];
//                }else{
//                    [weakSelf getNetToken];
//                }
                if (delegate.isNeedPush) {
                    [self getNetToken];
                    [HAMLogOutputWindow printLog:@"self getNetToken"];
                }else{
                    [HAMLogOutputWindow printLog:@"showFingerWithCompletionBlock"];
                    [self showFingerWithCompletionBlock:^{
                        [weakSelf getNetToken];
                    }];
                }
                
            }
            break;
        }
        case 3:
        {
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
            break;
        }
        case 4:
        {
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
                [weakSelf unbind];
            });
            
            break;
            
        }
        default:
            break;
    }
}

- (void)unbind{
    __weak typeof(self) weakSelf = self;
    [weakSelf showHudWithText:@"正在解除绑定..."];
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *uuid = [xindunsdk getCIMSUUID:userid];
    NSString *phone = [TRUUserAPI getUser].phone;
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
        [HAMLogOutputWindow printLog:@"getNetToken dic"];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        if (delegate.tokenCompletionBlock) {
            [HAMLogOutputWindow printLog:@"getNetToken dic1111"];
            delegate.tokenCompletionBlock(dic);
        }else if(weakSelf.completionBlock){
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
