/******************************************************************************

                  ��Ȩ���� (C), 2012-2020, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : anyoffice_array.h
  �� �� ��   : ����
  ��    ��   : ������/zKF69242
  ��������   : 2012��12��30��
  ����޸�   :
  ��������   :��ָ̬������ʵ��
  �����б�   :
              Tools_API_Array_GetCount
              Tools_API_Array_GetData
              Tools_API_Array_GetDataAtIndex
              Tools_API_Array_SetDataAtIndex
  �޸���ʷ   :
  1.��    ��   : 2012��12��30��
    ��    ��   : ������/zKF69242
    �޸�����   : �����ļ�, for OR.EAS.007, for OR.EAS.008

******************************************************************************/

#ifndef __ANYOFFICE_ARRAY_H__
#define __ANYOFFICE_ARRAY_H__

#ifdef __cplusplus
extern "C" {
#endif


/* array�ṹ�嶨�� */
typedef struct tagArray
{
    void **ppvArray;
    unsigned long ulLen;
    unsigned long ulMax;
} ARRAY_S;

ARRAY_S* Tools_API_Array_New(unsigned long ulInitSize);

int Tools_API_Array_Add(ARRAY_S *pstArray, void *pvData, unsigned long *ulIndx);

int Tools_API_Array_SetSize(ARRAY_S *pstArray, unsigned long ulNewSize);

int Tools_API_Array_Delete(ARRAY_S *pstArray, unsigned long ulIndx);

int Tools_API_Array_DeleteSlow(ARRAY_S *pstArray, unsigned long ulIndx);

int Tools_API_Array_DeleteFast(ARRAY_S *pstArray, unsigned long ulIndx);

/* Some of the following routines can be implemented as macros to
   be faster. If you don't want it, define NO_MACROS */

#ifdef NO_MACROS
/* Returns the array itself */
void** Tools_API_Array_GetData(ARRAY_S *);

/* Returns the number of elements in the array */
unsigned long Tools_API_Array_GetCount(ARRAY_S *);

/* Returns the contents of one cell */
void* Tools_API_Array_GetDataAtIndex(ARRAY_S *pstArray, unsigned long ulIndx);

/* Sets the contents of one cell */
VOID Tools_API_Array_SetDataAtIndex(ARRAY_S *pstArray, unsigned long ulIndx, void* pvValue);

#else
static void** Tools_API_Array_GetData(ARRAY_S *pstArray);
static unsigned long Tools_API_Array_GetCount(ARRAY_S *pstArray);
static void* Tools_API_Array_GetDataAtIndex(ARRAY_S *pstArray, unsigned long ulIndx);
static void Tools_API_Array_SetDataAtIndex(ARRAY_S *pstArray, unsigned long ulIndx, void *pvValue);
#endif

void Tools_API_Array_Free(ARRAY_S *pstArray);

#ifdef __cplusplus
}
#endif

#endif
