//
//  TRUDeviceModel.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/12.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUDeviceModel.h"
#import <YYModel.h>
@implementation TRUDeviceModel
+ (instancetype)modelWithDic:(NSDictionary *)dic{
    id model = [[self alloc] init];
    [model yy_modelSetWithDictionary:dic];
    if ([dic[@"isactive"] integerValue] == 0) {
        
    }
    return model;
}
//做兼容用
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
