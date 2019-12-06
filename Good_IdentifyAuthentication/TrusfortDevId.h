//
//  xindunsdk.h
//  xindunsdk
//
//  Created by zaifangwang on 2015/11/26.
//  Copyright © 2015年 product. All rights reserved.
//

#import <Foundation/Foundation.h>


//static NSString* const APPKEY = @"f394e5f5887b4dc483fb69a54f561d8f";
//static NSString * const SERVER_URL_PREFIX_RISK = @"http://192.168.1.113:8080"; //风控服务器前缀

static NSTimeInterval API_TIMEOUT_SECONDS = 10;

//初始化SDK识别的配置信息KEY
static NSString *EnbelWebInfoKey = @"EnbelWebInfoKey";
static NSString *EnbelLocationKey = @"EnbelLocationKey";
static NSString *CrashReportURL = @"CrashReportURL";


@interface TrusfortDfsSdk : NSObject

#pragma mark 在线设备指纹

/**
 *  初始化SDK运行环境
 *  @param appId     芯盾为客户应用服务器分配的APPID
 *  @return          YES：初始化成功 NO：参数错误
 */
+ (BOOL)initEnv:(NSString *)appId;

/**
 *  初始化SDK运行环境
 *  @param appId     芯盾为客户应用服务器分配的APPID
 *  @param appId     SDK配置参数，如是否采集位置信息，上报web信息等
 *  @return          YES：初始化成功 NO：参数错误
 */
+ (BOOL)initEnv:(NSString *)appId config:(NSDictionary *)config;



/**
 *  是否上报web信息，默认不上报
 *  @param flag     YES:上报, NO:不上报
 */
+ (void)enable_Webfp:(BOOL)flag;

/**
 *  是否采集位置信息，默认采集
 *  如果要禁用位置采集，需要在调用initEnv之前调用[TrusfortDfsSdk enable_Location:NO]
 *  @param flag     YES:采集, NO:不采集
 */
+ (void)enable_Location:(BOOL)flag;

/**
 *  是否采集传感器信息，默认不采集
 *  @param flag     YES:采集, NO:不采集
 */
+ (void)enableSensor:(BOOL)flag;

/**
 *  是否启用国密算法，默认不启用
 *  @param flag     YES:启用, NO:不启用
 */
+ (void)enableSM:(BOOL)flag;

/**
 *  是否允许预先获取公网ip地址，默认不获取
 *  @param flag     YES:获取, NO:不获取
 */
+ (void)enableGetPublicIP:(BOOL)flag;

/**
*  设置请求超时时间
*  @param time     超时秒数
*/
+(void)setTimeoutInterval:(NSTimeInterval)time;

/**
 *  从芯盾设备指纹云平台获取本机设备ID
 *  @param appId     芯盾设备指纹云平台服务端为客户分配的ID
 *  @param URL       芯盾设备指纹云平台获取iOS设备指纹的接口地址，如：https://id.trusfort.com:8043/xdid/mapi
 *  @param onresult  异步回调，格式
                                 error： 0 - 成功，其他 - 错误码
                                 dictResult：字典对象，包含如下内容
                                 - devid：设备ID
                                 - devname：设备名称
                                 - is_emu：是否模拟器
                                 - is_root：是否越狱
 
 */
+ (void) getDeviceIdOnline: (NSString *)appId withServer: (NSString *)URL OnResult:(void (^)(int error, id dicResult))onresult;

/**
 *  从芯盾设备指纹云平台获取本机设备ID
 *  @param appId     芯盾设备指纹云平台服务端为客户分配的ID
 *  @param URL       芯盾设备指纹云平台获取iOS设备指纹的接口地址，如：https://id.trusfort.com:8043/xdid/mapi
 *  @param extInfo     用户自定义json格式参数，字符串类型
 *  @param onresult  异步回调，格式
                             error： 0 - 成功，其他 - 错误码
                             dictResult：字典对象，包含如下内容
                             - devid：设备ID
                             - devname：设备名称
                             - is_emu：是否模拟器
                             - is_root：是否越狱
 
 */
+ (void)getDeviceIdOnline:(NSString*)appId withServer:(NSString *)URL withExtInfo:(NSString *)extInfo OnResult:(void (^)(int error, id dicResult))onresult;

/**
 *  从芯盾设备指纹云平台获取本机设备ID
 *  @param appId     芯盾设备指纹云平台服务端为客户分配的ID
 *  @param URL       芯盾设备指纹云平台获取iOS设备指纹的接口地址，如：https://id.trusfort.com:8043/xdid/mapi
 *  @param filter    设备信息过滤标识，默认为空，获取全量信息
 *  @param extInfo     用户自定义json格式参数，字符串类型
 *  @param onresult  异步回调，格式
 error： 0 - 成功，其他 - 错误码
 dictResult：字典对象，包含如下内容
 - devid：设备ID
 - devname：设备名称
 - is_emu：是否模拟器
 - is_root：是否越狱
 
 */
+ (void)getDeviceIdOnline:(NSString*)appId withServer:(NSString *)URL withFilter:(NSString *)filter withExtInfo:(NSString *)extInfo OnResult:(void (^)(int error, id dicResult))onresult;

/**
 *  上报设备环境信息
 *  @param APPID     芯盾设备指纹云平台服务端为客户分配的ID
 *  @param URL       芯盾设备指纹云平台获取iOS设备指纹的接口地址，如：https://id.trusfort.com:8043/xdid/mapi
 *  @param extInfo     用户自定义参数，字典类型
 *  @param onresult  异步回调，格式
 error： 0 - 成功，其他 - 错误码
 dictResult：字典对象，包含如下内容
 - devid：设备ID
 - devname：设备名称
 - is_emu：是否模拟器
 - is_root：是否越狱
 
 */
+ (void)reportDeviceEnvInfo:(NSString*)appId withServer:(NSString *)URL withExtInfo:(NSDictionary *)extInfo OnResult:(void (^)(int error, id dicResult))onresult;

/**
 *  获取加密设备信息（默认获取全量设备信息）
 *  @param APPID     芯盾设备指纹云平台服务端为客户分配的ID
 *  @return          @{"error" : @"错误码", @"devinfo" : @"设备信息密文"}
 
 */
+ (NSDictionary *)getEncryptedDeviceInfo: (NSString *)appId;

/**
 *  获取加密设备信息
 *  @param APPID        芯盾设备指纹云平台服务端为客户分配的ID
 *  @param deviceType   设备信息类型，0:全量设备信息， 1:Nona设备信息
 *  @return             @{"error" : @"错误码", @"devinfo" : @"设备信息密文"}
 
 */
+ (NSDictionary *)getEncryptedDeviceInfo: (NSString *)appId deviceType:(int)deviceType;

/**
 * 获取缓存的在线设备指纹服务器响应。
    用于加速此部分信息的返回，避免重复发起网络请求。
    缓存仅保存在内存中，APP重启后失效。
 * @return  上次getDeviceIdOnline方法调用返回的设备信息。
 *          如果之前没有调用过getDeviceIdOnline，返回为nil
 */
+ (NSString *) getCachedDeviceInfo;

#pragma mark - ******Logs api begin******

#define SDK_LOG_VERBOSE 1
#define SDK_LOG_DEBUG   2
#define SDK_LOG_INFO    3
#define SDK_LOG_WARN    4
#define SDK_LOG_ERROR   5
#define SDK_LOG_FATAL   6
#define SDK_LOG_END     7

+(void)changeLogLevel:(int)level;

+(NSString *)getLogs;

+(void)clearLogs;

#pragma mark ******Logs api end******

#pragma mark - ******error report begin******

/**
 *  是否允许错误上报
 *
 *  @param enable        YES：允许，NO：不允许
 */
+(void)setupEnableErrorReport:(BOOL)enable;

/**
 *  设置错误上报服务地址
 *
 *  @param url        错误上报服务地址，如果用户使用自己的地址部署错误上报服务，则需要正确设置url，如果使用芯盾错误上报云平台，则不许要设置
 */
+(void)setupCustormErrorReportURL:(NSString *)url;

#pragma mark ******error report end******
#pragma mark - ******crash report begin******

/**
 *  是否允许崩溃日志上报
 *
 *  @param enable        YES：允许，NO：不允许
 */
+(void)setupEnableCrashReport:(BOOL)enable;

/**
 *  设置崩溃日志上报服务地址
 *
 *  @param url        崩溃上报服务地址
 */
+(void)setupCustormCrashReportURL:(NSString *)url;

#pragma mark ******crash report end******
#pragma mark 获取设备信息
+ (NSDictionary *)getSDKInfo;

@end
