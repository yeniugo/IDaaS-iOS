#ifndef __TOOLS_FILE_H__
#define __TOOLS_FILE_H__
/******************************************************************************

                  ��Ȩ���� (C), 2001-2014, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : tools_file.h
  �� �� ��   : ����
  ��    ��   : zhangyantao
  ��������   : 2014��7��27��
  ����޸�   :
  ��������   : �ļ�������ع���
  �����б�   :
  �޸���ʷ   :
  1.��    ��   : 2014��7��27��
    ��    ��   : zhangyantao 00288282
    �޸�����   : �����ļ�

******************************************************************************/

#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif
#endif

#include "tools_common.h"


#ifndef PATH_MAX
#define PATH_MAX    512
#endif

INT32 Tools_File_Mkdir(CHAR *pcPath);



#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif

#endif


