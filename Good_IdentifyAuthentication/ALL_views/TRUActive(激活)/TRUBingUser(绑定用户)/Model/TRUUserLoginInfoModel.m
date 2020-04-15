//
//  TRUUserLoginInfoModel.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/12/5.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUUserLoginInfoModel.h"

@implementation TRUUserLoginInfoModel
+ (instancetype)modelWithDic:(NSDictionary *)dic{
    id model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
@end
