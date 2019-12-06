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
@interface TRUEnterAPPAuthView()
@property (nonatomic,assign) BOOL isShowPushAuth;//是否需要展示push验证
@end

@implementation TRUEnterAPPAuthView

//全局变量
static id _instance = nil;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
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

+ (void)showAuthView{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    if (delegate.thirdAwakeTokenStatus==2) {
//        [self dismissAuthView];
//        return;
//    }
//    if(delegate.thirdAwakeTokenStatus>0){
//        return;
//    }
    TRUEnterAPPAuthView *win = [[self alloc] init];
    if (win.hidden==NO) {
        return;
    }
    win.frame = [UIScreen mainScreen].bounds;
    win.windowLevel = 1.0;
    win.rootViewController = [self authVC];
    win.hidden = NO;
    
}

+ (void)showLoading{
    TRULoadingViewController *loadingVC = [[TRULoadingViewController alloc] init];
    TRUEnterAPPAuthView *win = [[self alloc] init];
    win.frame = [UIScreen mainScreen].bounds;
    win.windowLevel = UIWindowLevelNormal;
    win.rootViewController = loadingVC;
    win.hidden = NO;
}


+(void)showAuthViewWithCompletionBlock:(void (^)(void))success{
    [self dismissAuthView];
    TRUEnterAPPAuthView *win = [[self alloc] init];
    win.frame = [UIScreen mainScreen].bounds;
    win.windowLevel = 1;
    win.rootViewController = [self authVCWithCompletionBlock:^{
        success();
    }];
    win.hidden = NO;
}

+ (void)dismissAuthView{
    TRUEnterAPPAuthView *win = [[self alloc] init];
    win.hidden = YES;
    win.rootViewController = nil;
}

+ (void)dismissAuthViewAndCleanStatus{
    TRUEnterAPPAuthView *win = [[self alloc] init];
    win.hidden = YES;
    win.rootViewController = nil;
    win.isShowPushAuth = NO;
//    YCLog(@"dismissAuthViewAndCleanStatus");
//    [DDLog addLogger:[DDOSLogger sharedInstance]]; // Uses os_log
//
//    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
//    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
//    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
//    [DDLog addLogger:fileLogger];
//
//    DDLogVerbose(@"Verbose");
}

+ (TRUBaseNavigationController *)authVC{
    TRUEnterAPPAuthView *win = [[self alloc] init];
    if (win.isShowPushAuth) {
        return nil;
    }
    UIViewController *rootVC;
    //判断优先级 指纹和Face ID > 手势
    if ([TRUFingerGesUtil getLoginAuthFingerType] != TRULoginAuthFingerTypeNone) {
        if ([TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeFace) {
            //人脸
            TRUVerifyFaceViewController *verifyVC =  [[TRUVerifyFaceViewController alloc] init];
            verifyVC.isDoingAuth = YES;
            rootVC = verifyVC;
        }else{
            //指纹
            TRUVerifyFingerprintViewController *finVC = [[TRUVerifyFingerprintViewController alloc] init];
            finVC.isDoingAuth = YES;
            rootVC = finVC;
        }
    }else{
        TRUGestureVerifyViewController *verifyVC =  [[TRUGestureVerifyViewController alloc] init];
        verifyVC.isDoingAuth = YES;
        rootVC = verifyVC;
    }
    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:rootVC];
    [nav setNavBarColor:ViewDefaultBgColor];
    return nav;
}

+ (TRUBaseNavigationController *)authVCWithCompletionBlock:(void (^)(void))success{
    TRUEnterAPPAuthView *win = [[self alloc] init];
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

@end
