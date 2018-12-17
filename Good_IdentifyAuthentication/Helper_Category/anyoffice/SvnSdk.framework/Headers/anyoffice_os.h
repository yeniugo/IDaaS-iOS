#ifndef __ANYOFFICE_OS_H__
#define __ANYOFFICE_OS_H__
/******************************************************************************

                  ��Ȩ���� (C), 2001-2014, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : anyoffice_os.h
  �� �� ��   : ����
  ��    ��   : zhangyantao 00103873
  ��������   : 2014��7��18��
  ����޸�   :
  ��������   : ����ϵͳ����
  �����б�   :
  �޸���ʷ   :
  1.��    ��   : 2014��7��18��
    ��    ��   : zhangyantao 00103873
    �޸�����   : �����ļ�
******************************************************************************/
#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif
#endif

#include "tools_common.h"

#define DEVICE_FAMILY_TYPE_LEN 10

CHAR* AnyOffice_OS_API_GetAppID();

CHAR* AnyOffice_OS_API_GetDeviceID();


CHAR *AnyOffice_OS_API_GetSignatrueString();

INT32 AnyOffice_OS_API_SetDeviceID(CHAR *pcDeviceID);


CHAR* AnyOffice_OS_API_GetSystemVersion();

CHAR *AnyOffice_OS_API_GetUUID();

CHAR* AnyOffice_OS_API_GetOsFamilyType();

unsigned long AnyOffice_OS_API_ParseHostWithTimeout(const char* pcHostName, unsigned long ulTimeoutInterval);

#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif

#endif



