#ifndef __ANYOFFICE_HTTP_CLIENT_H__
#define __ANYOFFICE_HTTP_CLIENT_H__
/******************************************************************************

                  ��Ȩ���� (C), 2001-2014, ��Ϊ�������޹�˾

******************************************************************************
  �� �� ��   : anyoffice_httpclient.h
  �� �� ��   : ����
  ��    ��   : zhangyantao 00103873
  ��������   : 2014��7��18��
  ����޸�   :
  ��������   : HTTP �ͻ��ˣ����������HTTPSͨ��
  �����б�   :
  �޸���ʷ   :
  1.��    ��   : 2014��7��18��
    ��    ��   : zhangyantao 00103873
    �޸�����   : �����ļ�
******************************************************************************/
#include "tools_common.h"

#include "tools_string.h"

#ifdef __cplusplus
extern "C" {
#endif


#define HTTP_CLIENT_URL_MAX_LENGTH  1024

#define HTTP_CLIENT_METHOD_POST     0
#define HTTP_CLIENT_METHOD_OPTION   1
#define HTTP_CLIENT_METHOD_PUT      2
#define HTTP_CLIENT_METHOD_GET      3

#define HTTP_CLIENT_HEAD_TYPE_CONTENTTYPE           "Content-Type"
#define HTTP_CLIENT_HEAD_TYPE_CONTENTLENGTH         "Content-Length"
#define HTTP_CLIENT_HEAD_TYPE_AUTHORIZATION         "Authorization"
#define HTTP_CLIENT_HEAD_TYPE_USERAGENT             "User-Agent"
#define HTTP_CLIENT_HEAD_TYPE_HOST                  "Host"
#define HTTP_CLIENT_HEAD_TYPE_CONNECTION            "Connection"

#define HTTP_CLIENT_HEAD_VALUE_TEXT                 "txt/html"
//˫��У�����ϵͳ��ʶ
#define HTTP_CLIENT_OS_VALUE_ANDROID                 1
#define HTTP_CLIENT_OS_VALUE_IOS                      0
//�û�֤�飬�豸֤��
#define HTTP_CLIENT_OS_DEVICE_CERT                 0
#define HTTP_CLIENT_OS_USER_CERT                      1

#define HTTP_CLIENT_STATUS_OK                      200
#define HTTP_CLIENT_STATUS_PARTIAL_CONTENT         206
#define HTTP_CLIENT_STATUS_LOCATION_RESPONSE       301        /*�����ض���*/
#define HTTP_CLIENT_STATUS_TEMPLOCATION_RESPONSE   302        /*�����ض���*/
#define HTTP_CLIENT_STATUS_PAGE_NOTFOUND           404        /*ҳ�治����*/

/* HTTPͷ����������ͷ����Ӧͷ��ʹ�øýṹ */
typedef struct tagHttpClientVRBList
{
    CHAR                        *pcType;  /* ͷ���ͣ���Content-Type */
    CHAR                        *pcValue; /* ͷ��ֵ����application/vnd.ms-sync.wbxml */
    struct tagHttpClientVRBList *pNext;       /* ������һ��ͷ�ڵ� */
} HTTP_CLIENT_VRB_LIST_S;

/* HTTP ������ */
typedef struct tagHttpClientRequestLine
{
    ULONG ulMethod;     /* ���󷽷�����POST,OPTIONS */
    ULONG ulSSLEnable;
    ULONG ulPort;
    ULONG ulAppendSessionInfo;  /*URL���Ƿ����*/
    CHAR  *pcURL;        /* ������URL����֧���ض������Ӧֱ�ӽ��д��� */
    CHAR  *pcHost;       /* Host, */
    CHAR  *pcPath;
    CHAR  *pcServiceType;  /* ҵ������ */
    HTTP_CLIENT_VRB_LIST_S *pstParamList;  /* �����б� */
} HTTP_CLIENT_REQUEST_LINE_S;


/* HTTP��Ϣ��ṹ */
typedef struct tagHttpClientBody
{
    ULONG      ulContentLen;   /* http��Ӧͷ�е�content-length���� */
    ULONG      ulBodyLen;      /* ��Ϣ�峤�� */
    CHAR       *pcbody;        /* ��Ϣ������ */
} HTTP_CLIENT_BODY_S;



/* HTTP������Ϣ�ṹ */
typedef struct tagHttpClientRequest
{
    HTTP_CLIENT_REQUEST_LINE_S    *pstReqLine;   /* HTTP ������ */
    HTTP_CLIENT_VRB_LIST_S        *pstHeadList;  /* HTTPͷ������ */
    HTTP_CLIENT_BODY_S            stHttpBody;    /* HTTP��Ϣ�� */
} HTTP_CLIENT_REQUEST_S;

typedef struct tagHttpClientResponse
{
    ULONG                        ulStatusCode;   /* HTTP״̬�� */
    CHAR                         *pcRedirectURL;
    HTTP_CLIENT_VRB_LIST_S       *pstHeadList;   /* HTTPͷ������ */
    struct http_slist            *pstCookies;  /*��Ӧcookie*/
    HTTP_CLIENT_BODY_S           stHttpBody;     /* HTTP��Ϣ�� */
} HTTP_CLIENT_RESPONSE_S;

typedef ULONG (*HTTP_Client_IOCallBack)(UCHAR *pucData, ULONG ulSize, ULONG ulNmemb,void *pvUserData);
typedef INT32 (*HTTP_Client_ProgressCallBack)(VOID *pvClientp, double dltotal, double dlnow, double ultotal, double ulnow);


typedef struct tagHttpClientOption
{
    ULONG ulL4VPNFlag;
    ULONG ulAcceptGzip;
    ULONG ulTimeOut;
    ULONG ulSSLVerifyPeer;
    ULONG ulSSLVerifyHost;
    ULONG ulCurlLogVerbose;
    ULONG ulHttpAuthenticateEnable;
    ULONG ulPostFieldSize;
    ULONG ulNoProgress;
    ULONG ulResumeFrom;
    ULONG ulCaCheckFlg;
    CHAR* pcCaFileFullPath;
    HTTP_Client_IOCallBack callbackBodyRead;
    VOID *pvcallbackBodyReadUserData;
    HTTP_Client_IOCallBack callbackBodyWrite;
    VOID *pvcallbackBodyWriteUserData;
    HTTP_Client_IOCallBack callbackHeadWrite;
    VOID *pvcallbackHeadWriteUserData;
    HTTP_Client_ProgressCallBack callbackProgressFunction;
    VOID *pvcallbackProgressData;
    CHAR * pcHostName;
    ULONG ulMuteTimeout;
    ULONG ulAuthEnable;    /*�Ƿ�У�������*/
    ULONG diableMultiplex;  /*����socket����*/
} HTTP_CLIENT_OPTION_S;

HTTP_CLIENT_VRB_LIST_S *AnyOffice_HttpClient_API_AppendHeadVRB(HTTP_CLIENT_VRB_LIST_S *pstHeadList, CHAR *pcType, CHAR *pcValue);

VOID AnyOffice_HttpClient_API_FreeVRBList(HTTP_CLIENT_VRB_LIST_S    *pstVRBList);

VOID AnyOffice_HttpClient_API_FreeResponse(HTTP_CLIENT_RESPONSE_S *pstResponse);

void AnyOffice_HttpClient_API_FreeRequest(HTTP_CLIENT_REQUEST_S *pstRequest);

INT32 AnyOffice_HttpClient_API_Connect(
    HTTP_CLIENT_OPTION_S *pstOptions,
    HTTP_CLIENT_REQUEST_S *pstRequest,
    HTTP_CLIENT_RESPONSE_S *pstResponse);

INT32 AnyOffice_HttpClient_API_Init();

VOID AnyOffice_HttpClient_API_Fini();


#ifdef __cplusplus
}
#endif

#endif

