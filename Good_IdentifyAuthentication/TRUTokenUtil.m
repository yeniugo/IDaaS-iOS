//
//  TRUTokenUtil.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/16.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUTokenUtil.h"


static NSString *TRUTOKENKEY = @"TRUTOKENKEY";
static NSString *NEEDPUSHKEY = @"NEEDPUSHKEY";

@implementation TRUTokenUtil
+(void)saveLocalToken:(NSString *)tokenStr{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:tokenStr forKey:TRUTOKENKEY];
    [def synchronize];
}

+(NSString *)getLocalToken{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:TRUTOKENKEY];
}

+(void)cleanLocalToken{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:TRUTOKENKEY];
//    [def removeObjectForKey:NEEDPUSHKEY];
    [def removeObjectForKey:@"VerifyFingerNumber"];
    [def removeObjectForKey:@"VerifyFingerNumber2"];
    [def synchronize];
}

//+(BOOL)isNeedPush{
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    return [[def objectForKey:NEEDPUSHKEY] boolValue];
//}
//
//+(void)setNeedPush:(BOOL)need{
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    [def setObject:@(need) forKey:NEEDPUSHKEY];
//    [def synchronize];
//}

@end
