//
//  STSilentLivenessEnumTypeHeader.h
//  STSilentLivenessEnumTypeHeader
//
//  Created by huoqiuliang on 2018/2/28.
//  Copyright © 2018年 sensetime. All rights reserved.
//

#ifndef STSilentLivenessEnumTypeHeader_h
#define STSilentLivenessEnumTypeHeader_h

/**
 *  STIDSilentLiveness运行结果
 */
typedef NS_ENUM(NSInteger, STIDSilentLivenessResult) {
    /** 正常运行 */
    STIDSilentLiveness_OK = 0,
    /** 授权文件不合法 */
    STIDSilentLiveness_E_LICENSE_INVALID = 1,
    /** 授权文件不存在 */
    STIDSilentLiveness_E_LICENSE_FILE_NOT_FOUND = 2,
    /** 授权文件绑定包名错误 */
    STIDSilentLiveness_E_LICENSE_BUNDLE_ID_INVALID = 3,
    /** 授权文件过期 */
    STIDSilentLiveness_E_LICENSE_EXPIRE = 4,
    /** 授权文件与SDK版本不匹配 */
    STIDSilentLiveness_E_LICENSE_VERSION_MISMATCH = 5,
    /** 授权文件不支持当前平台 */
    STIDSilentLiveness_E_LICENSE_PLATFORM_NOT_SUPPORTED = 6,
    /** 模型文件不合法 */
    STIDSilentLiveness_E_MODEL_INVALID = 7,
    /** 模型文件不存在 */
    STIDSilentLiveness_E_MODEL_FILE_NOT_FOUND = 8,
    /** 模型文件过期 */
    STIDSilentLiveness_E_MODEL_EXPIRE = 9,
    /** 参数设置不合法 */
    STIDSilentLiveness_E_INVALID_ARGUMENT = 10,
    /** 检测扫描超时 */
    STIDSilentLiveness_E_TIMEOUT = 11,
    /** API账户信息错误。*/
    STIDSilentLiveness_E_API_KEY_INVALID = 12,
    /** 服务器访问错误 */
    STIDSilentLiveness_E_SERVER_ACCESS = 13,
    /** 服务器访问超时 */
    STIDSilentLiveness_E_SERVER_TIMEOUT = 14,
    /** 调用API状态错误 */
    STIDSilentLiveness_E_CALL_API_IN_WRONG_STATE = 15,
    /** 运行失败 */
    STIDSilentLiveness_E_FAILED = 16,
};

/**
 *  设备错误的类型
 */
typedef NS_ENUM(NSUInteger, STIDSilentLivenessDeveiceError) {
    /** 相机权限获取失败 */
    STIDSilentLiveness_E_CAMERA = 0,
    /** 应用即将被挂起 */
    STIDSilentLiveness_WILL_RESIGN_ACTIVE,
};

#endif /* STSilentLivenessEnumTypeHeader_h */
