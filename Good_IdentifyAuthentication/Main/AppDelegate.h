//
//  AppDelegate.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/25.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *appKey = @"e556fd0e9afcaf1e5ddab8e9";
static NSString *channel = @"Publish channel";
static BOOL isProduction = YES;
static BOOL isShowPortal = YES;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
//@property (assign, nonatomic) BOOL fromThirdAwake;//是否从第三方唤起app,默认值为NO
@property (nonatomic, copy) NSString *soureSchme;
//@property (assign, nonatomic) BOOL isFirstLogin;//是否为第一次登陆,默认值为NO
@property (assign, nonatomic) int thirdAwakeTokenStatus;//第三方唤起状态（token调用）
@property (assign, nonatomic) BOOL isNeedPush;//登录控制界面是否需要push
@property (nonatomic, copy) NSString *appid;//第三方应用appid
@property (nonatomic, copy) NSString *apid;//第三方应用UUID
@property (nonatomic, assign) BOOL isFirstStart;

//移动认证
@property (nonatomic, copy) void (^appCompletionBlock)(NSDictionary *tokenDic);
@property (nonatomic, strong) UIViewController *appPushVC;

//推送
@property (nonatomic, copy) void (^pushCompletionBlock)(NSDictionary *tokenDic);
@property (nonatomic, strong) UIViewController *tokenPushVC;
//- (UIViewController *)getRootWindowsViewController;
@property (nonatomic, assign) BOOL isFromSDK;//是否从SDK唤起
@property (nonatomic, assign) BOOL isMainSDK;//是否旧SDK，yes是新的，no是旧的
@property (nonatomic, assign) BOOL hasUpdate;//是否有更新
@property (nonatomic,assign) BOOL launchWithAuth;//程序第一次或者进入后台的时候有没有设置手势指纹
@property (nonatomic,assign) long loginExpired;
- (void)restUIForApp;
@end

