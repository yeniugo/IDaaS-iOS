/******************************************************************************

                  版权所有 (C), 2001-2011, 华为技术有限公司

 ******************************************************************************
  文 件 名   : secmail_tools_pub.h
  版 本 号   : 初稿
  作    者   : y90004712
  生成日期   : 2013年2月5日
  最近修改   :
  功能描述   : 安全邮箱工具函数模块结构定义
  函数列表   :
*
*

  修改历史   :
  1.日    期   : 2013年2月5日
    作    者   : y90004712
    修改内容   : 创建文件, for OR.EAS.007, for OR.EAS.008

******************************************************************************/

#ifndef __ANUOFFICE_TOOLS_PUB_H__
#define __ANUOFFICE_TOOLS_PUB_H__

/* 编译打桩, 实现内存管理模块后删除 */
#include <stdlib.h>
#include <string.h>

/*----------------------------------------------*
 * 外部变量说明                                 *
 *----------------------------------------------*/

/*----------------------------------------------*
 * 外部函数原型说明                             *
 *----------------------------------------------*/

/*----------------------------------------------*
 * 内部函数原型说明                             *
 *----------------------------------------------*/

/*----------------------------------------------*
 * 全局变量                                     *
 *----------------------------------------------*/

/*----------------------------------------------*
 * 模块级变量                                   *
 *----------------------------------------------*/

/*----------------------------------------------*
 * 常量定义                                     *
 *----------------------------------------------*/

/*----------------------------------------------*
 * 宏定义                                       *
 *----------------------------------------------*/

#define MID_TOOLS   0x1

#define TOOLS_MALLOC(size) malloc(size)
//#define TOOLS_REALLOC(mid, data, size)  realloc(data, size) 危险函数禁用
#define TOOLS_CALLOC(mid, count, size)  calloc(count, size)
#define TOOLS_SAFE_FREE(data)\
    if ( NULL != data )\
    {\
        free(data);\
        data = NULL;\
    }

#ifndef ANYOFFICE_SAFE_FREE_EX
#define ANYOFFICE_SAFE_FREE_EX(ptr, freefunc)\
            \
            if ( NULL != (ptr) )\
            {\
                if( NULL != (freefunc) )\
                {\
                    (freefunc)((ptr));\
                }\
                (ptr) = NULL;\
            }
#endif
#endif
