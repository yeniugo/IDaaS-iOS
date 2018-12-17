/******************************************************************************

                  ��Ȩ���� (C), 2001-2014, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : anyoffice_netstatus.h
  �� �� ��   : ����
  ��    ��   : LiJingjin 90004727
  ��������   : 2014��5��6��
  ����޸�   :
  ��������   : ϵͳ�ӿڻ�ȡ�����豸״̬�����仯ʱ�����ýӿڴ��������л���
  �����б�   :
*
*
  �޸���ʷ   :
  1.��    ��   : 2014��5��6��
    ��    ��   : LiJingjin 90004727
    �޸�����   : �����ļ�

******************************************************************************/
#ifndef __ANYOFFICE_NETSTATUS_H__
#define __ANYOFFICE_NETSTATUS_H__

#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif
#endif /* __cplusplus */
#include "tools_common.h"
#include "tools_string.h"
#include "anyoffice_def.h"


/*----------------------------------------------*
 * ͷ�ļ�                                       *
 *----------------------------------------------*/


/*----------------------------------------------*
 * ��������                                     *
 *----------------------------------------------*/
/* ��������ö�ٶ���(��ԭ���㶨��һ��) */
typedef enum tagNetType
{
    NET_TYPE_WIFI = 0,
    NET_TYPE_3G = 1,
    NET_TYPE_4G,
    NET_TYPE_OTHER = 99,
    NET_TYPE_UNREACHABLE = 999,
} NET_TYPE_EN;

/* ����״̬ö�ٶ��� */
typedef enum tagNetStatus
{
    NET_STATUS_OFFLINE = 0,
    NET_STATUS_ONLINE,
    NET_STATUS_CONNECTING
} NET_STATUS_EN;

typedef struct tagTLSDetectParam
{
    ULONG ulTLSDetectSuccessTimes;/*TLS���̽��ɹ�����*/
    INT32 ulTimeOut;/*TLS���̽�ⳬʱ*/
}TLS_DETECT_PARAM;


/*----------------------------------------------*
 *                         �궨��                                       *
 *----------------------------------------------*/
/* ���ߴ����붨�� */
#define ANYOFFICE_NET_STATUS_ERR_UNREACHABLE  -1000   /* �ն������ѶϿ� */
#define ANYOFFICE_NET_STATUS_DNS_TIMEOUT       20

/*----------------------------------------------*
 * ���ݽṹ����                                 *
 *----------------------------------------------*/
typedef struct tagAnyOfficeDeviceNetStatus
{
    NET_TYPE_EN   enNetType;  /* 4G/3G/Wifi */
    CHAR acSSID[ANYOFFICE_MAX_SSID_LEN];
} ANYOFFICE_DEVICE_NET_STATUS_S;


/*----------------------------------------------*
 * �ⲿ����ԭ��˵��                             *
 *----------------------------------------------*/

/* ��ȡ�������ӵ�״̬������������״̬ */
NET_STATUS_EN AnyOffice_API_GetNetStatus();

/* ��ȡ�����豸��״̬������ */
/* ����/�Ͽ� 3G/Wifi  SSID   */
ULONG AnyOffice_API_GetDeviceNetStatus(ANYOFFICE_DEVICE_NET_STATUS_S *pstStatus);


/* ��������״̬�仯�Ļص� */
typedef ULONG (*AnyOffice_API_NetChangeCallback)(NET_STATUS_EN enOldStatus, NET_STATUS_EN enNewStatus, INT32 iErrorCode);

ULONG AnyOffice_API_SetNetChangeCallback(AnyOffice_API_NetChangeCallback pfCallback);
ULONG AnyOffice_API_SetNetStatusManagerChangeCallback(AnyOffice_API_NetChangeCallback pfCallback);
ULONG NetStatusChangeNotify(NET_STATUS_EN enOldStatus, NET_STATUS_EN enNewStatus, INT32 iErrorCode);


#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */

#endif

