/******************************************************************************

                  ��Ȩ���� (C), 2001-2011, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : svn_file_api_ex.h
  �� �� ��   : ����
  ��    ��   : zhaixianqi 90006553
  ��������   : 2013��4��25��
  ����޸�   :
  ��������   : �ļ��ӽ�����չ�ӿڼ��ṹ������
  �����б�   :
  �޸���ʷ   :
  1.��    ��   : 2013��4��25��
    ��    ��   : zhaixianqi 90006553
    �޸�����   : �����ļ�
  2.��    ��   : 2013��3��27��
    ��    ��   : zhaixianqi 90006553
    �޸�����   : �޸�FSM_SEEK_EΪSVN_SEEK_E

******************************************************************************/

#ifndef __SVN_FILE_API_EX_H__
#define __SVN_FILE_API_EX_H__

#include "svn_file_api.h"

#include <fcntl.h>


#include <sys/mman.h>
#include <sys/stat.h>


#ifdef __cplusplus
extern "C"
{
#endif

/*********************************************************
 *
 * ��չ������Ͷ���
 *
 *********************************************************/
struct tagFSM_FILE_EX;
struct tagFSM_MAPPING;

typedef struct tagFSM_FILE_EX       FSM_FILE_EX_S;          /* ��չ�ļ���� */
typedef struct tagFSM_MAPPING       FSM_MAPPING_S;          /* ӳ���� */
typedef unsigned long               FSM_HANDLE;             /* ϵͳ���ֵ */



/****************************************************************************
 *
 *  linux��Ȩ�޲���
 *
 ***************************************************************************/
typedef enum emFSM_OPENEX_FLAGS
{
    FSM_EX_ONLYREAD = O_RDONLY,             /* 0x0 ֻ��Ȩ�� */
    FSM_EX_ONLYWRITE= O_WRONLY,             /* 0x1 ֻдȨ�� */
    FSM_EX_RW       = O_RDWR,               /* 0x2 ��дȨ�� */
    FSM_EX_APPEND   = O_APPEND,             /* 0x100 ׷��ģʽ */
    FSM_EX_CREATE   = O_CREAT,              /* 0x200 ����ģʽ */
    FSM_EX_EXCEL    = O_EXCL,               /* 0x1000 ����ļ����ڣ�����ʧ�� */
    FSM_EX_TRUNC    = O_TRUNC               /* 0x2000 �����дȨ�ޣ��ļ���� */
} FSM_OPENEX_FLAGS_E;


/****************************************************************************
 *
 *  linux��ģʽ���� ����λ����
 *
 ***************************************************************************/
typedef enum emFSM_OPENEX_MODE
{
    FSM_S_IRWXU = S_IRWXU,                  /* 00700 Ȩ�ޣ�ͬlinux */
    FSM_S_IRUSR = S_IRUSR,                  /* 00400 Ȩ�ޣ�ͬlinux */
    FSM_S_IWUSR = S_IWUSR,                  /* 00200 Ȩ�ޣ�ͬlinux */
    FSM_S_IXUSR = S_IXUSR,                  /* 00100 Ȩ�ޣ�ͬlinux */

    FSM_S_IRWXG = S_IRWXG,                  /* 00070 Ȩ�ޣ�ͬlinux */
    FSM_S_IRGRP = S_IRGRP,                  /* 00040 Ȩ�ޣ�ͬlinux */
    FSM_S_IWGRP = S_IWGRP,                  /* 00020 Ȩ�ޣ�ͬlinux */
    FSM_S_IXGRP = S_IXGRP,                  /* 00010 Ȩ�ޣ�ͬlinux */

    FSM_S_IRWXO = S_IRWXO,                  /* 00007 Ȩ�ޣ�ͬlinux */
    FSM_S_IROTH = S_IROTH,                  /* 00004 Ȩ�ޣ�ͬlinux */
    FSM_S_IWOTH = S_IWOTH,                  /* 00002 Ȩ�ޣ�ͬlinux */
    FSM_S_IXOTH = S_IXOTH,                  /* 00001 Ȩ�ޣ�ͬlinux */

    /* BEGIN: Added by zhaixianqi 90006553, 2013/11/21   ���ⵥ��:OR.SDK.002*/
    FSM_S_WATCHLOG = 0x1000                 /* ����¼�����־ */
                     /* END:   Added by zhaixianqi 90006553, 2013/11/21 */

} FSM_OPENEX_MODE_E;

/****************************************************************************
 *
 *  �ڴ汣����־
 *
 ***************************************************************************/
typedef enum emFSM_PROT
{
    FSM_PROT_READ = PROT_READ,              /* 0x1 ҳ���ݿɶ� */
    FSM_PROT_WRITE= PROT_WRITE,             /* 0x2 ҳ���ݿ�д */
    FSM_PROT_EXEC = PROT_EXEC,              /* 0x4 ҳ���ݿ�ִ�� */
    FSM_PROT_NONE = PROT_NONE               /* 0x0 ҳ���ݲ��ɷ��� */
} FSM_PROT_E;

/****************************************************************************
 *
 *  ӳ���������
 *
 ***************************************************************************/
typedef enum emFSM_MAP_FLAGS
{
    FSM_MAP_SHARED = MAP_SHARED,            /* 0x01 ����ӳ������д���൱��������ļ� */
    FSM_MAP_PRIVATE = MAP_PRIVATE           /* 0x02 ˽��ӳ�䣬����Ӱ���ļ� */
} FSM_MAP_FLAGS_E;



/****************************************************************************
 *
 *  ˢ������
 *
 ***************************************************************************/
typedef enum emFSM_MS_FLAGS
{
    FSM_MS_ASYNC = MS_ASYNC,                /* 1 ˢ��,�������� */
    FSM_MS_INVAL = MS_INVALIDATE,           /* 2 ֪ͨ��Ч */
    FSM_MS_SYNC = MS_SYNC                   /* 4 ˢ��,�ȴ�������ɷ��� */
} FSM_MS_FLAGS_E;



/*****************************************************************************
 �� �� ��  : SVN_API_SetJudgeKeyCallBack
 ��������  : ����ָ���ļ���ʹ��ָ����Կ
 �������  : JudgeKeyCallBack pfJudgeKeyFunction
 �������  : ��
 �� �� ֵ  : unsigned long
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2013��3��15��
    ��    ��   : zhaixianqi 90006553
    �޸�����   : �����ɺ���

*****************************************************************************/
unsigned long SVN_API_SetJudgeKeyCallBack(JudgeKeyCallBack pfJudgeKeyFunction);


/*****************************************************************************
 �� �� ��  : SVN_API_SetJudgePathCallBack
 ��������  : ����·�������жϺ���
 �������  : JudgePathCallBack pfJudgePathFunction
 �������  : ��
 �� �� ֵ  : unsigned long
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2013��3��21��
    ��    ��   : zhaixianqi 90006553
    �޸�����   : �����ɺ���

*****************************************************************************/
unsigned long SVN_API_SetJudgePathCallBack(JudgePathCallBack pfJudgePathFunction);





/*****************************************************************************
 �� �� ��  : svn_getsize
 ��������  : ��ȡ�ļ���С,���Ļ�ȡ��Ӧ���Ĵ�С
 �������  : const char* pcPath                 �ļ�����·��
 �������  : N/A
 �� �� ֵ  : unsigned long                      �ļ���С,��ȡʧ�ܷ���-1
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int svn_getsize(const char* pcPath);


/*****************************************************************************
 �� �� ��  : svn_fopen_ex
 ��������  : linux��ʽ.��չ�ļ�����.���ļ�,��ȡ�ļ��������
 �������  : const char* pcPath                 �ļ�·��,��������·��
             FSM_OPENEX_FLAGS_E enFlag          �򿪲���
             FSM_OPENEX_MODE_E enMode           �ļ�Ȩ��
 �������  : ��
 �� �� ֵ  : FSM_FILE_EX_S*                     �ļ����
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
FSM_FILE_EX_S* svn_fopen_ex(const char* pcPath,
                            FSM_OPENEX_FLAGS_E enFlag,
                            int enMode);

/*****************************************************************************
 �� �� ��  : FSM_API_CloseFilEx
 ��������  : linux��ʽ.��չ�ļ�����.�ر��ļ��������,�ͷ���Դ
 �������  : FSM_FILE_EX_S* pstFileexHandle     svn_fopen_ex��õ��ļ����
 �������  : ��
 �� �� ֵ  : FSM_BOOL                           �����Ƿ�ɹ�
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int svn_fclose_ex(FSM_FILE_EX_S* pstFileexHandle);

/*****************************************************************************
 �� �� ��  : svn_fread_ex
 ��������  : linux��ʽ.��չ�ļ�����.��ȡ�ļ�����
 �������  : FSM_FILE_EX_S* pstFileexHandle     svn_fopen_ex��õ��ļ����
             unsigned char* pucOutBuf           �ⲿ��������Ļ���
             unsigned long ulOutBufSize         �����С
 �������  : ��
 �� �� ֵ  : unsigned long                      �ɹ���ȡ���ֽ���
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
unsigned long svn_fread_ex(FSM_FILE_EX_S* pstFileexHandle,
                           unsigned char* pucOutBuf,
                           unsigned long ulOutBufSize);


/*****************************************************************************
 �� �� ��  : svn_fwrite_ex
 ��������  : linux��ʽ.��չ�ļ�����.д���ļ�����
 �������  : FSM_FILE_EX_S* pstFileexHandle     svn_fopen_ex��õ��ļ����
             const unsigned char* pucInBuf      ��д������ݻ���
             unsigned long ulInCount            ���ݴ�С
 �������  : ��
 �� �� ֵ  : unsigned long                      �ɹ�д����ֽ���
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
unsigned long svn_fwrite_ex(FSM_FILE_EX_S* pstFileexHandle,
                            const unsigned char* pucInBuf,
                            unsigned long ulInDataCount);

/*****************************************************************************
 �� �� ��  : svn_fseek_ex
 ��������  : linux��ʽ.��չ�ļ�����.��λ�ļ��α�
 �������  : FSM_FILE_EX_S* pstFileexHandle     svn_fopen_ex��õ��ļ����
             long lOffset                       �α�ƫ����
             SVN_SEEK_E enOrigin                �α�ƫ�Ƴ�ʼλ��
 �������  : ��
 �� �� ֵ  : unsigned long                      ��ǰ�α�λ��
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int svn_fseek_ex(FSM_FILE_EX_S* pstFileexHandle,
                 long lOffset,
                 SVN_SEEK_E enOrigin);

/*****************************************************************************
 �� �� ��  : svn_ftell_ex
 ��������  : linux��ʽ.��չ�ļ�����.��ȡ��ǰ�ļ��α�
 �������  : FSM_FILE_EX_S* pstFileexHandle     svn_fopen_ex��õ��ļ����
 �������  : ��
 �� �� ֵ  : unsigned long                      ��ǰ�α�λ��
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
long svn_ftell_ex(FSM_FILE_EX_S* pstFileexHandle);

/*****************************************************************************
 �� �� ��  : svn_mmap
 ��������  : linux��ʽ.��չ�ļ�����.ӳ���ļ����ݵ��ڴ�,��ȡ�������
 �������  : void* pvReserved                   ����
             unsigned long ulSize               ӳ������С
             FSM_PROT_E enProt                  ӳ��������ģʽ
             FSM_MAP_FLAGS_E enFlags            ӳ��������ģʽ
             unsigned long ulOffset             ӳ����ƫ��
             FSM_FILE_EX_S* pstFileexHandle     ӳ���ļ����ļ����,svn_fopen_ex��õ��ļ����
 �������  : ��
 �� �� ֵ  : FSM_MAPPING_S*                     ӳ����
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
FSM_MAPPING_S* svn_mmap(        void* pvReserved,
                                unsigned long ulSize,
                                FSM_PROT_E enProt,
                                FSM_MAP_FLAGS_E enFlags,
                                unsigned long ulOffset,
                                FSM_FILE_EX_S* pstFileexHandle);


/*****************************************************************************
 �� �� ��  : svn_msync
 ��������  : linux��ʽ.��չ�ļ�����.ˢ��ӳ����
 �������  : FSM_MAPPING_S* pstAddr             ӳ����
             unsigned long ulSize               ˢ���ֽ���
             FSM_MS_FLAGS_E enFlags             ˢ�²���
 �������  : ��
 �� �� ֵ  : FSM_BOOL                           �����Ƿ�ɹ�
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int svn_msync(FSM_MAPPING_S* pstMapHandle,
              unsigned long ulSize,
              FSM_MS_FLAGS_E enFlags);

/*****************************************************************************
 �� �� ��  : svn_munmap
 ��������  : linux��ʽ.��չ�ļ�����.ȡ��ӳ����
 �������  : FSM_MAPPING_S* pstAddr             ӳ����
             unsigned long ulSize               �ֽ���
 �������  : ��
 �� �� ֵ  : FSM_BOOL                           �����Ƿ�ɹ�
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int svn_munmap(FSM_MAPPING_S* pstMapHandle, unsigned long ulSize);

/*****************************************************************************
 �� �� ��  : FSM_API_GetOperator
 ��������  : ��ӳ�����л�ȡ�ڴ����ָ��
 �������  : FSM_MAPPING_S* pstAddr             ӳ����
 �������  : ��
 �� �� ֵ  : void*                              �ڴ����ָ��
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
void* svn_getmapoperator(FSM_MAPPING_S* pstAddr);


/*****************************************************************************
 �� �� ��  : svn_gethandle_ex
 ��������  : linux��ʽ.��չ�ļ�����.��ȡϵͳ�ļ��������
 �������  : const FSM_FILE_EX_S* pstFileexHandle   �ļ����
 �������  : ��
 �� �� ֵ  : FSM_HANDLE                             ϵͳ�ļ����,��int, FILE*, HANDLE
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
FSM_HANDLE svn_gethandle_ex(const FSM_FILE_EX_S* pstFileexHandle);

/*****************************************************************************
 �� �� ��  : svn_ftruncate_ex
 ��������  : �޸��ļ���С
 �������  : FSM_FILE_EX_S* pstFileHandle          svn_fopen��õ��ļ����
             unsigned long lNewSize             �µ��ļ�����
 �������  : ��
 �� �� ֵ  : FSM_BOOL                           �ɹ�ʧ��
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int svn_ftruncate_ex(FSM_FILE_EX_S* pstFileexHandle, unsigned long ulNewSize);


#ifdef __cplusplus
}
#endif

#endif /* __SVN_FILE_API_EX_H__ */
