//
//  TRUCompanyAPI.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2018/1/23.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUCompanyAPI.h"

static NSString *TRUCompanyKEY = @"913d3d1ses762af60e2qb3467ad1864p";

@implementation TRUCompanyAPI

+(void)saveCompany:(TRUCompanyModel *)company{
//    NSDictionary *dic = @{
//                          @"spid":company.spid,
//                          @"spname":company.spname,
//                          @"cims_server_url":company.cims_server_url,
//                          @"icon_url":company.icon_url,
//                          @"activation_mode":company.activation_mode,
//                          @"logo_url":company.logo_url,
//                          @"desc":company.desc,
//                          @"user_agreement_url":company.user_agreement_url,
//                          @"start_up_img_url":company.start_up_img_url
//                          };
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:company.spid,@"spid",company.spname,@"spname",company.cims_server_url,@"cims_server_url",company.icon_url,@"icon_url",company.activation_mode,@"activation_mode",company.logo_url,@"logo_url",company.desc,@"desc",company.user_agreement_url,@"user_agreement_url",company.start_up_img_url,@"start_up_img_url", nil];
    
    NSMutableDictionary *mutableDic = [NSMutableDictionary new];
    if (company.spid) {
        [mutableDic setObject:company.spid forKey:@"spid"];
    }
    if (company.spname) {
        [mutableDic setObject:company.spname forKey:@"spname"];
    }
    if (company.cims_server_url) {
        [mutableDic setObject:company.cims_server_url forKey:@"cims_server_url"];
    }
    if (company.icon_url) {
        [mutableDic setObject:company.icon_url forKey:@"icon_url"];
    }
    if (company.activation_mode) {
        [mutableDic setObject:company.activation_mode forKey:@"activation_mode"];
    }
    if (company.logo_url) {
        [mutableDic setObject:company.logo_url forKey:@"logo_url"];
    }
    if (company.desc) {
        [mutableDic setObject:company.desc forKey:@"desc"];
    }
    if (company.user_agreement_url) {
        [mutableDic setObject:company.user_agreement_url forKey:@"user_agreement_url"];
    }
    if (company.start_up_img_url) {
        [mutableDic setObject:company.start_up_img_url forKey:@"start_up_img_url"];
    }
    if (company.telephone) {
        [mutableDic setObject:company.telephone forKey:@"telephone"];
    }
    if (company.website) {
        [mutableDic setObject:company.website forKey:@"website"];
    }
    if (company.software_name) {
        [mutableDic setObject:company.software_name forKey:@"software_name"];
    }
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    YCLog(@"--Company--dic-->%@",dic);
    [defaults setObject:mutableDic.copy forKey:TRUCompanyKEY];
    [defaults synchronize];
}

+(void)deleteCompany{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:TRUCompanyKEY];
    [defaults synchronize];
}

+(TRUCompanyModel *)getCompany{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id data = [defaults objectForKey:TRUCompanyKEY];
    TRUCompanyModel *model = [TRUCompanyModel modelWithDic:data];
    return model;
}


@end
