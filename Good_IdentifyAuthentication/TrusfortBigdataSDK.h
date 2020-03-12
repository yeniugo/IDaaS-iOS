//
//  TrusfortBigdataSDK.h
//  
//
//  Created by Trusfort on 2016/12/27.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrusfortBigdataSDK : NSObject



/**
 * 初始化SDK运行环境
 *  @param riskServer        芯盾大数据平台风控服务器地址
 *  @param AppID             芯盾大数据平台服务端为客户分配的ID
 *  @param appKey            秘钥
 *  @param version           秘钥版本
 *  @param dfsAppID          芯盾大数据平台服务端为客户分配的在线设备指纹应用ID
 *  @param dfsServer         芯盾大数据平台服务端为客户分配的在线设备指纹服务地址
 *  @param enableSM          是否启用国密算法
 *  @return                  true：初始化运行环境成功，false：初始化运行环境失败
 */

+ (Boolean)initEnv:(NSString *)riskServer withAppID:(NSString *)appId appKey:(NSString *)appKey version:(NSString *)version dfsServer:(NSString *)dfsServer enableSM:(BOOL)enableSM;

/**
 *  白名单
 *
 *  @param params           参数集合，key参照开发者手册
 *  @param onResult         回调结果 response_body: json字符串
 */
+ (void)requestWhiteListWithParms:(NSDictionary *)params onResult:(void(^)(id responseBody))onResult;



/**
 *  风险评估
 *
 *  @param params      参数集合，key参照开发者手册
 *  @param onResult    回调结果 response_body: json字符串
 */
+ (void)getRiskInfoWithParams:(NSDictionary *)params onResult:(void(^)(id responseBody))onResult;
/**
 *  基础事件上报
 *
 *  @param params           参数集合，key参照开发者手册
 *  @param onResult         回调结果 response_body: json字符串
 */
+ (void)logreportBasicWithParams:(NSDictionary *)params onResult:(void(^)(id responseBody))onResult;
/**
 *  业务事件事件上报
 *
 *  @param params           参数集合，key参照开发者手册
 *  @param onResult         回调结果 response_body: json字符串
 */
+ (void)logreportBusinessWithParams:(NSDictionary *)params onResult:(void(^)(id responseBody))onResult;

/**
 获取设备信息
 
 @return 设备信息
 */
+ (NSString *)getDeviceInfo;

/**
 获取设备信息
 @param deviceType 设备信息类型
 @return 设备信息
 */
+ (NSString *)getDeviceInfo:(int)deviceType;

/**
 获取设备信息，用来获取在线设备指纹

 @return @{"error" : @"错误码", @"devinfo" : @"设备信息密文", @"uuid":@"操作流水号"}
 
 */
+ (NSDictionary *)getDeviceInfoForDeviceID;

/**
 *  获取解密后的在线设备指纹，用于非直连方式获取在线设备指纹解密服务端数据
 *  @param params       @{"appId": @"芯盾设备指纹云平台服务端为客户分配的ID", @"devinfo": @"服务端返回的密文",
 *                      @"uuid":@"getDeviceInfoForDeviceID返回的操作流水号" }
 *  @return             @{"error" : @"错误码", @"devid" : @"服务端返回的在线设备指纹"}
 
 */
+ (NSDictionary *)getDecryptedOnlineDeviceID:(NSDictionary *)params;

/**
 检测模拟器
 
 @param OnResult 回调结果，具体解析格式请参考API文档
 */
+ (void)checkSimulatorOnResult:(void(^)(id result))OnResult;

/**
 获取在线设备指纹
 @param APPID      大数据平台为在线设备指纹分配的应用ID
 @param URL        大数据平台为在线设备指纹分配的服务地址
 @param onresult   回调结果error:0,获取在线设备指纹成功，其他失败
 */
+ (void)getDeviceIdOnline:(NSString *)appId withServer:(NSString *)URL OnResult:(void (^)(int error))onresult;

#pragma mark  *** Deprecated/discouraged APIs ***
/**
 * 初始化SDK运行环境
 *  @param riskServer        芯盾大数据平台风控服务器地址
 *  @param AppID             芯盾大数据平台服务端为客户分配的ID
 *  @param appKey            秘钥
 *  @param version           秘钥版本
 *  @return                  true：初始化运行环境成功，false：初始化运行环境失败
 */

+ (Boolean)initEnv:(NSString *)riskServer withAppID:(NSString *)appId appKey:(NSString *)appKey version:(NSString *)version API_DEPRECATED("Use -initEnv:withAppID:appKey:version:dfsServer: instead", ios(2.0,2.0));

/**
 * 初始化SDK运行环境
 *  @param riskServer        芯盾大数据平台风控服务器地址
 *  @param AppID             芯盾大数据平台服务端为客户分配的ID
 *  @param appKey            秘钥
 *  @param version           秘钥版本
 *  @param dfsAppID          芯盾大数据平台服务端为客户分配的在线设备指纹应用ID
 *  @param dfsServer         芯盾大数据平台服务端为客户分配的在线设备指纹服务地址
 *  @return                  true：初始化运行环境成功，false：初始化运行环境失败
 */

+ (Boolean)initEnv:(NSString *)riskServer withAppID:(NSString *)appId appKey:(NSString *)appKey version:(NSString *)version dfsServer:(NSString *)dfsServer API_DEPRECATED("Use -initEnv:withAppID:appKey:version:dfsServer:enableSM: instead", ios(2.0,2.0));

@end

