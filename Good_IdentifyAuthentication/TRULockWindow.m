//
//  TRULockWindow.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/5/8.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRULockWindow.h"
#import "TRUVerifyFingerprintViewController.h"
#import "TRUGestureVerifyViewController.h"
#import "TRUFingerGesUtil.h"
#import "TRUBaseNavigationController.h"
#import "TRUVerifyFaceViewController.h"
#import "gesAndFingerNVController.h"
#import "AppDelegate.h"
#import "TRULoadingViewController.h"
@implementation TRULockWindow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//全局变量
static id _instance = nil;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        TRULockWindow *view = _instance;
//        view.authType = AuthViewTypeNone;
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
    
    
    TRULockWindow *win = [[self alloc] init];
    
    if (win.hidden == NO) {
        return;
    }
    win.frame = [UIScreen mainScreen].bounds;
    win.windowLevel = UIWindowLevelAlert;
    [win makeKeyAndVisible];
    
    YCLog(@"UIWindowLevelNormal = %f",UIWindowLevelNormal);
    win.rootViewController = [self authVC];
    win.hidden = NO;
}

+ (void)dismissAuthView{
    TRULockWindow *win = [[self alloc] init];
    win.hidden = YES;
    win.rootViewController = nil;
//    win.authType = AuthViewTypeNone;
    //    [HAMLogOutputWindow printLog:@"dismissAuthView"];
}

+ (void)dismissAuthViewAndCleanStatus{
    TRULockWindow *win = [[self alloc] init];
    win.hidden = YES;
    win.rootViewController = nil;
}

+ (TRUBaseNavigationController *)authVC{
    TRULockWindow *win = [[self alloc] init];
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
    return nav;
}


@end
