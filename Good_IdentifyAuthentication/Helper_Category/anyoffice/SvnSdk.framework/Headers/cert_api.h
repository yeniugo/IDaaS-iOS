/******************************************************************************

                  ��Ȩ���� (C), 2001-2014, ��Ϊ�������޹�˾

******************************************************************************
  �� �� ��   : mdmsdk_chash.c
  �� �� ��   : ����
  ��    ��   : kongsheng
  ��������   : 2014��7��31��
  ����޸�   :
  ��������   :
  �����б�   :

  �޸���ʷ   :
  1.��    ��   : 2014��7��14��
    ��    ��   :
    �޸�����   : �����ļ�

******************************************************************************/
#ifndef CERT_API_H
#define CERT_API_H
#ifdef __cplusplus
extern "C" {
#endif

INT32 AnyOffice_API_GetCertificate(CHAR *pcUsername, CHAR **ppcData, ULONG *pulDataLen, CHAR **ppcPassword);
INT32 AnyOffice_API_GetAccountName( CHAR **ppcAccountName);


#ifdef __cplusplus
}
#endif

#endif
