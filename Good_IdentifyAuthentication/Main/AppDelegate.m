//
//  AppDelegate.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/25.
//  Copyright © 2017年 zyc. All rights reserved.
//

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "TRUNewFeatuerViewController.h"
#import "AppDelegate.h"
#import "AppDelegate+AppDelegate_Xindun.h"
#import "TRUBaseTabBarController.h"
#import "TRUBaseNavigationController.h"
#import "TRUVersionUtil.h"
#import "TRUStartupViewController.h"
#import "TRULoginViewController.h"
#import "iflyMSC/iFlySetting.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "TRUVoiceConst.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "JPUSHService.h"
#import "TRUFingerGesUtil.h"
#import "TRUEnterAPPAuthView.h"
#import <Bugly/Bugly.h>
#import "AFNetworking.h"
#import "TRUAddPersonalInfoViewController.h"
#import "IQKeyboardManager.h"
#import "TRUAPPLogIdentifyController.h"
//#import "TRUAdViewController.h"
@interface AppDelegate ()
@property (nonatomic, copy) NSString *soureSchme;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[HAMLogOutputWindow sharedInstance] setHidden:YES];
//    [HAMLogOutputWindow printLog:@"app start"];
    [self creatShortcutItem];
    //注册JPush
#if TARGET_IPHONE_SIMULATOR
    [self initJPush:launchOptions];
#endif
    //init（xindun）
    [self initXdSDK];
    //初始化MSC
    [self initMSC];
    //初始化Bugly
    [self initBugly];
    
    //检查版本更新
//    [self checkVersion];
//    [self checkNewVersion];
    [self checkUpdataWithPlist];
    
    [xindunsdk getDeviceInfo];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self configRootBaseVCForApplication:application WithOptions:launchOptions];
    
    
    CGFloat sysversion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (sysversion >= 9.0){
        UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
        if (shortcutItem) {
            if ([shortcutItem.type isEqualToString:@"com.trusfort.cims.qrcode"]) {
                //扫一扫
                [self openQrCodeScanVC];
            }
            return NO;
        }
    }
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = NO; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    //keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    //keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    
    keyboardManager.shouldShowTextFieldPlaceholder = YES; // 是否显示占位文字
    
    //keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    
    return YES;
}
- (void)initBugly{
    [Bugly startWithAppId:@"70711601ce"];
}
- (void)creatShortcutItem{
    CGFloat sysversion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (sysversion < 9.0) return;
    //创建系统风格的icon
    UIApplicationShortcutIcon *qrIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"qriconp"];
    
    //创建快捷选项
    UIApplicationShortcutItem *qrItem = [[UIApplicationShortcutItem alloc]initWithType:@"com.trusfort.cims.qrcode" localizedTitle:@"扫一扫" localizedSubtitle:@"" icon:qrIcon userInfo:nil];
    
    //添加到快捷选项数组
    [UIApplication sharedApplication].shortcutItems = @[qrItem];
}

- (void) initMSC {
    //设置log等级，此处log为默认在documents目录下的msc.log文件
    [IFlySetting setLogFile:LVL_ALL];
    //输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",MSC_APP_ID];
    [IFlySpeechUtility createUtility:initString];
}

#pragma mark - 页面跳转逻辑
- (void)configRootBaseVCForApplication:(UIApplication *)application WithOptions:(NSDictionary *)launchOptions{
    
    NSDictionary *userInfo  = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    __weak typeof(self) weakSelf = self;
    BOOL isNewFeature = [TRUVersionUtil isFirstLauch];
    __block UIViewController *rootVC;
    isNewFeature = NO;
    //BOOL verification = [[TRUUserAPI getUser] verification];
    if (isNewFeature) {//有新版本
        
        rootVC = [[TRUNewFeatuerViewController alloc] init];
        
    }else{//无新版本
        
        TRUStartupViewController *startVC = [[TRUStartupViewController alloc] init];
        startVC.completionBlock = ^(TRUUserModel *userModel) {
            if (userModel && userModel.userId.length > 0) {
                
                if ([TRUFingerGesUtil getLoginAuthGesType]==TRULoginAuthGesTypeNone&&[TRUFingerGesUtil getLoginAuthFingerType]==TRULoginAuthFingerTypeNone){
                    TRULoginViewController *loginVC = [[TRULoginViewController alloc] init];
                    
                    rootVC = [[TRUBaseNavigationController alloc] initWithRootViewController:loginVC];
                }else if([self checkPersonInfoVC:userModel]) {//yes 表示需要完善信息
                    TRUAddPersonalInfoViewController *infoVC = [[TRUAddPersonalInfoViewController alloc] init];
                    if (userModel.phone.length >0) {
                        infoVC.phone = userModel.phone;
                    }else if (userModel.email.length >0){
                        infoVC.email = userModel.email;
                    }else{
                        infoVC.employeenum = userModel.employeenum;//员工号
                    }
                    infoVC.isStart = YES;
                    rootVC = [[TRUBaseNavigationController alloc] initWithRootViewController:infoVC];
                }else{
                    TRUBaseTabBarController *vc = [[TRUBaseTabBarController alloc] init];
                    vc.isAddUserInfo = NO;
                    rootVC =vc;
                }
            }else{
                TRULoginViewController *loginVC = [[TRULoginViewController alloc] init];
                
                rootVC = [[TRUBaseNavigationController alloc] initWithRootViewController:loginVC];
            }
            weakSelf.window.rootViewController = rootVC;
          
            if (userInfo) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf application:application didReceiveRemoteNotification:userInfo];
                });
                
            }
        };
        rootVC = startVC;
    }
    
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
}
- (void)initJPush:(NSDictionary *)launchOptions{
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:nil];
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
#if DEBUG
    // [[FLEXManager sharedManager] showExplorer];
#else
    [JPUSHService setLogOFF];
#endif
    //2.1.9版本新增获取registration id block接口。
#if TARGET_IPHONE_SIMULATOR
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    [stdDefaults setObject:@"" forKey:@"TRUPUSHID"];
    [stdDefaults synchronize];
#else
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
            [stdDefaults setObject:registrationID forKey:@"TRUPUSHID"];
            [stdDefaults synchronize];
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
#endif
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}
#pragma mark - 推送相关
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
    
    
}
//如果是10以下版本

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
    NSString *userId = [TRUUserAPI getUser].userId;
    NSLog(@"%s, UserID : %@", __func__ ,userId);
    if (userId && userInfo) {
        [self popAuthVCWithUserInfo:userInfo];
    }
    
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo 
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    NSString *userId = [TRUUserAPI getUser].userId;
    NSLog(@"%s, UserID : %@", __func__ ,userId);
    if (userInfo && userId) {
        [self popAuthVCWithUserInfo:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    }else{
        completionHandler(UIBackgroundFetchResultNoData);
    }
    
    
    
    
}
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        NSString *userId = [TRUUserAPI getUser].userId;
        if (userId) {
            if (userId) {
                [self popAuthVCWithUserInfo:userInfo];
            }
        }
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    //    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionSound);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        NSString *userId = [TRUUserAPI getUser].userId;
        if (userId) {
            [self popAuthVCWithUserInfo:userInfo];
        }
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}

#pragma mark 修改根控制器 私有方法
- (void)changeRootVCForLogin{
    self.window.rootViewController = nil;
    //只要跳转到激活页面，就把手势/指纹清空
//    [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
    [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
    [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
    TRULoginViewController *loginVC = [[TRULoginViewController alloc] init];
    self.window.rootViewController = [[TRUBaseNavigationController alloc] initWithRootViewController:loginVC];
}
- (void)changeRootVC{
    //    [TRUTimeSyncUtil syncTimeWithResult:nil];
    
    self.window.rootViewController = nil;
    TRUBaseTabBarController *tabvc = [[TRUBaseTabBarController alloc] init];
    tabvc.isAddUserInfo = YES;
    self.window.rootViewController = tabvc;
}
- (void)changeAvtiveRootVC{
    self.window.rootViewController = nil;
    TRUBaseTabBarController *tabvc = [[TRUBaseTabBarController alloc] init];
    tabvc.isAddUserInfo = YES;
    self.window.rootViewController = tabvc;
}

- (void)changeLoginRootVC{
    self.window.rootViewController = nil;
    TRUAPPLogIdentifyController *loginvc = [[TRUAPPLogIdentifyController alloc] init];
    loginvc.isFirstRegist = YES;
    TRUBaseNavigationController *navc = [[TRUBaseNavigationController alloc] initWithRootViewController:loginvc];
    self.window.rootViewController = navc;
}

- (void)changRestDataVC{
    [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
    [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
    self.window.rootViewController = nil;
    TRULoginViewController *loginvc = [[TRULoginViewController alloc] init];
    TRUBaseNavigationController *navc = [[TRUBaseNavigationController alloc] initWithRootViewController:loginvc];
    self.window.rootViewController = navc;
    
}

#pragma mark 返回原APP
- (void)back2SoureAPP{
    NSString *urlstr = [self.soureSchme stringByAppendingString:@"://"];
    NSURL *url = [NSURL URLWithString:urlstr];
    [[UIApplication sharedApplication] openURL:url options:@{@"key1":@"hahaha"} completionHandler:^(BOOL success) {
          
    }];
    
}
#pragma mark 处理APP拉起
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    
    NSArray *queryArr = [url.query componentsSeparatedByString:@"&"];
    self.soureSchme = [[queryArr.firstObject componentsSeparatedByString:@"="] lastObject];
    NSString *tokenStr = [[[queryArr lastObject] componentsSeparatedByString:@"="] lastObject];
    
    NSString *userid = [TRUUserAPI getUser].userId;

    if (userid && [xindunsdk isUserInitialized:userid]) {
        
        if (!tokenStr) {
            tokenStr = @"";
        }
        NSDictionary *dic = @{@"token" : tokenStr};
        
        [self popAuthVCWithUserInfo:dic];
    }else{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
                [self showWakeUPErrorInfo:tokenStr];
            });
        });
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    NSArray *queryArr = [url.query componentsSeparatedByString:@"&"];
    self.soureSchme = [[queryArr.firstObject componentsSeparatedByString:@"="] lastObject];
    NSString *tokenStr = [[[queryArr lastObject] componentsSeparatedByString:@"="] lastObject];
    NSString *userid = [TRUUserAPI getUser].userId;
    if (userid && [xindunsdk isUserInitialized:userid]){
        if (!tokenStr) {
            tokenStr = @"";
        }
        NSDictionary *dic = @{@"token" : tokenStr};
        [self popAuthVCWithUserInfo:dic];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showWakeUPErrorInfo:tokenStr];
            });
        });
    }
    return YES;
}

#pragma mark 显示拉APP未激活信息
- (void)showWakeUPErrorInfo:(NSString *)token{
    UIAlertController *errorVC = [UIAlertController alertControllerWithTitle:@"" message:@"该终端还未激活，无法完成认证操作，请返回原APP或自注册激活" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"自注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //保存token
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"WAKEUPTOKENKEY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
    UIAlertAction *back = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *urlstr = [self.soureSchme stringByAppendingString:@"://"];
        NSURL *url = [NSURL URLWithString:urlstr];
        [[UIApplication sharedApplication] openURL:url options:@{@"key1":@"hahaha"} completionHandler:^(BOOL success) {
            NSLog(@"%d",success);
        }];
    }];
    [errorVC addAction:back];
    [errorVC addAction:confirm];
    UIViewController *rootVC = self.window.rootViewController;
    if (rootVC.presentedViewController) {
        [rootVC.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [rootVC presentViewController:errorVC animated:YES completion:nil];
        }];
    }else{
        [rootVC presentViewController:errorVC animated:YES completion:nil];
    }
    
    
    
}

#pragma mark 推送
- (void)popAuthVCWithUserInfo:(NSDictionary *)userInfo{
    [self initXdSDK];
    NSString *token = userInfo[@"token"];
    UIViewController *rootVC = self.window.rootViewController;
    if ([rootVC isKindOfClass:[TRUBaseTabBarController class]]) {
        TRUBaseTabBarController *tabVC = (TRUBaseTabBarController *)rootVC;
        [tabVC showAuthVCWithToken:token];
    }
    
}
#pragma mark 3D Touch 回调
//如果APP没被杀死，还存在后台，点开Touch会调用该代理方法
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if (shortcutItem) {
        //判断设置的快捷选项标签唯一标识，根据不同标识执行不同操作
        if([shortcutItem.type isEqualToString:@"com.trusfort.cims.qrcode"]){
            //扫一扫
            [self openQrCodeScanVC];
        }
        
    }
    
    if (completionHandler) {
        completionHandler(YES);
    }
}
#pragma mark 3D Touch 扫一扫
- (void)openQrCodeScanVC{
    
    
    NSString *userid = [TRUUserAPI getUser].userId;
    if (userid == nil || userid.length == 0) return;
    
    //scanQRButtonClick
    Boolean flag = [xindunsdk isUserInitialized:userid];
//    [xindunsdk isUserActivitated:userid];
    UIViewController *rootVC = self.window.rootViewController;
    if (flag == true) {
        //用户已激活
        if ([rootVC isKindOfClass:[TRUBaseTabBarController class]]) {
            TRUBaseTabBarController *tabVC = (TRUBaseTabBarController *)rootVC;
            if ([tabVC respondsToSelector:@selector(scanQRButtonClick)]) {
                [tabVC performSelector:@selector(scanQRButtonClick) withObject:nil];
            }
        }
    }else{
        //用户未激活
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnterForegroundDyPw" object:nil];
    YCLog(@"test1--------------");
    [HAMLogOutputWindow printLog:@"test1--------------"];
    NSString *userid = [TRUUserAPI getUser].userId;
    YCLog(@"test2--------------");
    [HAMLogOutputWindow printLog:@"test2--------------"];
    if (userid && [xindunsdk isUserInitialized:userid] == true) {
        YCLog(@"test3--------------");
    
        if ([TRUFingerGesUtil getLoginAuthGesType] != TRULoginAuthGesTypeNone || [TRUFingerGesUtil getLoginAuthFingerType] != TRULoginAuthFingerTypeNone) {
            YCLog(@"test4--------------");
            [TRUEnterAPPAuthView showAuthView];
            YCLog(@"test5--------------");
        }
    }
} 

-(void)alertWithStr:(NSString *)alertstr{
    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"" message:alertstr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confrimAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self changeRootVCForLogin];
    }];
    [alertVC addAction:confrimAction];
    [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - 版本更新
-(void)checkVersion{
    // 获取发布版本的version
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/javascript",nil];
    //http://itunes.apple.com/lookup?id=1095195364
    //https://itunes.apple.com/cn/app/芯盾认证/id1195763218?mt=8
    NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=1195763218"];
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = responseObject[@"results"];
        if ([array count] > 0) {
            NSDictionary *dic = array[0];
            NSString *appStoreVersion = dic[@"version"];
            //打印版本号
            [self checkAppUpdate:appStoreVersion];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YCLog(@"获取版本号失败！");
    }];
}

-(void)checkAppUpdate:(NSString *)appInfo{
    //版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

//    YCLog(@"商店版本：%@ ,当前版本:%@",appInfo,version);
    if ([self updeWithDicString:version andOldString:appInfo]) {
        
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"新版本 %@ 已发布!",appInfo] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confrimAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *url = @"https://itunes.apple.com/cn/app/id1195763218?mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }];
        
        UIAlertAction *cancelAction =  [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:confrimAction];
        ;
        [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
        
    }else{
        YCLog(@"不用更新");
    }
}
-(BOOL)updeWithDicString:(NSString *)version andOldString:(NSString *)appVersion{
    
    NSArray *a1 = [version componentsSeparatedByString:@"."];
    NSArray *a2 = [appVersion componentsSeparatedByString:@"."];
    
    for (int i = 0; i < [a1 count]; i++) {
        if ([a2 count] > i) {
            if ([[a1 objectAtIndex:i] intValue] < [[a2 objectAtIndex:i] intValue]) {
                return YES;
            }
            else if ([[a1 objectAtIndex:i] intValue] > [[a2 objectAtIndex:i] intValue])
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    return [a1 count] < [a2 count];
}
- (BOOL)checkPersonInfoVC:(TRUUserModel *)model{
    
    if (model.phone.length>0 || model.email.length>0) {
        return NO;
    }else{
        return YES;
    }
}

- (void)checkNewVersion{
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/javascript",nil];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *updateUrl = [NSString stringWithFormat:@"%@/ios/cims.html",baseUrl];
    [manager GET:updateUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YCLog(@"update = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *bundle_version = responseObject[@"bundle_version"];
            BOOL force_update = [responseObject[@"force_update"] boolValue];
            NSString *url = responseObject[@"url"];
            [weakSelf checkNewAppUpdate:bundle_version updateURL:url withFouce:force_update];
        }
//        NSString *bundleidStr = [weakSelf getPlistVersionWithPlist:responseObject];
//        NSString *updateStr = [weakSelf getPlistFouceWithPlist:responseObject];
//        if (updateStr.length) {
//            if ([updateStr isEqualToString:@"1"]) {
//                [weakSelf checkNewAppUpdate:bundleidStr withFouce:YES];
//            }else{
//                [weakSelf checkNewAppUpdate:bundleidStr withFouce:NO];
//            }
//        }else{
//            [weakSelf checkNewAppUpdate:bundleidStr withFouce:NO];
//        }
//        YCLog(@"bundleidStr = %@",bundleidStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            YCLog(@"error");
    }];
//    if(@available(iOS 10.0,*)){
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services:///?action=download-manifest&url=https://www.quketing.com/plist/idass1.plist"] options:nil completionHandler:^(BOOL success) {
//
//        }];
//    }else{
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services:///?action=download-manifest&url=https://www.quketing.com/plist/idass1.plist"]];
//    }
}

- (void)checkUpdataWithPlist{
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/javascript",nil];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *updateUrl = [NSString stringWithFormat:@"%@/ios/cims.html",baseUrl];
    [manager GET:updateUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *url = responseObject[@"url"];
            if (url.length) {
                if ([url hasPrefix:@"https://"]) {
                    [weakSelf getPlistWithURL:url];
                }else{
                    url = [NSString stringWithFormat:@"%@%@",baseUrl,url];
                    [weakSelf getPlistWithURL:url];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YCLog(@"error");
    }];
}

- (void)getPlistWithURL:(NSString *)url{
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *bundleidStr = [weakSelf getPlistVersionWithPlist:responseObject];
        NSString *updateStr = [weakSelf getPlistFouceWithPlist:responseObject];
        if (updateStr.length) {
            if ([updateStr isEqualToString:@"1"]) {
                [weakSelf checkNewAppUpdate:bundleidStr updateURL:url withFouce:YES];
            }else{
                [weakSelf checkNewAppUpdate:bundleidStr updateURL:url withFouce:NO];
            }
        }else{
            [weakSelf checkNewAppUpdate:bundleidStr updateURL:url withFouce:NO];
        }
        YCLog(@"bundleidStr = %@",bundleidStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YCLog(@"error");
    }];
}

- (NSString *)getPlistVersionWithPlist:(id)plist{
//    NSMutableDictionary *dataDictionary;
    if ([plist isKindOfClass:[NSData class]]) {
        NSMutableDictionary *result = [NSPropertyListSerialization propertyListWithData:plist options:0 format:NULL error:NULL];
        NSArray *array = result[@"items"];
        NSMutableDictionary *messageDic = [array firstObject];
        NSMutableDictionary *metadata = messageDic[@"metadata"];
        return metadata[@"bundle-version"];
    }
    return nil;
    //    NSArray *array = dataDictionary[@"items"];
    //    NSMutableDictionary *messageDic = [array firstObject];
    //    NSMutableDictionary *metadata = messageDic[@"metadata"];
    //    return metadata[@"bundle-version"];
}

- (NSString *)getPlistFouceWithPlist:(id)plist{
    if ([plist isKindOfClass:[NSData class]]) {
        NSMutableDictionary *result = [NSPropertyListSerialization propertyListWithData:plist options:0 format:NULL error:NULL];
        NSArray *array = result[@"items"];
        NSMutableDictionary *messageDic = [array firstObject];
        NSMutableDictionary *metadata = messageDic[@"metadata"];
        return metadata[@"Forced-update"];
    }
    return nil;
}

-(void)checkNewAppUpdate:(NSString *)appInfo updateURL:(NSString *)updateURL withFouce:(BOOL)fouce{
    //版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    CGFloat dispatchTime;
    if ([self.window.rootViewController isKindOfClass: [TRUBaseTabBarController class]]) {
//        [HAMLogOutputWindow printLog:@"2.1s"];
        dispatchTime = 0.1;
    }else{
        dispatchTime = 2.1;
    }
    //    YCLog(@"商店版本：%@ ,当前版本:%@",appInfo,version);
    if ([self updeWithDicString:version andOldString:appInfo]) {
        if (fouce) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"新版本 %@ 已发布!",appInfo] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confrimAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                NSString *url = @"itms-services:///?action=download-manifest&url=https://www.quketing.com/plist/idass.plist";
                NSString *url = [NSString stringWithFormat:@"itms-services:///?action=download-manifest&url=%@",updateURL];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
//                });
            }];
            
            //            UIAlertAction *cancelAction =  [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
            //            }];
            //            [alertVC addAction:cancelAction];
            [alertVC addAction:confrimAction];//
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dispatchTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
            });
        }else{
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"新版本 %@ 已发布!",appInfo] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confrimAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *url = [NSString stringWithFormat:@"itms-services:///?action=download-manifest&url=%@",updateURL];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }];
            
            UIAlertAction *cancelAction =  [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:cancelAction];
            [alertVC addAction:confrimAction];//
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dispatchTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
            });
            
        }
    }else{
        YCLog(@"不用更新");
    }
}

@end
