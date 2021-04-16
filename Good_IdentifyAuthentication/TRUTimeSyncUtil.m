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
    NSString *para = [xindunsdk encryptByUkey:userId ctx:ctxx signdata:seed isDeviceType:NO];
// 添加了一个防崩溃
    int i = 0;
    while (para.length==0) {
        i++;
        if (i>4) {
            return;
        }
        seed = [self ret33bitString];
        ctxx = @[@"randa",seed];
        para = [xindunsdk encryptByUkey:userId ctx:ctxx signdata:seed isDeviceType:NO];
    }
    NSDictionary *paramsDic = @{@"params" : para};
//    long seconds_cli = (long)time((time_t *)NULL);
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/totp/sync"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        if (errorno!=0) {
            return;
        }
        NSDictionary *dic = nil;
        dic = [xindunsdk decodeServerResponse:responseBody];
        if ([dic[@"code"] intValue] == 0) {
            dic = dic[@"resp"];
            NSString *shmac = dic[@"hmac"];
            NSString *timestamp = [shmac substringToIndex:(shmac.length - 44)];
            long long time = [timestamp longLongValue];
            long long seconds_cli = [[NSDate date] timeIntervalSince1970]*1000;
            if( [xindunsdk checkCIMSHmac:userId randa:seed shmac:shmac]){
                long timedetal = (seconds_cli - time)/1000;
                long oldtime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"GS_DETAL_KEY"] longValue];
                DDLogWarn(@"本地时间 = %llu，服务器时间 = %llu，旧的时间差 = %ld，新时间差 = %ld",seconds_cli,time,oldtime,timedetal);
                NSLog(@"时间差 seconds_cli = %llu,time = %llu,dic= %@",seconds_cli,time,dic);
                [[NSUserDefaults standardUserDefaults] setObject:@(timedetal) forKey:@"GS_DETAL_KEY"];
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
    int sec = (seconds_cli - gs_detal*30) % 30;
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
