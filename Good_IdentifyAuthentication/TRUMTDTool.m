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
@implementation TRUMTDTool
+(void)uploadDevInfo{
//    if(![TRUUserAPI getUser].userId.length){
//        return;
//    }
//    NSDictionary *userInfo = @{@"userId":[TRUUserAPI getUser].userId,@"dataType":@"ios.marketing.cims"};
//    [TrusfortDfsSdk reportDeviceEnvInfo:@"com.example.demo" withServer:@"http://mtg.trusfort.com:8000/xdid/mapi" withExtInfo:userInfo OnResult:^(int error, id dicResult) {
//        NSString *msg = nil;
//        if (dicResult!=nil) {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[dicResult dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
//            msg = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
//        }
//        YCLog(@"error:%d\nmeg:%@",error,msg);
//    }];
}
@end
