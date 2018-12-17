/******************************************************************************

                  ��Ȩ���� (C), 2001-2011, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : anyoffice_strconv.h
  �� �� ��   : ����
  ��    ��   : chenxingcheng
  ��������   : 2012��10��13��
  ����޸�   :
  ��������   : anyoffice_strconv ��ͷ�ļ�
  �����б�   :
  �޸���ʷ   :
  1.��    ��   : 2012��10��13��
    ��    ��   : chenxingcheng
    �޸�����   : �����ļ�

******************************************************************************/
#ifndef __ANYOFFICE_STRCONV_H__
#define __ANYOFFICE_STRCONV_H__

#include "tools_common.h"

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

/* BEGIN: Added by huangyiyuan hkf60364, 2013/5/28   PN:DTS2013052502935*/
typedef struct tagPtmCodeTable
{
    USHORT usFrom;
    USHORT usTo;
} PTM_CodeTable;


#define    PTM_TABLE_LEN 23940          /*gbk unicode��Ӧ��ĳ���*/



extern int AnyOffice_StrConv_Gbk2Unicode(UCHAR *gbk_buf, USHORT *unicode_buf, int max_unicode_buf_size, int endian);
extern int AnyOffice_StrConv_Unicode2Gbk(USHORT *unicode_buf, UCHAR *gbk_buf, int max_gbk_buf_size, int endian);

extern int AnyOffice_StrConv_Unicode2Utf8(USHORT *unicode_buf, UCHAR *utf8_buf, int max_utf8_buf_size, int endian);
extern int AnyOffice_StrConv_Utf82Unicode(UCHAR *utf8_buf, USHORT *unicode_buf, ULONG max_unicode_buf_size, int endian);

/* END:   Added by huangyiyuan hkf60364, 2013/5/28 */

#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */


#endif /* __ANYOFFICE_STRCONV_H__ */




