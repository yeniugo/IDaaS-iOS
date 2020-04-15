//
//  AppDelegate+AppDelegate_Xindun.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/26.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "AppDelegate+AppDelegate_Xindun.h"
#import "xindunsdk.h"

@implementation AppDelegate (AppDelegate_Xindun)

- (void)initXdSDK{
    //http://cloud.trusfort.com:8000/cims
    //http://192.168.1.115:8080/cims
    
    //测试环境
//    NSString *kServerUrl = @"http://58.23.16.249:8180/cims";
    //NSString *kServerUrl = @"http://whxd1.trusfort.com:8100/cims";
    //生产环境 http://xd3.trusfort.com:8000/cims
//    NSString *kServerUrl = @"http://xd3.trusfort.com:8000/cims";
//    NSString *kServerUrl = @"http://58.23.16.249:8180/authn";
    NSString *kServerUrl = @"http://otp.xib.com.cn:8100/cims";
    [[NSUserDefaults standardUserDefaults] setObject:kServerUrl forKey:@"CIMSURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    bool result = [xindunsdk initEnv:@"com.example.demo" url:kServerUrl];
    NSLog(@"initXdSDK %d",result);
    //
}
@end
