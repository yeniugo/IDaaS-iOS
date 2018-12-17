/******************************************************************************

                  版权所有 (C), 2001-2014, 华为技术有限公司

 ******************************************************************************
  文 件 名   : anyoffice_sdk.h
  版 本 号   : 初稿
  作    者   : zhangyantao 00103873
  生成日期   : 2014年7月9日
  最近修改   :
  功能描述   : AnyOffice SDK 初始化和去初始化
  函数列表   :
*
*
  修改历史   :
  1.日    期   : 2014年7月9日
    作    者   : zhangyantao 00103873
    修改内容   : 创建文件

******************************************************************************/
#ifndef __ANYOFFICE_SDK_H__
#define __ANYOFFICE_SDK_H__

#ifdef __cplusplus
#if __cplusplus
extern "C"{
#endif
#endif /* __cplusplus */

/*----------------------------------------------*
 * 头文件                                       *
 *----------------------------------------------*/
#include "tools_common.h"
#include "svn_define.h"
/*----------------------------------------------*
 * 常量定义                                     *
 *----------------------------------------------*/

/*----------------------------------------------*
 * 宏定义                                       *
 *----------------------------------------------*/
#define ANYOFFICE_COMMON_OK   0
#define ANYOFFICE_ERROR_COMMON_UNDEFINED       1
#define ANYOFFICE_ERROR_COMMON_PARAMETER       2
#define ANYOFFICE_ERROR_COMMON_OUTOFMEMORY     3

#define ANYOFFICE_ERROR_COMMON_TCP_CONNECT_FAILED   -1
#define ANYOFFICE_ERROR_COMMON_PROXY_CONNECT_FAILED -2
#define ANYOFFICE_ERROR_COMMON_INVALID_PROXY        -3
#define ANYOFFICE_ERROR_CONMON_TLS_SHAKEHAND_FAILED -4
#define ANYOFFICE_ERROR_COMMON_UNAUTHORIED          -5
#define ANYOFFICE_ERROR_COMMON_GATEWAY_EXCEPTION    -99
#define ANYOFFICE_ERROR_COMMON_INTERNAL_EXCEPTION   -100

#define ANYOFFICE_ERROR_COMMON_UNINITIALIZED        -1001
#define ANYOFFICE_ERROR_COMMON_REQUIRE_APPAUTHEN    -1002  /* 应用验证失败,应用非法 */
#define ANYOFFICE_ERROR_COMMON_REQUIRE_USERAUTHEN   -1003
#define ANYOFFICE_ERROR_COMMON_REQUIRE_GET_POLICY   -1004
#define ANYOFFICE_ERROR_COMMON_REQUIRE_LOGIN        -1005
#define ANYOFFICE_ERROR_COMMON_VERSION_MISSMATCH    -1006
#define ANYOFFICE_ERROR_COMMON_INVALID_PARAMETER    -1007
#define ANYOFFICE_ERROR_COMMON_NOFUNCTION           -1008  /*no function is enabled*/
#define ANYOFFICE_ERROR_COMMON_CHK_CERT_BIND_FAIL       -1009  /*ckcert fail 由网关返回*/
#define ANYOFFICE_ERROR_COMMON_CHK_CERT_UNKNOW_FAIL       -1010  /*未知错误 属于证书校验失败，可能是网络异常导致，由客户端适配*/
#define ANYOFFICE_ERROR_COMMON_JEALBREAK            -1011


#define ANYOFFICE_ERROR_APP_INVALID_APPID           -2001
#define ANYOFFICE_ERROR_APP_INVALID_SIGNATURE       -2002
/*Begin modify by fanjiepeng on 2016-04-12,for DTS2015072301100*/
#define ANYOFFICE_ERROR_COMMON_NOLICENSE           -2008  /*no license*/
/*End modify by fanjiepeng on 2016-04-12,for DTS2015072301100*/    
#define ANYOFFICE_ERROR_GATEWAY_INVALID_TOKEN       -3001
#define ANYOFFICE_ERROR_GATEWAY_REQUIRE_USER        -3006
#define ANYOFFICE_ERROR_GATEWAY_REQUIRE_CONFIG      -3007

/* BEGIN: Modified by wenliang/90006494, for: DTS2015082705428  后台错误码在L4上适配 ,2015/9/25 */
#define ANYOFFICE_ERROR_GATEWAY_MDM_DEVICE_IS_NULL_OR_NOT_APPROVED     (-3008)    /* 终端不存在或者未审批 */
#define ANYOFFICE_ERROR_GATEWAY_MDM_REGISTER_LIMIT                     (-3009)    /* 用户注册终端数达上限 */
#define ANYOFFICE_ERROR_GATEWAY_MDM_SDK_OVER_TOP_LIMIT                 (-3010)    /* 超过系统终端规格上线，100w */
/* END: Modified by wenliang/90006494, for: DTS2015082705428  后台错误码在L4上适配 ,2015/9/25 */

/*Begin modify by fanjiepeng on 2016-03-01,for ICBC POC*/
#define ANYOFFICE_ERROR_GATEWAY_PASSWORD_EXPIRED      4300
#define ANYOFFICE_ERROR_GATEWAY_PASSWORD_ALMOST_EXPIRED      4301
#define ANYOFFICE_ERROR_ANYOFFICE_NOT_INSTALLED      -4302
/*End modify by fanjiepeng on 2016-03-01,for ICBC POC*/

/* BEGIN: Modified by wenliang/90006494, for: DTS2016012801551 提示语整改  ,2016/1/28 */
/*
https登陆错误，网关侧
#define SWM_RELOGINCAUSE_HIWORK_OTHER                   (-1)  重登录原因值-其他
#define SWM_RELOGINCAUSE_HIWORK_IPDENY                  (-2)   重登录原因值-IP受限 
#define SWM_RELOGINCAUSE_HIWORK_LICENSE_EXPIRE          (-3)  LISENCE过期
#define SWM_RELOGINCAUSE_HIWORK_DISABLE                 (-4)  该功能不可用
#define SWM_RELOGINCAUSE_HIWORK_USERINFOERROR           (-5)  用户身份验证失败
#define SWM_RELOGINCAUSE_HIWORK_CERT_VERIFY_FAIL        (-7)  用户证书验证失败
#define SWM_RELOGINCAUSE_HIWORK_NO_USRNAME              (-8)  缺少用户名
#define SWM_RELOGINCAUSE_HIWORK_NO_PASSWD               (-9)  
#define SWM_RELOGINCAUSE_HIWORK_NO_USRNAME_PASSWD       (-10) 
#define SWM_RELOGINCAUSE_HIWORK_CLIENTINFO_ERR          (-11) 客户端信息错误
#define SWM_RELOGINCAUSE_HIWORK_TOTOL_USEROVERTOP       (-12) 总用户达到上限
#define SWM_RELOGINCAUSE_HIWORK_ENDPOINT_USEROVERTOP    (-13) 终端用户达到上限
#define SWM_RELOGINCAUSE_HIWORK_MTM_USEROVERTOP         (-14) 多媒体隧道用户达到上限
#define SWM_RELOGINCAUSE_HIWORK_PUB_USEROVERTOP         (-15) 公共用户达到上限
#define SWM_RELOGINCAUSE_HIWORK_USERLOCKED              (-16)  用户多次尝试登陆都出错,被锁定 
#define SWM_RELOGINCAUSE_HIWORK_NO_USERGROUP            (-17) 没有找到用户组

#define SWM_RELOGINCAUSE_HIWORK_LOGIN_TIMEOUT           (-90) 长期未登入锁定
#define SWM_RELOGINCAUSE_HIWORK_SCHEDULE_CHECK_FAIL     (-20) 时间计划检查失败
#define SWM_RELOGINCAUSE_HIWORK_ACCOUNT_EXPIRE          (-21) 账号过期
#define SWM_RELOGINCAUSE_HIWORK_ACCOUNT_DISABLE         (-22) 账号被停用
#define SWM_RELOGINCAUSE_HIWORK_RDCERT_VERIFY_FAIL      (-23) radius证书验证失败
#define SWM_RELOGINCAUSE_HIWORK_INVAIL_AUTHPROC         (-24) 认证策略不允许使用该认证协议
#define SWM_RELOGINCAUSE_HIWORK_ACCOUNT_BLACKLIST       (-25) 账号被加入了黑名单或白名单中不存在该账号
#define SWM_RELOGINCAUSE_HIWORK_NO_ACCEPT_AGENT         (-26) 用户不支持使用agent认证

#define SWM_RELOGINCAUSE_HIWORK_ACCOUNT_SPECIFICATION_ERROR       (-30) radius账号同步错误，认证失败

#define SWM_RELOGINCAUSE_MDM_ERR                                (-20001)    mdm服务器异常 
#define SWM_RELOGINCAUSE_MDM_EXPIRED                            (-20002)    mdm服务器请求超时 
#define SWM_RELOGINCAUSE_MDM_DEVICE_IS_NULL_OR_NOT_APPROVED     (-20003)    终端不存在或者未审批 
#define SWM_RELOGINCAUSE_MDM_REGISTER_LIMIT                     (-20004)    用户注册终端数达上限 
#define SWM_RELOGINCAUSE_MDM_SDK_OVER_TOP_LIMIT                 (-20005)    超过系统终端规格上线，100w 
#define SWM_RELOGINCAUSE_MDM_SDK_NO_LISENCE                     (-11008)    Lisence不足,目前此错误码为-1008，为了便于后续修改，自定一个-11008 
#define SWM_RELOGINCAUSE_MDM_LICENSE_NO_FUNCTION                (-11009)    License没有此功能项,目前此错误码为-1008，为了便于后续修改，自定一个-11009  
#define SWM_RELOGINCAUSE_MDM_NO_LOGIN                           (-1008)     知客户端不可自动重登陆错误 
#define SWM_RELOGINCAUSE_ERROR_CERT_WITHOUT_BIND_FAIL           (-20009)    ckcert fail,mdm postonline时反馈，L4登陆错误时需要转化为mmtp错误码
#define SWM_RELOGINCAUSE_ERROR_TOKEN_AUTN_FAIL                  (-20010)
#define SWM_RELOGINCAUSE_RADIUS_UNKKOWN_ERR                     (-20501)    radius服务器认证错误，未知错误 
#define SWM_RELOGINCAUSE_RADIUS_EXPIRED                         (-20502)    radius服务器认证请求超时 
#define SWM_RELOGINCAUSE_RADIUS_RESETPSW                        (-20503)    radius服务器密码需要重置
*/


#define ANYOFFICE_ERROR_LOGIN_MISTAKE_ERR            -1       /* 其他错误:LOGIN_FAILLOG_ANYOFFICE_MISTAKE */
#define ANYOFFICE_ERROR_LOGIN_RELOGINCAUSE_HIWORK_IPDENY -2
#define ANYOFFICE_ERROR_LOGIN_SYSTEM_BUSY            -3       /* 连接网关失:LOGIN_FAILLOG_ANYOFFICE_NOGATEWAY */
#define ANYOFFICE_ERROR_LOGIN_GATEWAY_CONNECT_ERR   -4       /* 连接网关失:LOGIN_FAILLOG_ANYOFFICE_NOGATEWAY */
#define ANYOFFICE_ERROR_LOGIN_USERINFO_ERR           -5       /* 用户名密码错误:LOGIN_FAILLOG_ANYOFFICE_ERRORPASSWORD */
#define ANYOFFICE_ERROR_LOGIN_HIWORK_NO_USRNAME     (-8)
#define ANYOFFICE_ERROR_LOGIN_USERINFO_NO_PASSWORD  (-9)       /*没有密码*/
#define ANYOFFICE_ERROR_LOGIN_HIWORK_NO_USRNAME_PASSWD       (-10) 
#define ANYOFFICE_ERROR_LOGIN_HIWORK_PUB_USEROVERTOP    (-15)
#define ANYOFFICE_ERROR_LOGIN_HIWORK_USERLOCKED     (-16)
/* BEGIN: Modified by wenliang/90006494, for: DTS2015123105958 实时认证手动同步同步失败  ,2016/1/29 */
#define ANYOFFICE_ERROR_LOGIN_ACCOUNT_SPECIFICATION_ERROR       (-30) /* radius账号同步错误，认证失败 */
/* END: Modified by wenliang/90006494, for: DTS2015123105958 实时认证手动同步同步失败  ,2016/1/29 */
#define ANYOFFICE_ERROR_LOGIN_GATEWAY_PORT_ERR       -97     /* 端口号为空 */
#define ANYOFFICE_ERROR_LOGIN_GATEWAY_ADDRESS_ERR   -98      /* 网关地址为空 */
#define ANYOFFICE_ERROR_LOGIN_MAILINFO_ERR           -99       /* 邮件地址异常:LOGIN_FAILLOG_ANYOFFICE_ERROREMAIL */
#define ANYOFFICE_ERROR_LOGIN_GATEWAYINFO_ERR        -100       /* 服务器配置策略异常:LOGIN_FAILLOG_ANYOFFICE_ERRORSEVER */
#define ANYOFFICE_ERROR_LOGIN_CANOFFLINELOGIN_ERR        -100       /* 服务器配置策略异常:LOGIN_FAILLOG_ANYOFFICE_ERRORSEVER */
#define ANYOFFICE_ERROR_LOGIN_EXCEPTION              -101   /* 未知异常:LOGIN_FAILLOG_ANYOFFICE_EXCEPTION */
#define ANYOFFICE_ERROR_LOGIN_LICENSE_VISIT_LIMIT_ERR  -102/*license未激活或过期*/
#define ANYOFFICE_ERROR_LOGIN_POLICY_ENC_CHANGED  -103     /* 加解密策略切换 */
#define ANYOFFICE_ERROR_LOGIN_DB_CORRUPT -104            /* 数据库磁盘文件损坏 */
#define ANYOFFICE_ERROR_LOGIN_MAILISLOGIN_ANDCFGISCHANGED -105            /*未杀进程邮箱已经成功登录过，本次登录网关地址\邮件地址\用户名有修改,需要用户退出重登录(杀进程)*/
#define ANYOFFICE_ERROR_LOGINE_OFFLINE              -95
#define ANYOFFICE_ERROR_LOGIN_CHANGE_ACCOUNT -96
#define ANYOFFICE_ERROR_ALREADY_EXIST -106           /*配置文件已经存在*/
#define ANYOFFICE_ERROR_USER_NOSWITCH -107           /*没有发生用户切换*/

#define ANYOFFICE_ERROR_LOGIN_LONG_TIME_OFFLINE -110 /*长期未登录禁止离线登录*/
#define ANYOFFICE_ERROR_LOGIN_MDM_CHECK_FORBID_JOIN  -120 /*MDM违规禁止接入*/
#define ANYOFFICE_ERROR_LOGIN_URL_INVALID       -121 /*APP 的URL不可用*/

#define ANYOFFICE_SDK_ENTRY_VERSION_MAX_LEN 256
#define ANYOFFICE_ERROR_AUTH_NO_CLIENT_CERT -4000 /*双向校验函数，如果不存在证书，则返回错误*/
/* END: Modified by wenliang/90006494, for: DTS2016012801551 提示语整改  ,2016/1/28 */
    
    
//check bind
#define ANYOFFICE_ERROR_LOGIN_ASSERT_APPROVING -5001
#define ANYOFFICE_ERROR_LOGIN_ASSERT_BYOND_LIMINT -5002
#define ANYOFFICE_ERROR_LOGIN_ASSERT_BINDED_BY_OTHERS -5003
#define ANYOFFICE_ERROR_LOGIN_ASSERT_REG_BY_OTHERS -5004
#define ANYOFFICE_ERROR_LOGIN_ASSERT_NONBINDED -5005
#define ANYOFFICE_ERROR_LOGIN_ASSERT_BINDED_FAILED -5006
#define ANYOFFICE_ERROR_LOGIN_ASSERT_AGREEMENT_NOREAD -5007
#define ANYOFFICE_ERROR_LOGIN_ASSERT_AGREEMENT_NOREAD_OTHERS -5008
#define ANYOFFICE_ERROR_LOGIN_ASSERT_BINDED_MULTIUSER -5009
#define ANYOFFICE_ERROR_LOGIN_ASSERT_LOGON_TIMEOUT -5010
#define ANYOFFICE_ERROR_LOGIN_ASSERT_REJECT_APPROVE -5011
#define ANYOFFICE_ERROR_LOGIN_MDMSDK_KICKOFFT -5012
#define ANYOFFICE_ERROR_LOGIN_MDMSDK_NO_CHECKRESULT -5013
#define ANYOFFICE_ERROR_LOGIN_MDMDSDK_UNKOWN_ERROR -5014
    
#define ANYOFFICE_ERROR_LOGIN_MDMDSDK_OTHER_ERROR -5015
/* BEGIN: Added by zwx316192, 2017/07/05 for:上海银行：统一认证的错误码适配 */
#define ANYOFFICE_ERROR_LOGIN_THRIDPATY_ERR  -100001           /*第三方错误*/
/* END: Added by zwx316192, 2017/07/05 */

#define CSR_NO_MEMORY               1
#define CSR_ARG_ERR                 2
#define CSR_ERR_DN_TEMPLATE         3
#define CSR_ERR_GET_CONFIG          4
#define CSR_HTTP_CON_ERR            5
#define CSR_HTTP_RESPONSE_ERR       6

const unsigned char* AnyOffice_API_getEntryVersion();

void AnyOffice_API_setEntryVersion(unsigned char *pucEntryVersion);

INT32 AnyOffice_API_InitEnv(CHAR *pcUserName, CHAR *pcWorkPath);

INT32 AnyOffice_API_ResetEnv();

ULONG AnyOffice_API_CleanEnv(void);

VOID AnyOffice_API_SetOnlyPubAccountOn(ULONG ulOnlyPubAccountFlag);

/*Begin modify by fanjiepeng on 2016-03-01,for ICBC POC*/
INT32 AnyOffice_API_getUserSwitchStatus(CHAR * pcUserName);
INT32 AnyOffice_API_getUserAccountStatus(CHAR * pcUserName);
/*End modify by fanjiepeng on 2016-03-01,for ICBC POC*/

VOID AnyOffice_API_SetLogCallBack(SVN_WriteLogCallback pfCallBackWriteLog);
typedef VOID (*TreatCACallback)();
VOID AnyOffice_API_SetCATreatCallback(TreatCACallback pfCallbackTreatCA);

/* BEGIN:Add by zhongyongcai for webos,2015-05-5*/
#ifdef ANYOFFICE_ATELIEROS
void AnyOffice_SDK_SetPackageName(char* pcPackageName);
#endif
/* END:Add by zhongyongcai for webos,2015-05-5*/


/*****************************************************************************
 函 数 名  : AnyOffice_API_Apply_Certificate
 功能描述  : 对外提供证书申请功能
 输入参数  : CSR_PRE_INFO_S *pstCsrPreInfo           
             SVN_CLIENTCERT_INFO_S **ppstClientCert  
 输出参数  : CSR_PRE_INFO_S *pstCsrPreInfo    
 返 回 值  : CSR_NO_MEMORY               1 内存申请失败
             CSR_ARG_ERR                 2 参数错误
             CSR_ERR_DN_TEMPLATE         3 DN模板错误
             CSR_ERR_GET_CONFIG          4 获取Configuration files失败
             CSR_HTTP_CON_ERR            5 http链接失败
             CSR_HTTP_RESPONSE_ERR       6 http response失败
 调用函数  : 
 被调函数  : 
 
 修改历史      :
  1.日    期   : 2015年7月10日
    作    者   : suyaodong
    修改内容   : 新生成函数

*****************************************************************************/
struct tag_CSR_PRE_INFO_S;
int AnyOffice_API_Apply_Certificate(struct tag_CSR_PRE_INFO_S  *pstCsrPreInfo,SVN_CLIENTCERT_INFO_S **pstClientCert );

/*****************************************************************************
 函 数 名  : AnyOffice_API_Check_Cert_Bind
 功能描述  : 检查客户端证书是否绑定
 输出参数  : 无
 返 回 值  : LONG
 调用函数  : 
 被调函数  : 
 
 修改历史      :
  1.日    期   : 2015年7月30日
    作    者   : suyaodong
    修改内容   : 新生成函数

*****************************************************************************/
LONG AnyOffice_API_Check_Cert_Bind();

#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */

#endif

