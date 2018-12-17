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
@property (nonatomic, copy) void (^tokenCompletionBlock)(NSDictionary *tokenDic);
//- (UIViewController *)getRootWindowsViewController;
@end

