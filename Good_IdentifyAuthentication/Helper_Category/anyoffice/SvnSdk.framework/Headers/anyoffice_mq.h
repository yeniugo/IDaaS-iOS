/******************************************************************************

                  ��Ȩ���� (C), 2001-2011, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : mq.h
  �� �� ��   : ����
  ��    ��   : ������ 42408
  ��������   : 2005��7��13��
  ����޸�   :
  ��������   : ��Ϣ���й���ͷ�ļ�
  �����б�   :
  �޸���ʷ   :
  1.��    ��   : 2005��7��13��
    ��    ��   : ������ 42408
    �޸�����   : �����ļ�

******************************************************************************/

#ifndef __ANYOFFICE_MQ_H__
#define __ANYOFFICE_MQ_H__


#include <pthread.h>
//#include "svn_define.h"
//#include "secentry/common/secentry_pub.h"
#include "tools_common.h"
#include "anyoffice_thrsem.h"
#define     MQ_WAIT_FOREVER     0
#define     MQ_NO_WAIT          1

/*
    message queue struct;
*/
typedef struct tag_mq_s
{
    mutex_t   stmt;         /*���з�����*/
    thrsem_t  stsem;        /*�������ź�������������������м�����Ԫ*/

    USHORT    b;            /*���е�һ����Ԫ��λ��*/
    USHORT    e;            /*�������һ����Ԫ��λ��*/
    USHORT    mask;         /*��������*/
    USHORT    unit;         /*������ÿ����Ԫ�Ŀ��*/

    UCHAR     aucdata[0];   /*����Ԫ��ͷ��ַ*/
} mq_t;


extern INT32    mq_init(mq_t *pstmq, USHORT len, USHORT unit);
extern mq_t*    mq_create(USHORT len, USHORT unit);
extern INT32    mq_destroy(mq_t *pstmq);
extern INT32    mq_put(mq_t *pstmq, UCHAR *e);
extern INT32    mq_get(mq_t *pstmq, UCHAR *e, INT32 wait);

#endif /*__MQ_H__*/
