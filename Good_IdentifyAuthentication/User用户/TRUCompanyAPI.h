//
//  TRUCompanyAPI.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2018/1/23.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRUCompanyModel.h"
@interface TRUCompanyAPI : NSObject
//保存用户
+ (void)saveCompany:(TRUCompanyModel *)company;
//获取用户
+ (TRUCompanyModel *)getCompany;
//删除用户
+ (void)deleteCompany;
@end
