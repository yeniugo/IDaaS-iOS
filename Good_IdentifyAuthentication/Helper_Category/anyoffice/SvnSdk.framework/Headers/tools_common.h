/******************************************************************************

                  ��Ȩ���� (C), 2001-2013, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : tools_common.h
  �� �� ��   : ����
  ��    ��   : lifangxiang/00218420
  ��������   : 2013��11��1��
  ����޸�   :
  ��������   : tools_common.h ��ͷ�ļ�
  �����б�   :
  �޸���ʷ   :
  1.��    ��   : 2013��11��1��
    ��    ��   : lifangxiang/00218420
    �޸�����   : �����ļ�

******************************************************************************/
#ifndef __TOOLS_COMMON_H__
#define __TOOLS_COMMON_H__


/*----------------------------------------------*
 * ����ͷ�ļ�                                   *
 *----------------------------------------------*/
#include "tools_err.h"

#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif
#endif /* __cplusplus */
/*----------------------------------------------*
 * �ⲿ����˵��                                 *
 *----------------------------------------------*/

/*----------------------------------------------*
 * �ⲿ����ԭ��˵��                             *
 *----------------------------------------------*/

/*----------------------------------------------*
 * �ڲ�����ԭ��˵��                             *
 *----------------------------------------------*/

/*----------------------------------------------*
 * ȫ�ֱ���                                     *
 *----------------------------------------------*/

/*----------------------------------------------*
 * ģ�鼶����                                   *
 *----------------------------------------------*/

/*----------------------------------------------*
 * ��������                                     *
 *----------------------------------------------*/

/*----------------------------------------------*
 * �궨��                                       *
 *----------------------------------------------*/


/////////////////////////////

// iPhone OS's max length of file name is 256
//#define MAX_PATH          256
#ifndef VOS_INVALID_SOCKET
#define VOS_INVALID_SOCKET (-1)
#endif

#ifndef VOS_NULL_PTR
#define VOS_NULL_PTR 0L
#endif

#ifndef VOS_OK
#define VOS_OK 0
#endif

#ifndef VOS_ERR
#define VOS_ERR 1
#endif

#ifndef VOS_BOOL
#define VOS_BOOL unsigned int
#endif

#ifndef VOS_FALSE
#define VOS_FALSE 0
#endif

#ifndef VOS_TRUE
#define VOS_TRUE 1
#endif

#ifndef SIZE_T
#define SIZE_T unsigned long
#endif

/*----------------------------------------------*
 * �ڲ��ṹ����                                 *
 *----------------------------------------------*/

/*----------------------------------------------*
 * �ⲿ�ṹ����                                 *
 *----------------------------------------------*/

/*----------------------------------------------*
 * �����Ͷ���                                 *
 *----------------------------------------------*/
#ifndef VOS_UINT8
#define VOS_UINT8 unsigned char
#endif

#ifndef VOS_INT8
#define VOS_INT8 signed char
#endif

#ifndef VOS_UCHAR
#define VOS_UCHAR unsigned char
#endif

#ifndef VOS_UINT16
#define VOS_UINT16 unsigned short
#endif

#ifndef VOS_INT16
#define VOS_INT16 signed short
#endif

#ifndef VOS_WCHAR
#define VOS_WCHAR signed short
#endif

#ifndef VOS_INT
#define VOS_INT int
#endif

#ifndef VOS_UINT
#define VOS_UINT unsigned int
#endif

#ifndef VOS_FLOAT
#define VOS_FLOAT float
#endif

#ifndef  VOS_DOUBLE
#define  VOS_DOUBLE double
#endif

#ifndef PID
#define PID  unsigned long
#endif

#ifndef FID
#define FID unsigned long
#endif

#ifndef CPUSTATE
#define CPUSTATE unsigned long
#endif

#define MAX_PATH          260

#undef FAR
#undef  NEAR
#define FAR
#define NEAR


// android OS's max length of file name is 256
//#define MAX_PATH          256
#ifndef INT
#define INT int
#endif

#ifndef INT8
#define INT8 signed char
#endif
#ifndef INT16
#define INT16 signed short
#endif
#ifndef UINT8
#define UINT8 unsigned char
#endif

#ifndef UINT16
#define UINT16 unsigned short
#endif


#ifndef INT32
#define INT32 int
#endif

#ifndef UINT32
#define UINT32 unsigned int
#endif

#ifndef UINT
#define UINT unsigned int
#endif

#ifndef LONG
#define LONG long
#endif

#ifndef ULONG
#define ULONG  unsigned long
#endif

#ifndef SHORT
#define SHORT short
#endif

#ifndef USHORT
#define  USHORT unsigned short
#endif

#ifndef CHAR
#define CHAR char
#endif

#ifndef UCHAR
#define UCHAR unsigned char
#endif

#ifndef INT64
#define INT64 long long
#endif

#ifndef UINT64
#define UINT64 unsigned long long
#endif

#ifndef FLOAT
typedef float               FLOAT;
#endif

#ifndef DOUBLE
typedef double              DOUBLE;
#endif

#ifndef VOID
typedef void                VOID;
#endif

#ifndef VOS_UINT32
#define VOS_UINT32 unsigned int
#endif

#ifndef VOS_INT32
#define VOS_INT32 int
#endif

#ifndef VOS_CHAR
#define VOS_CHAR char
#endif

#ifndef VOS_VOID
#define VOS_VOID void
#endif

#ifndef VOS_SOCKET
#define VOS_SOCKET INT32
#endif


#if defined(__APPLE__)
#else
#ifndef BOOL
#   ifdef __cplusplus
typedef bool            BOOL;
#   else
#define BOOL int//android
#   endif
#endif
#endif


#ifndef CONST
#define CONST               const
#endif

#ifndef ECODE_E
typedef INT32               ECODE_E;
#endif
/*----------------------------------------------*
 * ���ó����궨��                               *
 *----------------------------------------------*/
#ifndef NUM_8
#define NUM_8 8
#endif

#ifndef NUM_16
#define NUM_16 16
#endif

#ifndef NUM_32
#define NUM_32 32
#endif

#ifndef NUM_64
#define NUM_64 64
#endif

#ifndef NUM_128
#define NUM_128 128
#endif

#ifndef NUM_256
#define NUM_256 256
#endif

#ifndef NUM_512
#define NUM_512 512
#endif

#ifndef NUM_1024
#define NUM_1024 1024
#endif


/*----------------------------------------------*
 * �����ֽں궨��                               *
 *----------------------------------------------*/
#ifndef SIZE_BYTE_8
#define SIZE_BYTE_8 NUM_8
#endif

#ifndef SIZE_BYTE_16
#define SIZE_BYTE_16 NUM_16
#endif

#ifndef SIZE_BYTE_32
#define SIZE_BYTE_32 NUM_32
#endif

#ifndef SIZE_BYTE_64
#define SIZE_BYTE_64 NUM_64
#endif

#ifndef SIZE_BYTE_256
#define SIZE_BYTE_256 NUM_256
#endif

#ifndef SIZE_BYTE_512
#define SIZE_BYTE_512 NUM_512
#endif

#ifndef SIZE_BYTE_1024
#define SIZE_BYTE_1024 NUM_1024
#endif

#ifndef SIZE_KBYTE
#define SIZE_KBYTE SIZE_BYTE_1024
#endif

#ifndef SIZE_KBYTE_16
#define SIZE_KBYTE_16 (NUM_16 * SIZE_KBYTE)
#endif


/*----------------------------------------------*
 * Ĭ��ֵ����                                   *
 *----------------------------------------------*/
/*Some systems define NULL as (-1), in our system, NULL must be (0). */
#define NULL (0)


#ifndef STATIC
#define STATIC static
#endif

/*----------------------------------------------*
 * BOOLֵ����                                   *
 *----------------------------------------------*/
#ifndef TRUE
#   ifdef __cplusplus
#   define TRUE true
#   else
#   define TRUE (1)
#   endif
#endif

#ifndef FALSE
#   ifdef __cplusplus
#   define FALSE false
#   else
#   define FALSE (0)
#   endif
#endif
/*----------------------------------------------*
 * ��ȫ�ͷź궨��                               *
 *----------------------------------------------*/
#ifndef TOOLS_HLP_FREE
#define TOOLS_HLP_FREE(ptr)\
            if ( NULL != (ptr) )\
            {\
                free(ptr);\
                (ptr) = NULL;\
            }
#endif


#ifndef TOOLS_HLP_FREE_EX
#define TOOLS_HLP_FREE_EX(ptr, freefunc)\
            if ( NULL != (ptr) )\
            {\
                if ( NULL != (freefunc) )\
                {\
                    freefunc(ptr);\
                }\
                (ptr) = NULL;\
            }
#endif
/*----------------------------------------------*
 * �ڴ�����                                     *
 *----------------------------------------------*/
#ifndef TOOLS_HLP_MALLOC
#define TOOLS_HLP_MALLOC(size) malloc(size)
#endif

//#ifndef TOOLS_HLP_REALLOC
//#define TOOLS_HLP_REALLOC(data, size)  realloc(data, size)
//#endif

#ifndef TOOLS_HLP_CALLOC
#define TOOLS_HLP_CALLOC(count, size)  calloc((count), (size))
#endif


//typedef void *HANDLE;

typedef unsigned long       DWORD;

typedef CHAR *NPSTR, *LPSTR, *PSTR;
typedef CONST CHAR *LPCSTR, *PCSTR;

typedef unsigned int UINT_PTR, *PUINT_PTR;

#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */


#endif /* __TOOLS_COMMON_H__ */

