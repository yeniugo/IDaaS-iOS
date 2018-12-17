/******************************************************************************

                  ��Ȩ���� (C), 2001-2014, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : anyoffice_jni_util.h
  �� �� ��   : ����
  ��    ��   : zhangyantao 00103873
  ��������   : 2014��7��11��
  ����޸�   :
  ��������   : Java����
  �����б�   :
*
*

  �޸���ʷ   :
  1.��    ��   : 2014��7��11��
    ��    ��   : zhangyantao 00103873
    �޸�����   : �����ļ�

******************************************************************************/
#ifdef __TOOLS_JNI_UTIL_H__
#define __TOOLS_JNI_UTIL_H__

#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif
#endif /* __cplusplus */


#include "anyoffice_def.h"
#include "tools_common.h"
#include <jni.h>


extern ULONG Tools_JNI_GetStringFieldofObject(JNIEnv *env, jobject targetObject,
        CHAR* pcFieldName, CHAR **ppcValue);


ULONG Tools_JNI_SetBoolFieldofObject(JNIEnv *env, jobject targetObject,
                                     CHAR* pcFieldName, ULONG ulValue);

extern ULONG Tools_JNI_SetStringFieldofObject(JNIEnv *env, jobject targetObject,
        CHAR* pcFieldName, CHAR *pcValue);


jobject Tools_JNI_NewObject(JNIEnv *env, CHAR *pcClassName, CHAR *pcDescriptor, ...);


extern jvalue Tools_JNI_GetFieldofObject(JNIEnv *env,
        jobject targetObject,
        CHAR* pcFieldName,
        CHAR *pcDescriptor);

jvalue Tools_JNI_GetStaticObjFieldofClass(JNIEnv *env,
        CHAR *pcClassName,
        CHAR *pcFieldName,
        CHAR *pcDescriptor);

jvalue Tools_JNI_GetStaticObjFieldofClassByID(JNIEnv *env,
        jcalss clazz,
        CHAR *pcFieldName,
        CHAR *pcDescriptor);


extern jvalue Tools_JNI_CallStaticMethodByID(JNIEnv *env,
        jboolean *hasException,
        jclass clazz,
        jmethodID mid,
        CHAR *pcMethodProtocol, ...);

extern jvalue Tools_JNI_CallMethodByName(JNIEnv *env,
        jobject obj,
        jboolean *hasException,
        const CHAR *pcMethodName,
        const CHAR *pcMethodProtocol, ...);

extern jvalue Tools_JNI_CallMethodByID(JNIEnv *env,
                                       jobject obj,
                                       jboolean *hasException,
                                       jclass clazz,
                                       jmethodID mid,
                                       const CHAR *pcMethodProtocol, ...);


extern CHAR* Tools_JNI_jstring2char(JNIEnv *env, jobject jstringObj);


extern ULONG Tools_JNI_ParseAddressFromObj(JNIEnv *env, jobject inetAddress, CHAR **ppcAddress, ULONG *pulPort);


#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */


#endif

