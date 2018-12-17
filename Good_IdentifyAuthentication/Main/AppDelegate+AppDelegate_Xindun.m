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
    //http://cloud.trusfort.com:8000/cims
    //http://192.168.1.115:8080/cims
#if TARGET_IPHONE_SIMULATOR
    [[NSUserDefaults standardUserDefaults] setObject:@"http://192.168.1.214:8100/cims" forKey:@"CIMSURL"];
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
    
    bool result = [xindunsdk initEnv:@"com.example.demo" url:kServerUrl];
    YCLog(@"initXdSDK %d",result);
    
    //
}
@end
