/******************************************************************************

                  ��Ȩ���� (C), 2001-2011, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : mdmsdk.c
  �� �� ��   : ����
  ��    ��   : kongsheng
  ��������   : 2013��12��6��
  ����޸�   :
  ��������   : �ʲ�����ģ����غ���
  �����б�   :
  �޸���ʷ   :
  1.��    ��   : 2013��12��6��
    ��    ��   : kongsheng
    �޸�����   : �����ļ�

******************************************************************************/
#ifndef __MDMSDK_API_H__
#define __MDMSDK_API_H__

typedef enum tagAssert_Bind_Result
{
    ASSERT_BINDED_BY_USER = 1,     /* �Ѿ�����ǰ��¼�û���
                        ���������Ƿ������û����ܣ����Ķ�����Э�飺�Ϸ��û������Խ��룩 */
    ASSERT_APPROVING = 2,                   /*�������Ƿ������û����ܣ�δ��&��������
                        ���������豸����������룩 */
    ASSERT_BYOND_LIMINT = 3,               /*�������Ƿ������û����ܣ�����������豸����
                         ����������룩*/
    ASSERT_BINDED_BY_OTHERS = 4,       /*   ���豸�ѱ������û���
                         ��δ�������û����ܣ���¼�û���ע���û�Ϊ��ͬ�û�����������룩 */
    ASSERT_REG_BY_OTHERS = 5,           /* �������Ƿ������û����ܣ����豸�ѱ������û�ע��,����������
                        ���������豸����������룩 */
    ASSERT_NONBINDED = 6,                  /*  δ��&�ɰ�
                        ����Ҫ����ע�ᣩ  */
    ASSERT_BINDED_FAILED = 7,             /* �������Ƿ������û����ܣ��ʲ���ʧ�ܣ�����ϵ����Ա�����ݿ����ʧ�ܣ� */
    ASSERT_AGREEMENT_NOREAD = 8,     /*  ע��ͨ������δ�鿴������Э��
                  ����ǰ��¼�û�Ϊ�ʲ�ע���ˣ���Ҫ�Ķ�����Э�飩 */
    ASSERT_AGREEMENT_NOREAD_OTHERS = 9,/*  ע��ͨ������δ�鿴������Э��
                   ���ѿ������û�:��ǰ��¼�û����ʲ�ע���ˣ���������룩 */
    ASSERT_BINDED_MULTIUSER = 10,  /* �Ѿ��������û���-----��ASSERT_BINDED_BY_OTHERS��Ӧ
                   ���������û����ܣ��Ϸ��û������Ķ�����Э����Խ��룩 */
    ASSERT_LOGON_TIMEOUT = 12,        /* ���豸����δ��¼:���ڶ��û���û���κ�һ���û���¼�����豸 */
    /* BEGIN: Added by hexinxin, 2014/2/17   PN:����������ּ�����*/
    ASSERT_REJECT_APPROVE = 13 /*����Ա�ܾ�����*/
                            /* END:   Added by hexinxin, 2014/2/17 */
} Assert_Bind_Result_E;

#define MDMSDK_KICKOFF             15
#define MDMSDK_NO_CHECKRESULT      16
#define MDMDSDK_UNKOWN_ERROR       0xFFFF


unsigned long SVN_API_CheckBind( char* pszInBuff,  long lInBuffLen);

/* BEGIN:   Added for PN:DTS2014041602406 by LiJingjin 90004727, 2014/4/16 */
int SVN_API_GetMdmViolationResult(char **ppcMdmCheckResult, unsigned long *pulOutLen);
/* END:   Added for PN:DTS2014041602406 by LiJingjin 90004727, 2014/4/16 */
int AnyOffice_API_SetMdmViolationResult(int iViolationType, int iViolationHandle);
int AnyOffice_API_SetMdmRepaireResult(int iViolationType);
void MDMSDK_API_SetIsMdmManager(int iFlag);

#endif
