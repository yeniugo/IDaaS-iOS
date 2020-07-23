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
#import "gesAndFingerNVController.h"

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

#import "TRUBingUserController.h"

#import "TRUCompanyAPI.h"
#import <YYWebImage.h>
#import "TRUAdViewController.h"
#import "TRUPushViewController.h"
#import "TRUPushingViewController.h"
#import "TRUMacros.h"
#import "TRUhttpManager.h"
#import "TRUSchemeTokenViewController.h"
#import "TRUAuthenticateViewController.h"
#import "TRUTimeSyncUtil.h"
#import "TRUAllInOneAuthViewController.h"
#import "TRUAPPLogIdentifyController.h"
@interface AppDelegate ()<JPUSHRegisterDelegate>
//@property (nonatomic, copy) NSString *soureSchme;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *RemoteTokenStr;//远程token字符串
@property (nonatomic, copy) NSDictionary *launchOptions;
@property (nonatomic,assign) UIBackgroundTaskIdentifier backIden;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.rootViewController = [[TRUPushingViewController alloc] init];
//    [self.window makeKeyAndVisible];
//    return YES;
    self.launchOptions = launchOptions;
    return [self application:application initWithOptions:launchOptions];
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    TRUAllInOneAuthViewController *advc = [[TRUAllInOneAuthViewController alloc] init];
//    self.window.rootViewController = advc;
//    [self.window makeKeyAndVisible];
//    return YES;
}

- (BOOL)application:(UIApplication *)application initWithOptions:(NSDictionary *)launchOptions{
    [DDLog addLogger:[DDOSLogger sharedInstance]];
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    DDLogFileManagerDefault *logFileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:documentsDirectory];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
    fileLogger.rollingFrequency = 60 * 60 * 24;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    
    [self creatShortcutItem];
    //注册JPush
    [self initJPush:launchOptions];
    //init（xindun）
    [self initXdSDK];
    self.isFirstStart = YES;
    
//    for (int i = 0; i < 10000; i++) {
//        @autoreleasepool{
//            NSString *userId = [TRUUserAPI getUser].userId;
//            [xindunsdk getCIMSDynamicCode:userId];
////            for (int j = 0; j < 10000; j++) {
////                [TRUTimeSyncUtil syncTimeWithResult:^(int error) {
////
////                }];
////            }
//        }
//    }
//    [[HAMLogOutputWindow sharedInstance] setHidden:NO];
//    [HAMLogOutputWindow printLog:@"didFinishLaunchingWithOptions"];
//    NSString *isss = [xindunsdk getDeviceId];
//    [HAMLogOutputWindow printLog:isss];
//    NSDictionary *dic = [xindunsdk getDeviceInfo];
//    YCLog(@"dic = ");
    //初始化MSC
    [self initMSC];
    //初始化Bugly
    [self initBugly];
    //更新公司信息
//    [self requestSPinfo];
    //检查版本更新
    [self checkVersion];
//    [self checkNewVersion];
//    [self checkNewVersion];
//    [self checkUpdataWithPlist];
    //    [xindunsdk getDeviceInfo];
    //广告页
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    TRUAdViewController *advc = [[TRUAdViewController alloc] init];
    self.window.rootViewController = advc;
    [self.window makeKeyAndVisible];
    NSString *imgUrlStr = [TRUCompanyAPI getCompany].start_up_img_url;
    YCLog(@"imgUrlStr = %@",imgUrlStr);
    //    UIImageView *launchImageView = [[UIImageView alloc] initWithFrame:self.window.bounds];
    //    [launchImageView yy_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholder:nil];
    //    [self.window addSubview:launchImageView];
    //    [self.window bringSubviewToFront:launchImageView];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.thirdAwakeTokenStatus) {
            
        }else{
            //            [HAMLogOutputWindow printLog:@"configRootBaseVCForApplication3"];
            [strongSelf configRootBaseVCForApplication:application WithOptions:launchOptions];
        }
    });
    [HAMLogOutputWindow printLog:[[NSUserDefaults standardUserDefaults] objectForKey:@"TRUPUSHID"]];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"OAuthVerify"];
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

- (void)restUIForApp{
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    TRUAdViewController *advc = [[TRUAdViewController alloc] init];
    self.window.rootViewController = advc;
    [self.window makeKeyAndVisible];
    NSString *imgUrlStr = [TRUCompanyAPI getCompany].start_up_img_url;
//    [TRUEnterAPPAuthView lockView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.thirdAwakeTokenStatus) {
            [TRUEnterAPPAuthView unlockView];
        }else{
            //            [HAMLogOutputWindow printLog:@"configRootBaseVCForApplication3"];
            [self configRootBaseVCForApplication:nil WithOptions:nil];
            
        }
       
    });
}

#pragma mark - 页面跳转逻辑
- (void)configRootBaseVCForApplication:(UIApplication *)application WithOptions:(NSDictionary *)launchOptions{
    
    NSDictionary *userInfo  = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    
    BOOL isNewFeature = [TRUVersionUtil isFirstLauch];
    __block UIViewController *rootVC;
    isNewFeature = NO;
    if (isNewFeature) {//有新版本
        rootVC = [[TRUNewFeatuerViewController alloc] init];
    }else{//无新版本
        TRUStartupViewController *startVC = [[TRUStartupViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        startVC.completionBlock = ^(TRUUserModel *userModel) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (userModel && userModel.userId.length > 0) {
                if (0) {//yes 表示需要完善信息
                    TRUAddPersonalInfoViewController *infoVC = [[TRUAddPersonalInfoViewController alloc] init];
                    if (userModel.phone.length >0) {
                        infoVC.phone = userModel.phone;
                    }else if (userModel.email.length >0){
                        infoVC.email = userModel.email;
                    }else{
                        infoVC.employeenum = userModel.employeenum;//员工号
                    }
                    
                    infoVC.isStart = YES;
                    rootVC = [[gesAndFingerNVController alloc] initWithRootViewController:infoVC];
                }else{
//                    rootVC = [[TRUBaseTabBarController alloc] init];
                    UIViewController *vc1 = [[TRUAllInOneAuthViewController alloc] init];
                    TRUBaseNavigationController *baseNav = [[TRUBaseNavigationController alloc] initWithRootViewController:vc1];
                    if([TRUFingerGesUtil getLoginAuthGesType] == TRULoginAuthGesTypeNone && [TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeNone){
                        strongSelf.launchWithAuth = YES;
//                        baseNav = [[TRUBaseNavigationController alloc] initWithRootViewController:[[TRUAPPLogIdentifyController alloc] init]];
                        UIViewController *vc2 = [[TRUAPPLogIdentifyController alloc] init];
                        baseNav.viewControllers = @[vc1,vc2];
                    }
//                    baseNav.navigationBarHidden = YES;
                    rootVC = baseNav;
//                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[TRUBaseTabBarController alloc] init]];
//                    nav.navigationBarHidden = YES;
//                    rootVC = nav;
                }
            }else{
                TRULoginViewController *loginVC = [[TRULoginViewController alloc] init];
                
                rootVC = [[TRUBaseNavigationController alloc] initWithRootViewController:loginVC];
            }
            strongSelf.window.rootViewController = rootVC;
            
            if (userInfo) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    if(@available(iOS 10.0,*)){
//
//                    }
                    [strongSelf application:application didReceiveRemoteNotification:userInfo];
//                    [weakSelf application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {
                    
//                    }];
                });
            }
        };
        rootVC = [[TRUBaseNavigationController alloc] initWithRootViewController:startVC];
    }
    
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
}
- (void)openApplication:(UIApplication *)application WithOptions:(NSDictionary *)launchOptions{
    NSDictionary *userInfo  = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    UIViewController *rootVC;
    TRUUserModel *userModel = [TRUUserAPI getUser];
    if (userModel && userModel.userId.length > 0) {
        if (0) {//yes 表示需要完善信息
            TRUAddPersonalInfoViewController *infoVC = [[TRUAddPersonalInfoViewController alloc] init];
            if (userModel.phone.length >0) {
                infoVC.phone = userModel.phone;
            }else if (userModel.email.length >0){
                infoVC.email = userModel.email;
            }else{
                infoVC.employeenum = userModel.employeenum;//员工号
            }
            
            infoVC.isStart = YES;
            rootVC = [[gesAndFingerNVController alloc] initWithRootViewController:infoVC];
        }else{
            //                    rootVC = [[TRUBaseTabBarController alloc] init];
            //            [HAMLogOutputWindow printLog:@"TRUBaseTabBarController1"];
            TRUBaseNavigationController *baseNav = [[TRUBaseNavigationController alloc] initWithRootViewController:[[TRUAllInOneAuthViewController alloc] init]];
            baseNav.navigationBarHidden = YES;
            rootVC = baseNav;
            //                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[TRUBaseTabBarController alloc] init]];
            //                    nav.navigationBarHidden = YES;
            //                    rootVC = nav;
        }
    }else{
        TRULoginViewController *loginVC = [[TRULoginViewController alloc] init];
        
        rootVC = [[TRUBaseNavigationController alloc] initWithRootViewController:loginVC];
    }
    self.window.rootViewController = rootVC;
    
    if (userInfo) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                    if(@available(iOS 10.0,*)){
            //
            //                    }
            [self application:application didReceiveRemoteNotification:userInfo];
            //                    [weakSelf application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {
            
            //                    }];
        });
    }
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
}
- (void)initJPush:(NSDictionary *)launchOptions{
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
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
            YCLog(@"registrationID获取成功：%@",registrationID);
            NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
            NSString *pushid = [stdDefaults objectForKey:@"TRUPUSHID"];
            if ([pushid isEqualToString:@"1234567890"]) {
                //走同步信息接口
                NSString *userid = [TRUUserAPI getUser].userId;
                if (userid) {
//                    [xindunsdk requestCIMSUserInfoSyncForUser:userid phone:nil authCode:nil pushid:registrationID onResult:^(int error, id response) {
//                        if (error ==0) {
//                            //同步pushid成功-更新存储的pushid
//                            [stdDefaults setObject:registrationID forKey:@"TRUPUSHID"];
//                            [stdDefaults synchronize];
//                        }else{
//                            //失败了，依然维持原先的固定值
//                            [stdDefaults setObject:@"1234567890" forKey:@"TRUPUSHID"];
//                            [stdDefaults synchronize];
//                        }
//                    }];

                }
            }else{
                [stdDefaults setObject:registrationID forKey:@"TRUPUSHID"];
                [stdDefaults synchronize];
            }
        }
        else{
            YCLog(@"registrationID获取失败，code：%d",resCode);
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
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    YCLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    YCLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
    
}
//如果是10以下版本
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [JPUSHService handleRemoteNotification:userInfo];
    YCLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
    NSString *userId = [TRUUserAPI getUser].userId;
    YCLog(@"%s, UserID : %@", __func__ ,userId);
    if (userId && userInfo) {
        [self popAuthVCWithUserInfo:userInfo];
    }
}


- (void)application:(UIApplication *)applicationdidReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    YCLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    NSString *userId = [TRUUserAPI getUser].userId;
    YCLog(@"%s, UserID : %@", __func__ ,userId);
    if (userInfo && userId) {
        [self popAuthVCWithUserInfo:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    }else{
        completionHandler(UIBackgroundFetchResultNoData);
    }
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    [JPUSHService setBadge:0];
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
        YCLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        NSString *userId = [TRUUserAPI getUser].userId;
        if (userId) {
            if (userId) {
                [self popAuthVCWithUserInfo:userInfo];
            }
        }
    }
    else {
        // 判断为本地通知
        YCLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    //    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionSound);
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    [JPUSHService setBadge:0];
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
        YCLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        NSString *userId = [TRUUserAPI getUser].userId;
        if (userId) {
            [self popAuthVCWithUserInfo:userInfo];
        }
    }
    else {
        // 判断为本地通知
        YCLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}

#pragma mark 修改根控制器 私有方法
- (void)changeRootVCForLogin{
    self.window.rootViewController = nil;
    //只要跳转到激活页面，就把手势/指纹清空
    [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
    [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
    TRULoginViewController *loginVC = [[TRULoginViewController alloc] init];
    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:loginVC];
    [nav setNavBarColor:DefaultNavColor];
//    [TRUhttpManager startALLHttp];
    self.window.rootViewController = nav;
}
- (void)changeRootVC{
    //    [TRUTimeSyncUtil syncTimeWithResult:nil];
    
    self.window.rootViewController = nil;
//    TRUAllInOneAuthViewController *tabvc = [[TRUAllInOneAuthViewController alloc] init];
//    tabvc.isAddUserInfo = NO;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: tabvc];
//    nav.navigationBarHidden = YES;
//    self.window.rootViewController = tabvc;
//    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:tabvc];
    UIViewController *vc1 = [[TRUAllInOneAuthViewController alloc] init];
    TRUBaseNavigationController *baseNav = [[TRUBaseNavigationController alloc] initWithRootViewController:vc1];
    if([TRUFingerGesUtil getLoginAuthGesType] == TRULoginAuthGesTypeNone && [TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeNone){
        self.launchWithAuth = YES;
        //                        baseNav = [[TRUBaseNavigationController alloc] initWithRootViewController:[[TRUAPPLogIdentifyController alloc] init]];
        UIViewController *vc2 = [[TRUAPPLogIdentifyController alloc] init];
        baseNav.viewControllers = @[vc1,vc2];
    }
//    nav.navigationBarHidden = YES;
    self.window.rootViewController = baseNav;
}
- (void)changeRootVCWithInfo{
    //    [TRUTimeSyncUtil syncTimeWithResult:nil];
    
    self.window.rootViewController = nil;
    TRUAllInOneAuthViewController *tabvc = [[TRUAllInOneAuthViewController alloc] init];
//    tabvc.isAddUserInfo = YES;
    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:tabvc];
//    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;
//    self.window.rootViewController = tabvc;
}
- (void)changeAvtiveRootVC{
    //只要跳转到激活页面，就把手势/指纹清空
    [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
    [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
    TRULoginViewController *loginVC = [[TRULoginViewController alloc] init];
//    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:loginVC];
//    self.window.rootViewController = nav;
    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:loginVC];
    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;
//    [TRUhttpManager startALLHttp];
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
    YCLog(@"openURL");
    if(!@available(iOS 9.0,*)){
        return NO;
    }
    [self initXdSDK];
    NSString *str = [NSString stringWithFormat:@"%@",url.query];
    NSString *userid = [TRUUserAPI getUser].userId;
    if ([str containsString:@"&"]) {
        if ([url.host isEqualToString:@"auth"]){
            NSArray *queryArr = [str componentsSeparatedByString:@"&"];
            self.soureSchme = [[queryArr.firstObject componentsSeparatedByString:@"="] lastObject];
            NSString *tokenStr = [[[queryArr lastObject] componentsSeparatedByString:@"="] lastObject];
            NSString *type = [[[queryArr lastObject] componentsSeparatedByString:@"="] firstObject];
            if([url.host isEqualToString:@"auth"]){
                self.isMainSDK = YES;
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                NSArray *urlArray = [url.query componentsSeparatedByString:@"&"];
                if (urlArray.count==2) {
                    NSString *appid = [[urlArray[0] componentsSeparatedByString:@"="] lastObject];
                    self.appid = appid;
    //                [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"appid = %@",appid]];
                    NSString *type = [[urlArray[1] componentsSeparatedByString:@"="] lastObject];
                    self.isFromSDK = NO;
                    [self getAuthWithType:[type intValue]];
                    
                }
                if (urlArray.count==3) {
                    NSString *appid = [[urlArray[0] componentsSeparatedByString:@"="] lastObject];
                    self.appid = appid;
    //                [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"appid = %@",appid]];
                    NSString *type = [[urlArray[1] componentsSeparatedByString:@"="] lastObject];
                    self.soureSchme = [[urlArray[2] componentsSeparatedByString:@"="] lastObject];
                    self.isFromSDK = YES;
                    [self getAuthWithType:[type intValue]];
                    
                }
            }else if([type isEqualToString:@"type"]){//蓝信调用
                if([tokenStr isEqualToString:@"getLocalToken"]){
                    [self getTokenVC:1];
                }else if([tokenStr isEqualToString:@"getNetToken"]){
                    //self.fromThirdAwake = YES;
                    self.thirdAwakeTokenStatus = 2;
                    if (!userid || userid.length==0) {
                        //[self application:self initWithOptions:nil];
                        //[[UIApplication sharedApplication] openURL:@"trusfortcims://"];
                        //[self application:self initWithOptions:nil];
                        
                    }else{
                        NSString *userid = [TRUUserAPI getUser].userId;
                        if (!userid.length || ![xindunsdk isUserInitialized:userid]){
                            return NO;
                        }
                        if ([TRUFingerGesUtil getLoginAuthFingerType]==TRULoginAuthFingerTypeNone&&[TRUFingerGesUtil getLoginAuthGesType]==TRULoginAuthGesTypeNone) {
    //                        [self application:self initWithOptions:nil];
                            
                        }else{
                            [self getTokenVC:2];
    //                        [HAMLogOutputWindow printLog:@"getTokenVC 2"];
                        }
                    }
                }else if ([tokenStr isEqualToString:@"logout"]){
                    [self getTokenVC:3];
                }else if ([tokenStr isEqualToString:@"unBind"]){
                    [self getTokenVC:4];
                }
            }else{
                if (userid && [xindunsdk isUserInitialized:userid]) {
                    
                    if (!tokenStr) {
                        tokenStr = @"";
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:self.soureSchme forKey:@"WAKEUPSOURESCHME"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"OAuthVerify"];
                    [[NSUserDefaults standardUserDefaults] setObject:tokenStr forKey:@"WAKEUPTOKENKEY"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSDictionary *dic = @{@"token" : tokenStr};
                    
                    [self popAuthVCWithUserInfo:dic];
                    
                }else{
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showWakeUPErrorInfo:tokenStr];
                        });
                    });
                }
            }
        }else if([url.host isEqualToString:@"auth1"]){
            [self configRootBaseVCForApplication:[UIApplication sharedApplication] WithOptions:self.launchOptions];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSArray *urlArray = [url.query componentsSeparatedByString:@"&"];
            for (NSString *str in urlArray) {
                NSArray *tmp = [str componentsSeparatedByString:@"="];
                NSString *key = [tmp firstObject];
                NSArray *value = [tmp lastObject];
                if (key && value) {
                    dic[key] = value;
                }
            }
            NSString *scheme = dic[@"scheme"];
            NSString *type = dic[@"type"];
            NSString *appid = dic[@"appid"];
            NSString *apid = dic[@"apid"];
            NSString *phone = dic[@"phone"];
            if (scheme.length) {
                self.soureSchme = scheme;
            }
            if (appid.length) {
                self.appid = appid;
            }
            if (apid.length) {
                self.apid = apid;
            }
            NSString *schemeType;
            if ([type isEqualToString:@"auth1"]) {
                schemeType = @"11";
            }else if ([type isEqualToString:@"logout"]){
                schemeType = @"12";
            }else if ([type isEqualToString:@"logoutWithBack"]){
                schemeType = @"13";
            }
            [self getAuth1WithType:[schemeType intValue]];
        }
        
    }else{//针对于日报社项目
        if (options){
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:options];
            NSString *buildstr = dic[@"UIApplicationOpenURLOptionsSourceApplicationKey"];
//            com.sangfor.aWorkStd
            if ([buildstr isEqualToString:@"com.sangfor.aWorkStd"]) {//日报社id
                NSArray *arr = [str componentsSeparatedByString:@"schemes="];
                if (arr.count>1) {
                    self.soureSchme = arr[1];
                }
                if (userid && [xindunsdk isUserInitialized:userid]){
					[self requestCIMSOAuthInfo];
                    
                }else{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showWakeUP2ErrorInfo];
                        });
                    });
                }
            }else if([buildstr isEqualToString:@"com.trusfort.test.RBSwakeDemo"]){//其他类似项目
                NSArray *arr = [str componentsSeparatedByString:@"schemes="];
                if (arr.count>1) {
                    self.soureSchme = arr[1];//
                }
                if (userid && [xindunsdk isUserInitialized:userid]){
					[self requestCIMSOAuthInfo];
                    
                }else{
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showWakeUP2ErrorInfo];
                        });
                    });
                }
            }
        }
    }
    return YES;
}

- (void)getAuthWithType:(int)type{
    self.thirdAwakeTokenStatus = type;
    TRUSchemeTokenViewController *tokenVC = [[TRUSchemeTokenViewController alloc] init];
    tokenVC.schemetype = type;
    
    __weak typeof(self) weakSelf = self;
    CGFloat dispatchTime = 2.5;
    if ([self.window.rootViewController isKindOfClass: [TRUAdViewController class]]) {
        //                [HAMLogOutputWindow printLog:@"2.1s"];
        dispatchTime = 2.5;
    }else{
        dispatchTime = 0.5;
    }
    self.appCompletionBlock = ^(NSDictionary *tokenDic) {
        NSString *urlStr;
        if ([weakSelf.soureSchme containsString:@"://"]) {
            if([tokenDic[@"tokenerror"] integerValue]!=0){
                urlStr = [NSString stringWithFormat:@"%@?tokenerror=%d",weakSelf.soureSchme,tokenDic[@"tokenerror"]];
            }else{
                urlStr = [NSString stringWithFormat:@"%@?token=%@",weakSelf.soureSchme,tokenDic[@"token"]];
            }
            
        }else{
            if([tokenDic[@"tokenerror"] integerValue]!=0){
                urlStr = [NSString stringWithFormat:@"%@://?tokenerror=%@",weakSelf.soureSchme,tokenDic[@"tokenerror"]];
            }else{
                urlStr = [NSString stringWithFormat:@"%@://?token=%@",weakSelf.soureSchme,tokenDic[@"token"]];
            }
            
        }
        //                [HAMLogOutputWindow printLog:@"1111"];
        weakSelf.soureSchme = nil;
        weakSelf.thirdAwakeTokenStatus = 0;
        weakSelf.isFromSDK = NO;
        weakSelf.isMainSDK = NO;
        weakSelf.isNeedPush = NO;
        if (self.window.rootViewController.presentedViewController) {
            [weakSelf.window.rootViewController dismissViewControllerAnimated:YES completion:^{
                YCLog(@"dismissViewController success");
                if (@available(iOS 10.0,*)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                    }];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                }
            }];
        }else{
            if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *rootnav = self.window.rootViewController;
                [rootnav popToRootViewControllerAnimated:NO];
//                [HAMLogOutputWindow printLog:@"popToRootViewControllerAnimated"];
            }
            if (@available(iOS 10.0,*)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                    //                            [HAMLogOutputWindow printLog:@"2222"];
                }];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                //                        [HAMLogOutputWindow printLog:@"3333"];
            }
        }
        
        //        weakSelf.soureSchme = nil;
        //        weakSelf.isNeedPush = NO;
        //weakSelf.fromThirdAwake = NO;
        //        if (@available(iOS 10.0,*)) {
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
        //
        //            }];
        //        }else{
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        //        }
    };
    switch (type) {
        case 1:
        {
            tokenVC.isNeedpush = YES;
        }
            break;
        case 2:
        {
            
        }
        default:
            break;
    }
    NSString *userid = [TRUUserAPI getUser].userId;
    if (!userid.length || ![xindunsdk isUserInitialized:userid]){
        return;
    }
    if ([TRUFingerGesUtil getLoginAuthGesType] != TRULoginAuthGesTypeNone || [TRUFingerGesUtil getLoginAuthFingerType] != TRULoginAuthFingerTypeNone){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (1) {
                
                if ([self.window.rootViewController isKindOfClass:[TRUAdViewController class]]) {
                    [self openApplication:[UIApplication sharedApplication] WithOptions:self.launchOptions];
                }
                if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                    //                    [HAMLogOutputWindow printLog:@"001"];
                    UINavigationController *rootnav = self.window.rootViewController;
                    
                    [rootnav pushViewController:tokenVC animated:NO];
                    //                    self.appPushVC = tokenVC;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushAuthVC" object:nil];
                }else{
                    self.appPushVC = tokenVC;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushAuthVC" object:nil];
                }
            }
        });
    }else{
        if ([self.window.rootViewController isKindOfClass:[TRUAdViewController class]]) {
            [self openApplication:[UIApplication sharedApplication] WithOptions:self.launchOptions];
        }
        if(type==2){
            self.thirdAwakeTokenStatus = 1;
        }
    }
}

- (void)getAuth1WithType:(int)type{
    __weak typeof(self) weakSelf = self;
    TRUSchemeTokenViewController *tokenVC = [[TRUSchemeTokenViewController alloc] init];
    self.thirdAwakeTokenStatus = type;
    tokenVC.schemetype = type;
    CGFloat dispatchTime = 2.5;
    if ([self.window.rootViewController isKindOfClass: [TRUAdViewController class]]) {
        //                [HAMLogOutputWindow printLog:@"2.1s"];
        dispatchTime = 2.5;
    }else{
        dispatchTime = 0.5;
    }
    tokenVC.isNeedpush = YES;
    self.appCompletionBlock = ^(NSDictionary *tokenDic){
        NSString *urlStr;
        NSString *cimsurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        if ([weakSelf.soureSchme containsString:@"://"]) {
            urlStr = [NSString stringWithFormat:@"%@auth1?scheme=trusfortcims&type=auth1&code=%@&status=%ld&cimsurl=%@&statusmessage=%@",weakSelf.soureSchme,tokenDic[@"code"],[tokenDic[@"codeerror"] integerValue],cimsurl,tokenDic[@"message"]];
        }else{
            urlStr = [NSString stringWithFormat:@"%@://auth1?scheme=trusfortcims&type=auth1&code=%@&status=%ld&cimsurl=%@&statusmessage=%@",weakSelf.soureSchme,tokenDic[@"code"],[tokenDic[@"codeerror"] integerValue],cimsurl,tokenDic[@"message"]];
        }
        weakSelf.soureSchme = nil;
        weakSelf.thirdAwakeTokenStatus = 0;
        weakSelf.isFromSDK = NO;
        weakSelf.phone = nil;
        weakSelf.isNeedPush = NO;
        weakSelf.appid = nil;
        weakSelf.apid = nil;
        if (self.window.rootViewController.presentedViewController) {
            [self.window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:^{
                YCLog(@"dismissViewController success");
//                [HAMLogOutputWindow printLog:@"dismissViewController success"];
                if (@available(iOS 10.0,*)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                    }];
//                    [HAMLogOutputWindow printLog:@"auth1"];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                }
            }];
        }else{
            if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *rootnav = self.window.rootViewController;
                [rootnav popToRootViewControllerAnimated:NO];
//                [HAMLogOutputWindow printLog:@"poptorootsuccess"];
            }
            if (@available(iOS 10.0,*)) {
                urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
//                    self.tokenCompletionBlock = nil;
                    self.appCompletionBlock = nil;
                }];
//                [HAMLogOutputWindow printLog:@"auth2"];
            }else{
                urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//                self.tokenCompletionBlock = nil;
                self.appCompletionBlock = nil;
            }
        }
    };
    if (type == 12) {
        self.appCompletionBlock = nil;
    }else if(type == 13){
        self.appCompletionBlock = ^(NSDictionary *tokenDic){
            NSString *urlStr;
            NSString *cimsurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
            if ([weakSelf.soureSchme containsString:@"://"]) {
                urlStr = [NSString stringWithFormat:@"%@auth1?scheme=trusfortcims&type=logout&code=%@&status=%ld&cimsurl=%@&statusmessage=%@",weakSelf.soureSchme,[tokenDic[@"codeerror"] integerValue],cimsurl,tokenDic[@"message"]];
            }else{
                urlStr = [NSString stringWithFormat:@"%@://auth1?scheme=trusfortcims&type=logout&status=%ld&cimsurl=%@&statusmessage=%@",weakSelf.soureSchme,[tokenDic[@"codeerror"] integerValue],cimsurl,tokenDic[@"message"]];
            }
            weakSelf.soureSchme = nil;
            weakSelf.thirdAwakeTokenStatus = 0;
            weakSelf.isFromSDK = NO;
            weakSelf.phone = nil;
            weakSelf.isNeedPush = NO;
            weakSelf.appid = nil;
            weakSelf.apid = nil;
            if (self.window.rootViewController.presentedViewController) {
                [self.window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:^{
                    YCLog(@"dismissViewController success");
//                    [HAMLogOutputWindow printLog:@"dismissViewController success"];
                    if (@available(iOS 10.0,*)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                        }];
//                        [HAMLogOutputWindow printLog:@"auth1"];
                    }else{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                }];
            }else{
                if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *rootnav = self.window.rootViewController;
                    [rootnav popToRootViewControllerAnimated:NO];
//                    [HAMLogOutputWindow printLog:@"poptorootsuccess"];
                }
                if (@available(iOS 10.0,*)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
//                        self.tokenCompletionBlock = nil;
                        self.appCompletionBlock = nil;
                    }];
//                    [HAMLogOutputWindow printLog:@"auth2"];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//                    self.tokenCompletionBlock = nil;
                    self.appCompletionBlock = nil;
                }
            }
        };
        
    }
    NSString *userid = [TRUUserAPI getUser].userId;
    if (!userid.length || ![xindunsdk isUserInitialized:userid]){
        return;
    }
    if ([TRUFingerGesUtil getLoginAuthGesType] != TRULoginAuthGesTypeNone || [TRUFingerGesUtil getLoginAuthFingerType] != TRULoginAuthFingerTypeNone){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (1) {
//                    [HAMLogOutputWindow printLog:@"pushAuthVC"];
                    weakSelf.appPushVC = tokenVC;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushAuthVC" object:nil];
                }
            });
        }else{
            NSString *currentUserId = [TRUUserAPI getUser].userId;
            if (!currentUserId || currentUserId.length == 0 || [xindunsdk isUserInitialized:currentUserId] == false) {
                if(type==2){
                    self.thirdAwakeTokenStatus = 1;
                }else{
                    if (type==3) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        dic[@"status"] = @(0);
                        self.appCompletionBlock(dic);
                    }
                }
            } else {
            }
            
        }
}

#pragma mark net scheme token
- (void)getTokenVC:(int)type{//蓝信
    self.thirdAwakeTokenStatus = type;
    YCLog(@"thirdAwakeTokenStatus = %d",type);
    TRUSchemeTokenViewController *tokenVC = [[TRUSchemeTokenViewController alloc] init];
    tokenVC.schemetype = type;
    __weak typeof(self) weakSelf = self;
    CGFloat dispatchTime = 2.1;
    switch (type) {
        case 1:
        {
            if ([self.window.rootViewController isKindOfClass: [TRUAdViewController class]]) {
//                [HAMLogOutputWindow printLog:@"2.1s"];
                dispatchTime = 2.1;
            }else{
                dispatchTime = 0.5;
            }
            tokenVC.completionBlock= ^(NSDictionary *tokenDic) {
                NSString *urlStr;
                if([tokenDic[@"status"] intValue]==0){
                    if ([tokenDic[@"phone"] length]) {
                        urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=getLocalToken&status=%d&token=%@&phone=%@",weakSelf.soureSchme,[tokenDic[@"status"] intValue],tokenDic[@"token"],tokenDic[@"phone"]];
                    }else{
                        urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=getLocalToken&status=%d&token=%@",weakSelf.soureSchme,[tokenDic[@"status"] intValue],tokenDic[@"token"]];
                    }
                    
                }else{
                    if ([tokenDic[@"phone"] length]) {
                        urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=getLocalToken&status=%d&phone=%@",weakSelf.soureSchme,[tokenDic[@"status"] intValue],tokenDic[@"phone"]];
                    }else{
                        urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=getLocalToken&status=%d",weakSelf.soureSchme,[tokenDic[@"status"] intValue]];
                    }
                    
                }
//                [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *rootnav = self.window.rootViewController;
                    [rootnav popToRootViewControllerAnimated:YES];
//                    [HAMLogOutputWindow printLog:@"popToRootViewControllerAnimated"];
                }
                weakSelf.soureSchme = nil;
                //weakSelf.fromThirdAwake = NO;
                if (@available(iOS 10.0,*)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                        
                    }];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                }
                //                weakSelf.soureSchme = nil;
                //                weakSelf.fromThirdAwake = NO;
            };
        }
            break;
        case 2:
        {
//            dispatchTime = 2.1;
            if ([self.window.rootViewController isKindOfClass: [TRUAdViewController class]]) {
//                [HAMLogOutputWindow printLog:@"2.1s"];
                dispatchTime = 2.1;
            }else{
                dispatchTime = 0.5;
            }
            tokenVC.isShowAuth = YES;
            self.appCompletionBlock = ^(NSDictionary *tokenDic) {
                NSString *urlStr;
                if([tokenDic[@"status"] intValue]==0){
                    if ([tokenDic[@"phone"] length]) {
                        urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=getNetToken&status=%d&token=%@&phone=%@",weakSelf.soureSchme,[tokenDic[@"status"] intValue],tokenDic[@"token"],tokenDic[@"phone"]];
                    }else{
                        urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=getNetToken&status=%d&token=%@",weakSelf.soureSchme,[tokenDic[@"status"] intValue],tokenDic[@"token"]];
                    }
                }else{
                    if ([tokenDic[@"phone"] length]) {
                        urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=getNetToken&status=%d&phone=%@",weakSelf.soureSchme,[tokenDic[@"status"] intValue],tokenDic[@"phone"]];
                    }else{
                        urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=getNetToken&status=%d",weakSelf.soureSchme,[tokenDic[@"status"] intValue]];
                    }
                }
//                [HAMLogOutputWindow printLog:@"1111"];
                weakSelf.soureSchme = nil;
                weakSelf.thirdAwakeTokenStatus = 0;
                if (self.window.rootViewController.presentedViewController) {
                    [weakSelf.window.rootViewController dismissViewControllerAnimated:YES completion:^{
                        YCLog(@"dismissViewController success");
                        if (@available(iOS 10.0,*)) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
//                                [HAMLogOutputWindow printLog:@"2222"];
                            }];
                        }else{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//                            [HAMLogOutputWindow printLog:@"3333"];
                        }
                    }];
                }else{
                    if (@available(iOS 10.0,*)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
//                            [HAMLogOutputWindow printLog:@"2222"];
                        }];
                    }else{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//                        [HAMLogOutputWindow printLog:@"3333"];
                    }
                }
                
                
                //weakSelf.fromThirdAwake = NO;
                
                //                weakSelf.soureSchme = nil;
                //                weakSelf.fromThirdAwake = NO;
            };
        }
            break;
        case 3:
        {
            if ([self.window.rootViewController isKindOfClass: [TRUAdViewController class]]) {
//                [HAMLogOutputWindow printLog:@"2.1s"];
                dispatchTime = 2.1;
            }else{
                dispatchTime = 0.5;
            }
            tokenVC.completionBlock= ^(NSDictionary *tokenDic) {
                NSString *urlStr;
                if([tokenDic[@"phone"] length]){
                    urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=logout&status=%d&phone=%@",weakSelf.soureSchme,[tokenDic[@"status"] intValue],tokenDic[@"phone"]];
                }else{
                    urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=logout&status=%d",weakSelf.soureSchme,[tokenDic[@"status"] intValue]];
                }
                [weakSelf.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                weakSelf.soureSchme = nil;
                //weakSelf.fromThirdAwake = NO;
                if (@available(iOS 10.0,*)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                        
                    }];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                }
            };
        }
            break;
        case 4:
        {
            if ([self.window.rootViewController isKindOfClass: [TRUAdViewController class]]) {
//                [HAMLogOutputWindow printLog:@"2.1s"];
                dispatchTime = 2.1;
            }else{
                dispatchTime = 0.5;
            }
            tokenVC.completionBlock= ^(NSDictionary *tokenDic) {
                NSString *urlStr;
                if ([tokenDic[@"phone"] length]) {
                    urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=unBind&status=%d&phone=%@",weakSelf.soureSchme,[tokenDic[@"status"] intValue],tokenDic[@"phone"]];
                }else{
                    urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=unBind&status=%d",weakSelf.soureSchme,[tokenDic[@"status"] intValue]];
                }
                
                weakSelf.soureSchme = nil;
                //weakSelf.fromThirdAwake = NO;
                [weakSelf.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                if (@available(iOS 10.0,*)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                        
                    }];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                }
                
            };
        }
            break;
        default:
            break;
    }
    //self.window.rootViewController = nil;
    //TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:tokenVC];
    //self.window.rootViewController = nav;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLocalAuth" object:nil];
    
//    if (SCREENW==320) {
//        dispatchTime = 5.0;
//    }else{
//        dispatchTime = 3.0;
//    }
//    if (type==2) {
//        return;
//    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dispatchTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:tokenVC];
        [nav setNavBarColor:DefaultNavColor];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    });
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    if(@available(iOS 9.0,*)){
        return NO;
    }
    NSString *str = [NSString stringWithFormat:@"%@",url.query];
    NSString *userid = [TRUUserAPI getUser].userId;
    [self initXdSDK];
    if ([str containsString:@"&"]) {
        NSArray *queryArr = [str componentsSeparatedByString:@"&"];
        NSString *testType = [[[queryArr lastObject] componentsSeparatedByString:@"="] firstObject];
        if (queryArr.count==4 || [testType isEqualToString:@"apid"]) {
            [self getAuthWithURL:url];
            return YES;
        }
        self.soureSchme = [[queryArr.firstObject componentsSeparatedByString:@"="] lastObject];
        NSString *tokenStr = [[[queryArr lastObject] componentsSeparatedByString:@"="] lastObject];
        NSString *type = [[[queryArr lastObject] componentsSeparatedByString:@"="] firstObject];
        if([type isEqualToString:@"type"]){//蓝信调用
            if([tokenStr isEqualToString:@"getLocalToken"]){
                [self getTokenVC:1];
            }else if([tokenStr isEqualToString:@"getNetToken"]){
                //self.fromThirdAwake = YES;
                if (!userid.length || userid.length==0 || ![xindunsdk isUserInitialized:userid]) {//没有激活
                    //[self application:self initWithOptions:nil];
                    //[[UIApplication sharedApplication] openURL:@"trusfortcims://"];
//                    [self application:self initWithOptions:nil];
                }else if([TRUFingerGesUtil getLoginAuthFingerType]==TRULoginAuthFingerTypeNone&&[TRUFingerGesUtil getLoginAuthGesType]==TRULoginAuthGesTypeNone){
//                    [self application:self initWithOptions:nil];
                }else{
                    [self getTokenVC:2];
                }
            }else if ([tokenStr isEqualToString:@"logout"]){
                [self getTokenVC:3];
            }else if ([tokenStr isEqualToString:@"unBind"]){
                [self getTokenVC:4];
            }
        }else{
            if (userid && [xindunsdk isUserInitialized:userid]) {
                
                if (!tokenStr) {
                    tokenStr = @"";
                }
                [[NSUserDefaults standardUserDefaults] setObject:self.soureSchme forKey:@"WAKEUPSOURESCHME"];
                [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"OAuthVerify"];
                [[NSUserDefaults standardUserDefaults] setObject:tokenStr forKey:@"WAKEUPTOKENKEY"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSDictionary *dic = @{@"token" : tokenStr};
                
                [self popAuthVCWithUserInfo:dic];
                
            }else{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showWakeUPErrorInfo:tokenStr];
                    });
                });
            }
        }
    }else{//日报社
        if (sourceApplication) {
            NSString *buildstr = sourceApplication;
            
            if ([buildstr isEqualToString:@"com.sangfor.aWorkStd"]) {//日报社id
                NSArray *arr = [str componentsSeparatedByString:@"schemes="];
                if (arr.count>1) {
                    self.soureSchme = arr[1];//
                }
                if (userid && [xindunsdk isUserInitialized:userid]){
					[self requestCIMSOAuthInfo];
                    
                }else{
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showWakeUP2ErrorInfo];
                        });
                    });
                }
            }else if([buildstr isEqualToString:@"com.trusfort.test.RBSwakeDemo"]){//其他类似项目
                NSArray *arr = [str componentsSeparatedByString:@"schemes="];
                if (arr.count>1) {
                    self.soureSchme = arr[1];//
                }
                if (userid && [xindunsdk isUserInitialized:userid]){
                    [self requestCIMSOAuthInfo];
                    
                }else{
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showWakeUP2ErrorInfo];
                        });
                    });
                }
            }
        }
    }
    return YES;
}
#pragma mark 移动认证
- (void)getAuthWithURL:(NSURL *)url{
    NSString *str = [NSString stringWithFormat:@"%@",url.query];
    NSArray *queryArr = [str componentsSeparatedByString:@"&"];
    self.soureSchme = [[queryArr.firstObject componentsSeparatedByString:@"="] lastObject];
    NSString *type = [[queryArr[1] componentsSeparatedByString:@"="] lastObject];
    NSString *appid = [[queryArr[2] componentsSeparatedByString:@"="] lastObject];
    NSString *apid = [[queryArr[3] componentsSeparatedByString:@"="] lastObject];
    self.appid = appid;
    self.apid = apid;
    self.thirdAwakeTokenStatus = 8;
//    YCLog(@"thirdAwakeTokenStatus = %d",type);
    TRUSchemeTokenViewController *tokenVC = [[TRUSchemeTokenViewController alloc] init];
    tokenVC.schemetype = 8;
    __weak typeof(self) weakSelf = self;
    CGFloat dispatchTime = 2.1;
    if ([self.window.rootViewController isKindOfClass: [TRUAdViewController class]]) {
        dispatchTime = 2.1;
    }else{
        dispatchTime = 0.5;
    }
    NSString *userid = [TRUUserAPI getUser].userId;
    if (!userid || userid.length==0 || ![xindunsdk isUserInitialized:userid]) {
        //[self application:self initWithOptions:nil];
        //[[UIApplication sharedApplication] openURL:@"trusfortcims://"];
        //[self application:self initWithOptions:nil];
        
        self.appCompletionBlock = ^(NSDictionary *tokenDic) {
            NSString *urlStr;
            NSString *cimsURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
            urlStr = [NSString stringWithFormat:@"%@://auth?scheme=trusfortcims&type=auth&cimsurl=%@&code=%@&status=%d",self.soureSchme,cimsURL,tokenDic[@"code"],[tokenDic[@"status"] intValue]];
            if([self.window.rootViewController isKindOfClass:[UINavigationController class]]){
                UINavigationController *rootnav = self.window.rootViewController;
                //                    [rootnav popToRootViewControllerAnimated:NO];
                [rootnav popViewControllerAnimated:NO];
//                [HAMLogOutputWindow printLog:@"popViewControllerAnimated"];
            }
            weakSelf.soureSchme = nil;
            weakSelf.thirdAwakeTokenStatus = 0;
            if (self.window.rootViewController.presentedViewController) {
                [weakSelf.window.rootViewController dismissViewControllerAnimated:YES completion:^{
                    YCLog(@"dismissViewController success");
                    if (@available(iOS 10.0,*)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:nil];
                    }else{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                }];
            }else{
                if (@available(iOS 10.0,*)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                    }];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                }
            }
            
        };
        return;
    }else{
        if ([TRUFingerGesUtil getLoginAuthFingerType]==TRULoginAuthFingerTypeNone&&[TRUFingerGesUtil getLoginAuthGesType]==TRULoginAuthGesTypeNone) {
            
            self.appCompletionBlock = ^(NSDictionary *tokenDic) {
                NSString *urlStr;
                NSString *cimsURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
                urlStr = [NSString stringWithFormat:@"%@://auth?scheme=trusfortcims&type=auth&cimsurl=%@&code=%@&status=%d",self.soureSchme,cimsURL,tokenDic[@"code"],[tokenDic[@"status"] intValue]];
                if([self.window.rootViewController isKindOfClass:[UINavigationController class]]){
                    UINavigationController *rootnav = self.window.rootViewController;
                    //                    [rootnav popToRootViewControllerAnimated:NO];
                    [rootnav popViewControllerAnimated:NO];
//                    [HAMLogOutputWindow printLog:@"popViewControllerAnimated"];
                }
                weakSelf.soureSchme = nil;
                weakSelf.thirdAwakeTokenStatus = 0;
                if (self.window.rootViewController.presentedViewController) {
                    [weakSelf.window.rootViewController dismissViewControllerAnimated:YES completion:^{
                        YCLog(@"dismissViewController success");
                        if (@available(iOS 10.0,*)) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:nil];
                        }else{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                        }
                    }];
                }else{
                    if (@available(iOS 10.0,*)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                        }];
                    }else{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                }
                
            };
            return;
        }else{
//            NSString *cimsURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
            self.appCompletionBlock = ^(NSDictionary *tokenDic) {
                NSString *urlStr;
                NSString *cimsURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
                urlStr = [NSString stringWithFormat:@"%@://auth?scheme=trusfortcims&type=auth&cimsurl=%@&code=%@&status=%d",self.soureSchme,cimsURL,tokenDic[@"code"],[tokenDic[@"status"] intValue]];
                if([self.window.rootViewController isKindOfClass:[UINavigationController class]]){
                    UINavigationController *rootnav = self.window.rootViewController;
//                    [rootnav popToRootViewControllerAnimated:NO];
                    [rootnav popViewControllerAnimated:NO];
//                    [HAMLogOutputWindow printLog:@"popViewControllerAnimated"];
                }
                weakSelf.soureSchme = nil;
                weakSelf.thirdAwakeTokenStatus = 0;
                if (self.window.rootViewController.presentedViewController) {
                    [weakSelf.window.rootViewController dismissViewControllerAnimated:YES completion:^{
                        YCLog(@"dismissViewController success");
                        if (@available(iOS 10.0,*)) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:nil];
                        }else{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                        }
                    }];
                }else{
                    if (@available(iOS 10.0,*)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                        }];
                    }else{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                }
                
            };
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dispatchTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:tokenVC];
//                [nav setNavBarColor:ViewDefaultBgColor];
//                [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
//                if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
//                    UINavigationController *rootnav = self.window.rootViewController;
//                    [rootnav pushViewController:tokenVC animated:YES];
//                }
                self.appPushVC = tokenVC;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"pushAuthVC" object:nil];
            });
        }
    }
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
            YCLog(@"%d",success);
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
- (void)showWakeUP2ErrorInfo{
    UIAlertController *errorVC = [UIAlertController alertControllerWithTitle:@"" message:@"该终端还未激活，无法完成认证操作，请返回原APP或自注册激活" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"自注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //激活
    }];
    
    UIAlertAction *back = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (self.soureSchme) {
            NSString *urlstr = [self.soureSchme stringByAppendingString:@"://type=notactive"];
            NSURL *url = [NSURL URLWithString:urlstr];
            
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    //NSLog(@"%d",success);
                    //                self.soureSchme = nil;
                }];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
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
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushTrusfort" object:token];
    if ([self.RemoteTokenStr isEqualToString:token]) {
        return;
    }
    self.RemoteTokenStr = token;
    NSString *userid = [TRUUserAPI getUser].userId;
    if (!userid.length || ![xindunsdk isUserInitialized:userid]){
        return;
    }
    if ([TRUFingerGesUtil getLoginAuthGesType] == TRULoginAuthGesTypeNone && [TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeNone) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    CGFloat dispatchTime;
    if ([self.window.rootViewController isKindOfClass: [TRUAdViewController class]]) {
//        [HAMLogOutputWindow printLog:@"2.1s"];
        dispatchTime = 2.1;
    }else{
        dispatchTime = 0.5;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dispatchTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *rootVC = self.window.rootViewController;
        if (rootVC.presentedViewController) {
//            [rootVC.presentedViewController dismissViewControllerAnimated:NO completion:^{
//                TRUPushingViewController *authVC = [[TRUPushingViewController alloc] init];
//                authVC.userNo = [TRUUserAPI getUser].userId;
//                authVC.token = token;
//                TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:authVC];
//                [weakSelf.window.rootViewController presentViewController:nav animated:YES completion:nil];
//            }];
            TRUPushingViewController *authVC = [[TRUPushingViewController alloc] init];
            authVC.userNo = [TRUUserAPI getUser].userId;
            authVC.token = token;
            self.tokenPushVC = authVC;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"needpushToken" object:nil];
        }else{
//            TRUPushingViewController *authVC = [[TRUPushingViewController alloc] init];
//            authVC.userNo = [TRUUserAPI getUser].userId;
//            authVC.token = token;
//            TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:authVC];
//            [weakSelf.window.rootViewController presentViewController:nav animated:YES completion:nil];
            TRUPushingViewController *authVC = [[TRUPushingViewController alloc] init];
            authVC.userNo = [TRUUserAPI getUser].userId;
            authVC.token = token;
//            TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:authVC];
            self.tokenPushVC = authVC;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"needpushToken" object:nil];
//            TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:authVC];
//            [weakSelf.window.rootViewController presentViewController:nav animated:YES completion:nil];
//            UINavigationController *vc = weakSelf.window.rootViewController;
//            if ([weakSelf.window.rootViewController isKindOfClass:[UINavigationController class]]) {
//                YCLog(@"rootViewController UINavigationController");
//            }
//            if (vc.viewControllers<2) {
//                [vc pushViewController:authVC animated:YES];
//            }
        }
//        TRUPushingViewController *authVC = [[TRUPushingViewController alloc] init];
//        authVC.userNo = [TRUUserAPI getUser].userId;
//        authVC.token = token;
//        TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:authVC];
//        [weakSelf.window.rootViewController presentViewController:nav animated:YES completion:nil];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        });
        
    });
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
    if (application.applicationState == UIApplicationStateBackground){
//        [HAMLogOutputWindow printLog:@"applicationWillResignActive1"];
        self.thirdAwakeTokenStatus == 0;
        self.isFromSDK = NO;
        self.soureSchme = nil;
        self.isNeedPush = NO;
        self.pushCompletionBlock = nil;
        self.appCompletionBlock = nil;
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [[NSNotificationCenter defaultCenter] postNotificationName:TRUEnterBackgroundKey object:nil];
//    [TRUEnterAPPAuthView dismissAuthViewAndCleanStatus];
//    self.thirdAwakeTokenStatus = 0;
//    self.tokenCompletionBlock = nil;
//    UIViewController *rootVC = self.window.rootViewController;
//    if (rootVC.presentedViewController) {
//    YCLog(@"rootVC.presentedViewController=%@",rootVC.presentedViewController);
//        if([rootVC.presentedViewController isKindOfClass:[UIAlertController class]]){
//            return;
//        }
//        if ([rootVC.presentedViewController isKindOfClass:[TRUBaseNavigationController class]]) {
//            TRUBaseNavigationController *nav = rootVC.presentedViewController;
//            if ([[nav.viewControllers firstObject] isKindOfClass:[TRUSchemeTokenViewController class]]) {
//                [rootVC.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//                YCLog(@"dismissViewController success");
//            }
//        }
//
//    }
    [self beginBackTask];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    self.isFirstStart = NO;
    int thirdAwakeTokenStatus = self.thirdAwakeTokenStatus;
    self.thirdAwakeTokenStatus = 0;
    self.isNeedPush = NO;
    self.isFromSDK = NO;
    self.isMainSDK = NO;
    self.appid = nil;
    self.apid = nil;
    self.soureSchme = nil;
    self.appPushVC = nil;
    self.tokenPushVC = nil;
    [TRUEnterAPPAuthView dismissAuthViewAndCleanStatus];
    self.pushCompletionBlock = nil;
    self.appCompletionBlock = nil;
    YCLog(@"applicationWillEnterForeground");
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnterForegroundDyPw" object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *userid = [TRUUserAPI getUser].userId;
        if (userid && [xindunsdk isUserInitialized:userid] == true) {
            
            //兼容2.0.4之前的版本
            if ([TRUFingerGesUtil getLoginAuthType] != TRULoginAuthTypeNone) {
                if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeFinger) {
                    [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFinger];
                }else if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeFace){
                    [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFace];
                }else if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeGesture){
                    [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeture];
                }
                [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
                if (thirdAwakeTokenStatus==2 || thirdAwakeTokenStatus==8) {
                    //                    [TRUEnterAPPAuthView showAuthViewWithCompletionBlock:^{
                    //                        [[NSNotificationCenter defaultCenter] postNotificationName:TRUGetNetTokenKey object:nil];
                    //                    }];
                    //                    [TRUEnterAPPAuthView showLoading];
                }else{
//                    [TRUEnterAPPAuthView showAuthView];
                }
            }else{
                if ([TRUFingerGesUtil getLoginAuthGesType] != TRULoginAuthGesTypeNone || [TRUFingerGesUtil getLoginAuthFingerType] != TRULoginAuthFingerTypeNone) {
                    if (thirdAwakeTokenStatus==2 || thirdAwakeTokenStatus==8) {
                        
                    }else{
                        if ([self.window.rootViewController isKindOfClass: [TRUAdViewController class]]) {
                            
                        }else{
//                            [TRUEnterAPPAuthView showAuthView];
                        }
                        
                    }
                }
            }
        }
//        weakSelf.thirdAwakeTokenStatus = 0;
    });
    [self endBackTask];
}

- (void)beginBackTask{
    _backIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackTask]; // 如果在系统规定时间内任务还没有完成，在时间到之前会调用到这个方法，一般是10分钟
    }];
}

- (void)endBackTask{
    [[UIApplication sharedApplication] endBackgroundTask:_backIden];
    _backIden = UIBackgroundTaskInvalid;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    //self.fromThirdAwake = NO;
//    self.soureSchme = nil;
//    self.isNeedPush = NO;
    //self.isFirstLogin = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNumber" object:nil];
    
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *rootnav = self.window.rootViewController;
        if (rootnav.viewControllers>1) {
            
            UIViewController *vc = [rootnav.viewControllers lastObject];
            if ([rootnav.viewControllers.firstObject isKindOfClass:[TRULoginViewController class]]) {
                return;
            }
            [rootnav popToRootViewControllerAnimated:YES];
        }
    }
//    [HAMLogOutputWindow printLog:@"dismissAuthView1"];
    [TRUEnterAPPAuthView dismissAuthView];
    YCLog(@"applicationWillEnterForeground");
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnterForegroundDyPw" object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *userid = [TRUUserAPI getUser].userId;
        if (userid && [xindunsdk isUserInitialized:userid] == true) {
            
            //兼容2.0.4之前的版本
            if ([TRUFingerGesUtil getLoginAuthType] != TRULoginAuthTypeNone) {
                if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeFinger) {
                    [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFinger];
                }else if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeFace){
                    [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFace];
                }else if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeGesture){
                    [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeture];
                }
                [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
                if (self.isMainSDK) {
                    if (!self.thirdAwakeTokenStatus) {
                        [TRUEnterAPPAuthView showAuthView];
                    }else{
//                        [HAMLogOutputWindow printLog:@"dismissAuthView2"];
                        [TRUEnterAPPAuthView dismissAuthView];
                    }
                }else{
                    if (self.thirdAwakeTokenStatus!=4) {
                        [TRUEnterAPPAuthView showAuthView];
                    }
                }
            }else{
                if ([TRUFingerGesUtil getLoginAuthGesType] != TRULoginAuthGesTypeNone || [TRUFingerGesUtil getLoginAuthFingerType] != TRULoginAuthFingerTypeNone) {
                    if (self.isMainSDK) {
                        if (!self.thirdAwakeTokenStatus) {
                            [TRUEnterAPPAuthView showAuthView];
                        }else{
//                            [HAMLogOutputWindow printLog:@"dismissAuthView3"];
                            [TRUEnterAPPAuthView dismissAuthView];
                        }
                    }else{
                        if (self.thirdAwakeTokenStatus!=4) {
                            [TRUEnterAPPAuthView showAuthView];
                        }
                    }
                }else{
                    self.launchWithAuth = YES;
                    UIViewController *vc1 = [[TRUAllInOneAuthViewController alloc] init];
                    TRUBaseNavigationController *baseNav = [[TRUBaseNavigationController alloc] initWithRootViewController:vc1];
                    if([TRUFingerGesUtil getLoginAuthGesType] == TRULoginAuthGesTypeNone && [TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeNone){
                        //                        baseNav = [[TRUBaseNavigationController alloc] initWithRootViewController:[[TRUAPPLogIdentifyController alloc] init]];
                        UIViewController *vc2 = [[TRUAPPLogIdentifyController alloc] init];
                        baseNav.viewControllers = @[vc1,vc2];
                    }
                    //                    baseNav.navigationBarHidden = YES;
                    self.window.rootViewController = baseNav;
                }
            }
        }
    });
    
    
    
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"--soureSchme-->%@",self.soureSchme);
//        if (self.soureSchme.length>0) {
//
//        }else{
//
//        }
//    });
    
    /*
    //同步一次用户信息
    if (userid.length>0) {
        [xindunsdk getCIMSUserInfoForUser:userid onResult:^(int error, id response) {
            if (0 == error) {
                //用户信息同步成功
                TRUUserModel *model = [TRUUserModel modelWithDic:response];
                model.userId = userid;
                [TRUUserAPI saveUser:model];
                if ([self checkPersonInfoVC:model]) {//yes 表示需要完善信息
                    TRUAddPersonalInfoViewController *infoVC = [[TRUAddPersonalInfoViewController alloc] init];
                    if (model.phone.length >0) {
                        infoVC.phone = model.phone;
                    }else if (model.email.length >0){
                        infoVC.email = model.email;
                    }else{
                        infoVC.employeenum = model.employeenum;//员工号
                    }
                    infoVC.isStart = YES;
                    self.window.rootViewController = [[TRUBaseNavigationController alloc] initWithRootViewController:infoVC];
                }
            }else if(9008 == error){
                //秘钥失效
                if (userid && [xindunsdk isUserInitialized:userid] == true && [TRUFingerGesUtil getLoginAuthType] != TRULoginAuthTypeNone) {
                    [TRUEnterAPPAuthView dismissAuthView];
                }
//                [xindunsdk deactivateAllUsers];
                [TRUUserAPI deleteUser];
                [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
                [self alertWithStr:@"秘钥失效,需要重新激活"];
                
            }else if (9019 == error){
                //用户被禁用 取本地
            }else{
                
            }
        }];
    }
     */
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}
-(void)alertWithtokenStr:(NSString *)alertstr{
    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"" message:alertstr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confrimAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self changeRootVCForLogin];
    }];
    [alertVC addAction:confrimAction];
    [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
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
    NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=1195763218"];//
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
/*
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YCLog(@"error");
    }];
    
}

-(void)checkNewAppUpdate:(NSString *)appInfo updateURL:(NSString *)updateURL withFouce:(BOOL)fouce{
    //版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    CGFloat dispatchTime;
    if ([self.window.rootViewController isKindOfClass: [TRUBaseTabBarController class]]) {
        
        dispatchTime = 0.1;
    }else{
        dispatchTime = 20;
    }
    
    if ([self updeWithDicString:version andOldString:appInfo]) {
        if (fouce) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"新版本 %@ 已发布!",appInfo] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confrimAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *url = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",updateURL];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
                
            }];
            
            
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
    NSMutableDictionary *dataDictionary;
    if ([plist isKindOfClass:[NSData class]]) {
        NSMutableDictionary *result = [NSPropertyListSerialization propertyListWithData:plist options:0 format:NULL error:NULL];
        NSArray *array = result[@"items"];
        NSMutableDictionary *messageDic = [array firstObject];
        NSMutableDictionary *metadata = messageDic[@"metadata"];
        return metadata[@"bundle-version"];
    }
    return nil;

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

*/

-(void)checkAppUpdate:(NSString *)appInfo{
    //版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"sys-clientVersion"];

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
        [alertVC addAction:confrimAction];//
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
        });
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
    NSString *activeStr = [TRUCompanyAPI getCompany].activation_mode;
    if (activeStr.length == 3) {
        if ([activeStr containsString:@","]) {
            NSArray *arr = [activeStr componentsSeparatedByString:@","];
            NSString *modestr = arr[1];
            if ([modestr isEqualToString:@"1"]) {
                if (model.email.length >0) {
                    return NO;
                }else{
                    return YES;
                }
            }else if ([modestr isEqualToString:@"2"]){
                if (model.phone.length >0) {
                    return NO;
                }else{
                    return YES;
                }
            }else if ([modestr isEqualToString:@"0"]){
                return NO;
            }else{
                return NO;
//                if (model.employeenum.length >0) {
//                    return NO;
//                }else{
//                    return YES;
//                }
            }
        }else{
            return NO;
        }
        
    }else if (activeStr.length == 1){
        return NO;
    }else{
        return NO;
    }
}

#pragma mark-公司信息更新
-(void)requestSPinfo{
    NSString *spcode = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL_SPCODE"];
    if (spcode.length>0) {
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSString *para = [xindunsdk encryptByUkey:spcode];
        NSDictionary *dict = @{@"params" : [NSString stringWithFormat:@"%@",para]};
        [TRUhttpManager getCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/api/ios/cims.html"] withParts:dict onResult:^(int errorno, id responseBody) {
            //            NSLog(@"--%d-->%@",errorno,responseBody);
            if (errorno == 0 && responseBody) {
                NSDictionary *dictionary = responseBody;
                if (1) {
                    NSDictionary *dic = responseBody;
                    TRUCompanyModel *companyModel = [TRUCompanyModel modelWithDic:dic];
                    companyModel.desc = dic[@"description"];
                    [TRUCompanyAPI saveCompany:companyModel];
//                    NSLog(@"-121-->%@",companyModel.desc);
                }
            }
        }];
    }
}

-(void)requestCIMSOAuthInfo{
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *para = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/getoauth"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        if (responseBody && errorno == 0) {
            NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
            int code = [dic[@"code"] intValue];
            if (code == 0) {
                NSString *urlstr = [self.soureSchme stringByAppendingString:@"://type=success"];
                NSURL *url = [NSURL URLWithString:urlstr];
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                
            }else{
                NSString *urlstr = [self.soureSchme stringByAppendingString:[NSString stringWithFormat:@"://type=failCode%d",errorno]];
                NSURL *url = [NSURL URLWithString:urlstr];
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }else{
            NSString *urlstr = [self.soureSchme stringByAppendingString:[NSString stringWithFormat:@"://type=failCode%d",errorno]];
            NSURL *url = [NSURL URLWithString:urlstr];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }];
}

//- (UIViewController *)getRootWindowsViewController{
//    return self.window.rootViewController;
//}

@end


