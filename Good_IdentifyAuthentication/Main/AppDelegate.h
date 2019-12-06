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
static BOOL isProduction = NO;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
//@property (assign, nonatomic) BOOL fromThirdAwake;//是否从第三方唤起app,默认值为NO
@property (nonatomic, copy) NSString *soureSchme;
@property (nonatomic, copy) NSString *fullSoureSchme;//完整的scheme
//@property (assign, nonatomic) BOOL isFirstLogin;//是否为第一次登陆,默认值为NO
@property (assign, nonatomic) int thirdAwakeTokenStatus;//第三方唤起状态（token调用）
@property (assign, nonatomic) BOOL isNeedPush;//登录控制界面是否需要push
@property (nonatomic, copy) NSString *appid;//应用appid
@property (nonatomic, copy) NSString *apid;//应用appid
@property (nonatomic, assign) BOOL isFromSDK;//是否从SDK唤起
@property (nonatomic, assign) BOOL isMainSDK;//是否旧SDK，yes是新的，no是旧的
@property (nonatomic, copy) void (^tokenCompletionBlock)(NSDictionary *tokenDic);
@property (nonatomic, copy) void (^appCompletionBlock)(NSDictionary *tokenDic);
@property (nonatomic, strong) UIViewController *appPushVC;
@property (nonatomic, copy) NSString *phone;//蓝证带过来的手机号
@property (nonatomic, copy) NSString *token;//蓝证token
@property (assign, nonatomic) BOOL isFirstLauch;//是否第一次启动
@end

