/******************************************************************************

                  ��Ȩ���� (C), 2001-2011, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : anyoffice_login_private.h
  �� �� ��   : ����
  ��    ��   : y90004712
  ��������   : 2014��7��26��
  ����޸�   :
  ��������   : ��¼��ص��ڲ�����
  �����б�   :
*
*

  �޸���ʷ   :
  1.��    ��   : 2014��7��26��
    ��    ��   : y90004712
    �޸�����   : �����ļ�

******************************************************************************/
#ifndef __ANYOFFICE_LOGIN_PRIVATE_H__
#define __ANYOFFICE_LOGIN_PRIVATE_H__


#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif
#endif /* __cplusplus */

//typedef enum tagAutoLoginType
//{
//    AUTO_LOGIN_ENABLE = 1,
//    AUTO_LOGIN_DISABLE = 0,
//    AUTO_LOGIN_DEFAULT = 999
//} AUTO_LOGIN_TYPE_EN;


/* Ӧ��ǩ����Ϣ������Ӧ����֤ */
typedef struct tagAnyOfficeAppSignatureInfo
{
    CHAR *pcAppID;      /* Ӧ��ID, Androidƽ̨��Ӧ�ڰ��� */
    CHAR *pcPublicKey;  /* AndroidӦ��ǩ��֤�鹫Կ */
} ANYOFFICE_SIGNATURE_INFO_S;


typedef struct tagAnyOfficeInetAddress
{
    CHAR *pcHost;
    CHAR *pcIp;
    ULONG ulPort;
} ANYOFFICE_INET_ADDRESS;

/*
*  ��������ӿ�
*/
INT32 AnyOffice_API_CreateTunnel();
INT32 AnyOffice_API_ReCreateTunnel();

/* ���̴߳������ */
VOID AnyOffice_API_CreateTunnelAsyn();



#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */

#endif
