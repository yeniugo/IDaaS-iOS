//
//  TRUDeviceModel.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/12.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRUDeviceModel : NSObject

/** uuid */
@property (nonatomic, copy) NSString *uuid;
/** 设备指纹 */
@property (nonatomic, copy) NSString *devfp;

/** 设备类型 */
@property (nonatomic, copy) NSString *ostype;

/** 手机系统版本 */
@property (nonatomic, copy) NSString *osversion;

/** 设备名 */
@property (nonatomic, copy) NSString *devname;

/** model */
@property (nonatomic, copy) NSString *model;

/** model */
@property (nonatomic, copy) NSString *brand;
/** 是否本机 */
@property (nonatomic, assign) NSString *ifself;
/** 是否接受推送 */
@property (nonatomic, assign) NSString *ifpush;

+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
