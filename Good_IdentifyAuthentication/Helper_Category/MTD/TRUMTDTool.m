//
//  TRUMTDTool.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/9/4.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRUMTDTool.h"
#import "TRUUserApi.h"
#import "TrusfortDevId.h"
#import "TRUCompanyAPI.h"
@implementation TRUMTDTool
+(void)uploadDevInfo{
    if(![TRUUserAPI getUser].userId.length){
        return;
    }
    NSDictionary *userInfo = @{@"userId":[TRUUserAPI getUser].userId,@"dataType":@"ios.marketing.cims"};
    NSString *cimsurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *reportURL = [cimsurl stringByAppendingString:@"/mapi/01/init/getDeviceFingerPrintingId/mapi"];
    if ([TRUCompanyAPI getCompany].mtdExternalUrl.length == 0) {
        reportURL = @"http://dev.trusfort.com:8000/xdid/mapi";
    }else{
        reportURL = [TRUCompanyAPI getCompany].mtdExternalUrl;
        reportURL = [reportURL stringByAppendingString:@"/ios/mapi"];
    }
    [TrusfortDfsSdk reportDeviceEnvInfo:@"com.example.demo" withServer:reportURL withExtInfo:userInfo OnResult:^(int error, id dicResult) {
        NSString *msg = nil;
        if (dicResult!=nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[dicResult dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            msg = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
//            [HAMLogOutputWindow printLog:@"mtd成功"];
        }else{
//            [HAMLogOutputWindow printLog:@"mtd失败"];
        }
        YCLog(@"error:%d\nmeg:%@",error,msg);

    }];
}
@end
