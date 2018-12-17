#ifndef __ANYOFFICE_KEYSPACE_H__
#define __ANYOFFICE_KEYSPACE_H__
/******************************************************************************

                  ��Ȩ���� (C), 2001-2014, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : anyoffice_keyspace.h
  �� �� ��   : ����
  ��    ��   : LiJingjin 90004727
  ��������   : 2014��5��6��
  ����޸�   :
  ��������   : ϵͳ��ȫ�洢���ӿڶ���
  �����б�   :
*
*
  �޸���ʷ   :
  1.��    ��   : 2014��5��6��
    ��    ��   : LiJingjin 90004727
    �޸�����   : �����ļ�

******************************************************************************/
#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif
#endif /* __cplusplus */


/*----------------------------------------------*
 * ͷ�ļ�                                       *
 *----------------------------------------------*/
#include "svn_define.h"
#include "tools_hash.h"
#include "anyoffice_login.h"

/*----------------------------------------------*
 * ��������                                     *
 *----------------------------------------------*/

/*----------------------------------------------*
 * �궨��                                       *
 *----------------------------------------------*/

/*----------------------------------------------*
 * ���ݽṹ����                                 *
 *----------------------------------------------*/

/*----------------------------------------------*
 * �ⲿ����ԭ��˵��                             *
 *----------------------------------------------*/

INT32 AnyOffice_KeySpace_API_WriteItem(const char *pcGroup, const char *pcName, const char *pcValue);

INT32 AnyOffice_KeySpace_API_WriteItemPrivate(const char *pcGroup, const char *pcName, const char *pcValue);

INT32 AnyOffice_KeySpace_API_WriteGroup(const char *pcGroup, HASH_S* pstHash);

INT32 AnyOffice_KeySpace_API_ReadItem(const char *pcGroup, const char *pcName, char **ppcValue);

INT32 AnyOffice_KeySpace_API_ReadItemPrivate(const char *pcGroup, const char *pcName, char **ppcValue);

INT32 AnyOffice_KeySpace_API_ReadGroup(const char *pcGroup, HASH_S** ppstHash);

INT32 AnyOffice_KeySpace_API_DeleteItem(const char *pcGroup, const char *pcName);

INT32 AnyOffice_KeySpace_API_DeleteItemPrivate(const char *pcGroup, const char *pcName);

INT32 AnyOffice_KeySpace_API_DeleteGroup(const char *pcGroup);

INT32 AnyOffice_KeySpace_API_DeleteDeviceInfoGroup();



#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */


#endif /* __KEYSPACE_API_H__ */
