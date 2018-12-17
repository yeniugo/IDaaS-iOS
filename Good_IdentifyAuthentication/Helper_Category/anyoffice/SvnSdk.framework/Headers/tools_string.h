/******************************************************************************

                  版权所有 (C), 2001-2014, 华为技术有限公司

 ******************************************************************************
  文 件 名   : tools_string.h
  版 本 号   : 初稿
  作    者   : lijingjin/90004727
  生成日期   : 2014年5月17日
  最近修改   :
  功能描述   : 
  函数列表   :
              Tools_String_Trim
  修改历史   :
  1.日    期   : 2013年5月17日
    作    者   : lijingjin/90004727
    修改内容   : 创建文件

******************************************************************************/
#ifndef __TOOLS_STRING_H__
#define __TOOLS_STRING_H__

/*----------------------------------------------*
 * 包含头文件                                   *
 *----------------------------------------------*/

#include "anyoffice_def.h"
#include "tools_common.h"
#include "securec.h"

#ifdef __cplusplus
extern "C" {
#endif


typedef enum
{
    TOOLS_COMMON_OK   = 0,
    TOOLS_ERROR_COMMON_UNDEFINED,
    TOOLS_ERROR_COMMON_PARAMETER,
    TOOLS_ERROR_COMMON_OUTOFMEMORY
}TOOLS_ERRNO_E;

void Tools_String_Trim(char * str);
int Tools_safe_snprintf_s(ULONG Line ,char* strDest, size_t destMax, size_t count, const char* format, ...);
ULONG tools_scnprintf(char * pchBuf, size_t size, const char *pchFmt, ...);
#define TOOLS_SNPRINTF    tools_scnprintf
#define TOOLS_STRNICMP    strnicmp
#define TOOLS_STRCASECMP  strcasecmp
/* BEGIN: Modified for PN:DTS2013101606962 对邮件头部分字段加密 by zhaopindong, 2013/10/12 */
#define TOOLS_STRLEN(a)      (NULL == (a) ? 0 : strlen(a))
/* END:   Modified for PN:DTS2013101606962 对邮件头部分字段加密 by zhaopindong, 2013/10/12 */
#define TOOLS_STRLEN_NOT_SAFE(a)      strlen(a)


INT32 Tools_String_StrCmp(CHAR *Str1, CHAR* Str2);
#define TOOLS_STRCMP      Tools_String_StrCmp
#define TOOLS_STRNCMP     strncmp
#define TOOLS_STRSTR      strstr


#define TOOLS_STRING_ISEMPTY(pcValue)   ((NULL == (pcValue)) || ('\0' == (pcValue)[0]))



#define TOOLS_STRTOUL(pcValue, ulValue) {if (NULL != pcValue) {ulValue = (ULONG)strtoul(pcValue, NULL, 10);}}
#define TOOLS_STRTOUS(pcValue, usValue) {if (NULL != pcValue) {usValue = (USHORT)strtoul(pcValue, NULL, 10);}}
#define TOOLS_STRTOUC(pcValue, ucValue) {if (NULL != pcValue) {ucValue = (UCHAR)strtoul(pcValue, NULL, 10);}}
#define TOOLS_STRTOL(pcValue,  iValue)  {if (NULL != pcValue) {iValue = strtol(pcValue, NULL, 10);}}

/* BEGIN: Added by LiJingjin 90004727, 2013/7/3   PN:迭代四需求开发*/
/* 传入的指针务必注意，如果是存在数据的，会先释放。 */
#define TOOLS_STRDUP(pcDst, pcSrc, ulLen)      {if (NULL != pcDst){ANYOFFICE_SAFE_FREE(pcDst);} ;if (NULL != pcSrc) {ulLen = TOOLS_STRLEN(pcSrc); pcDst = ANYOFFICE_MALLOC(ulLen + 1); {if (NULL != pcDst) {(void)TOOLS_STRNCPY_S(pcDst, ulLen + 1, pcSrc, ulLen);}}}}
/* END:   Added by LiJingjin 90004727, 2013/7/3 */

/* BEGIN: Added by ljj, 2014/11/3   PN:*/
#define TOOLS_MEMSET   memset_s
#define TOOLS_BEZERO(buf, len)  memset_s(buf, len, 0, len)
#define TOOLS_MEMCPY_S   memcpy_s
#define TOOLS_MEMMOVE_S  memmove_s

#define TOOLS_STRCPY_S   strcpy_s   
#define TOOLS_STRNCPY_S  strncpy_s  
#define TOOLS_STRCAT_S   strcat_s   
#define TOOLS_STRNCAT_S  strncat_s   
#define TOOLS_STRTOK_S   strtok_s   

#define TOOLS_SPRINTF_S   sprintf_s   
#define TOOLS_SNPRINTF_S(strDest, destMax,count,format, ...)\
        Tools_safe_snprintf_s(__LINE__ ,strDest, destMax, count,format, ##__VA_ARGS__)   
#define TOOLS_VSPRINTF_S  vsprintf_s   
#define TOOLS_VSNPRINTF_S vsnprintf_s   

#define TOOLS_SCANF_S     scanf_s     
#define TOOLS_VSCANF_S    vscanf_s     
#define TOOLS_FSCANF_S    fscanf_s     
#define TOOLS_VFSCANF_S   vfscanf_s     
#define TOOLS_SSCANF_S    sscanf_s     
#define TOOLS_VSSCANF_S   vsscanf_s     

#define TOOLS_GETS_S      gets_s     
/* END:   Added by ljj, 2014/11/3 */

#define TOOLS_STRING_COPY_AND_CAT(pcDes, ulDesLen, pcSrc, pcCatStr)  \
((VOID)TOOLS_STRCPY_S(pcDes, ulDesLen, pcSrc), (VOID)TOOLS_STRCAT_S(pcDes, ulDesLen, pcCatStr), pcDes)

#define TOOLS_SAFE_FREE_KEY(key, len)\
    if (NULL != (key) )\
    {\
        if ((len) > 0)\
        {\
            (void)memset_s((key), (len), 0, (len));\
        }\
        free((key));\
        (key) = NULL;\
    }\

#define TOOLS_SAFE_FREE_STRING_KEY(key)\
    if (NULL != (key))\
    {\
        unsigned long len = TOOLS_STRLEN((const char*)key);\
        (void)memset_s((key), (len), 0, (len));\
        free(key);\
        key = NULL;\
    }\

INT32 Tools_realloc_s(VOID *pOldMemPtr,ULONG ulOldSize, VOID **ppNewMemPtrPtr, ULONG ulNewSize);

char* Tools_String_StriStr( char *Str1, char *Str2 );


char* Tools_String_StrToJson(char *pcSrc,char* pcRes, char *pcDest , unsigned int ulMaxLenth);

#define TOOLS_XML_MAX_KEY_LEN 256
#define TOOLS_XML_MAX_VALUE_LEN 1024
LONG Tools_String_ParseXmlItem(CHAR* pcXml, CHAR* pcKey, CHAR* pcValue, ULONG ulValueBufLen);

LONG Tools_String_GetLocalEndian();

INT32 Tools_String_URLEncode(const UCHAR* pucSrc, ULONG ulSrcLen, UCHAR* pucDest, ULONG ulDestLen,ULONG *plDecoded);

UCHAR *AnyOffice_String_URLEncode(const UCHAR* pucSrc, ULONG ulSrcLen, ULONG *pulDstLen);

INT32 Tools_String_BinaryStream2HexStream(
    CHAR *pcBinaryStream, ULONG ulBinaryLen, CHAR **ppcHexStream);

char * Tools_String_Base64Encode(const unsigned char * in, int len);
UCHAR* AnyOffice_Encodebase64(UCHAR* src, ULONG ulSize);
INT32 Tools_String_EncryptAndBase64Encode(UCHAR *pucInput, UCHAR **ppucOutPut);


INT32 Tools_String_Base64DecodeAndDecrypt(UCHAR *pucInput, UCHAR **ppucOutPut);
char * Tools_String_Base64Decode(const char * in, int len, int *piOutLen);

VOID Tools_uppercase (CHAR *str);
void Tools_lowercase(CHAR *str);


LONG Tools_ltoa (LONG nVal, CHAR *szStr,UINT32 uilen);
int Tools_String_CompareEx(const char *str1, const char *str2);


#ifdef __cplusplus
}
#endif

#endif




