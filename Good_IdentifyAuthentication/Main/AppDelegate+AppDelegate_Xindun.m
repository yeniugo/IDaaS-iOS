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
@implementation AppDelegate (AppDelegate_Xindun)

- (void)initXdSDK{
    //https://test1.bsb.com.cn:8100/cims
    //https://ida.bsb.com.cn/cims
    //http://192.168.1.211:8100/cims
    //http://14.2.34.19:8100/cims
#if TARGET_IPHONE_SIMULATOR
    //http://192.168.1.215:8100/cims
    [[NSUserDefaults standardUserDefaults] setObject:@"https://ida.bsb.com.cn/cims" forKey:@"CIMSURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    TRUCompanyModel *companymodel = [[TRUCompanyModel alloc] init];
    companymodel.activation_mode = @"2";
    [TRUCompanyAPI saveCompany:companymodel];
#else
    [[NSUserDefaults standardUserDefaults] setObject:@"https://ida.bsb.com.cn/cims" forKey:@"CIMSURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    TRUCompanyModel *companymodel = [[TRUCompanyModel alloc] init];
    companymodel.activation_mode = @"2";
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
//    [[NSUserDefaults standardUserDefaults] setObject:@"http://192.168.1.215:9100/authn" forKey:@"CIMSURL"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    bool result = [xindunsdk initEnv:@"com.example.demo" url:kServerUrl];
    bool result = [xindunsdk initCIMSEnv:@"com.example.demo" serviceUrl:kServerUrl devfpUrl:kServerUrl];
//    bool result = [xindunsdk initEnv:@"com.example.demo" algoType:XDAlgoTypeOpenSSL baseUrl:kServerUrl];
//    [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"初始化 %d",result]];
    YCLog(@"initXdSDK %d",result);
//    [xindunsdk getDeviceIdOnline:@"com.example.demo" withServer:@"https://dfs.trusfort.com/xdid/mapi" OnResult:^(int error, id dicResult) {
//        YCLog(@"error = %d,dicResult = %@",error,dicResult);
//    }];
    //
}
@end
