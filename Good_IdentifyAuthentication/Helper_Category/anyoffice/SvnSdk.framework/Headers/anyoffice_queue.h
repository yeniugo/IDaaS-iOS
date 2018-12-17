/******************************************************************************

                  ��Ȩ���� (C), 2001-2011, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : anyoffice_queue.h
  �� �� ��   : ����
  ��    ��   : zhangwenhu
  ��������   : 2013��6��24��
  ����޸�   :
  ��������   : ��������Ķ���ʵ��
  �����б�   :
  �޸���ʷ   :
  1.��    ��   : 2013��6��24��
    ��    ��   : zhangwenhu
    �޸�����   : �����ļ�

******************************************************************************/

#ifndef ANYOFFICE_QUEUE_H__
#define ANYOFFICE_QUEUE_H__

#include <pthread.h>
#include "anyoffice_dlist.h"
#include "tools_common.h"

#ifdef  __cplusplus
extern "C" {
#endif

typedef void (*ANYOFFICE_FREE_CB)(void *ptr);
typedef ULONG (*ANYOFFICE_QUEUENODE_OP_CB)(void* argv1/*�Զ������*/, void* argv2/*�����н�������*/);

/*���нڵ㶨��  */
typedef struct tagANYOFFICE_QueueNode
{
    SVN_DLIST_HEAD_S            stNode;         /*˫����ڵ�  */
    VOID*                       pvData;         /*�ڵ�����ָ�� */
} ANYOFFICE_QUEUENODE_S;

/*������״���ж���  */
typedef struct tagANYOFFICE_Queue
{
    ULONG               usNodeCount;        /*���г���  */
    pthread_mutex_t     mutexQueue;

    SVN_DLIST_HEAD_S    stDataList;         /*���ݶ���  */
    SVN_DLIST_HEAD_S    stIdleList;         /*���ж���  */
} ANYOFFICE_QUEUE_S;

ANYOFFICE_QUEUE_S* ANYOFFICE_Queue_Create();
VOID ANYOFFICE_Queue_Release(ANYOFFICE_QUEUE_S* pstQueue, ANYOFFICE_FREE_CB cbFree);

LONG ANYOFFICE_Queue_Push(ANYOFFICE_QUEUE_S* pstQueue, VOID* pvData);
LONG ANYOFFICE_Queue_PushToHead(ANYOFFICE_QUEUE_S* pstQueue, VOID* pvData);
VOID* ANYOFFICE_Queue_Pop(ANYOFFICE_QUEUE_S* pstQueue);
VOID* ANYOFFICE_Queue_Peek(ANYOFFICE_QUEUE_S* pstQueue);
LONG ANYOFFICE_Queue_IsEmpty(ANYOFFICE_QUEUE_S* pstQueue);
LONG ANYOFFICE_Queue_Clear(ANYOFFICE_QUEUE_S* pstQueue, ANYOFFICE_FREE_CB cbFree);
LONG ANYOFFICE_Queue_Walk(ANYOFFICE_QUEUE_S* pstQueue, ANYOFFICE_QUEUENODE_OP_CB cbQueueNodeOP, VOID* pvData);
LONG ANYOFFICE_Queue_ItemCount(ANYOFFICE_QUEUE_S* pstQueue);

#ifdef  __cplusplus
}
#endif

#endif
