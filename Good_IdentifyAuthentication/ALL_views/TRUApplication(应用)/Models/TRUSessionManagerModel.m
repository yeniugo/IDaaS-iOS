//
//  TRUSessionManagerModel.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/9/11.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUSessionManagerModel.h"

@implementation TRUSessionManagerModel
+ (instancetype)modelWithDic:(NSDictionary *)dic{
    id model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
//为了兼容
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
