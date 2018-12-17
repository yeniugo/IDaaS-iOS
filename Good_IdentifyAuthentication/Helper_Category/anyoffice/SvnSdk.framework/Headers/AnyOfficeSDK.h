//
//  AnyOfficeSDK.h
//  SvnSdk
//
//  Created by l00174413 on 8/1/16.
//  Copyright © 2016 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>



#import "svn_define.h"
#import "svn_api.h"
#import "svn_file_api.h"
#import "svn_file_api_ex.h"
#import "svn_ios_api.h"


#import "svn_socket_api.h"
#import "svn_socket_err.h"

#import "anyoffice_sqlite3.h"
#import "anyoffice_keyspace.h"

#import "SDKContext.h"
#import "LoginParam.h"
#import "LoginAgent.h"
#import "AnyOfficeUserInfo.h"
#import "AnyOfficeSSOInfo.h"
#import "NetStatusManager.h"
#import "MdmDeviceIdInfo.h"
#import "MdmCheck.h"
#import "AppManager.h"
#import "AppInfo.h"



#import "SecBrowHttpProtocol.h"
#import "AnyOfficeWebView.h"

#import "CustomCopyAndPast.h"

#import "PreviewView.h"
#import "DocumentViewController.h"


#import "SvnFileHandle.h"
#import "SvnFileManager.h"
#import "SvnFileInputStream.h"
#import "SvnFileOutputStream.h"

#import "NSClassExtend.h"
#import "SvnGCDAsyncSocket.h"

#import "AnyOfficeInitOption.h"
#import "AnyOfficeAuthenticationOption.h"






extern const NSInteger ANYOFFICE_RET_OK;

extern const NSInteger ANYOFFICE_RET_ERROR;

extern const NSInteger ANYOFFICE_RET_ERROR_PARAM;

extern const NSInteger ANYOFFICE_RET_ERROR_NOT_INIT;
extern const NSInteger ANYOFFICE_RET_ERROR_ALREADY_INIT;
extern const NSInteger ANYOFFICE_RET_ERROR_AUTH_TIMEOUT;



extern const NSInteger ANYOFFICE_LOG_TYPE_ERR;
extern const NSInteger ANYOFFICE_LOG_TYPE_WARNING;
extern const NSInteger ANYOFFICE_LOG_TYPE_INFO;
extern const NSInteger ANYOFFICE_LOG_TYPE_DEBUG;


/**
 * 网络状态变更处理回调定义
 * 定义网络状态变更处理回调形式
 *
 * @author  l00174413
 * @version  [版本号, 2016-8-1]
 * @see  [相关类/方法]
 * @since  [产品/模块版本]
 */

@protocol TunnelStatusChangeDelegate <NSObject>

@required

/**
 * 处理回调
 * 网络状态变更处理回调
 * @param oldStatus 原网络状态
 * @param newStatus 当前网络状态
 * @param errCode 网络断开时对应的错误码
 * @see [类、类#方法、类#成员]
 */
-(void)onTunnelStatusChangedWithOldStatus:(NET_STATUS_EN)oldStatus newStatus:(NET_STATUS_EN)newStatus errCode:(int)error;

@end



/**
 *  AnyOffice SDK封装类
 *  @author  l00174413
 *  @version  [版本号, 2016-8-1]
 *  @since  V1.5.70
 */
@interface AnyOfficeSDK : NSObject


/**
 *  获取SDK版本号
 *
 *  @return SDK版本号
 */
+ (NSString*) getVersion;


/**
 *  初始化SDK
 *
 *  @param initOption SDK初始化选项
 *  @see  [AnyOfficeInitOption]
 *  @return 初始化结果
 */
+ (int) initWithOption:(AnyOfficeInitOption*) initOption;



/**
 *  登录AnyOffice网关
 *
 *  @param loginOption    登录参数
 *  @param statusDelegate 隧道状态回调
 *  @see  [AnyOfficeAuthenticationOption]
 *  @return 登录状态
 */
+ (int) authenticateWithOption:(AnyOfficeAuthenticationOption*) authOption tunnelStatusDelegate:(id<TunnelStatusChangeDelegate>) statusDelegate;


/**
 *  获取隧道状态
 *
 *  @return 隧道状态
 */
+ (NET_STATUS_EN)getTunnelStatus;


/**
 *  获取隧道IP地址
 *
 *  @return 隧道IP地址
 */
+ (NSString*) getTunnelIPAddress;



/**
 *  获取用户信息
 *  @see  [AnyOfficeUserInfo]
 *  @return 用户信息
 */
+ (AnyOfficeUserInfo*) getUserInfo;



@end




