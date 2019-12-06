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
    
    NSDictionary *dic = @{@"userId":user.userId,@"phone":user.phone,@"realname":user.realname,@"department":user.department,@"employeenum":user.employeenum,@"email":user.email,@"spid":user.spid,@"spname":user.spname,@"voiceid":user.voiceid,@"faceinfo":user.faceinfo};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dic forKey:TRUUSERKEY];
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
