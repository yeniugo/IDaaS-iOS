//
//  TRUTimeSyncUtil.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2016/12/28.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "TRUTimeSyncUtil.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "TRUhttpManager.h"
@implementation TRUTimeSyncUtil
static NSString *TIMEKEY = @"61cef4db2a378bc1b5983f84fbd00768";
+ (void)syncTime{
    
    long gs_detal= [[[NSUserDefaults standardUserDefaults] objectForKey:@"GS_DETAL_KEY"] longValue];
    
    if (0 == gs_detal) {
        
    }
}
+(NSString *)ret33bitString{
    char data[33];
    for (int x=0; x <33; data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    
}
+ (void)syncTimeWithResult:(void (^)(int))syncFinshBlock{
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *userId = [TRUUserAPI getUser].userId;
    NSString *seed = [self ret33bitString];
    NSArray *ctxx = @[@"randa",seed];
    YCLog(@"test6--------------");
    [HAMLogOutputWindow printLog:@"test6--------------"];
    NSString *para = [xindunsdk encryptByUkey:userId ctx:ctxx signdata:seed isDeviceType:NO];
    while(para.length==0){
        seed = [self ret33bitString];
        ctxx = @[@"randa",seed];
        para = [xindunsdk encryptByUkey:userId ctx:ctxx signdata:seed isDeviceType:NO];
    }
    YCLog(@"test7--------------");
    [HAMLogOutputWindow printLog:@"test7--------------"];
    NSDictionary *paramsDic = @{@"params" : para};
    [HAMLogOutputWindow printLog:@"test8--------------"];
    __block long seconds_cli = (long)time((time_t *)NULL);
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/totp/sync"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        NSDictionary *dic = nil;
        dic = [xindunsdk decodeServerResponse:responseBody];
        if ([dic[@"code"] intValue] == 0) {
            dic = dic[@"resp"];
            NSString *shmac = dic[@"hmac"];
            NSString *timestamp = [shmac substringToIndex:(shmac.length - 44 - 3)];
            long time = [timestamp longLongValue];
            //hmac=timestamp+hmac（userkey，randa+timestamp）;
            if( [xindunsdk checkCIMSHmac:userId randa:seed shmac:shmac]){
                seconds_cli = seconds_cli - time ;
                [[NSUserDefaults standardUserDefaults] setObject:@(seconds_cli) forKey:@"GS_DETAL_KEY"];
                // 添加了一个数据保存
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (syncFinshBlock) {
                    syncFinshBlock(0);
                }
            }else{
                if (syncFinshBlock) {
                    syncFinshBlock(-5001);
                }
            }
        }else{
            if (syncFinshBlock) {
                syncFinshBlock(errorno);
            }
        }
    }];
}
+ (CGFloat)getTimePercent{
//    CGFloat per = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PERCENTKEY"] floatValue];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    long seconds_cli = (long)time((time_t*)NULL);
    long gs_detal = [[def objectForKey:@"PERCENTKEY"] longValue];
    int sec = (seconds_cli - gs_detal) % 30;
    if (sec < 0) {
        sec = ABS(sec);
    }
    CGFloat percent = sec / 30.0;
    return percent;
}
+ (void)saveTimePercent:(CGFloat)timePercent{
//    if (timePercent >= 1.0) {
//        timePercent -= 1.0;
//    }
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@(timePercent) forKey:@"PERCENTKEY"];;
    [def synchronize];
}

+ (void)saveCurrentTime{
    long seconds_cli = (long)time((time_t*)NULL);
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@(seconds_cli) forKey:TIMEKEY];;
    [def synchronize];
}
+ (CGFloat)getTimeSpan{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    long seconds_cli = [[def objectForKey:TIMEKEY] longValue];
    long seconds_cli_now = (long)time((time_t*)NULL);
    CGFloat percent = ((seconds_cli_now - seconds_cli) % 30) / 30.0;
    return percent;
}
@end
