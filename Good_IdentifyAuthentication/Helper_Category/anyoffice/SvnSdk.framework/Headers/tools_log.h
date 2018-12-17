/******************************************************************************

                  ��Ȩ���� (C), 2001-2013, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : tools_log.h
  �� �� ��   : ����
  ��    ��   : lifangxiang/00218420
  ��������   : 2013��11��5��
  ����޸�   :
  ��������   : tools_log.h ��ͷ�ļ�
  �����б�   :
  �޸���ʷ   :
  1.��    ��   : 2013��11��5��
    ��    ��   : lifangxiang/00218420
    �޸�����   : �����ļ�

******************************************************************************/
#ifndef __TOOLS_LOG_H__
#define __TOOLS_LOG_H__


/*----------------------------------------------*
 * ����ͷ�ļ�                                   *
 *----------------------------------------------*/
#include <pthread.h>

#ifdef _lint
#ifndef __FUNCTION__
#define __FUNCTION__ ""
#endif /* end of __FUNCTION__ */
#endif

#define ANYOFFICE_SDK_ERR_LOG      1
#define ANYOFFICE_SDK_WARN_LOG     2
#define ANYOFFICE_SDK_NOTICE_LOG   3
#define ANYOFFICE_SDK_DEBUG_LOG    4

/* ��־ģ��ID */
#define TOOLS_MOD_NAME_SDK         0x1000



/*----------------------------------------------*
 * �Զ���ģ����־��ӡ                           *
 *----------------------------------------------*/
extern void WriteLog(unsigned long ulInfoID, unsigned long ulErrorLevel, const char *pcFuncName, unsigned long ulLineNum, char *pcFormat, ...);
#define TOOLS_LOGD(mod, format, ...) WriteLog(mod, ANYOFFICE_SDK_NOTICE_LOG, __FUNCTION__, __LINE__, format, ##__VA_ARGS__)
#define TOOLS_LOGN(mod, format, ...) WriteLog(mod, ANYOFFICE_SDK_NOTICE_LOG, __FUNCTION__, __LINE__, format, ##__VA_ARGS__)
#define TOOLS_LOGW(mod, format, ...) WriteLog(mod, ANYOFFICE_SDK_WARN_LOG, __FUNCTION__, __LINE__, format, ##__VA_ARGS__)
#define TOOLS_LOGE(mod, format, ...) WriteLog(mod, ANYOFFICE_SDK_ERR_LOG, __FUNCTION__, __LINE__, format, ##__VA_ARGS__)

/*----------------------------------------------*
 * ��ģ����־��ӡ                               *
 *----------------------------------------------*/

#define _TOOLS_LOGD(format, ...) TOOLS_LOGD(TOOLS_MOD_NAME_SDK, format, ##__VA_ARGS__)
#define _TOOLS_LOGE(format, ...) TOOLS_LOGE(TOOLS_MOD_NAME_SDK, format, ##__VA_ARGS__)
#define _TOOLS_LOGN(format, ...) TOOLS_LOGN(TOOLS_MOD_NAME_SDK, format, ##__VA_ARGS__)
#define _TOOLS_LOGW(format, ...) TOOLS_LOGW(TOOLS_MOD_NAME_SDK, format, ##__VA_ARGS__)

#endif /* __TOOLS_LOG_H__ */

