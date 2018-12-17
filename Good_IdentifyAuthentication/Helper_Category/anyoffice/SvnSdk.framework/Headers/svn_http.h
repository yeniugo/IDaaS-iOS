
/******************************************************************************
*    �ļ����� :    svn_http.h
*    ��    �� :    ��Ϊ�������޹�˾(Huawei Tech.Co.,Ltd)
*    �ļ����� :    HTTPģ�����APIͷ�ļ�
*    ����ʱ�� :    2012-12-11
*    ��Ȩ���� :    Copyright (C) 2012
*                  ��Ϊ�������޹�˾(Huawei Tech.Co.,Ltd)
*    �޶���ʷ :    2012-12-11    1.0.1
******************************************************************************/

#ifndef __svnhttp_h_
#define __svnhttp_h_


#include <stdio.h>

#ifdef __cplusplus
extern "C" {    /* Assume C declarations for C++ */
#endif  /* __cplusplus */



#define HTTP_API   __attribute__ ((__visibility__ ("default")))



typedef unsigned long HTTPHANDLE;
typedef unsigned long HTTPULong;
typedef long LONG;
typedef int HTTPInt;
typedef unsigned int HTTPUInt;

typedef char HTTPChar;

typedef HTTPULong HTTPBOOL;

#define HTTP_TRUE 1
#define HTTP_FALSE 0

#define HTTP_FAILURE (-1)
#define HTTP_SUCCESS (0)

#ifdef __cplusplus
#define HTTP_NULL    0
#else
#define HTTP_NULL    ((void *)0)
#endif

#define     EN_HTTP_CURLE_ERR_START       100    /*���صĴ�����ӳ�䵽HTTP�������׼ֵ*/

#define     HTTP_DEFAULT_HANDLE_NUM       16     /*Ĭ��֧�ֵ�handle����*/
#define     HTTP_MAX_HANDLE_NUM           500    /*���֧�ֵ�handle����*/
#define     HTTP_MIN_HANDLE_NUM           1      /*��С֧�ֵ�handle����*/


/* ������ */
typedef enum
{
    EN_HTTP_OK,
    EN_HTTP_INIT_FAIL,                      /* 1 ��ʼ��ʧ�� */
    EN_HTTP_UNINIT,                         /* 2 δ��ʼ�� */
    EN_HTTP_INVALID_PARAM,                  /* 3 ��Ч���� */
    EN_HTTP_INVALID_HANDLE,                 /* 4 ��Ч��� */
    EN_HTTP_HANDLE_INUSE,                   /* 5 ��ǰ�������ʹ���У��������� */
    EN_HTTP_HANDLE_STATE_ERROR,             /* 6 ��ǰ���״̬��֧�ֶ�Ӧ���� */
    EN_HTTP_ALLOC_MEM_FAIL,                 /* 7 �ڴ����ʧ�� */
    EN_HTTP_CREATE_HANDLE_FAIL,             /* 8 ����handleʧ�� */
    EN_HTTP_INVALID_TLS_MODE,               /* 9 tlsģʽ���� */
    EN_HTTP_INVALID_URL,                    /* 10 ��Ч��URL */
    EN_HTTP_INVALID_HEAD_TYPE,              /* 11 ��Ч��ͷ������ */
    EN_HTTP_OPEN_LOG_FAIL,                  /* 12 ����־ʧ�� */
    EN_HTTP_WRITE_LOG_FAIL,                 /* 13 д��־ʧ�� */
    EN_HTTP_INVALID_FILEPATH,               /* 14 ��Ч���ļ�·�� */
    EN_HTTP_HANDLE_RELEASED,                /* 15 handle�Ѿ����ͷ� */
    EN_HTTP_CREATE_MUTEX_FAIL,              /* 16 ����mutexʧ�� */
    EN_HTTP_LOCK_MUTEX_FAIL,                /* 17 LOCK mutexʧ�� */
    EN_HTTP_UNLOCK_MUTEX_FAIL,              /* 18 UNLOCK mutexʧ�� */
    EN_HTTP_CREATE_THREAD_FAIL,             /* 19 �����߳�ʧ�� */
    EN_HTTP_NOT_SUPPORT,                    /*20 ��֧�ָù��� */
    EN_HTTP_GETHOSTNAME_FAIL,               /* 26 ��ȡ������ʧ�� */
    EN_HTTP_NET_NTOA_FAIL,                  /*27 IP ��ַת��ʧ��*/
    EN_HTTP_RESPONSE_PARSE_ERR,             /* 28 ��Ӧ���ݽ���ʧ�� */


    EN_HTTP_CURLE_UNSUPPORTED_PROTOCOL = EN_HTTP_CURLE_ERR_START + 1,    /* 101 */
    EN_HTTP_CURLE_FAILED_INIT,             /* 102 */
    EN_HTTP_CURLE_URL_MALFORMAT,           /* 103 */
    EN_HTTP_CURLE_NOT_BUILT_IN,            /* 104 */
    EN_HTTP_CURLE_COULDNT_RESOLVE_PROXY,   /* 105 */
    EN_HTTP_CURLE_COULDNT_RESOLVE_HOST,    /* 106 */
    EN_HTTP_CURLE_COULDNT_CONNECT,         /* 107 */
    EN_HTTP_CURLE_FTP_WEIRD_SERVER_REPLY,  /* 108 */
    EN_HTTP_CURLE_REMOTE_ACCESS_DENIED,    /* 109 a service was denied by the server
                                              due to lack of access - when login fails
                                              this is not returned. */
    EN_HTTP_CURLE_FTP_ACCEPT_FAILED,       /* 110 */
    EN_HTTP_CURLE_FTP_WEIRD_PASS_REPLY,    /* 111 */
    EN_HTTP_CURLE_FTP_ACCEPT_TIMEOUT,      /* 112 - timeout occurred accepting server*/
    EN_HTTP_CURLE_FTP_WEIRD_PASV_REPLY,    /* 113 */
    EN_HTTP_CURLE_FTP_WEIRD_227_FORMAT,    /* 114 */
    EN_HTTP_CURLE_FTP_CANT_GET_HOST,       /* 115 */
    EN_HTTP_CURLE_OBSOLETE16,              /* 116 - NOT USED */
    EN_HTTP_CURLE_FTP_COULDNT_SET_TYPE,    /* 117 */
    EN_HTTP_CURLE_PARTIAL_FILE,            /* 118 */
    EN_HTTP_CURLE_FTP_COULDNT_RETR_FILE,   /* 119 */
    EN_HTTP_CURLE_OBSOLETE20,              /* 120 - NOT USED */
    EN_HTTP_CURLE_QUOTE_ERROR,             /* 121 - quote command failure */
    EN_HTTP_CURLE_HTTP_RETURNED_ERROR,     /* 122 */
    EN_HTTP_CURLE_WRITE_ERROR,             /* 123 */
    EN_HTTP_CURLE_OBSOLETE24,              /* 124 - NOT USED */
    EN_HTTP_CURLE_UPLOAD_FAILED,           /* 125 - failed upload "command" */
    EN_HTTP_CURLE_READ_ERROR,              /* 126 - couldn't open/read from file */
    EN_HTTP_CURLE_OUT_OF_MEMORY,           /* 127 */
    /* Note: CURLE_OUT_OF_MEMORY may sometimes indicate a conversion error
       instead of a memory allocation error if CURL_DOES_CONVERSIONS
       is defined*/
    EN_HTTP_CURLE_OPERATION_TIMEDOUT,      /* 128 - the timeout time was reached */
    EN_HTTP_CURLE_OBSOLETE29,              /* 129 - NOT USED */
    EN_HTTP_CURLE_FTP_PORT_FAILED,         /* 130 - F-T-P PORT operation failed */
    EN_HTTP_CURLE_FTP_COULDNT_USE_REST,    /* 131 - the REST command failed */
    EN_HTTP_CURLE_OBSOLETE32,              /* 132 - NOT USED */
    EN_HTTP_CURLE_RANGE_ERROR,             /* 133 - RANGE "command" didn't work */
    EN_HTTP_CURLE_HTTP_POST_ERROR,         /* 134 */
    EN_HTTP_CURLE_SSL_CONNECT_ERROR,       /* 135 - wrong when connecting with SSL */
    EN_HTTP_CURLE_BAD_DOWNLOAD_RESUME,     /* 136 - couldn't resume download */
    EN_HTTP_CURLE_FILE_COULDNT_READ_FILE,  /* 137 */
    EN_HTTP_CURLE_LDAP_CANNOT_BIND,        /* 138 */
    EN_HTTP_CURLE_LDAP_SEARCH_FAILED,      /* 139 */
    EN_HTTP_CURLE_OBSOLETE40,              /* 140 - NOT USED */
    EN_HTTP_CURLE_FUNCTION_NOT_FOUND,      /* 141 */
    EN_HTTP_CURLE_ABORTED_BY_CALLBACK,     /* 142 */
    EN_HTTP_CURLE_BAD_FUNCTION_ARGUMENT,   /* 143 */
    EN_HTTP_CURLE_OBSOLETE44,              /* 144 - NOT USED */
    EN_HTTP_CURLE_INTERFACE_FAILED,        /* 145 - CURLOPT_INTERFACE failed */
    EN_HTTP_CURLE_OBSOLETE46,              /* 146 - NOT USED */
    EN_HTTP_CURLE_TOO_MANY_REDIRECTS ,     /* 147 - catch endless re-direct loops */
    EN_HTTP_CURLE_UNKNOWN_OPTION,          /* 148 - User specified an unknown option */
    EN_HTTP_CURLE_TELNET_OPTION_SYNTAX ,   /* 149 - Malformed remote login option */
    EN_HTTP_CURLE_OBSOLETE50,              /* 150 - NOT USED */
    EN_HTTP_CURLE_PEER_FAILED_VERIFICATION, /* 151 - peer's certificate or fingerprint
                                               wasn't verified fine */
    EN_HTTP_CURLE_GOT_NOTHING,             /* 152 - when this is a specific error */
    EN_HTTP_CURLE_SSL_ENGINE_NOTFOUND,     /* 153 - SSL crypto engine not found */
    EN_HTTP_CURLE_SSL_ENGINE_SETFAILED,    /* 154 - can not set SSL crypto engine as default */
    EN_HTTP_CURLE_SEND_ERROR,              /* 155 - failed sending network data */
    EN_HTTP_CURLE_RECV_ERROR,              /* 156 - failure in receiving network data */
    EN_HTTP_CURLE_OBSOLETE57,              /* 157 - NOT IN USE */
    EN_HTTP_CURLE_SSL_CERTPROBLEM,         /* 158 - problem with the local certificate */
    EN_HTTP_CURLE_SSL_CIPHER,              /* 159 - couldn't use specified cipher */
    EN_HTTP_CURLE_SSL_CACERT,              /* 160 - problem with the CA cert (path?) */
    EN_HTTP_CURLE_BAD_CONTENT_ENCODING,    /* 161 - Unrecognized/bad encoding */
    EN_HTTP_CURLE_LDAP_INVALID_URL,        /* 162 - Invalid LDAP URL */
    EN_HTTP_CURLE_FILESIZE_EXCEEDED,       /* 163 - Maximum file size exceeded */
    EN_HTTP_CURLE_USE_SSL_FAILED,          /* 164 - Requested F-T-P SSL level failed */
    EN_HTTP_CURLE_SEND_FAIL_REWIND,        /* 165 - Sending the data requires a rewind that failed */
    EN_HTTP_CURLE_SSL_ENGINE_INITFAILED,   /* 166 - failed to initialise ENGINE */
    EN_HTTP_CURLE_LOGIN_DENIED,            /* 167 - user, password or similar was not
                                              accepted and we failed to login */
    EN_HTTP_CURLE_TFTP_NOTFOUND,           /* 168 - file not found on server */
    EN_HTTP_CURLE_TFTP_PERM,               /* 169 - permission problem on server */
    EN_HTTP_CURLE_REMOTE_DISK_FULL,        /* 170 - out of disk space on server */
    EN_HTTP_CURLE_TFTP_ILLEGAL,            /* 171 - Illegal TFTP operation */
    EN_HTTP_CURLE_TFTP_UNKNOWNID,          /* 172 - Unknown transfer ID */
    EN_HTTP_CURLE_REMOTE_FILE_EXISTS,      /* 173 - File already exists */
    EN_HTTP_CURLE_TFTP_NOSUCHUSER,         /* 174 - No such user */
    EN_HTTP_CURLE_CONV_FAILED,             /* 175 - conversion failed */
    EN_HTTP_CURLE_CONV_REQD,               /* 176 - caller must register conversion
                                                callbacks using curl_easy_setopt options
                                                CURLOPT_CONV_FROM_NETWORK_FUNCTION,
                                                CURLOPT_CONV_TO_NETWORK_FUNCTION, and
                                                CURLOPT_CONV_FROM_UTF8_FUNCTION */
    EN_HTTP_CURLE_SSL_CACERT_BADFILE,      /* 177 - could not load CACERT file, missing
                                                or wrong format */
    EN_HTTP_CURLE_REMOTE_FILE_NOT_FOUND,   /* 178 - remote file not found */
    EN_HTTP_CURLE_SSH,                     /* 179 - error from the SSH layer, somewhat
                                                generic so the error message will be of
                                                interest when this has happened */
    EN_HTTP_CURLE_SSL_SHUTDOWN_FAILED,     /* 180 - Failed to shut down the SSL
                                                connection */
    EN_HTTP_CURLE_AGAIN,                   /* 181 - socket is not ready for send/recv,
                                                wait till it's ready and try again (Added
                                                in 7.18.2) */
    EN_HTTP_CURLE_SSL_CRL_BADFILE,         /* 182 - could not load CRL file, missing or
                                                wrong format (Added in 7.19.0) */
    EN_HTTP_CURLE_SSL_ISSUER_ERROR,        /* 183 - Issuer check failed. */
    EN_HTTP_CURLE_FTP_PRET_FAILED,         /* 184 - a PRET command failed */
    EN_HTTP_CURLE_RTSP_CSEQ_ERROR,         /* 185 - mismatch of RTSP CSeq numbers */
    EN_HTTP_CURLE_RTSP_SESSION_ERROR,      /* 186 - mismatch of RTSP Session Ids */
    EN_HTTP_CURLE_FTP_BAD_FILE_LIST,       /* 187 - unable to parse F-T-P file list */
    EN_HTTP_CURLE_CHUNK_FAILED,            /* 188 - chunk callback reported error */

    EN_HTTP_CURL_CREATE_HANDLE_FAIL = 201,   /* 201 */
    EN_HTTP_CURL_SET_HEAD_FAIL,              /* 202 */

    EN_HTTP_ERRORCODE_BUTT                   /* never used */

} EN_HTTP_ERRORCODE;


/* TLSģʽ */
typedef enum
{
    EN_TLS_CLOSE              = 0, /*�رղ�ʹ��TLS*/
    EN_TLS_VERIFY_NONE        = 1, /*����TLS����У��*/
    EN_TLS_VERIFY_SERVER      = 2, /*����TLS����У�������*/
    EN_TLS_VERIFY_CLIENT      = 3, /*����TLS����У��ͻ���*/
    EN_TLS_VERIFY_BOTH        = 4, /*����TLS�����������ͻ��˾�У��*/

    EN_TLS_MODE_BUTT

} EN_TLS_MODE;

/* TLSУ���������ʽ */
typedef enum
{
    EN_VERIFY_SERVER_PEER               = 0, /*��У��֤��(Ĭ�Ϸ�ʽ��*/
    EN_VERIFY_SERVER_PEER_AND_HOST      = 1, /*У��֤�������*/

    EN_VERIFY_SERVER_BUTT

} EN_VERIFY_SERVER_MODE;


/* TLS���� */
typedef struct tagHTTP_TLS_PARA
{
    HTTPChar    *pcCaCertPath;                   /*CA֤�� */
    HTTPChar    *pcClientCertPath;               /*�ͻ���֤�� */
    HTTPChar    *pcClientCertType;               /*�ͻ���֤�����ͣ�"PEM"/"DER" */
    HTTPChar    *pcClientKeyPath;                /*�ͻ�����Կ*/
    HTTPChar    *pcClientKeyType;                /*�ͻ�����Կ���ͣ�"PEM"/"DER"/"ENG" */
    HTTPChar    *pcClientPrivKeyPw;              /*�ͻ���˽Կ���� */
    EN_VERIFY_SERVER_MODE  enVerifyServerMode;   /*У������ģʽ(Ĭ��Ϊ֤���������У�飩*/
} ST_HTTP_TLS_PARA;

/* httpͷ������ */
typedef struct tagST_HTTP_HEAD_LIST
{
    HTTPChar                   *pcHeadType;
    HTTPChar                   *pcHeadValue;
    struct tagST_HTTP_HEAD_LIST     *pNext;

} ST_HTTP_HEAD_LIST;


/* http body�ṹ */
typedef struct tagST_HTTP_BODY
{
    HTTPChar       *pcbody;
    HTTPULong       ulBodyLen;
} ST_HTTP_BODY;

/* http��Ӧ���� */
typedef struct tagST_HTTP_RSP
{
    HTTPULong              ulStatusCode;
    ST_HTTP_HEAD_LIST      *pstHeadList;
    ST_HTTP_BODY           stHttpBody;
} ST_HTTP_RSP;


/* http������Ӧ�Ļص�����ָ�� */
typedef int (*HttpRspNotify)(HTTPHANDLE handle, LONG lCode, ST_HTTP_RSP *pstHttpRsp);

/* http���ò��� */
typedef struct tagST_HTTP_HANDLE_CONFIG
{

    HTTPChar               *pcHostIP;
    HTTPUInt                hostPort;
    EN_TLS_MODE             enTlsMode;
    ST_HTTP_TLS_PARA        stTLSPara;

} ST_HTTP_HANDLE_CONFIG;

/* HTTP ������ */
typedef struct tagST_HTTP_REQUEST_LINE
{
    HTTPChar          *pcMethod;
    HTTPChar          *pcUrl;

} ST_HTTP_REQUEST_LINE;


/* HTTP ��־���� */
typedef enum
{
    EN_HTTP_LOG_NONE         = 0,    /*�ر���־*/
    EN_HTTP_LOG_ERROR        = 1,    /*����(������־)*/
    EN_HTTP_LOG_WARNING      = 2,    /*�澯(������־)*/
    EN_HTTP_LOG_INFO         = 3,    /*��ʾ(������־)*/
    EN_HTTP_LOG_DEBUG        = 4     /*����(������־)*/

} EN_HTTP_LOG_LEVEL;


/* HTTP��ʼ������ */
typedef struct tagST_HTTP_CONFIG
{
    EN_HTTP_LOG_LEVEL           enLevel;            /*��־����*/
    HTTPUInt                    uiLogFileSize;      /*��־�ļ���С(����־����ΪEN_HTTP_LOG_NONEʱ��Ч)*/
    HTTPChar                    *pcFilePath;        /*��־�ļ�·��(����־����ΪEN_HTTP_LOG_NONEʱ��Ч)*/
    HTTPUInt                    uiHandleNum;        /*֧�ֵ�handle����*/
} ST_HTTP_CONFIG;



/*
 *****************************************************************************
 * �� �� ��  : svn_http_init
 * ��������  : HTTP sdk��ʼ��
 * �������  : ��
 *
 * �������  : ��
 * �� �� ֵ  : �ɹ�����EN_HTTP_OK��ʧ�ܷ��ض�Ӧ������
 * ����˵��  : ֻ��Ҫһ�λ�����ʼ��
 *
 * �޸���ʷ      :
 *  1.��    ��   : 2012��12��24��
 *    ��    ��   :
 *    �޸�����   : �����ɺ���
 *
 *****************************************************************************
 */
HTTP_API LONG svn_http_init();


/*
 *****************************************************************************
 * �� �� ��  : svn_http_cleanup
 * ��������  : HTTP sdk��������
 * �������  : ��
 * �������  : ��
 * �� �� ֵ  : �ɹ�����EN_HTTP_OK��ʧ�ܷ��ض�Ӧ������
 * ����˵��  :
 *
 * �޸���ʷ      :
 *  1.��    ��   : 2012��12��24��
 *    ��    ��   :
 *    �޸�����   : �����ɺ���
 *
 *****************************************************************************
 */
HTTP_API LONG svn_http_cleanup();


/*
 *****************************************************************************
 * �� �� ��  : svn_http_createhandle
 * ��������  : ����HTTP����ľ���������ø�handle���ò���
 * �������  : pstHttpHandleConfig
 *             pstHttpHandleConfig�� �������ʱ��ʹ�õĲ��������������
               HTTPChar               *pcHostIP : HTTP����IP
               HTTPUInt                hostPort:  HTTP����˿�
               EN_TLS_MODE             enTlsMode��TLS��ȫģʽ���μ�ͷ�ļ�����
               ST_HTTP_TLS_PARA        stTLSPara������TLSʱ��Ҫ�Ĳ������μ�ͷ�ļ�

 * �������  : pHandle ����HTTP����ľ�������ں�����������Ӧ����
 * �� �� ֵ  : �ɹ�����EN_HTTP_OK��ʧ�ܷ��ض�Ӧ������
 * ����˵��  :
 *
 * �޸���ʷ      :
 *  1.��    ��   : 2012��12��24��
 *    ��    ��   :
 *    �޸�����   : �����ɺ���
 *
 *****************************************************************************
 */
HTTP_API LONG svn_http_createhandle(const ST_HTTP_HANDLE_CONFIG *pstHttpHandleConfig, HTTPHANDLE *pHandle);


/*
 *****************************************************************************
 * �� �� ��  : svn_http_closehandle
 * ��������  : �ر�HTTP����ľ��
 * �������  : handle
 * �������  : ��
 * �� �� ֵ  : �ɹ�����EN_HTTP_OK��ʧ�ܷ��ض�Ӧ������
 * ����˵��  :
 *
 * �޸���ʷ      :
 *  1.��    ��   : 2012��12��24��
 *    ��    ��   :
 *    �޸�����   : �����ɺ���
 *
 *****************************************************************************
 */
HTTP_API LONG svn_http_closehandle(HTTPHANDLE handle);


/*
 *****************************************************************************
 * �� �� ��  : svn_http_setrequestline
 * ��������  : ����HTTP������
 * �������  : handle
 *             pstRequestLine
 *
 * �������  : ��
 * �� �� ֵ  : �ɹ�����EN_HTTP_OK��ʧ�ܷ��ض�Ӧ������
 * ����˵��  :
 *
 * �޸���ʷ      :
 *  1.��    ��   : 2012��12��24��
 *    ��    ��   :
 *    �޸�����   : �����ɺ���
 *
 *****************************************************************************
 */
HTTP_API LONG svn_http_setrequestline(HTTPHANDLE handle, const ST_HTTP_REQUEST_LINE *pstRequestLine);


/*
 *****************************************************************************
 * �� �� ��  : svn_http_addheadcontent
 * ��������  : ���httpͷ��
 * �������  : handle
 *             pcHeadType
 *             pcHeadValue
 *
 * �������  : ��
 * �� �� ֵ  : �ɹ�����EN_HTTP_OK��ʧ�ܷ��ض�Ӧ������
 * ����˵��  :
 *
 * �޸���ʷ      :
 *  1.��    ��   : 2012��12��24��
 *    ��    ��   :
 *    �޸�����   : �����ɺ���
 *
 *****************************************************************************
 */
HTTP_API LONG svn_http_addheadcontent(HTTPHANDLE handle, const HTTPChar *pcHeadType, const HTTPChar *pcHeadValue);


/*
 *****************************************************************************
 * �� �� ��  : svn_http_setbody
 * ��������  : ����http�����body
 * �������  : handle
 *             pstBody
 * �������  : ��
 * �� �� ֵ  : �ɹ�����EN_HTTP_OK��ʧ�ܷ��ض�Ӧ������
 * ����˵��  :
 *
 * �޸���ʷ      :
 *  1.��    ��   : 2012��12��24��
 *    ��    ��   :
 *    �޸�����   : �����ɺ���
 *
 *****************************************************************************
 */
HTTP_API LONG svn_http_setbody(HTTPHANDLE handle, const ST_HTTP_BODY* pstBody);


/*
 *****************************************************************************
 * �� �� ��  : svn_http_reqasynsend
 * ��������  : �첽����ͨ�õ�http����
 * �������  : handle
 *             httpRspNotifyFunc �ص�����
 *
 * �������  :
 * �� �� ֵ  : �ɹ�����EN_HTTP_OK��ʧ�ܷ��ض�Ӧ������
 * ����˵��  : �첽����
 *
 * �޸���ʷ      :
 *  1.��    ��   : 2012��12��24��
 *    ��    ��   :
 *    �޸�����   : �����ɺ���
 *
 *****************************************************************************
 */
HTTP_API LONG svn_http_reqasynsend(HTTPHANDLE handle, HttpRspNotify httpRspNotifyFunc);


/*
 *****************************************************************************
 * �� �� ��  : svn_http_reqsynsend
 * ��������  : ͬ������ͨ�õ�http����
 * �������  : handle
 *             httpRspNotifyFunc �ص�����
 *
 * �������  :
 * �� �� ֵ  : �ɹ�����EN_HTTP_OK��ʧ�ܷ��ض�Ӧ������
 * ����˵��  :
 *
 * �޸���ʷ      :
 *  1.��    ��   : 2012��12��24��
 *    ��    ��   :
 *    �޸�����   : �����ɺ���
 * 2.add by liushangshu for change function name.
 *****************************************************************************
 */
HTTP_API EN_HTTP_ERRORCODE svn_http_reqsynsend(HTTPHANDLE handle, ST_HTTP_RSP **ppstHttpRsp);

/*
 *****************************************************************************
 * �� �� ��  : svn_http_releasesynrsp
 * ��������  : �ͷ�ͬ�������������Ӧ
 * �������  : pstHttpRsp
 *
 * �������  :
 * �� �� ֵ  : EN_HTTP_ERRORCODE
 * ����˵��  :
 *
 * �޸���ʷ      :
 *  1.��    ��   :
 *    ��    ��   : ***
 *    �޸�����   : �����ɺ���
 *  2.��    ��   : 2013��5��14��
 *    ��    ��   : add by liushangshu
 *    �޸�����   : ʵ�ִ����߼�
 *
 *****************************************************************************
 */
HTTP_API EN_HTTP_ERRORCODE svn_http_releasesynrsp(ST_HTTP_RSP *pstHttpRsp);

#ifdef __cplusplus
}
#endif  /* __cplusplus */

#endif //__svnhttp_h_
