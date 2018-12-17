/******************************************************************************

                  ��Ȩ���� (C), 2001-2014, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : anyoffice_login.h
  �� �� ��   : ����
  ��    ��   : LiJingjin 90004727
  ��������   : 2014��5��6��
  ����޸�   :
  ��������   : ���ӹ������ӿ�
  �����б�   :
*
*
  �޸���ʷ   :
  1.��    ��   : 2014��5��6��
    ��    ��   : LiJingjin 90004727
    �޸�����   : �����ļ�

******************************************************************************/
#ifndef __ANYOFFICE_LOGIN_H__
#define __ANYOFFICE_LOGIN_H__

#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif
#endif /* __cplusplus */


/*----------------------------------------------*
 * ͷ�ļ�                                       *
 *----------------------------------------------*/
#include "tools_hash.h"
#include "tools_common.h"
#include "svn_define.h"


/*----------------------------------------------*
 * ��������                                     *
 *----------------------------------------------*/

/*----------------------------------------------*
 * �궨��                                       *
 *----------------------------------------------*/
#define ANYOFFICE_SDK_APPMODULE_ANYOFFICE   "home"
#define ANYOFFICE_SDK_APPMODULE_MAIL        "mail"
#define ANYOFFICE_SDK_APPMODULE_BROWSER     "browser"


/*----------------------------------------------*
 * ���ݽṹ����                                 *
 *----------------------------------------------*/

/* ��ʼ��ҵ��ʱ����ĵ����½��Ϣ���ýṹ��passwordΪ���ģ����������ڴ��г�פ */
typedef struct tagAnyOfficeUserInfo
{
    CHAR *pcDomainName;
    CHAR *pcUserName;
    CHAR *pcPassword;
    /* BEGIN: add by xwx213835, 2015/12/31   PN:DTS2016011208802 ���ݹ���poc���orgcode*/
    CHAR *pcAccount;
    CHAR *pcOrgCode;
    CHAR *pcOrgName;
    CHAR *pcCardID;
    /* END:   add by xwx213835, 2015/12/31 */

    /* BEGIN: add by f00291727, 2016/02/18   PN:DTS2016011208802���ݹ���*/
    CHAR* pcFullName;
    CHAR* pcPosition;
    CHAR* pcMobilePhoneNumber;
    CHAR* pcMemberOf;
    CHAR* pcDescription;

    //����POC
    CHAR* pcSsiAuth;
    CHAR* pcSsiSign;
    /* END: add by f00291727, 2016/02/18   PN:DTS2016011208802���ݹ���*/
    /*BEGIN: f00291727 2016-05-20*/
    CHAR* pcTicket;
    CHAR* pcServiceTicket;
    /*END: f00291727 2016-05-20*/

} ANYOFFICE_USER_INFO_S;

/* ��ʼ��ҵ��ʱ����ĵ����½��Ϣ,�ýṹ��tokenδ���ģ����������ڴ��г�פ */
typedef struct tagAnyOfficeSSOInfo
{
    CHAR *pcToken;
} ANYOFFICE_SSO_INFO_S;

typedef struct tagAnyOfficeGatewayInfo
{
    CHAR *pcInternetAddress;
    ULONG ulInternetPort;
    CHAR *pcIntranetAddress;
    ULONG ulIntranetPort;
} ANYOFFICE_GATEWAY_INFO_S;


#define ANYOFFICE_AUTOLOGIN_DEFAULT 999
#define ANYOFFICE_CONNECTTYPE_DEFAULT 999
typedef struct tagAnyofficeLoginParam
{
    CHAR  *pcServiceType;
    CHAR *pcUserType;         /* �û����� */
    CHAR *pcAppName;          /* Ӧ������ */
    ULONG ulUseSecureTransfer;
    ULONG ulAutoLoginType;   /* 1 enable ANYOFFICE_ENABLE , 0 disable  ANYOFFICE_DISABLE */
    ANYOFFICE_GATEWAY_INFO_S *pstGatewayInfo;
    ANYOFFICE_USER_INFO_S    *pstUserInfo;
    ANYOFFICE_SSO_INFO_S     *pstSSOInfo;
    ULONG ulConnectType;
    ULONG ulAuthGateway;
    ULONG ulTokenEnable;        /* �Ƿ�ʹ��token��֤ */
    /* BEGIN: Added by fengzhengyu, 2016/1/26  for:S44557(�������š��ͻ�ϣ��anyoffice������������Ŷ���֤ϵͳ�û�MDM��֤����)*/
    CHAR *pcSuffix;
    /* END:   Added by fengzhengyu, 2016/1/26 */
    CHAR *pcThirdPartDeviceID; /*������DeviceID*/
	int ulServiceType;
    
    //mdm check
    ULONG ulChekBindWhenLogin;
    /* BEGIN: Modified by ��̩�� 00218689, 2017/2/16   PN:IREQ00058303:�����ն�����license����ʵ��*/
    ULONG ulDisablecustomflag;/* ��½�����Ƿ�ǿ�Ʋ�Я��customization�ֶ� */
    /* END:   Modified by ��̩�� 00218689, 2017/2/16 */
    
} ANYOFFICE_LOGIN_PARAM_S;

/*----------------------------------------------*
 * �ⲿ����ԭ��˵��                             *
 *----------------------------------------------*/
/*
    ͬ���ӿڣ�ʵ�ֶԼ���SDK��Ӧ�õ���֤��ֻ��ͨ����֤��������ʹ��SDK����
*/
INT32 AnyOffice_API_DoAppAuthentication(ANYOFFICE_GATEWAY_INFO_S *pstGateway);

INT32 AnyOffice_API_DoGatewayAuthentication_Sync(
    ULONG ulAutoLogin,
    ANYOFFICE_LOGIN_PARAM_S *pstLoginParam);

INT32 AnyOffice_API_GetGatewayAuthenticationResult(HASH_S **ppstHash);

/*
* �������ϲ�ѯ�û����ԣ������Ƿ�ʹ�ð�ȫ��������úͲ��Ծ����Ƿ񴴽����
*/
#define ANYOFFICE_SECURE_TRANSFER_DISABLE 0
#define ANYOFFICE_SECURE_TRANSFER_ENABLE  1
INT32 AnyOffice_API_GetAppPolicy_Sync(
    ULONG ulUseSecureTransfer, CHAR **ppcPolicy);
INT32 AnyOffice_API_GetAppMdmPolicy_Sync(CHAR **ppcPolicy, ULONG *pulMdmPolicyEqualFlag);

INT32 AnyOffice_API_GetEmailAddress(CHAR **ppcEnailAddress);


INT32 AnyOffice_API_GetServiceTicket(CHAR **ppcServiceTicket);

/*
*  ��ѯ�Ự��Ϣ
*/
INT32 AnyOffice_API_GetSSOInfo(ANYOFFICE_SSO_INFO_S **ppstSSOInfo);

/*
*  ��ѯ�û���Ϣ
*/
INT32 AnyOffice_API_GetUserInfo(ANYOFFICE_USER_INFO_S **pstUserInfo);

/*
*  ��ѯ������Ϣ
*/
INT32 AnyOffice_API_GetGatewayInfo(ANYOFFICE_GATEWAY_INFO_S **ppstGatewayInfo);

/*
*  ��ȡ����������ͣ� ���ص�ǰ��������������
*/
#define ANYOFFICE_INNER_NETWORK     1      /* ��ǰ�ն˴������� */
#define ANYOFFICE_OUTER_NETWORK     2      /* ��ǰ�ն˴������� */
INT32 AnyOffice_API_GetNetworkAccessType();

/*
*  ��ѯSDK����ĵ�¼����
*/
INT32 AnyOffice_API_GetLoginParam(ANYOFFICE_LOGIN_PARAM_S** ppstLoginParam);

VOID AnyOffice_API_FreeLoginParam(ANYOFFICE_LOGIN_PARAM_S* pstLoginParam);


/*
*  ���Խ���
*/
typedef long (*ANYOFFICE_SDK_POLICY_CALL_BACK)(CHAR *pLableValue,int iValueLen);

typedef struct tagAnyOfficeSDKLableTOFunc
{
    ANYOFFICE_SDK_POLICY_CALL_BACK pPolicyCallback;         /*�ص�����*/
    CHAR *pcLableName;                                              /*��ǩ��*/
} ANYOFFICE_SDK_POLICY_FUNC;

INT32 AnyOffice_SDK_API_ParseAndSavePolicy(const CHAR* pcXmlStr,
        ANYOFFICE_SDK_POLICY_FUNC CALL_BACK[], int iCallFuncCnt);

typedef long (*ANYOFFICE_SDK_SESSION_UPDATE_CALL_BACK)(UCHAR * pucUserID, UCHAR * pucSessionID);

VOID AnyOffice_API_SetSessionUpdate_CAllback(
    ANYOFFICE_SDK_SESSION_UPDATE_CALL_BACK callbackSessionUpdate);

INT32 AnyOffice_API_LoginWithoutGatewayAuthentication(CHAR *pcUserName);


INT32 AnyOffice_API_RedoGatewayAuthentication();

INT32 AnyOffice_API_RefreshUser()
;

typedef struct tagAnyOfficeAppInfo
{
    CHAR *pcAppVersion;
    CHAR *pcIdentifier;
    CHAR *pcName;
    CHAR *pcAppSize;
    CHAR *pcPackageUrl;
    CHAR *pcIconUrl;
    CHAR *pcDescription;
    ULONG ulPackageSize;
} ANYOFFICE_APP_INFO_S;

INT32 AnyOffice_API_CheckAppVersionUpdate(
    CHAR *pcAppID, CHAR *pcVersionNO, int languageType,char ** jsonAppInfo);

INT32 AnyOffice_API_GetCertificate(
    CHAR *pcUserName, CHAR **cert, ULONG *puSize, CHAR **ppcPassword);

/* BEGIN: Modified by zhangtailei 00218689, 2015/4/2   PN:�޸������iOSû����ת�����ص�½����*/
void AnyOffice_API_ClearToKen(void);
/* END:   Modified by zhangtailei 00218689, 2015/4/2 */

/* BEGIN:Add by zhongyongcai for webos,2015-04-29 */
#ifdef ANYOFFICE_ATELIEROS
VOID AnyOffice_Login_FreeUserInfo(ANYOFFICE_USER_INFO_S* pstUserInfo);
#endif
/* END:Add by zhongyongcai for webos,2015-04-29 */

/*****************************************************************************
 �� �� ��  : AnyOffice_API_SetClientCert
 ��������  : ������������Ŀͻ���֤�鵽keyspace
 �������  : SVN_CLIENTCERT_INFO_S *pstClientCert
 �������  : ��
 �� �� ֵ  : LONG
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2015��7��17��
    ��    ��   : suyaodong
    �޸�����   : �����ɺ���

*****************************************************************************/
LONG  AnyOffice_API_SetClientCert(SVN_CLIENTCERT_INFO_S *pstClientCert );

/*****************************************************************************
 �� �� ��  : AnyOffice_API_GetClientCert
 ��������  : ��ȡsandbox�б���Ŀͻ���֤��
 �������  : SVN_CLIENTCERT_INFO_S * pstClientCert
 �������  : ��
 �� �� ֵ  : ULONG
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2015��7��17��
    ��    ��   : suyaodong
    �޸�����   : �����ɺ���

*****************************************************************************/
ULONG  AnyOffice_API_GetClientCert(SVN_CLIENTCERT_INFO_S * pstClientCert);
ULONG  AnyOffice_SDK_GetClientCert(SVN_CLIENTCERT_INFO_S * pstClientCert);

/*****************************************************************************
 �� �� ��  : AnyOffice_API_DeleteClientCert
 ��������  : ɾ�����������֤�飨�������豸���
 �������  : ��
 �� �� ֵ  : ULONG
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2015��7��17��
    ��    ��   : suyaodong
    �޸�����   : �����ɺ���

*****************************************************************************/
ULONG  AnyOffice_API_DeleteClientCert();
/*�ͷ�֤���ڲ��洢����*/
#define AnyOffice_Free_Client_Cert(cert) \
    do \
    {    \
        ANYOFFICE_SAFE_FREE(cert.pucClientCert);\
        ANYOFFICE_SAFE_FREE(cert.pucPrivatekey);\
        ANYOFFICE_SAFE_FREE(cert.pszPrivateKeyPwd);\
    }\
    while(0)
#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */

#endif


