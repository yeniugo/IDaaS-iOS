//
//  TRUBaseTabBarController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/26.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUBaseTabBarController.h"

#import "TRUMineViewController.h"
#import "TRUDynamicPasswordViewController.h"
#import "TRUApplicationViewController.h"
#import "TRUBioinformationViewController.h"
#import "TRUBaseNavigationController.h"
#import "TRUAuthSacnViewController.h"
#import "TRUPushViewController.h"
#import "TRUPushingViewController.h"
#import "TRUFingerGesUtil.h"
#import "TRUEnterAPPAuthView.h"
#import "TRUUserAPI.h"
#import "MyTabBar.h"
#import <AVFoundation/AVFoundation.h>
#import "TRUAuthenticateViewController.h"

#import "TRUGestureVerifyViewController.h"
#import "TRUVerifyFingerprintViewController.h"
#import "TRUPersonalViewController.h"

#import "AppDelegate.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
#import "TRUTokenUtil.h"
@interface TRUBaseTabBarController ()<MyTabBarDetagate>
@property(nonatomic,weak)MyTabBar *customTabBar;
@property (nonatomic, strong) TRUBaseNavigationController *gesFingerNavVC;
@property (nonatomic, assign) BOOL isShowLocalAuth;//是否显示本地验证

@end

@implementation TRUBaseTabBarController
- (TRUBaseNavigationController *)gesFingerNavVC{
    UIViewController *rootVC;
    if ([TRUFingerGesUtil getLoginAuthGesType] == TRULoginAuthGesTypeture) {
        TRUGestureVerifyViewController *vc = [[TRUGestureVerifyViewController alloc] init];
        vc.isDoingAuth = YES;
        rootVC = vc;
    }else if ([TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeFace || [TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeFinger){
        TRUVerifyFingerprintViewController *vc = [[TRUVerifyFingerprintViewController alloc] init];
        vc.isDoingAuth = YES;
        rootVC = vc;
    }
    _gesFingerNavVC = [[TRUBaseNavigationController alloc] initWithRootViewController:rootVC];
    return _gesFingerNavVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    YCLog(@"TRUBaseNavigationController viewDidLoad");
    __weak typeof(self) weakSelf = self;
//    YCLog(@"TRUBaseTabBarController viewdidload");
    if (!self.isAddUserInfo) {
//        if (self.isShowLocalAuth) {
////            [TRUEnterAPPAuthView dismissAuthView];
//        }else{
//            [self showFinger];
//        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            if (delegate.thirdAwakeTokenStatus) {
                if (delegate.thirdAwakeTokenStatus==2 && ([TRUFingerGesUtil getLoginAuthFingerType]!=TRULoginAuthFingerTypeNone||[TRUFingerGesUtil getLoginAuthGesType]!=TRULoginAuthGesTypeNone)) {
//                    [TRUEnterAPPAuthView showAuthViewWithCompletionBlock:^{
//                        [weakSelf getNetToken];
//                    }];
                }else{
                    [TRUEnterAPPAuthView showAuthView];
                }
            }else{
                if (([TRUFingerGesUtil getLoginAuthFingerType]!=TRULoginAuthFingerTypeNone||[TRUFingerGesUtil getLoginAuthGesType]!=TRULoginAuthGesTypeNone)) {
                    [TRUEnterAPPAuthView showAuthView];
                }
            }
        });
        
    }
    
    [self setUpTabbar];
    [self setUPChildrenVC];
    
}

- (void)hideLocalAuth{
    self.isShowLocalAuth = YES;
    [TRUEnterAPPAuthView dismissAuthView];
}

- (void)showFinger{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if ([TRUFingerGesUtil getLoginAuthType] != TRULoginAuthTypeNone) {
        if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeFinger) {
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFinger];
        }else if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeFace){
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFace];
        }else if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeGesture){
            [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeture];
        }
        [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
        if (delegate.thirdAwakeTokenStatus==2) {
            [TRUEnterAPPAuthView showLoading];
        }else{
            [TRUEnterAPPAuthView showAuthView];
        }
    }else{
        if ([TRUFingerGesUtil getLoginAuthGesType] != TRULoginAuthGesTypeNone || [TRUFingerGesUtil getLoginAuthFingerType] != TRULoginAuthFingerTypeNone) {
            if (delegate.thirdAwakeTokenStatus==2) {
                [TRUEnterAPPAuthView showLoading];
            }else{
                [TRUEnterAPPAuthView showAuthView];
            }
        }
    }
}
///移除自带的tabBar
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    YCLog(@"TRUBaseNavigationController viewWillAppear");
    for(UIView *child in self.tabBar.subviews){
        if([child isKindOfClass:[UIControl class]]){
            [child removeFromSuperview];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLocalAuth) name:@"hideLocalAuth" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUpTabbar{
    
    MyTabBar *customTabBar=[[MyTabBar alloc]init];
    customTabBar.frame=self.tabBar.bounds;
    self.customTabBar=customTabBar;
    customTabBar.delegate=self;
    [self.tabBar addSubview:customTabBar];
    
}

//防止tabBar出现重影
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    for(UIView *child in self.tabBar.subviews){
        if([child isKindOfClass:[UIControl class]]){
            [child removeFromSuperview];
        }
    }
}
//监听按的改变
-(void)tabBar:(MyTabBar *)tabBar didselectedButtonFrom:(int)from to:(int)to{
    self.selectedIndex=to;

}
- (void)setUPChildrenVC{
    
    [self set1ChildVCWithVC:[TRUAuthenticateViewController class] title:@"认证" image:@"tabbarAuth"];
    [self set1ChildVCWithVC:[TRUDynamicPasswordViewController class] title:@"动态口令" image:@"tabbarDynamic"];
    
//    [self set1ChildVCWithVC:[TRUBioinformationViewController class] title:@"生物信息" image:@"biologicalicon"];
    [self set1ChildVCWithVC:[TRUPersonalViewController class] title:@"我的" image:@"tabbarMine"];
    
    
}
- (void)set1ChildVCWithVC:(Class)vcClass title:(NSString *)title image:(NSString *)image{
    
    UIViewController *VC = [[vcClass alloc] init];
    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:VC];
    VC.title = title;
    
    VC.tabBarItem.selectedImage = [self orignImage:[NSString stringWithFormat:@"%@_selected",image]];
    VC.tabBarItem.image = [self orignImage:[NSString stringWithFormat:@"%@_normal",image]];
    self.tabBar.tintColor = DefaultGreenColor;
    [self addChildViewController:nav];
    [self.customTabBar addTabBarButtonWithItem:VC.tabBarItem];
}
- (UIImage *)orignImage:(NSString *)imageName{
    UIImage *img = [UIImage imageNamed:imageName];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}

#pragma mark TRUTabBarScanButtonDelegate
//扫一扫
-(void)scanQRButtonClick{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        TRUAuthSacnViewController *vc = [[TRUAuthSacnViewController alloc] init];
        
        [self presentViewController:vc animated:YES completion:nil];
        
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                TRUAuthSacnViewController *vc = [[TRUAuthSacnViewController alloc] init];
                
                [self presentViewController:vc animated:YES completion:nil];
            }else{
                [self showConfrimCancelDialogViewWithTitle:@"" msg:kCameraFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                } cancelBlock:nil];
            }
        }];
    }else if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        [self showConfrimCancelDialogViewWithTitle:@"" msg:kCameraFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } cancelBlock:nil];
    }
    
    
}


- (void)showConfrimCancelDialogViewWithTitle:(NSString *)title msg:(NSString *)msg confrimTitle:(NSString *)confrimTitle cancelTitle:(NSString *)cancelTitle confirmRight:(BOOL)confirmRight confrimBolck:(void (^)())confrimBlock cancelBlock:(void (^)())cancelBlock{
    
    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *confrimAction = [UIAlertAction actionWithTitle:confrimTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (confrimBlock) {
            confrimBlock();
        }
    }];
    if (cancelTitle && cancelTitle.length > 0) {
        UIAlertAction *cancelAction =  [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
            
        }];
        if (confirmRight) {
            [alertVC addAction:cancelAction];
            [alertVC addAction:confrimAction];
        }else{
            [alertVC addAction:confrimAction];
            [alertVC addAction:cancelAction];
        }
    }else{
        [alertVC addAction:confrimAction];
    }
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)showAuthVCWithToken:(NSString *)stoken{
    NSString *userNo = [TRUUserAPI getUser].userId;
    TRUPushingViewController *vc = [[TRUPushingViewController alloc] init];
    vc.userNo = userNo;
    vc.token = stoken;
    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:vc];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [self presentViewController:nav animated:YES completion:nil];
        }];
    }else{
        [self presentViewController:nav animated:YES completion:nil];
    }
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
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        if (delegate.tokenCompletionBlock) {
            // 延迟的时间
            delegate.tokenCompletionBlock(dic);
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                weakSelf.completionBlock(dic);
            //            });
        }
    }];
}


@end
