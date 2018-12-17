/******************************************************************************

                  ��Ȩ���� (C), 2006-2016, ��Ϊ�������˿Ƽ����޹�˾

 ******************************************************************************
�� �� ��  : cert.h
�� �� ��  : V200R002C10
��    ��  : �·� 90004813
��������  : 2014-11-5
����޸�  :
��������  : ��֤�鹦�ܵ���ؽӿ�
�����б�  : ��
�޸���ʷ  :
1.��    ��:
  ��    ��:
  �޸�����:
******************************************************************************/


#ifndef __ANYOFFICE_CERT_H__
#define __ANYOFFICE_CERT_H__

#ifdef __cplusplus
extern "C" {
#endif

#include "svn_define.h"
#include "anyoffice_csr.h"
#include <unistd.h>

ULONG AnyOffice_Cert_CreatPFX_by_X509AndEVPKEY(UCHAR *pucX509Cert ,ULONG ulX509Length,
        UCHAR *pucEVPKey,ULONG keyLength, UCHAR *pucKeyPassword,UCHAR **ppucPFXCert);
void AnyOffice_Cert_PrivateKey2Pkcs8(char *pcInPriKey, unsigned long ulInLen, char **ppcOutPriPkcs8Key, unsigned long *pulOutLen);
long AnyOffice_Cert_X509_cmp_time(char *pcInX509Buf, unsigned long ulInX509Len, time_t *cmp_time);
unsigned char **AnyOffice_Cert_Get_Issuer_Name(char *pcInX509Buf, unsigned long ulInX509Len);

/*****************************************************************************
 �� �� ��  : AnyOffice_Cert_UseCert
 ��������  : openssl���ÿͻ���֤���װ����
 �������  : void * sslctx
             void * x
 �������  : ��
 �� �� ֵ  : int
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2015��7��27��
    ��    ��   : suyaodong
    �޸�����   : �����ɺ���

*****************************************************************************/
int AnyOffice_Cert_UseCert(void * sslctx, void * x);

/*****************************************************************************
 �� �� ��  : AnyOffice_Cert_UsePriv
 ��������  : openssl���ÿͻ���֤��˽Կ��װ����
 �������  : void *sslctx
             void * pkey
 �������  : ��
 �� �� ֵ  : int
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2015��7��27��
    ��    ��   : suyaodong
    �޸�����   : �����ɺ���

*****************************************************************************/
int AnyOffice_Cert_UsePriv(void *sslctx, void * pkey);
#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */

#endif /* __CSR_H__ */
