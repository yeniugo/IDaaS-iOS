//
//  TRUFingerGesUtil.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/2/13.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUFingerGesUtil.h"
#import "xindunsdk.h"
static NSString *TRULOGINAUTHTYPEKEY = @"TRULOGINAUTHTYPEKEY";

//手势
static NSString *TRUGESTUREKEY = @"TRUGESTUREKEY";
//static NSString *TRUGESKEY = @"TRUGESKEY";
static NSString *TRULOGINAUTHTYPEGESKEY = @"TRULOGINAUTHTYPEGESKEY";

static NSString *TRULOGINAUTHTYPEGESKEYENCRYPT = @"TRULOGINAUTHTYPEGESKEYENCRYPT";
//指纹、Face ID
static NSString *TRUFIGERTUREKEY = @"TRUFIGERTUREKEY";
//static NSString *TRUFIGERKEY = @"TRUFIGERKEY";
static NSString *TRULOGINAUTHTYPEFIGERKEY = @"TRULOGINAUTHTYPEFIGERKEY";

static NSString *TRULOGINAUTHTYPEFIGERKEYENCRYPT = @"TRULOGINAUTHTYPEFIGERKEYENCRYPT";

@implementation TRUFingerGesUtil

+ (TRULoginAuthType)getLoginAuthType{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [[def objectForKey:TRULOGINAUTHTYPEKEY] integerValue];
}
+ (void)saveLoginAuthType:(TRULoginAuthType)type{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    if (type == TRULoginAuthTypeNone) {
//        [def removeObjectForKey:TRUGESTUREKEY];
//    }
    [def setObject:@(type) forKey:TRULOGINAUTHTYPEKEY];
    [def synchronize];
}

//指纹/Face ID
+ (TRULoginAuthFingerType)getLoginAuthFingerType{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def objectForKey:TRULOGINAUTHTYPEFIGERKEYENCRYPT] stringValue].length == 0) {
        int type = [[def objectForKey:TRULOGINAUTHTYPEFIGERKEY] integerValue];
        [self saveLoginAuthFingerType:type];
        [def removeObjectForKey:TRULOGINAUTHTYPEFIGERKEY];
        return type;
    }else{
        NSString *key = [[def objectForKey:TRULOGINAUTHTYPEFIGERKEYENCRYPT] stringValue];
        NSString *loginStr = [xindunsdk decryptText:key];
        return loginStr.intValue;
    }
    return [[def objectForKey:TRULOGINAUTHTYPEFIGERKEY] integerValue];
}
+ (void)saveLoginAuthFingerType:(TRULoginAuthFingerType)type{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *loginStr = [xindunsdk encryptText:[NSString stringWithFormat:@"%ld",(long)type]];
    [def setObject:loginStr forKey:TRULOGINAUTHTYPEFIGERKEYENCRYPT];
    [def synchronize];
}
//手势
+ (TRULoginAuthGesType)getLoginAuthGesType{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def objectForKey:TRULOGINAUTHTYPEGESKEYENCRYPT] stringValue].length == 0) {
        int type = [[def objectForKey:TRULOGINAUTHTYPEGESKEY] integerValue];
        [self saveLoginAuthGesType:type];
        [def removeObjectForKey:TRULOGINAUTHTYPEGESKEY];
        return type;
    }else{
        NSString *key = [[def objectForKey:TRULOGINAUTHTYPEGESKEYENCRYPT] stringValue];
        NSString *loginStr = [xindunsdk decryptText:key];
        return loginStr.intValue;
    }
    return [[def objectForKey:TRULOGINAUTHTYPEGESKEY] integerValue];
}
+ (void)saveLoginAuthGesType:(TRULoginAuthGesType)type{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (type == TRULoginAuthGesTypeNone) {
        [def removeObjectForKey:TRUGESTUREKEY];
    }
    NSString *loginStr = [xindunsdk encryptText:[NSString stringWithFormat:@"%ld",(long)type]];
    [def setObject:loginStr forKey:TRULOGINAUTHTYPEGESKEYENCRYPT];
    [def synchronize];
}

+ (NSString *)getGesturePwd{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:TRUGESTUREKEY];
}
+ (void)saveGesturePwd:(NSString *)pwd{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:pwd forKey:TRUGESTUREKEY];
    [def synchronize];
}
@end
