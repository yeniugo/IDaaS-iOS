//
//  TRUScreenShotAlert.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/7/24.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRUScreenShotAlert.h"

@implementation TRUScreenShotAlert

//全局变量
static id _ScreenShotAlert = nil;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ScreenShotAlert = [super allocWithZone:zone];
        TRUScreenShotAlert *view = _ScreenShotAlert;
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        //注册通知
        [center addObserver:self selector:@selector(takescreenshot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    });
    return _ScreenShotAlert;
}

//copy在底层 会调用copyWithZone:
- (id)copyWithZone:(NSZone *)zone{
    return  _ScreenShotAlert;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return  _ScreenShotAlert;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return _ScreenShotAlert;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _ScreenShotAlert;
}

+ (void)takescreenshot:(NSNotification *)noti{
    TRUScreenShotAlert *win = [[self alloc] init];
    win.hidden = NO;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"截屏提示" message:@"为了您的安全，请不要随意分享截屏" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    [alertView show];
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissView];
}

- (void)takescreenshot:(NSNotification *)noti{
    TRUScreenShotAlert *win = [[TRUScreenShotAlert alloc] init];
    win.hidden = NO;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"截屏提示" message:@"为了您的安全，请不要随意分享截屏" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissView];
}

+ (void)dismissView{
    TRUScreenShotAlert *win = [[self alloc] init];
    win.hidden = YES;
}

- (void)dismissView{
    TRUScreenShotAlert *win = [[TRUScreenShotAlert alloc] init];
    win.hidden = YES;
}

+ (void)showScreen{
    TRUScreenShotAlert *win = [[self alloc] init];
    win.frame = [UIScreen mainScreen].bounds;
    [win setBackgroundColor:[UIColor clearColor]];
    win.windowLevel = 10;
    [win makeKeyAndVisible];
    win.rootViewController = [self authVC];
    win.hidden = YES;
}

+ (UIViewController *)authVC{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor clearColor];
    return vc;
}

@end
