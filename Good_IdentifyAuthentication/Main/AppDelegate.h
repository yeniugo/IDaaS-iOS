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

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
//@property (assign, nonatomic) BOOL fromThirdAwake;//是否从第三方唤起app,默认值为NO
@property (nonatomic, copy) NSString *soureSchme;
//@property (assign, nonatomic) BOOL isFirstLogin;//是否为第一次登陆,默认值为NO
@property (assign, nonatomic) int thirdAwakeTokenStatus;//第三方唤起状态（token调用）
@property (assign, nonatomic) BOOL isNeedPush;//登录控制界面是否需要push
@property (nonatomic, copy) NSString *appid;//第三方应用appid
@property (nonatomic, copy) NSString *token;//第三方应用token
@property (nonatomic, copy) NSString *apid;//第三方应用UUID
@property (nonatomic, assign) BOOL isFirstStart;
@property (nonatomic, copy) NSString *urlstr;//授权后跳转的网址
//移动认证
@property (nonatomic, copy) void (^appCompletionBlock)(NSDictionary *tokenDic);
@property (nonatomic, strong) UIViewController *appPushVC;

//推送
@property (nonatomic, copy) void (^pushCompletionBlock)(NSDictionary *tokenDic);
@property (nonatomic, strong) UIViewController *tokenPushVC;
//- (UIViewController *)getRootWindowsViewController;
- (void)useTokenFromWeb;
- (void)checkUpdataWithPlist;
@end

