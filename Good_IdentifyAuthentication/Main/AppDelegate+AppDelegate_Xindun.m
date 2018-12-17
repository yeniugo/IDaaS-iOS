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
    [[NSUserDefaults standardUserDefaults] setObject:@"http://whxd1.trusfort.com:8100/cims" forKey:@"CIMSURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
#endif

    
    NSString *cimsurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    if (!cimsurl.length) {
        [[NSUserDefaults standardUserDefaults] setObject:@"http://39.1.194.1:9000/cims" forKey:@"CIMSURL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString *kServerUrl;
    if (cimsurl.length >0) {
        kServerUrl = cimsurl;
    }else{
        //测试环境
//        kServerUrl = @"http://192.168.1.99:8000/cims";
        //kServerUrl = @"http://192.168.1.115:8000/cims";
        //生产环境 http://xd3.trusfort.com:8000/cims
        
        cimsurl = @"http://39.1.194.1:9000/cims";
        kServerUrl = @"http://39.1.194.1:9000/cims";
        TRUCompanyModel *companyModel = [[TRUCompanyModel alloc] init];
        companyModel.activation_mode = @"3";
        [TRUCompanyAPI saveCompany:companyModel];
    }
    
    bool result = [xindunsdk initEnv:@"com.example.demo" url:kServerUrl];
    YCLog(@"initXdSDK %d",result);
    
    //
}
@end
