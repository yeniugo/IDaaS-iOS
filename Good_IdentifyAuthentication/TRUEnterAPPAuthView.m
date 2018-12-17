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
    TRUEnterAPPAuthView *win = [[self alloc] init];
    win.frame = [UIScreen mainScreen].bounds;
    win.windowLevel = UIWindowLevelNormal;
    win.rootViewController = [self authVC];
    win.hidden = NO;
    
}

+ (void)dismissAuthView{
    TRUEnterAPPAuthView *win = [[self alloc] init];
    win.hidden = YES;
    win.rootViewController = nil;
}


+ (TRUBaseNavigationController *)authVC{
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
    
    return [[TRUBaseNavigationController alloc] initWithRootViewController:rootVC];
}
@end
