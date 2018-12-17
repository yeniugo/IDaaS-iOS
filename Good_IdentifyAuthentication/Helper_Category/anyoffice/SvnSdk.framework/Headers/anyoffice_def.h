/******************************************************************************

                  ��Ȩ���� (C), 2001-2011, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : anyoffice_def.h
  �� �� ��   : ����
  ��    ��   : chenxingcheng
  ��������   : 2012��9��12��
  ����޸�   :
  ��������   : ����Anyoffice����ĺ궨�塢���ݽṹ�ȡ�
               ��Щ�궨������ݽṹ���Ա�Anyoffice������������ã���SecMail, MDM, PushService�ȡ�
  �����б�   :
  �޸���ʷ   :
  1.��    ��   : 2012��9��12��
    ��    ��   : chenxingcheng
    �޸�����   : �����ļ�

******************************************************************************/

#ifndef __ANYOFFICE_DEF_H__
#define __ANYOFFICE_DEF_H__


#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/*----------------------------------------------*
 * �ⲿ����˵��                                 *
 *----------------------------------------------*/

/*----------------------------------------------*
 * �ⲿ����ԭ��˵��                             *
 *----------------------------------------------*/

/*----------------------------------------------*
 * �ڲ�����ԭ��˵��                             *
 *----------------------------------------------*/

/*----------------------------------------------*
 * ȫ�ֱ���                                     *
 *----------------------------------------------*/

/*----------------------------------------------*
 * ģ�鼶����                                   *
 *----------------------------------------------*/

/*----------------------------------------------*
 * ��������                                     *
 *----------------------------------------------*/

/*----------------------------------------------*
 * �궨��                                       *
 *----------------------------------------------*/
/* BEGIN: Added by hexinxin, 2014/4/22   PN:����������֧�ֶ˿ڿ����ã��ͻ�������ʱ���Ӷ˿�*/
#define HIWORK_SSL_DEFAULT_PORT 443
/* END:   Added by hexinxin, 2014/4/22 */
/* BEGIN: Modified for ���ⵥ��:DTS2013030503243  by chenxingcheng, 2013/3/6 */
#define SAFE_LVL_REDLINE    0x10
/* BEGIN: Modified for ���ⵥ��:DTS2013080100226 �ͻ�����־�к���������Ϣ by wangyinan wKF70505, 2013/8/1 */
#define SAFE_LVL_DEV        0x20
/* END:   Modified by wangyinan wKF70505, 2013/8/1 */
/*
    ˵����ע������:
    1. ��ȫ�ȼ����ڵ��ڿ����ߵȼ�ʱ�����Դ�ӡ�û��������������Ϣ
    2. ������Ա���ص���ʱ������ʹ�� SAFE_LVL_DEV
    3. !!! �����ߵȼ�������Ҫ�����Դ����Ͽ�ʱ���ְ�ȫ�ȼ�Ϊ SAFE_LVL_REDLINE !!!
    4. ��������Լ��: ��ӡ������Ϣ�Ĵ��붼Ӧ�÷ŵ������ߵȼ��ĺ귶Χ�У�����:
        #if (ANYOFFICE_SAFE_LVL >= SAFE_LVL_DEV)
            ��ӡ������Ϣ
        #endif
    5. ����Ҫʹ�� #if (ANYOFFICE_SAFE_LVL >= SAFE_LVL_DEV) ʱ�� ��ֱ�ӻ��߼�Ӱ�����ͷ�ļ��������жϿ��ܺ����!!
        #include "anyoffice_def.h"
    6. ��Ҫ�������ļ����ض���ú�
*/
#define ANYOFFICE_SAFE_LVL   SAFE_LVL_REDLINE
/* END:   Modified by chenxingcheng, 2013/3/6 */

/* BEGIN: Added by chenxingcheng, 2012/9/5
ʹ��Curl�����Http����ʱ,��ʹ����ɫ��������SVN_MAX_URL_LEN(128)���Զ�������URL����*/
#define ANYOFFICE_MAX_CURL_URL_LEN           1024

/* END:   Added by chenxingcheng, 2012/9/5 */

/* BEGIN: Added by chenxingcheng, 2012/10/15   PN:�����ֽ���*/
#define ANYOFFICE_LITTLE_ENDIAN      0
#define ANYOFFICE_BIG_ENDIAN         1
#define ANYOFFICE_UNKNOWN_ENDIAN    2
/* END:   Added by chenxingcheng, 2012/10/15 */

#define ANYOFFICE_ENABLE  1     /* ʹ�� */
#define ANYOFFICE_DISABLE 0     /* δʹ�� */

#define ANYOFFICE_IPADDR_LEN      32   /* ����ַ���� */
#define ANYOFFICE_MAX_SSID_LEN    128  /* ���SSID���� */

/* BEGIN: Added by ljj, 2014/9/18   PN:sdk�����ṩ��ȡip/�����Ľӿ�*/
#define ANYOFFICE_MAX_DOM_LEN     128  /* ����������󳤶� */
/* END:   Added by ljj, 2014/9/18 */




/* BEGIN: Added by chenxingcheng, 2012/11/21   PN:��applistΪ��ʱ�����ظ�UI���ַ���*/
#define STRING_APPLIST_EMPTY    "{\"start\":0,\"count\":0,\"totalCnt\":0,\"items\":[]}"
/* END:   Added by chenxingcheng, 2012/11/21 */
#define MDM_SAVE_APK_DIR        "/mnt/sdcard/AnyofficeDownload"

/* BEGIN: Added by xingxiaofeng, 2012/6/19 */
#define MID_SECENTRY_HIWORK     0xddcc0000
/* END:   Added by xingxiaofeng, 2012/6/19 */

#define MAX_LOGBUF_LEN 256


#define ANYOFFICE_MALLOC(length) malloc(length)
//#define ANYOFFICE_REMALLOC(pOldMemPtr,ulNewSize) realloc(pOldMemPtr,ulNewSize)
#ifndef ANYOFFICE_SAFE_FREE
#define ANYOFFICE_SAFE_FREE(data) \
    if(data) \
    {\
        free(data);\
        (data) = NULL; \
    }
#endif

#ifndef ANYOFFICE_SAFE_FREE_NOT_SAFE
#define ANYOFFICE_SAFE_FREE_NOT_SAFE(data)  free(data); (data) = NULL;

#endif


#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* __ANYOFFICE_DEF_H__ */
