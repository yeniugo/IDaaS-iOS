//
//  TRUCompanyModel.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2018/1/19.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUCompanyModel.h"
#import <objc/runtime.h>

@implementation TRUCompanyModel
+ (instancetype)modelWithDic:(NSDictionary *)dic{
    id model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
//兼容
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *nameStr = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:nameStr];
        [aCoder encodeObject:value forKey:nameStr];
    }
    free(ivars);
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i ++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
        
    }
    return self;
}
@end
