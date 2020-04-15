//
//  xindunsdk.h
//  xindunsdk
//
//  Created by zaifangwang on 2015/11/26.
//  Copyright © 2015年 product. All rights reserved.
//

/*****   API使用说明
0. 设置芯盾服务器部署地址：initEnv

1. 检查用户是否已经激活：isUserActivitated(userid)
    userid：必选参数。在应用内唯一标识该用户的字符串，在芯盾SDK内使用此串标识用户。
        可以是对帐号进行Hash+salt的结果。
        【仅支持字母和数字的组合】

2. 如果用户未激活，需要走通过语音验证码激活用户的流程：
      - 提醒用户，继续操作将收到电话语音播报的4位数字验证码；
      - 调用requestVoiceCaptchaForUser 申请电话语音验证码：需要传入userid和用户已经绑定的手机号
      - 用户输入验证码以后，调用verifyVoiceCaptchaForUser 进行校验，校验通过则用户在本设备上变成已激活状态。

3. 用户已经激活以后，可以调用解密短信验证码、加密明文验证码的接口
**/

/** 错误码定义
 ---SDK定义的错误码
 0 //操作成功
 -1 //操作失败
 -5000  // SDK未授权
 -5001 // 参数错误
 -5002 // 内存不足
 -5003 // 重复初始化
 -5004 // 网络错误
 
 ---服务器返回的错误码
 9002 // 需要轮询检查服务器状态
 
 */

/**
 * Update Logs:
  - 2016-08-01: 支持U盾、人脸、上行短信初始化方式；支持风控开关。
  - 2016-03-03: 增加云平台获取SID支持；接口增加APP_SECRET字段，增强APP校验
  - 2015-12-17: 增加修改服务器部署地址的接口。
  - 2015-11-27: 去除无用函数声明
 *
 */


#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,XDAlgoType){
    XDAlgoTypeOpenSSL = 0,     //OPENSSL
    XDAlgoTypeSM= 1        //国密
};

typedef NS_OPTIONS(NSUInteger, XDDeviceFilter){
    XDDeviceFilterNone = 0,       //不过滤
    XDDeviceFilterWeb = 1,        //过滤web
    XDDeviceFilterSensor = 2,     //过滤传感器
    XDDeviceFilterDynamic = 4,    //过滤动态信息
    XDDeviceFilterStatic = 8,     //过滤静态信息
    XDDeviceFilterAPPInfo = 16    //过滤APPInfo
};
//nano信息过滤标识
static XDDeviceFilter nano_filter = XDDeviceFilterWeb | XDDeviceFilterSensor | XDDeviceFilterDynamic | XDDeviceFilterStatic | XDDeviceFilterAPPInfo;
//small信息过滤标识
static XDDeviceFilter default_filter = XDDeviceFilterWeb | XDDeviceFilterSensor;
//全量信息过滤标识
static XDDeviceFilter none_filter = XDDeviceFilterNone;


@interface xindunsdk : NSObject

#pragma mark 重新整理的SDK（集成最新设备信息、设备指纹代码，通过参数配置设备信息采集内容、是否采集web、web是否从线上html获取，国密、openssl切换）

/**
 *  交易信息加密
 *  @param userId               芯盾SDK唯一识别用户的ID。由应用生成，需要和应用的用户ID一一对应
 *  @param transactionInfo      交易相关信息，格式由应用自行定义
 *  @return                     status对应的错误码，encdata对应的加密字符串
 */
+ (NSDictionary *)getEncryptedTransactionInfo:(NSString *)userId transactionInfo:(NSString *) transactionInfo;


/**
 * 初始化SDK运行环境(非直连)
 @param appId              芯盾为客户应用服务器分配的APPID
 @param algoType           加密类型，XDAlgoTypeOpenSSL：OPENSSL，XDAlgoTypeSM：国密
 @param enableOnLineDevfp  是否启用在线设备指纹
 @param url                设备指纹地址
 @return 初始化SDK运行环境结果
 */
+ (BOOL)initEnv:(NSString *)appId algoType:(XDAlgoType)algoType enableOnLineDevfp:(BOOL)enableOnLineDevfp url:(NSString *)url;

/**
 * 初始化SDK运行环境(直连)
 @param appId              芯盾为客户应用服务器分配的APPID
 @param algoType           加密类型，XDAlgoTypeOpenSSL：OPENSSL，XDAlgoTypeSM：国密
 @param baseUrl            芯盾服务地址
 @return 初始化SDK运行环境结果
 */
+ (BOOL)initEnv:(NSString *)appId algoType:(XDAlgoType)algoType baseUrl:(NSString *)baseUrl;



/**
 *  初始化状态检查
 *  @param userId     芯盾SDK唯一识别用户的ID。由应用生成，需要和应用的用户ID一一对应
 *  @return           YES：已经初始化 NO：未初始化
 */
//+ (BOOL)isUserInitialized:(NSString *)userId;


/**
 *  清除初始化状态
 *  @param userId     芯盾SDK唯一识别用户的ID。由应用生成，需要和应用的用户ID一一对应
 */
//+ (void)deactivateUser:(NSString *)userId;

/**
 * 获取设备信息
 @param deviceFilter   过滤标识，默认取全部信息
 @return NSDictionary，{"status" : 0, "deviceInfo" : {}}
 */
+ (NSDictionary *)getDeviceInfo:(XDDeviceFilter)deviceFilter;

/**
 * 获取SDK信息
 
 @param userid 芯盾SDK唯一识别用户的ID。由应用生成，需要和应用的用户ID一一对应。此接口如果不传，ukid返回空字符串
 @return NSDictionary，{"status" : 0, "info" : {}}
 */
+ (NSDictionary *)getSDKInfo:(NSString *)userid;


#pragma mark ******统一身份认证******
/////////////////////// 统一身份认证 ////////////////////////////

//申请激活
+ (void)requestCIMSActiveForUser:(NSString *)user type:(NSString *)type onResult:(void(^)(int error, id response))onResult;
//激活
+ (void)verifyCIMSActiveForUser:(NSString *)user authCode:(NSString *)authCode pushID:(NSString *)pushID onResult:(void(^)(int error, id response))onResult;
//用户信息同步
+ (void)requestCIMSUserInfoSyncForUser:(NSString *)user realName:(NSString *)realName phone:(NSString *)phone authCode:(NSString *)authCode department:(NSString *)department employeeNum:(NSString *)employeeNum onResult:(void(^)(int error, id response))onResult;
//应用列表接口
+ (void)getCIMSAppInfoListForUser:(NSString *)user onResult:(void(^)(int error, id response))onResult;
//单个应用
+ (void)checkCIMSAppUser:(NSString *)user appID:(NSString *)appID userName:(NSString *)userName pwd:(NSString *)pwd onResult:(void(^)(int error, id response))onResult;
+ (void)requestCIMSDelUserAppInfo:(NSString *)user appID:(NSString *)appID onResult:(void (^)(int error))onResult;
//获取验证码
+ (void)requestCIMSAuthCodeForUser:(NSString *)user phone:(NSString *)phone type:(NSString *)type onResult:(void(^)(int error, id response))onResult;
//fetch
+ (void)getCIMSPushFetchForUser:(NSString *)user stoken:(NSString *)stoken onResult:(void(^)(int error, id response))onResult;
///push/getlist
+ (void)getCIMSPushListForUser:(NSString *)user onResult:(void(^)(int error, id response))onResult;

+ (void)requestCIMSCheckTokenForUser:(NSString *)user stoken:(NSString *)stoken confirm:(NSString *)confirm onResult:(void(^)(int error, id response))onResult;
+ (void)getCIMSUserInfoForUser:(NSString *)user onResult:(void(^)(int error, id response))onResult;
//+ (NSString *)getCIMSDynamicCode:(NSString *)userNo;
+ (void)requestCIMSSyncTotp:(NSString *)userID onResult:(void (^)(int error))onResult;

//设备相关
+ (void)getCIMSActivedDeviceListForUser:(NSString *)user onResult:(void(^)(int error, id response))onResult;

+ (void)requestCIMSDevicePushConfigForUser:(NSString *)user openDevices:(NSArray *)openDevices closeDevices:(NSArray *)closeDevices onResult:(void(^)(int error))onResult;

+ (void)requestCIMSDeviceDeleteForUser:(NSString *)user deleteDevices:(NSArray *)deleteDevices onResult:(void(^)(int error))onResult;

//人脸相关
+ (void)requestCIMSFaceInfoSyncForUser:(NSString *)user faceData:(NSData *)faceData onResult:(void(^)(int error))onResult;
+ (void)verifyCIMSFaceForUser:(NSString *)user ftoken:(NSString *)ftoken confirm:(NSString *)confirm faceData:(NSData *)faceData onResult:(void(^)(int error))onResult;


//声纹相关
+ (void)requestCIMSVoiceInfoSyncForUser:(NSString *)user voiceId:(NSString *)voiceId onResult:(void(^)(int error))onResult;
+ (void)verifyCIMSVoiceForUser:(NSString *)user vtoken:(NSString *)vtoken confirm:(NSString *)confirm onResult:(void(^)(int error))onResult;
//+ (NSString *)getCIMSUUID:(NSString *)user;
+ (void)deleteCIMSFaceVoiceInfoForUser:(NSString *)user type:(NSString *)type onResult:(void(^)(int error))onResult;
//+ (NSString *)getCIMSVoiceAuthIDForUser:(NSString *)user;
//单点登录相关
+ (void)getCIMSLogin2Target4AppForUser:(NSString *)user onResult:(void(^)(int error, id response))onResult;
//今日验证次数 getdatecount
+ (void)getCIMSDateCountForUser:(NSString *)user startDate:(NSDate *)startDate endDate:(NSDate *)endDate onResult:(void(^)(int error, id response))onResult;

//获取旧手机号验证码
+ (void)getCIMSAuthcode4Update:(NSString *)user authType:(NSString *)authType onResult:(void(^)(int error, id response))onResult;
//校验旧手机验证码
+ (void)checkCIMSAuchcode4Update:(NSString *)user authcode:(NSString *)authcode onResult:(void(^)(int error, id response))onResult;
//获取用户的会话列表
+ (void)getCIMSSessionList:(NSString *)user appid:(NSString *)appid onResult:(void(^)(int error, id response))onResult;
/**
 注销对应会话的用户
 
 @param user 芯盾SDK唯一识别用户的ID。由应用生成，需要和应用的用户ID一一对应
 @param appid 应用ID
 @param sid sessionID
 @param onResult 回调结果，error：错误码
 */
+ (void)requestCIMSSessionLogout:(NSString *)user appid:(NSString *)appid sid:(NSString *)sid onResult:(void (^)(int error))onResult;

/**
 获取OAuth信息
 
 @param user 芯盾SDK唯一识别用户的ID。由应用生成，需要和应用的用户ID一一对应
 @param onResult 回调结果， error：错误码，response：OAuth信息
 */
+ (void)requestCIMSOAuthInfo:(NSString *)user onResult:(void(^)(int error, id response))onResult;






/////////////////////////////// 设备指纹：在线获取 ++++++++++ ////////////////
#pragma mark ******在线获取设备指纹接口******
/**
 * 从芯盾设备指纹云平台获取本机设备ID。
     输入：APPID，芯盾设备指纹云平台为客户分配的ID
     异步返回：
         error： 0 - 成功，其他 - 错误码
         dictResult：字典对象，包含如下内容
             - devid：设备ID
             - devname：设备名称
             - is_emu：是否模拟器
             - is_root：是否越狱
 */
+ (void) getDeviceIdOnline: (NSString *)APPID withServer: (NSString *)URL OnResult:(void (^)(int error, id dicResult))onresult;
+ (void) getDeviceIdOnline: (NSString *)APPID OnResult:(void (^)(int error, id dicResult))onresult;

+ (void)getDeviceIdOnline:(NSString*)APPID withServer:(NSString *)URL  withParams:(NSDictionary *)param OnResult:(void (^)(int error, id dicResult))onresult;
/////////////////////////////// 设备指纹：在线获取 ---------- ////////////////

/////////////////////////////// 设备注册+登录 ++++++++++ ////////////////
+ (NSDictionary *)getEncryptCommonParamsDevinfoWithParams:(NSDictionary *)params devinfo:(NSString *)devinfo;
/////////////////////////////// 设备注册+登录 ---------- ////////////////


// 取消所有本地用户的激活状态。
//+ (void) deactivateAllUsers;
// 取消指定用户的激活状态。
//+ (void) deactivateUser: (NSString *)userid;

////////////////////// 通用数据加解密，HMAC接口 ////////////////////
/**
 * 字符串加密接口。使用WORK_KEY，必须使用本SDK或者对应芯盾服务器解密。
 * 输出：密文字符串
 */
+ (NSString *) encryptText: (NSString *)plain;
+ (NSString *) decryptText: (NSString *)encrypted;
+ (NSString *) getTextHmac: (NSString *)text;

////////////////////// 获取设备ID ////////////////////
//+ (NSString *) getDeviceId;


/////////////////////// 二维码扫码验证支持 ////////////////////////////
+ (NSString *) getQrcodeStokenSignature: (NSString *)serverToken ForTransaction: (NSString *)transaction_id;



/////////////////////// SSE 设备信息（某客户特有） ////////////////////////////

#pragma mark ******IDAAS解耦SDK*******

/**
 *  获取设备信息
 *
 *  @return 设备信息字符串
 */
+ (NSString *)getDeviceInfo;

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
 *  用户状态信息
 *  返回值NSDictionary，"status"：状态码，"msg":手机信息
 */
+ (NSDictionary *)userInitializedInfo:(NSString *)userId;
/**
 获取动态验证码
 
 @param userNo 用户ID
 @return 动态验证码
 */
+ (NSString *)getCIMSDynamicCode:(NSString *)userNo;

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
 注册或验证人脸
 @param user 用户ID
 @return 为当前用户生成声纹ID
 */
+ (NSString *)requestOrverifyCIMSFaceForUser:(NSString *)user faceData:(NSData *)faceData ctx:(NSArray *)ctx signdata:(NSString *)sign isType:(BOOL)isType;

/**
 *  会话秘钥加密-激活前
 *  @param user       用户ID
 *  @param deviceType   是否添加deviceInfo参数
 *  @param ctx          拼接参数值
 *  @return             加密后的params的字符串
 */

+ (NSString *)encryptBySkey:(NSString *)user ctx:(NSString *)ctx isType:(BOOL)type;

/**
 *  会话秘钥加密，用户秘钥签名
 *  @param userid       用户ID
 *  @param deviceType   是否添加deviceInfo参数
 *  @param ctx          拼接参数值
 *  @return             加密后的params的字符串
 */
+ (NSString *)encryptByUkey:(NSString *)userid ctx:(NSArray *)ctx signdata:(NSString *)sign isDeviceType:(BOOL)isDeviceType;
/**
 *  获取spinfo信息
 *  spcode  公司spid
 */
+ (NSString *)encryptByUkey:(NSString *)spcode;
#pragma mark - SSE
//解密激活后返回
+ (NSDictionary *)decodeServerResponse:(NSString *)resp;
//SSE
+ (int)privateVerifyCIMSInitForUserNo:(NSString *)userNo response:(NSDictionary *)response userId:(NSString **)userId;
+ (BOOL)checkCIMSHmac:(NSString *)userID randa:(NSString *)randa shmac:(NSString *)shmac;
#pragma mark 其他可能用到的辅助接口
+ (NSString *) encryptData: (NSString *)plain ForUser: (NSString *)userid;
+ (NSString *) decryptData: (NSString *)encrypted ForUser: (NSString *)userid;


#pragma mark-厦门国际 2.0.1版本
/**
 *  清除所有设备初始化状态
 */
+ (void) deactivateAllUsers;
/**
 获取设备ID
 */
+ (NSString *) getDeviceId;

/**
 *获取加密后的params-自注册
 @param ctx     上传参数的拼接
 @param user    用户id或者用户账号
 */
+ (NSString *)getParamsWithencryptText:(NSString *)ctx user:(NSString *)user;


@end
