//
//  TRUVersionUtil.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/2/9.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUVersionUtil.h"

@implementation TRUVersionUtil
static NSString *TRUVersionKey = @"TRUVersionKey";

+ (void)saveCurrentVersion{
    NSString *appCurVersion = [self getCurrentVersion];
    [[NSUserDefaults standardUserDefaults] setObject:appCurVersion forKey:TRUVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getCurrentVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appCurVersion;
}
+ (NSString *)getOldVersion{
    return [[NSUserDefaults standardUserDefaults] objectForKey:TRUVersionKey];
}
#pragma mark - 判断是不是首次登录或者版本更新
+(BOOL )isFirstLauch{
    
    NSString *currentAppVersion = [self getCurrentVersion];
    //获取上次启动应用保存的appVersion
    NSString *version = [self getOldVersion];
    //版本升级或首次登录
    if (version == nil || ![version isEqualToString:currentAppVersion]) {
//        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:TRUVersionKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)isNewVersion{
    //这个版本产品没时间做图，暂定放在下一版本
    NSString *current = [self getCurrentVersion];
    NSString *old = [self getOldVersion];
    return ([current compare:old options:NSNumericSearch] == NSOrderedDescending);
}
@end
