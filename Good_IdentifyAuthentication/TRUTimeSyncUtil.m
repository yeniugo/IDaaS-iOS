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

@implementation TRUTimeSyncUtil
static NSString *TIMEKEY = @"61cef4db2a378bc1b5983f84fbd00768";
+ (void)syncTime{
    
    long gs_detal= [[[NSUserDefaults standardUserDefaults] objectForKey:@"GS_DETAL_KEY"] longValue];
    
    if (0 == gs_detal) {
        
    }
}
+ (void)syncTimeWithResult:(void (^)(int))syncFinshBlock{
//    __block long gs_detal= [[[NSUserDefaults standardUserDefaults] objectForKey:@"GS_DETAL_KEY"] longValue];
//    if (0 != gs_detal){
//        if (syncFinshBlock) {
//            syncFinshBlock(0) ;
//        }
//        
//        return;
//    }
    
    NSString *userId = [TRUUserAPI getUser].userId;
    [xindunsdk requestCIMSSyncTotp:userId onResult:^(int error) {
        if (0 == error) {
//            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//            long seconds_cli = (long)time((time_t*)NULL);
//            long gs_detal = [[def objectForKey:@"GS_DETAL_KEY"] longValue];
//            int sec = (seconds_cli - gs_detal) % 30;
//            
//            float percent = sec / 30.0;
//            [def setObject:@(percent) forKey:@"PERCENTKEY"];
//            [def synchronize];
        }
        
        if (syncFinshBlock) {
            syncFinshBlock(error);
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
