//
//  WiFiManager.h
//  
//
//  Created by AnyOfficeSDK
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AnyOfficeWiFiConfigTemplate : NSObject
@property(nonatomic,strong) NSString *deviceID;
@property(nonatomic,strong) NSString *mailAccount;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *wifiMac;
@end

@interface AnyOfficeWiFiConfig_EAPClientConfiguration : NSObject

@property(nonatomic,strong) NSArray* AcceptEAPTypes;
@property(nonatomic,assign) int EAPFASTProvisionPAC;
@property(nonatomic,assign) int EAPFASTProvisionPACAnonymously;
@property(nonatomic,assign) int EAPFASTUsePAC;
@property(nonatomic,copy) NSString *OuterIdentity;
@property(nonatomic,strong) NSArray* PayloadCertificateAnchorUUID;
@property(nonatomic,strong) NSArray* TLSTrustedServerNames;
@property(nonatomic,copy) NSString *TTLSInnerAuthentication;
@property(nonatomic,assign) int OneTimeUserPassword;

@end

@interface AnyOfficeWiFiConfig : NSObject

@property(nonatomic,assign) int AutoJoin;
@property(nonatomic,strong) AnyOfficeWiFiConfig_EAPClientConfiguration* EAPClientConfiguration;
@property(nonatomic,copy) NSString *EncryptionTYpe;
@property(nonatomic,assign) int Hidden_Network;
@property(nonatomic,copy) NSString *PayloadCertificateUUID;
@property(nonatomic,copy) NSString *UserCertName;
@property(nonatomic,copy) NSString *PayloadDescription;
@property(nonatomic,copy) NSString *PayloadDisplayName;
@property(nonatomic,copy) NSString *PayloadIdentifier;
@property(nonatomic,copy) NSString *PayloadType;
@property(nonatomic,copy) NSString *PayloadUUID;
@property(nonatomic,assign) int PayloadVersion;
@property(nonatomic,copy) NSString *ProxyType;
@property(nonatomic,copy) NSString *SSID;

@end

typedef NS_ENUM(NSInteger, WiFiManagerCode) {
    WiFiManager_OK = 0,
    WiFIManager_GetUserInfoFailed,
    WiFiManager_NetworkError,
    WiFIManager_ExceptionConfig,
    WiFIManager_ConfigNotInstalled,
    WiFiManager_OtherError,
    WiFiManager_ReadLocalFileFailed,
    WiFiManager_GatewayConfigError,
    /**
     * WIFI配置申请失败原因:证书申请失败
     */
    WiFiManager_OP_FAIL_CERT = 9,
    /**
     * WIFI配置申请失败原因:参数为空
     */
    WiFiManager_OP_FAIL_NULLPARAMETERS,
    /**
     * WIFI配置申请失败原因:数据异常
     */
    WiFiManager_OP_FAIL_BADDATA,
    /**
     * 服务器内部数据异常:服务器中应该存在的数据为查找到
     */
    WiFiManager_OP_INTERNAL_EXCEPTION,
    /**
     * 报文异常:报文中没有DeviceID、OS等必须字段
     */
    WiFiManager_OP_BAD_REQUEST,
    WIFiManager_MDMModuleNotEnable
}WiFiManagerCodes;

typedef NS_ENUM(NSInteger, WiFiStatusCode) {
    WiFiStatusWiFiConfigured = 0,
    WiFiStatusWiFiNotConfigured,
    WiFiStatusClientCertNeedRenew
};

@protocol WiFiManagerDelegate <NSObject>
@optional
/**
 *  获取wifi配置后回调
 *
 *  @param errcode 错误码，参考WiFiManagerCodes
 *  @param config  WiFi配置信息
 *
 *  @return YES继续配置 NO取消
 */
-(BOOL)onConfigurationReceived:(AnyOfficeWiFiConfig *)config resultCode:(WiFiManagerCode)errcode;

/**
 *  获取wifi证书后回调
 *
 *  @param errcode 错误码，参考WiFiManagerCodes
 *  @param cert    证书
 *
 *  @return YES继续配置 NO取消
 */
-(BOOL)onCertificateReceived:(SecCertificateRef)cert resultCode:(WiFiManagerCode)errcode;
/**
 *  wifi配置安装回调
 *
 *  @param errcode 错误码，0为OK
 *
 *  @return YES继续配置 NO取消
 */
-(void)onWIFIConfigureCompleted:(WiFiManagerCode)errcode;
@end


@interface AnyOfficeWiFiConfigManager : NSObject

/**
 *  获取实例
 *
 *  @return wifi单一实例
 */
+(AnyOfficeWiFiConfigManager *)shareManager;

/**
 *  开始进行wifi配置
 *
 *  @param  config    可配置的WiFi信息
 *  @param  delegate  接收回调信息的对象
*/

-(void)configureWIFIAsync:(AnyOfficeWiFiConfigTemplate*)config delegate:(id<WiFiManagerDelegate>)delegate;

/**
 *  wifi配置状态检查
 *
 *  @return 检查结果(OK;配置变更；未配置；证书即将过期(时间))
 */
-(WiFiStatusCode)WiFiStatusCheck;

@end




