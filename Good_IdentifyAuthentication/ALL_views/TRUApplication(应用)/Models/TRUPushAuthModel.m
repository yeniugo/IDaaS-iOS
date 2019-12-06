//
//  TRUPushAuthModel.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2016/12/27.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "TRUPushAuthModel.h"

@implementation TRUPushAuthModel
+ (instancetype)modelWithDic:(NSDictionary *)dic{
    id model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
//为了兼容
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
