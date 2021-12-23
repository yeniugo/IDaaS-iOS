//
//  TRUEnterAPPAuthView.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/2/16.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUEnterAPPAuthView.h"
#import "TRUVerifyFingerprintViewController.h"
#import "TRUGestureVerifyViewController.h"
#import "TRUFingerGesUtil.h"
#import "TRUBaseNavigationController.h"
#import "TRUVerifyFaceViewController.h"
#import "gesAndFingerNVController.h"
#import "AppDelegate.h"
#import "TRULoadingViewController.h"
#import "TRUMTDTool.h"
#import "TRULoginDefaultViewController.h"
@interface TRUEnterAPPAuthView()
@property (nonatomic,assign) BOOL isShowPushAuth;//是否需要展示push验证
@property (nonatomic,assign) AuthViewType authType;//授权类型

@end

@implementation TRUEnterAPPAuthView
static NSInteger _lockid = 0;
//全局变量
static id _instance = nil;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        TRUEnterAPPAuthView *view = _instance;
        view.authType = AuthViewTypeNone;
    });
    return _instance;
}

//copy在底层 会调用copyWithZone:
- (id)copyWithZone:(NSZone *)zone{
    return  _instance;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return  _instance;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

//- (BOOL)lock{
//    return _lock;
//}
//
//+ (void)setLock:(BOOL)lock{
//    _lock = lock;
//}
+ (NSInteger)lockid{
    return _lockid;
}

+ (void)setLockid:(NSInteger)lockid{
    _lockid = lockid;
}

+ (void)showAuthView{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    if (delegate.thirdAwakeTokenStatus==2||delegate.thirdAwakeTokenStatus==8) {
//        [self dismissAuthView];
//        return;
//    }
//    if(delegate.thirdAwakeTokenStatus>0){
//        return;
//    }
//    TRUEnterAPPAuthView *authView = [[self alloc] init];
    if (self.lockid) {
        return;
    }
//    BOOL isLogout = [[NSUserDefaults standardUserDefaults] boolForKey:@"applogout"];
//    if (!isLogout) {
//        return;
//    }
    NSNumber *time1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"applogintime"];
    long seconds_cli = (long)time((time_t *)NULL);
    if (time1.longValue > seconds_cli) {
        return;
    }
    TRUEnterAPPAuthView *win = [[self alloc] init];
//    if (win.lock) {
//        return;
//    }
//    if (win.authType==AuthViewTypeAuth && win.hidden == NO) {
//        return;
//    }
    win.frame = [UIScreen mainScreen].bounds;
    win.windowLevel = 1.0;
//    if (win.rootViewController==nil) {
    win.rootViewController = [self authVC];
//    }
    
    win.hidden = NO;
    win.authType = AuthViewTypeAuth;
//    [HAMLogOutputWindow printLog:@"showAuthView"];
}

+ (void)showLoading{
    
//    TRUEnterAPPAuthView *authView = self;
    TRULoadingViewController *loadingVC = [[TRULoadingViewController alloc] init];
    TRUEnterAPPAuthView *win = [[self alloc] init];
    if (win.authType==AuthViewTypeLoading && win.hidden == NO) {
        return;
    }
    win.frame = [UIScreen mainScreen].bounds;
    win.windowLevel = UIWindowLevelNormal;
    win.rootViewController = loadingVC;
    win.hidden = NO;
    win.authType = AuthViewTypeLoading;
}


+(void)showAuthViewWithCompletionBlock:(void (^)(void))success{
//    [self dismissAuthView];
    
    TRUEnterAPPAuthView *win = [[self alloc] init];
//    if (win.authType==AuthViewTypeAuthWithBlock) {
//        return;
//    }else{
//        
//    }
    win.frame = [UIScreen mainScreen].bounds;
    win.windowLevel = UIWindowLevelNormal;
//    if (win.rootViewController==nil) {
    win.rootViewController = [self authVCWithCompletionBlock:^{
        success();
    }];
//    }
//    [HAMLogOutputWindow printLog:@"showAuthViewWithCompletionBlock"];
    win.hidden = NO;
    win.authType = AuthViewTypeAuthWithBlock;
//    [HAMLogOutputWindow printLog:@"showAuthViewWithCompletionBlock"];
}

+ (void)dismissAuthView{
    if (self.lockid) {
        return;
    }
    TRUEnterAPPAuthView *win = [[self alloc] init];
    win.hidden = YES;
    win.rootViewController = nil;
    win.authType = AuthViewTypeNone;
//    [HAMLogOutputWindow printLog:@"dismissAuthView"];
//    [TRUMTDTool uploadDevInfo];
}

+ (void)dismissAuthViewAndCleanStatus{
    if (self.lockid) {
        return;
    }
    TRUEnterAPPAuthView *win = [[self alloc] init];
    win.hidden = YES;
    win.rootViewController = nil;
    win.isShowPushAuth = NO;
    win.authType = AuthViewTypeNone;
//    YCLog(@"dismissAuthViewAndCleanStatus");
//    [DDLog addLogger:[DDOSLogger sharedInstance]]; // Uses os_log
//
//    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
//    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
//    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
//    [DDLog addLogger:fileLogger];
//
//    DDLogVerbose(@"Verbose");
//    [HAMLogOutputWindow printLog:@"dismissAuthViewAndCleanStatus"];
}

+ (TRUBaseNavigationController *)authVC{
    TRUEnterAPPAuthView *win = [[self alloc] init];
    if (win.isShowPushAuth) {
        return nil;
    }
    UIViewController *rootVC;
    TRULoginDefaultViewController *vc = [[TRULoginDefaultViewController alloc] init];
    //判断优先级 指纹和Face ID > 手势
//    if ([TRUFingerGesUtil getLoginAuthFingerType] != TRULoginAuthFingerTypeNone) {
//        if ([TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeFace) {
//            //人脸
//            TRUVerifyFaceViewController *verifyVC =  [[TRUVerifyFaceViewController alloc] init];
//            verifyVC.isDoingAuth = YES;
//            rootVC = verifyVC;
//        }else{
//            //指纹
//            TRUVerifyFingerprintViewController *finVC = [[TRUVerifyFingerprintViewController alloc] init];
//            finVC.isDoingAuth = YES;
//            rootVC = finVC;
//        }
//    }else{
//        TRUGestureVerifyViewController *verifyVC =  [[TRUGestureVerifyViewController alloc] init];
//        verifyVC.isDoingAuth = YES;
//        rootVC = verifyVC;
//    }
    rootVC = vc;
    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:rootVC];
    rootVC.navigationBar.hidden = YES;
//    [nav setNavBarColor:ViewDefaultBgColor];
    return nav;
}

+ (TRUBaseNavigationController *)authVCWithCompletionBlock:(void (^)(void))success{
    TRUEnterAPPAuthView *win = [[self alloc] init];
//    if (success==nil) {
//        win.isShowPushAuth = NO;
//    }else{
//        win.isShowPushAuth = YES;
//    }
    win.isShowPushAuth = YES;
    UIViewController *rootVC;
    //判断优先级 指纹和Face ID > 手势
    if ([TRUFingerGesUtil getLoginAuthFingerType] != TRULoginAuthFingerTypeNone) {
        if ([TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeFace) {
            //人脸
            TRUVerifyFaceViewController *verifyVC =  [[TRUVerifyFaceViewController alloc] init];
            verifyVC.isDoingAuth = YES;
            verifyVC.completionBlock = success;
            rootVC = verifyVC;
        }else{
            //指纹
            TRUVerifyFingerprintViewController *finVC = [[TRUVerifyFingerprintViewController alloc] init];
            finVC.isDoingAuth = YES;
            finVC.completionBlock = success;
            rootVC = finVC;
        }
    }else{
        TRUGestureVerifyViewController *verifyVC =  [[TRUGestureVerifyViewController alloc] init];
        verifyVC.isDoingAuth = YES;
        verifyVC.completionBlock = success;
        rootVC = verifyVC;
    }
    
    return [[TRUBaseNavigationController alloc] initWithRootViewController:rootVC];
}

+ (void)lockView{
    self.lockid = 1;
}

+ (void)unlockView{
    self.lockid = 0;
}

@end
