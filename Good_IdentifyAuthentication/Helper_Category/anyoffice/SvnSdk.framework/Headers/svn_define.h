#ifndef __SVN_DEFINE_H__
#define __SVN_DEFINE_H__


#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif
#endif /* __cplusplus */

/* BEGIN: Added for PN:�ڴ��Ż� by huangyiyuan hkf60364, 2013/5/10 */
/* BEGIN: Added for PN:xxxxx by zhaixianqi 90006553, 2012/9/13 */
#define SVN_MAX_MEMORY 6
/* END:   Added for PN:xxxxx by zhaixianqi 90006553, 2012/9/13 */
/* END:   Added for PN:�ڴ��Ż� by huangyiyuan hkf60364, 2012/5/10 */



/* �ͻ���֧�ֵ������������Ϣ */
#define SVN_MAX_PROXY_URL_LEN               128     /* ���������IP��󳤶� */
#define SVN_MAX_PROXY_USERNAME_LEN          256     /* �����û�����󳤶� */
#define SVN_MAX_PROXY_USERPWD_LEN           256     /* ����������󳤶� */
#define SVN_MAX_PROXY_DOMAIN_LEN            128     /* ������󳤶� */

/* BEGIN: Added by fengzhengyu, 2016/2/26 */
#define SVN_MAX_APP_ID_LEN                  128     /*APP ID����󳤶�*/
#define SVN_MAX_APP_PKEY_LEN                64     /*APP ǩ����Կ����󳤶�*/
/* END:   Added by fengzhengyu, 2016/2/26 */

/*BEGIN: f00291727 2016-05-20*/
#define SVN_MAX_USER_TYPE_LEN             64
#define SVN_MAX_TICKET_LEN                64
#define SVN_MAX_SERVICE_TICKET_LEN                64
/*End: f00291727 2016-05-20*/
/* BEGIN: Added by zwx316192, 2017/07/05 for:�Ϻ����У�ͳһ��֤�Ĵ��������� */
#define SVN_MAX_ERRMESSAGE_LEN                256
/* END: Added by zwx316192, 2017/07/05 */

/* APN���ֵ���󳤶� */
#define SVN_MAX_APNNAME_LEN                 128     /* APN����󳤶� */

/* �û���֤id����󳤶� */
/* BEGIN: Modefied by liushangshu WX80847 for ����������SDK����, 2013/8/1 */
#define SVN_MAX_AUTH_ID_LEN                 64
/* END: Modefied by liushangshu WX80847 for ����������SDK����, 2013/8/1 */


/* SVN����֧�ֵ�����û��������볤�� */
/* BEGIN: Modified by zhaixianqi 90006553, 2013/11/30 for
    GBKתUTF8������ٽ���URL���룬�ַ�ת�����󳤶�Ϊ 62/2*3*3 + 3 = 282
    ���ⵥ��:DTS2013112611858 */
#define SVN_MAX_USERNAME_LEN            (63 * 3 * 3 + 1)      /* SVN�����û�����󳤶� 568 */
/* END:   Modified by zhaixianqi 90006553, 2013/11/30 */
#define SVN_MAX_USERPWD_LEN             (64+4)  /* SVN����������󳤶�Ϊ64��4�ֽڶ��䣬����68*/
#define SVN_MAX_URL_LEN                 128     /* ����������󳤶� */
/* BEGIN: Added by liushangshu WX80847 for ����������SDK����, 2013/5/7 */
#define SVN_MAX_APP_NAME_LEN            256     /*�ͻ�Ӧ������󳤶�*/
#define SVN_MAX_DEVICE_ID_LEN           64     /*�ͻ�deviceid��󳤶�*/
/* END: Added by liushangshu WX80847 for ����������SDK����, 2013/5/7 */
#define SVN_MAX_ICON_LEN                256

#define SVN_TOKEN_MAX_LEN 68
    
#define SVN_MAX_SERVER_TYPE_LEN        4

/* BEGIN: Added by liushangshu WX80847 for ����������SDK����, 2013/7/25 */
#define SVN_CONNECT_TYPE_E2E           3      /*�˵�����������*/
#define SVN_CONNECT_TYPE_MTM           2      /*�����Ķ�ý���������*/
#define SVN_CONNECT_TYPE_ANYOFFICE     1      /*Anyoffice ����*/
#define SVN_CONNECT_TYPE_SDK           0      /*SDK ����*/
/* END: Added by liushangshu WX80847 for ����������SDK����, 2013/7/25 */


/* ��������ʱ�����������󷵻���Ϊ10�� */
#define SVN_MAX_URL_NUM                 10

/* �������ģʽ*/
#define SVN_TUNNEL_MODE_DTLS            0       /* ���ģʽDTLS */
#define SVN_TUNNEL_MODE_TLS             1       /* ���ģʽTLS */
#define SVN_TUNNEL_MODE_UDP             2       /* ���ģʽUDP */
#define SVN_TUNNEL_MODE_UDPS            3       /* ���ģʽTLS + UDPS */

/*BEGIN:Add by liushangshu for Tcp over Udp.2013.06.06*/
/*TCP OVER�UUDP����*/
#define SVN_UDP_OVER_UDP_OFF            0       /* TCP OVER�UUDP�� */
#define SVN_UDP_OVER_UDP_ON             1       /* TCP OVER�UUDP�� */
/*END:Add by liushangshu for Tcp over Udp.2013.06.06*/

/* �����ʼ�����Ʋ������� */
#define SVN_ENV_CONTROL_TYPE_MEN_SIZE   1       /* �����ʼ��ʱ��������ڴ��С��������ֵ */
#define SVN_ENV_CONTROL_TYEP_SSL_TIME    2      /*SSL���ֳ�ʱʱ�䣬��λS*/

/* �����ʼ�����Ʋ����ṹ�壬���������������Ʋ����Ķ�Ӧֵ�����ڸýṹ������չ������ʹ��ʱ�����ݿ��Ʋ�����������ȡֵ */
typedef struct tagSVNInitConctrolInfo
{
    unsigned  long ulMemorySize;                /* ��ʼ��ʱ��Ҫ������ڴ��С����λMB����С3�����6 */
    int iSslConnTimeout;         /*SSL���ֳ�ʱʱ������*/
} SVN_INIT_CONTROL_S;


#define WM_SVN_MESSAGE_TYPE_BASE         0x1000    /* Windows״̬֪ͨ��Ϣ���͵Ļ���ƫ��ֵ�����ڼ���Windows��Ϣ֪ͨ���������״̬�Ķ�Ӧ��ϵ */

/*----------------------------SVN���״̬����-----------------------------*/
/* SVN���״̬��׼���壨�����ڳ�Windows��ĸ�ƽ̨�� */
#define SVN_STATUS_OFFLINE              0x0       /* ��ʾ��������� */
#define SVN_STATUS_ONLINE               0x1       /* ��ʾ�������   */
#define SVN_STATUS_CONNECTING           0x2       /* ��ʾ���ڵ�¼��ע����������У������ڽ���������� */

/* Windowsƽ̨��SVN���״̬���� ��Windowsƽ̨�±���ʹ�����¶��壩*/
#define WM_SVN_STATUS_OFFLINE           (WM_SVN_MESSAGE_TYPE_BASE + SVN_STATUS_OFFLINE)        /* windowsƽ̨�£���������� */
#define WM_SVN_STATUS_ONLINE            (WM_SVN_MESSAGE_TYPE_BASE + SVN_STATUS_ONLINE)         /* windowsƽ̨�£�������� */
#define WM_SVN_STATUS_CONNECTING        (WM_SVN_MESSAGE_TYPE_BASE + SVN_STATUS_CONNECTING)     /* windowsƽ̨�£���ʾ���ڵ�¼��ע����������У������ڽ���������� */
/*-----------------------------------------------------------------------*/


/* �������֪ͨ��Ϣ������,�����Ϣ֪ͨ�ص���������ʱʹ�� */
typedef enum enNEM_NotifyState
{
    SVN_NOTIFY_STATUS                 = 0,  /* SVN���״̬֪ͨ��Ϣ ,���״̬�����仯ʱ֪ͨ��ǰ���״̬����Ӧ������ */
    SVN_NOTIFY_USER_LOCK              = 1   /* �û���¼�������ʱ�����������ᱻSVN��ȫ�豸�����û�����֪ͨ�ϲ㣬����ʣ�ೢ�Դ��� */

} SVN_NOTIFY_STATE_EN;


/* ��������õļ��ִ����� */
#define SVN_TCP_CONNECT_ERR             -1      /* ����TCP����ʧ�ܣ������������Ӻ����صĵ�ַ�Ͷ˿��Ƿ���ȷ�������ƶ��ն���Ҫȷ�������Ѽ��� */
#define SVN_PROXY_CONNECT_ERR           -2      /* ��������������ʧ�ܣ���������ʹ����������ַ�Ͷ˿��Ƿ���ȷ */
#define SVN_PROXY_INFO_ERR              -3      /* ������Ϣ������������û��������롢����Ϣ�Ƿ���ȷ */
#define SVN_TLS_HANDSHAKE_ERR           -4      /* TLS����ʧ��*/
#define SVN_USER_INFO_ERR               -5      /* ��¼SVN���û������������ */
#define SVN_VIP_UNAVAILABLE             -6      /* �޷���ȡ����IP */
#define SVN_USER_EXCEED_LIMIT           -7      /* �û����ﵽ���� */
#define SVN_USER_IP_DENY                -8      /* �û�IP���� */
#define SVN_TUNNEL_DISABLED             -9      /* ��ý���������δ���� */
#define SVN_USERID_INVALID              -10     /* �û�ID��Ч */
#define SVN_TUNNEL_CLOSED               -11     /* ����رգ��û���������*/
#define SVN_UDPS_TUNNEL_BLOCK           -12     /* ��¼SVN����ʱ,UDP���̽�ⳬʱʧ��,��������״�� */
#define SVN_SERVER_VERIFY_FAILED        -13     /* ��¼SVN����ʱ,������֤���CA��ƥ��,У��ʧ�� */
#define SVN_VERIFY_CLIENT_CERT_ERR      -14     /* ��¼SVN����ʱ,�ͻ���֤�鲻ƥ��,У��ʧ�� */
#define SVN_USER_LOCKED                 -15     /* �û����������޷���¼ */
#define SVN_USER_AUTH_ID_ERR            -16     /* auth id��ʽ��¼��ʽ���û�����auth id��ƥ�䣬�޷���¼ */
#define SVN_USER_AUTH_CERT_NOT_MATCH    -17     /* �ͻ���֤��Ͱ�֤�鲻ƥ�� */
#define SVN_USER_AUTH_MDM_SERVER_ERR    -18     /* MDM Server ���� */
#define SVN_USER_AUTH_MDM_NOT_APPROVED  -19     /* �ն˲����ڻ���δ���� */
#define SVN_USER_AUTH_MDM_REGISTER_LIMIT -20    /* �û���ע���ն��������� */
#define SVN_USER_AUTH_APP_AUTH_FAILED    -21    /* Ӧ��У��ʧ�� */
#define SVN_USER_AUTH_ACCOUNT_FROZEN     -22    /* The Accout was frozen */
/*begin: add by chenfeng 90004813 for */
#define SVN_USER_AUTH_THIRDPART_DEVICEID_ERR  -23    /* ThirdPart Device auth err */
#define SVN_USER_AUTH_RAIDUS_RELAY_ERR        -24 /* third part radius auth failed */
/*end: add by chenfeng 90004813 for */
#define SVN_USER_AUTH_ACCOUNT_SPECIFICATION_ERROR -30    /* ʵʱ��֤�˺Ź��У������ */
#define SVN_USER_AUTH_ACCOUNT_RELOGIN_ERROR -31    /* ���û����ն�ͬʱ��½ */
#define SVN_GATEWAY_EXCEPTION           -99     /* ���������쳣 */
#define SVN_SYSTEM_EXCEPTION            -100    /* ��������쳣 */
#define SVN_CFCA_CERT_REVOKED           -101   /*The certificate is revoked*/
#define SVN_OCSP_CERT_REVOKED           -102   /*The certificate is revoked*/
/* BEGIN: Modified by ��̩�� 00218689, 2017/5/26   ���ⵥ��:S216907 ������Ҫ�޸����������*/
#define SVN_NEED_RESET_PWD              -103   /*������Ҫ����*/
/* END:   Modified by ��̩�� 00218689, 2017/5/26 */

/* BEGIN: Added by zwx316192, 2017/07/05 for:�Ϻ����У�ͳһ��֤�Ĵ��������� */
#define SVN_USER_LOGIN_THRIDPATY_ERR  -100001           /*����������*/
/* END: Added by zwx316192, 2017/07/05 */

/* �ӽ��ܽӿڴ����붨�� */
#define SVN_CRYPT_PARAMETER_ERR         2000    /* �ӽ�����δ���ULONGֵ */
#define SVN_CRYPT_MEMORY_ERR            2001    /* �ӽ��ܺ����BUFF���Ȳ��㣬ULONGֵ */
#define SVN_CRYPT_APPAUTH_ERR           2002    /* Ӧ��У��ʧ�ܲ�������üӽ��ܽӿ�*/



/* ������붨�� */
#define SVN_OK              0       /* �� */
#define SVN_ERR             1       /* ���� */
#define SVN_ERR_PARAM       2       /* ����������� */
#define SVN_ERR_EXIST       3       /* �Ѿ���ҵ�������У�DLL��ؼ��������ͻ��˻��� */

/* BOOL���Ͷ��� */
#define SVN_TRUE            1
#define SVN_FALSE           0



/* �������� */
#define SVN_PROXY_NONE      0      /* ��ʹ�ô���*/
#define SVN_PROXY_HTTP      1      /* ʹ��HTTP���� */
#define SVN_PROXY_SOCKS5    2      /* ʹ��SOCK5���� */
#define SVN_PROXY_UNKNOWN   3      /* ʹ��δ֪���� */

#define MTM_KEEPALIVE_INITIAL   0
#define MTM_KEEPALIVE_SUCCESSED 1
#define MTM_KEEPALIVE_FAILED    2


/* ������Ϣ */
typedef struct tagSVNProxyInfo
{
    char            acProxyUrl[SVN_MAX_PROXY_URL_LEN];              /* ���������IP������ */
    unsigned short  usProxyPort;                                    /* ����������˿� */
    unsigned short  usProxyType;                                    /* �������ͣ�SYS_PROXY_NO/SYS_PROXY_HTTP/SYS_PROXY_SOCKS5 */
    char            acProxyUserName[SVN_MAX_PROXY_USERNAME_LEN];    /* �����û��� */
    char            acProxyPassword[SVN_MAX_PROXY_USERPWD_LEN];     /* �������� */
    char            acProxyDomain[SVN_MAX_PROXY_DOMAIN_LEN];        /* ��֤���� */
} SVN_PROXY_INFO_S;

#define MAX_INFO_ITEM_LEN 64
typedef struct enInfoByServiceTicket
{
    char acEmpid[MAX_INFO_ITEM_LEN];
    char acOdlempid[MAX_INFO_ITEM_LEN];
    char acUid[MAX_INFO_ITEM_LEN];
} INFO_BY_SERVICETICKET;

/*ע����Ӧ�ص�����*/
typedef int (*SVN_StatusCallback)(unsigned int uiStatus, int iErrorCode);

/*ע��svn�汾�Żص�����*/
typedef void (*SVN_EntryVersionCallback)(unsigned char *pucEntryVersion);

/* �����Ϣ֪ͨ�ص����� */
typedef int (*SVN_StatusNotifyCallback)(unsigned int iMessageType, void* pWPara, void* pLPara);


/* ��־�ص�����ָ�� */
typedef int (*SVN_WriteLogCallback) (unsigned char *pucLog, unsigned long ulLogLen, unsigned long ulLogLevel);

/* Ping�ص�����ָ�� */
typedef void (*SVN_PingCallback) (unsigned char *pucPingBuffer);

/* Traceroute�ص�����ָ�� */
typedef void (*SVN_TracertCallback) (unsigned char *pucTracertBuffer);

/* BEGIN: Modified for ���ⵥ��:L4VPN֧��DNS������������ by y90004712, 2013/11/26 */
/* ���������ص�����ָ�룬�������ϲ㴫�ݽ���������� */
typedef void (*SVN_ParseURLCallback) (unsigned int ulIP[SVN_MAX_URL_NUM], void *pvData);
/* END:   Modified by y90004712, 2013/11/26 */
typedef  void (*SVN_GetServiceTicketCallback) (unsigned long ret, unsigned char * serviceTicket);
typedef void (*SVN_GetInfoByServiceTicketCallBack)(INFO_BY_SERVICETICKET  stInfoByServiceTicket);

typedef void (*MTM_KeepAliveCallback)();
/*ע����Ϣ*/
typedef struct tagSVNRegisterInfo
{
    SVN_StatusCallback    pfStatusCallback;                   /* ��windowsƽ̨Ϊ����״̬֪ͨ�Ĵ��ھ����������ƽ̨Ϊ״̬֪ͨ�ص�����ָ�� */
    SVN_WriteLogCallback  pfWriteLogCallback;                 /* ��־����ص�����ָ�� */
    char                  acServerURL[SVN_MAX_URL_LEN];       /* ���ص�ַ�����磺9.1.1.3 �� www.abc.com */
    unsigned short        usServerPort;                       /* ���صĶ˿� */
    unsigned short        usTunnelMode;                       /* ���ģʽ */
    char                  acUserName[SVN_MAX_USERNAME_LEN];   /* ע��SVN�����û��� */
    char                  acPassword[SVN_MAX_USERPWD_LEN];    /* ע��SVN��������  */
    unsigned int          ulAPNID;                            /* APN��ID��ֻ����symbianƽ̨��Ч */
    char                  acAPNName[SVN_MAX_APNNAME_LEN];     /* APN���֣�ֻ����symbianƽ̨��Ч */
    char                  acAuthId[SVN_MAX_AUTH_ID_LEN];      /* �û���֤id */
    SVN_PROXY_INFO_S      stProxyInfo;                        /* ������Ϣ�ṹ */
    /* BEGIN: Added by liushangshu WX80847 for ����������SDK����, 2013/5/7 */
    char                  acAPPName[SVN_MAX_APP_NAME_LEN];    /*Ӧ����*/
    char                  acDeviceID[SVN_MAX_DEVICE_ID_LEN];       /*�豸ID*/
    /* END: Added by liushangshu WX80847 for ����������SDK����, 2013/5/7 */

    unsigned char         aucToken[SVN_TOKEN_MAX_LEN];

    /* BEGIN: Added by liushangshu WX80847 for ����������SDK����, 2013/7/25 */
    unsigned int          ulConnectType ;
    /* END: Added by liushangshu WX80847 for ����������SDK����, 2013/7/25 */
    /* BEGIN: Modified by ��̩�� 00218689, 2017/2/20   PN:IREQ00058303:�����ն�����license����ʵ��*/
    unsigned int         uiCustomization;       /* �Ƿ����ն� */  
    /* END:   Modified by ��̩�� 00218689, 2017/2/20 */
    
    /* BEGIN: Added by chenfeng 90004813 for ����svn�豸�汾��, 2015-4-17 */
    SVN_EntryVersionCallback pfEntryVersionCallback;
    /* END: Added by chenfeng 90004813 for ����svn�豸�汾��, 2015-4-17 */
    unsigned char                  aucAppID[SVN_MAX_APP_ID_LEN];
    unsigned char                  aucAppPKey[SVN_MAX_APP_PKEY_LEN];

    /*BEGIN: f00291727 2016-05-20*/
    char                  acUserType[SVN_MAX_USER_TYPE_LEN];
    char                  acTicket[SVN_MAX_TICKET_LEN];
    /*END: f00291727 2016-05-20*/

    /*begin: add by chenfeng 90004813 for third part device id huawei it */
    char acThirdPartDeviceID[SVN_MAX_DEVICE_ID_LEN];   
    /*end: add by chenfeng 90004813 for third part device id huawei it */
    
    /*f00291727 server type*/
    unsigned long ulServiceType;
    unsigned int  iUseAppVPN;
} SVN_REGISTER_INFO_S;

typedef struct tag_SVN_KEEPALIVE_PARAM_S
{
    unsigned int timeout;
    void *pvData;
    void (*pfKeepaliveStatus)(void *, unsigned long);
}SVN_KEEPALIVE_PARAM_S;

/* ��Ϲ�������궨�� */
#define SVN_SWITCH_STATE_ON            1  /* ��Ͽ���Ϊ�� */
#define SVN_SWITCH_STATE_OFF           0  /* ��Ͽ���Ϊ�� */



/* ������־���� */
#define SVN_ERR_LOG         1    /* �����޷�������ɲ��������������쳣�Ͽ��������շ��쳣���ڴ�����ʧ�ܡ���μ������ */

#define SVN_WARN_LOG        2    /* ����һ���쳣��֧�������������������������û�������������ն˰�ȫ�������߳������˳����������ߵ� */

#define SVN_NOTICE_LOG      3    /* �ճ�������ʾ��Ϣ������ͻ��˵�¼���˳���־ */

#define SVN_DEBUG_LOG       4    /* ������Ϣ����ӡ�Ƚ�Ƶ������ӡ���ݶ࣬���籨�����ݴ�ӡ��������ڳ���׷����־�� */


/* ͳ������ģ��ṹ�嶨�� */
typedef struct tagSVNStatisticInfo
{
    unsigned long ulVSockRecvTCPLen;        /*���յ�TCP�������ݳ��ȣ������TCP����ͨ�Žӿڴ�ͳ��*/

    unsigned long ulVSockSendTCPLen;        /*���͵�TCP�������ݳ��ȣ������TCP����ͨ�Žӿڴ�ͳ��*/

    unsigned long ulVSockRecvUDPPktNum;     /*���յ�UDP���ĸ����������UDP����ͨ�Žӿ���ͳ��*/

    unsigned long ulVSockSendUDPPktNum;     /*���͵�UDP���ĸ����������UDP����ͨ�Žӿ���ͳ��*/

    unsigned long ulSockRecvUDPPktNum;      /*���յ�UDP���ĸ������ڵ��ò���ϵͳUDPͨ�Žӿڴ�ͳ��*/

    unsigned long ulSockSendUDPPktNum;      /*���͵�UDP���ĸ������ڵ��ò���ϵͳUDPͨ�Žӿڴ�ͳ��*/

    unsigned long ulSockSendUDPSpeed;       /*����UDP���ĵ����ʣ��ڵ��ò���ϵͳUDPͨ�Žӿڴ�ͳ��*/

    unsigned long ulSockRecvUDPSpeed;       /*����UDP���ĵ����ʣ��ڵ��ò���ϵͳUDPͨ�Žӿڴ�ͳ��*/

    unsigned long ulTLSConnTimes;           /* TLS���ӽ���������� */

    unsigned long ulTLSConnFailTimes;       /* TLS����ʧ�ܴ��� */

    unsigned long ulTLSReConnTimes;         /* TLS�ؽ����� */

    unsigned long ulTLSReConnFailTimes;     /* TLS�ؽ�ʧ�ܵĴ��� */

    unsigned long ulRecvRTPDelay;           /* RTP�����������ʱ��ͳ�� ��λ������ */

    unsigned long ulSendRTPDelay;           /* RTP�����������ʱ��ͳ�� ��λ������ */

    unsigned long ulFreeMem;                /* ��������ڴ� ��λ KByte */

    unsigned long ulUsedMem;                /* ���ʹ���ڴ� ��λ KByte */

} SVN_STATISTIC_INFO_S;

/* ֤�鵼������붨�� */
#define SVN_ERR_NO_KEY              21     /* û��˽Կ */
#define SVN_ERR_TYPE_MISMATCH       22     /* ֤���˽Կ���Ͳ�ƥ�� */
#define SVN_ERR_VALUE_MISMATCH      23     /* ֤���˽Կ���ݲ�ƥ�� */
#define SVN_ERR_UNKNOWN_TYPE        24     /* ����ʶ������� */
#define SVN_ERR_CN_MISMATCH         25     /* �ͻ���֤���е�CN�ʹ����CN��ƥ�� */

#define SVN_ERR_CA_IMPORT_SIZE_ERROR        26 /* �����ļ���֤���С����3k */
#define SVN_ERR_CA_IMPORT_ERROR             27 /* ����֤��ʧ�� */
#define SVN_ERR_CA_IMPORT_NUM_LIMIT_ERROR   28 /* ϵͳCA֤�����Ѵ����� */
#define SVN_ERR_CA_IMPORT_LEVEL_LIMIT_ERROR 29 /* ����֤�鼶������10 */
#define SVN_ERR_CA_IMPORT_VALUE_ERROR       30 /* ����֤�����ݷǷ�*/


/* ֧�ֵĿͻ���֤������:PEM.DER.PKCS12 */
#define SVN_CERT_PEM           1
#define SVN_CERT_DER           2
#define SVN_CERT_PKCS12        3

/* ֧�ֵĿͻ���˽Կ����:PEM.DER */
#define SVN_PRIVATEKEY_PEM     1
#define SVN_PRIVATEKEY_DER     2

/* ֧�ֵķ����CA֤������:PEM.DER.PKCS7 */
#define SVN_CACERT_PEM         1
#define SVN_CACERT_DER         2
#define SVN_CACERT_PKCS7       3

/* RSA˽Կ������Կ����󳤶�(DES_CBC�����㷨) */
#define SVN_MAX_RSA_PWD_LEN     256

/* CA֤��ļ������� */
#define SVN_CA_LEVEL_NUM        9

/* ������豸CA֤������޶� */
#define SVN_CERTIFICATE_NUM     80

/* ����֤�飨�����ͻ���֤���Լ�CA֤�飩���ݳ����޶� */
#define SVN_CERTIFICATE_MAX_LEN     (3*1024)


/* RSA��Կλ��:�ֽ� */
#define SVN_RSA_KeyBits_512     512
#define SVN_RSA_KeyBits_1024    1024
#define SVN_RSA_KeyBits_2048    2048
#define SVN_RSA_KeyBits_4096    4096

/* ��ɫ���:����֤��������ݽṹ�嶨�� */
typedef struct tagEntry
{
    char *key;      /* �ؼ��֣����ڵ�������ʱ����ʵ���� */
    char *value;    /* ���ݣ�������䵽ʵ���� */
} SVN_CERT_ENTRY_S;


/* ��ɫ���:�ͻ���֤��ṹ�嶨�� */
typedef struct tagSVNClientCertInfoInput
{
    unsigned char          *pucClientCert;       /* ��ɫ�ͻ���֤������Buffer */
    unsigned char          *pucPrivatekey;       /* ��ɫ�ͻ���֤���Ӧ��˽Կ����Buffer */
    unsigned long          ulClientCertLen;      /* ֤�鳤�ȣ��ֽ�����*/
    unsigned long          ulPrivateKeyLen;      /* ˽Կ���ȣ��ֽ�����*/
    unsigned short         usClientCertType;     /* ֤���ʽ���� */
    unsigned short         usPrivateKeyType;     /* ˽Կ��ʽ���� */
    unsigned char          *pszPrivateKeyPwd;    /* �������루����������ô˱������������NULL��*/
} SVN_CLIENTCERT_INFO_S;


/* ��ɫ���:�豸CA֤��ṹ�嶨�� */
typedef struct tagSVNServerCACertInfoInput
{
    struct tagSVNServerCACertInfoInput  *pstServerCACertNext;  /* ָ����һ��CA֤���� */
    unsigned char                       *pszServerCACert;      /* �����CA֤�飨��������Buffer */
    unsigned long                       ulServerCACertLen;     /* Buffer���ȣ��ֽ�����*/
    unsigned short                      usServerCACertType;    /* CA֤���ʽ���� */
    unsigned short                      usReserve;             /* Ϊ�ֽڶ��룬���ñ���λ */
} SVN_SERVERCACERT_INFO_S;

/* ���״̬������ṹ�� */
typedef struct tagSVNTunnelStatusInfo
{
    unsigned int    uiStatus;       /* ���״̬ */
    int             iErrorCode;     /* ������ */
} SVN_TUNNEL_STATUS_NOTIFY_S;

/* �û�������Ϣ�ṹ�嶨�� */
typedef struct tagSVNUserLockInfo
{
    unsigned char ucRemanentTimes;  /* �û�����ʣ�ೢ�Դ��� */
} SVN_USER_LOCK_NOTIFY_S;
/*BEGIN: add by tianxin KF35598 2012-8-7*/
typedef unsigned long (*SVN_RegFuc)(unsigned char* , unsigned short);
typedef struct tagSvnCallbackOps
{
    unsigned char ucRegFlags;
    SVN_RegFuc pfProcessFuc;
} CMTM_SVN_CALLBACKOPS_S;
/*END: add by tianxin KF35598 2012-8-7*/
#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */

#endif /* __SVN_DEFINE_H__ */
