//
//  LoginParam.h
//  anyofficesdk
//
//  Created by z00103873 on 14-7-4.
//  Copyright (c) 2014年 pangqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnyOfficeUserInfo.h"
#import "AnyOfficeSSOInfo.h"

typedef enum {
    /**
     * 默认值，未知的类型。
     */
    LOGIN_UNKNOWN_NETWORK = 0,
    
    /**
     * 内网。
     */
    LOGIN_INNER_NETWORK = 1,
    
    
    /**
     * 外网。
     */
    LOGIN_OUTER_NETWORK = 2
    
    
}LOGIN_ADDRESS_TYPE;

typedef enum {
    AUTO_LOGIN_DISABLE = 0, //非自动登陆
    AUTO_LOGIN_ENABLE,      //自动登陆
    AUTO_LOGIN_DEFAULT = 999      //默认，由SDK内部决定是否自动登陆
}AUTO_LOGIN_TYPE;

typedef enum {
    CONNECT_TYPE_SDK = 0,
    CONNECT_TYPE_ANYOFFICE,
    CONNECT_TYPE_MTM,
    CONNECT_TYPE_E2E,
    CONNECT_TYPE_DEFAULT = 999
}CONNECT_TYPE;

#define SERVERTYPE_BROWSER 0x01
#define SERVERTYPE_MAIL    0x02
#define SERVERTYPE_MDM     0x04

@interface LoginParam : NSObject <NSCopying> {

}

@property(nonatomic, strong) AnyOfficeUserInfo* userInfo;
@property(nonatomic, strong) AnyOfficeSSOInfo* ssoInfo;
@property(strong, nonatomic) NSString* serviceType;
@property(strong, nonatomic) NSString* appName;
@property(strong, nonatomic) NSString* userType;		//用户密码类型staticUid 静态密码  dynamicUid 动态密码
@property(nonatomic, assign) BOOL tokenEnable;	//是否使用token登陆
@property(nonatomic, assign) BOOL useSecureTransfer;
@property(nonatomic, strong) NSString* internetAddress;
@property(nonatomic, strong) NSString* intranetAddress;
@property(nonatomic, assign) BOOL loginBackgroud; //是否后台登陆
@property(nonatomic, assign) BOOL useSafeKeyboard; //是否开启安全键盘，默认不开启
@property(nonatomic, assign) AUTO_LOGIN_TYPE loginType;  //登陆类型：自动登陆，非自动登陆，默认
@property(nonatomic, assign) CONNECT_TYPE connectType;
@property(nonatomic, assign) BOOL authGateway;

/*Begin modify by fanjiepeng on 2016-03-15,for ICBC POC*/
@property(nonatomic, assign) BOOL chekcAnyOfficeWhenLogin;
@property(nonatomic, strong) NSString *anyOfficeUrlScheme;
@property(nonatomic, strong) NSString *anyOfficeDisplayName;
/*End modify by fanjiepeng on 2016-03-15,for ICBC POC*/
@property(nonatomic, strong) NSString* suffix;
@property(nonatomic, strong) NSString* thirdPartDeviceID;
@property(nonatomic, assign) BOOL checkMdmWhenLogin;/*登录的时候做MDM检查特性*/
@property(nonatomic, strong) NSURL *appCurrentUrl;/*应用当前界面*/

/*Begin modify by fanjiepeng on 2016-08-08,for ICBC POC*/
@property(nonatomic, assign) BOOL checkJealbreakWhenLogin;/*登录的时候做越狱检查特性*/
/*End modify by fanjiepeng on 2016-08-08,for ICBC POC*/


@property(nonatomic, strong) NSString* loginAddress;
@property(nonatomic, assign) LOGIN_ADDRESS_TYPE loginAddressType;


@property(nonatomic, assign) BOOL useMDMModule;
@property(nonatomic, assign) BOOL useMailModule;
@property(nonatomic, assign) BOOL useBrowserModule;
//登录时做资产绑定检查
@property(nonatomic, assign) BOOL checkBindWhenLogin;
//新增GatewayIP，表示当前连接的网关
@property(nonatomic, strong) NSString* gatewayIP;

-(id)initWithServiceType:(NSString *) srvType andUseSecTrans:(BOOL)usel4;


@end
