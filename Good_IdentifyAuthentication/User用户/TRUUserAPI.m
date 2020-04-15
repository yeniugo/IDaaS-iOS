//
//  TRUAuthAPI.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2016/12/12.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "TRUUserAPI.h"

static NSString *TRUUSERKEY = @"993d3d1eee762af60e2f13387ad18640";
static NSString *TRULASTUSEREMAILKEY = @"d5ec612335cd2c67bb3a4363e1d93bda";

@implementation TRUUserAPI

+ (void)saveUser:(TRUUserModel *)user{
//    NSDictionary *dic = @{@"userId":user.userId,@"phone":user.phone,@"realname":user.realname,@"department":user.department,@"employeenum":user.employeenum,@"email":user.email,@"spid":user.spid,@"spname":user.spname,@"voiceid":user.voiceid,@"faceinfo":user.faceinfo};
    
    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:user.userId,@"userId",user.phone,@"phone",user.realname,@"realname",user.department,@"department",user.employeenum,@"employeenum",user.email,@"email",user.spid,@"spid",user.spname,@"spname",user.voiceid,@"voiceid",user.faceinfo,@"faceinfo",nil];
    
    NSMutableDictionary *mutableDic = [NSMutableDictionary new];
    if (user.userId) {
        [mutableDic setObject:user.userId forKey:@"userId"];
    }
    if (user.phone) {
        [mutableDic setObject:user.phone forKey:@"phone"];
    }
    if (user.realname) {
        [mutableDic setObject:user.realname forKey:@"realname"];
    }
    if (user.department) {
        [mutableDic setObject:user.department forKey:@"department"];
    }
    if (user.employeenum) {
        [mutableDic setObject:user.employeenum forKey:@"employeenum"];
    }
    if (user.email) {
        [mutableDic setObject:user.email forKey:@"email"];
    }
    if (user.spid) {
        [mutableDic setObject:user.spid forKey:@"spid"];
    }
    if (user.spname) {
        [mutableDic setObject:user.spname forKey:@"spname"];
    }
    if (user.voiceid) {
        [mutableDic setObject:user.voiceid forKey:@"voiceid"];
    }
    if (user.faceinfo) {
        [mutableDic setObject:user.faceinfo forKey:@"faceinfo"];
    }
    
    
    
//    YCLog(@"---diccccccc-->%@----->%@",dic,mutableDic);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:mutableDic.copy forKey:TRUUSERKEY];
    [defaults setObject:user.email forKey:TRULASTUSEREMAILKEY];
    [defaults synchronize];
}
+ (TRUUserModel *)getUser{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id data = [defaults objectForKey:TRUUSERKEY];
    TRUUserModel *model;
    NSString *classNameStr = NSStringFromClass([data class]);
    if ([classNameStr isEqualToString:@"__NSCFData"]) {
        
        model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }else{
        
        model = [TRUUserModel modelWithDic:data];
    }
    
    return model;
}
+ (void)deleteUser{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:TRUUSERKEY];
    [defaults synchronize];
}

@end
