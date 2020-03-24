//
//  AppDelegate+AppDelegate_Xindun.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/26.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "AppDelegate+AppDelegate_Xindun.h"
#import "xindunsdk.h"
#import "TRUCompanyAPI.h"
#import "TrusfortDevId.h"
@implementation AppDelegate (AppDelegate_Xindun)

- (void)initXdSDK{
    //http://cloud.trusfort.com:8000/cims
    //http://192.168.1.115:8080/cims
#if TARGET_IPHONE_SIMULATOR
    //http://192.168.1.215:8100/cims
    [[NSUserDefaults standardUserDefaults] setObject:@"http://192.168.1.204:8004" forKey:@"CIMSURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    TRUCompanyModel *companymodel = [[TRUCompanyModel alloc] init];
//    companymodel.activation_mode = @"1";
    [TRUCompanyAPI saveCompany:companymodel];
#endif

    NSString *cimsurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    
    NSString *kServerUrl;
    if (cimsurl.length >0) {
        kServerUrl = cimsurl;
    }else{
        //测试环境
//        kServerUrl = @"http://192.168.1.99:8000/cims";
        //kServerUrl = @"http://192.168.1.115:8000/cims";
        //生产环境 http://xd3.trusfort.com:8000/cims
        kServerUrl = @"http://xd3.trusfort.com:8000/cims";
    }
//    [[NSUserDefaults standardUserDefaults] setObject:@"http://idportal.mwr.gov.cn:8100/authn" forKey:@"CIMSURL"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    bool result = [xindunsdk initEnv:@"com.example.demo" url:kServerUrl];
    bool result = [xindunsdk initCIMSEnv:@"com.example.demo" serviceUrl:kServerUrl devfpUrl:kServerUrl];
//    bool result = [xindunsdk initEnv:@"com.example.demo" algoType:XDAlgoTypeOpenSSL baseUrl:kServerUrl];
    
    
    YCLog(@"initXdSDK %d",result);
//    [xindunsdk getDeviceIdOnline:@"com.example.demo" withServer:@"https://dfs.trusfort.com/xdid/mapi" OnResult:^(int error, id dicResult) {
//        YCLog(@"error = %d,dicResult = %@",error,dicResult);
//    }];
    //
    [TrusfortDfsSdk initEnv:@"com.example.demo"];
//    NSString *crashURL = [NSString stringWithFormat:@"%@/crash_report",@"https://mtg.trusfort.com:8443/xdid"];
//    [TrusfortDfsSdk setupCustormCrashReportURL:crashURL];
//    [TrusfortDfsSdk enableSensor:YES];
    YCLog(@"sdk initXdSDK");
    [HAMLogOutputWindow printLog:@"初始化sdk"];
}
@end
