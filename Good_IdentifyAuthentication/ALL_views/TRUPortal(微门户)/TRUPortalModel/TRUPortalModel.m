//
//  TRUPortalModel.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/3/19.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRUPortalModel.h"

@implementation TRUPortalModel
+ (instancetype)modelWithDic:(NSDictionary *)dic{
    id model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
@end
