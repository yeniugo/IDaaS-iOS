//
//  xindunsdk.h
//  xindunsdk
//
//  Created by zaifangwang on 2015/11/26.
//  Copyright © 2015年 product. All rights reserved.
//



#import <Foundation/Foundation.h>


@interface xindunsdk : NSObject

#pragma mark 统一身份认证
/////////////////////// 统一身份认证 ////////////////////////////
/**
 *  初始化SDK运行环境
 *  @param appId      芯盾为客户应用服务器分配的APPID
 *  @param url        芯盾服务器部署地址
 *  @return           YES：初始化成功 NO：参数错误
 */
+ (BOOL)initEnv:(NSString *)appId url:(NSString *)url;

/**
 *  初始化状态检查
 *  @param userId     芯盾SDK唯一识别用户的ID。由应用生成，需要和应用的用户ID一一对应
 *  @return           YES：已经初始化 NO：未初始化
 */
+ (BOOL)isUserInitialized:(NSString *)userId;


/**
 *  清除初始化状态
 *  @param userId     芯盾SDK唯一识别用户的ID。由应用生成，需要和应用的用户ID一一对应
 */
+ (void)deactivateUser:(NSString *)userId;
/**
 *  清除所有用户初始化状态
 */
+ (void)deactivateAllUsers;
/**
 *  用户状态信息
 *  返回值NSDictionary，"status"：状态码，"msg":手机信息
 */
+ (NSDictionary *)userInitializedInfo:(NSString *)userId;

/**
 申请激活

 @param user 用户邮箱/手机号/工号
 @param type email:邮箱,phone:手机号,employeenum:工号
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)requestCIMSActiveForUser:(NSString *)user type:(NSString *)type onResult:(void(^)(int error, id response))onResult;

/**
 激活

 @param user 用户邮箱/手机号/工号
 @param type email:邮箱,phone:手机号,employeenum:工号
 @param authCode 验证码或密码
 @param pushID 推送ID，目前有极光SDK生成
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)verifyCIMSActiveForUser:(NSString *)user type:(NSString *)type authCode:(NSString *)authCode pushID:(NSString *)pushID onResult:(void(^)(int error, id response))onResult;

/**
 用户信息同步

 @param user 用户ID，激活接口完成后，服务器端会给每个用户生成唯一的用户ID
 @param realName 真实姓名
 @param phone 手机号
 @param authCode 验证码
 @param department 部门
 @param employeeNum 工号
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)requestCIMSUserInfoSyncForUser:(NSString *)user realName:(NSString *)realName phone:(NSString *)phone authCode:(NSString *)authCode department:(NSString *)department employeeNum:(NSString *)employeeNum onResult:(void(^)(int error, id response))onResult;

/**
 获取应用列表

 @param user 用户ID
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)getCIMSAppInfoListForUser:(NSString *)user onResult:(void(^)(int error, id response))onResult;
/**
 激活单个应用（废弃），目前当前用户拥有的应用权限有管理平台配置

 @param user 用户ID
 @param appID 应用ID
 @param userName 当前应用的用户名
 @param pwd 当前应用的用户密码
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)checkCIMSAppUser:(NSString *)user appID:(NSString *)appID userName:(NSString *)userName pwd:(NSString *)pwd onResult:(void(^)(int error, id response))onResult;
/**
 删除单个应用（废弃），目前当前用户拥有的应用权限有管理平台配置

 @param user 用户ID
 @param appID 应用ID
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)requestCIMSDelUserAppInfo:(NSString *)user appID:(NSString *)appID onResult:(void (^)(int error))onResult;
//获取验证码
+ (void)requestCIMSAuthCodeForUser:(NSString *)user phone:(NSString *)phone type:(NSString *)type onResult:(void(^)(int error, id response))onResult;

/**
 获取单个推送信息/获取扫码信息

 @param user 用户ID
 @param stoken 当前推送下传的token，用来交换实际的内容
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)getCIMSPushFetchForUser:(NSString *)user stoken:(NSString *)stoken onResult:(void(^)(int error, id response))onResult;

/**
 获取推送列表（推送不涉及敏感内容，只会下传token）

 @param user 用户ID
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)getCIMSPushListForUser:(NSString *)user onResult:(void(^)(int error, id response))onResult;

/**
 扫码、push认证
 @param user 用户ID
 @param stoken token
 @param confirm 1确认/2拒绝
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)requestCIMSCheckTokenForUser:(NSString *)user stoken:(NSString *)stoken confirm:(NSString *)confirm onResult:(void(^)(int error, id response))onResult;
/**
 获取用户信

 @param user 用户ID
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)getCIMSUserInfoForUser:(NSString *)user onResult:(void(^)(int error, id response))onResult;
/**
 获取动态验证码

 @param userNo 用户ID
 @return 动态验证码
 */
+ (NSString *)getCIMSDynamicCode:(NSString *)userNo;
/**
 otp同步

 @param userID 用户ID
 @param onResult 回调结果，error:错误码
 */
+ (void)requestCIMSSyncTotp:(NSString *)userID onResult:(void (^)(int error))onResult;


/**
 获取已注册设备列表

 @param user 用户ID
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)getCIMSActivedDeviceListForUser:(NSString *)user onResult:(void(^)(int error, id response))onResult;

/**
 配置设备是否接受推送

 @param user 用户ID
 @param openDevices 接收推送的设备列表，数组
 @param closeDevices 关闭推送的设备列表，数组
 @param onResult 回调结果，error:错误码
 */
+ (void)requestCIMSDevicePushConfigForUser:(NSString *)user openDevices:(NSArray *)openDevices closeDevices:(NSArray *)closeDevices onResult:(void(^)(int error))onResult;

/**
 删除激活设备

 @param user 用户ID
 @param deleteDevices 需要删除的设备列表，数组
 @param onResult 回调结果，error:错误码
 */
+ (void)requestCIMSDeviceDeleteForUser:(NSString *)user deleteDevices:(NSArray *)deleteDevices onResult:(void(^)(int error))onResult;


/**
 注册人脸信息

 @param user 用户ID
 @param faceData 人脸数据，目前是奥森提供接口
 @param onResult 回调结果，error:错误码
 */
+ (void)requestCIMSFaceInfoSyncForUser:(NSString *)user faceData:(NSData *)faceData onResult:(void(^)(int error))onResult;


/**
 人脸验证

 @param user 用户ID
 @param ftoken token
 @param confirm 1确认/2拒绝
 @param faceData 人脸数据，目前是奥森提供接口
 @param onResult 回调结果，error:错误码
 */
+ (void)verifyCIMSFaceForUser:(NSString *)user ftoken:(NSString *)ftoken confirm:(NSString *)confirm faceData:(NSData *)faceData onResult:(void(^)(int error))onResult;

/**
 删除声纹/人脸信息

 @param user 用户ID
 @param type 类型，人脸/声纹
 @param onResult 回调结果，error:错误码
 */
+ (void)deleteCIMSFaceVoiceInfoForUser:(NSString *)user type:(NSString *)type onResult:(void(^)(int error))onResult;
/**
 注册声纹信息，目前由科大讯飞提供

 @param user 用户ID
 @param voiceId 声纹ID
 @param onResult 回调结果，error:错误码
 */
+ (void)requestCIMSVoiceInfoSyncForUser:(NSString *)user voiceId:(NSString *)voiceId onResult:(void(^)(int error))onResult;


/**
 声纹验证

 @param user 用户ID
 @param vtoken 认证token
 @param confirm 1确认/2拒绝
 @param onResult 回调结果，error:错误码
 */
+ (void)verifyCIMSVoiceForUser:(NSString *)user vtoken:(NSString *)vtoken confirm:(NSString *)confirm onResult:(void(^)(int error))onResult;
/**
 获取UUID

 @param user 用户ID
 @return UUID
 */
+ (NSString *)getCIMSUUID:(NSString *)user;

/**
 生成声纹ID

 @param user 用户ID
 @return 为当前用户生成声纹ID
 */
+ (NSString *)getCIMSVoiceAuthIDForUser:(NSString *)user;


/**
 单点登录

 @param user 用户ID
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)getCIMSLogin2Target4AppForUser:(NSString *)user onResult:(void(^)(int error, id response))onResult;

/**
 获取今日验证次数

 @param user 用户ID
 @param startDate 开始日期
 @param endDate 结束日期
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)getCIMSDateCountForUser:(NSString *)user startDate:(NSDate *)startDate endDate:(NSDate *)endDate onResult:(void(^)(int error, id response))onResult;


/**
 获取旧手机号验证码

 @param user 用户ID
 @param authType 类型，1语音/2短信
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)getCIMSAuthcode4Update:(NSString *)user authType:(NSString *)authType onResult:(void(^)(int error, id response))onResult;
/**
 校验旧手机验证码

 @param user 用户ID
 @param authcode 验证码
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)checkCIMSAuchcode4Update:(NSString *)user authcode:(NSString *)authcode onResult:(void(^)(int error, id response))onResult;


/**
 获取当前用户会话列表

 @param user 用户ID
 @param appid 应用ID
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)getCIMSSessionList:(NSString *)user appid:(NSString *)appid onResult:(void(^)(int error, id response))onResult;

/**
 注销指定会话

 @param user 用户ID
 @param appid 应用ID
 @param sid sessionID
 @param onResult 回调结果，error:错误码,response响应内容，格式参考文档
 */
+ (void)requestCIMSSessionLogout:(NSString *)user appid:(NSString *)appid sid:(NSString *)sid onResult:(void (^)(int error))onResult;

/**
 获取邮件验证码
 
 @param user 用户ID
 @param authType 1：邮件验证码
 @param onResult 回调结果，error:错误码
 */

+ (void)requestCIMSEmailCode:(NSString *)user email:(NSString *)email authType:(NSString *)authType onResult:(void (^)(int error))onResult;

/**
 获取OAuth信息
 
 @param user 芯盾SDK唯一识别用户的ID。由应用生成，需要和应用的用户ID一一对应
 @param onResult 回调结果， error：错误码，response：OAuth信息
 */
+ (void)requestCIMSOAuthInfo:(NSString *)user onResult:(void(^)(int error, id response))onResult;

/**
 完善用户信息
 
 @param user 芯盾SDK唯一识别用户的ID。由应用生成，需要和应用的用户ID一一对应
 @param info 需要同步的信息
 @param type email：邮箱，phone：手机号，employeenum：工号
 @param onResult 回调结果， error：错误码，response：OAuth信息
 */
+ (void)requestCIMSUserInfoSync2ForUser:(NSString *)user info:(NSString *)info type:(NSString *)type authcode:(NSString *)authcode onResult:(void (^)(int error))onResult;
#pragma mark 其他可能用到的辅助接口

+ (NSString *) encryptData: (NSString *)plain ForUser: (NSString *)userid;
+ (NSString *) decryptData: (NSString *)encrypted ForUser: (NSString *)userid;

////////////////////// 通用数据加解密，HMAC接口 ////////////////////
/**
 * 字符串加密接口。使用WORK_KEY，必须使用本SDK或者对应芯盾服务器解密。
 * 输出：密文字符串
 */
+ (NSString *) encryptText: (NSString *)plain;
+ (NSString *) decryptText: (NSString *)encrypted;
+ (NSString *) getTextHmac: (NSString *)text;

/////////////////////// 交易信息加密接口 ////////////////////////////

+ (void) getUserAuthTokenForUser: (NSString *)userid ForTransaction: (NSString *)transaction_info OnResult:(void (^)(int error, id authToken))onresult;

/**
 *  交易信息加密
 *  @param userId               芯盾SDK唯一识别用户的ID。由应用生成，需要和应用的用户ID一一对应
 *  @param transactionInfo      交易相关信息，格式由应用自行定义
 *  @return                     status对应的错误码，encdata对应的加密字符串
 */
+ (NSDictionary *)getEncryptedTransactionInfo:(NSString *)userId transactionInfo:(NSString *) transactionInfo;
/**
 *  获取设备ID
 *  @return  设备ID字符串
 */
+ (NSString *)getDeviceId;

+ (NSString *)getDeviceInfo;


#pragma mark 以下为已过期接口，不建议使用


/**
 *  用户激活
 *  @param user               邮箱
 *  @param authCode           验证码
 *  @param pushID             推送ID，目前由极光生成
 *  @param onResult           回调结果，参考开发手册
 */
+ (void)verifyCIMSActiveForUser:(NSString *)user authCode:(NSString *)authCode pushID:(NSString *)pushID onResult:(void(^)(int error, id response))onResult NS_DEPRECATED_IOS(2.0,  2.0, "请使用verifyCIMSActiveForUser:type:authCode:pushID:onResult:");

@end
