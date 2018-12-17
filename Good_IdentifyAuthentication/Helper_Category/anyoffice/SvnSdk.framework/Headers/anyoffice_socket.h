/******************************************************************************

                  ��Ȩ���� (C), 2001-2014, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : anyoffice_socket.h
  �� �� ��   : ����
  ��    ��   : LiJingjin 90004727
  ��������   : 2014��5��6��
  ����޸�   :
  ��������   : ���ӹ������ӿ�
  �����б�   :
*
*
  �޸���ʷ   :
  1.��    ��   : 2014��5��6��
    ��    ��   : LiJingjin 90004727
    �޸�����   : �����ļ�

******************************************************************************/
#ifndef __ANYOFFICE_SOCKET_H__
#define __ANYOFFICE_SOCKET_H__

#ifdef __cplusplus
#if __cplusplus
extern "C"{
#endif
#endif /* __cplusplus */

/*----------------------------------------------*
 * ͷ�ļ�                                       *
 *----------------------------------------------*/
#include "tools_socket.h"
#include "anyoffice_socket_impl.h"

/*----------------------------------------------*
 * ��������                                     *
 *----------------------------------------------*/

/*----------------------------------------------*
 * �궨��                                       *
 *----------------------------------------------*/

#ifndef sockaddr
#define sockaddr svn_sockaddr
#endif
 
#ifndef fd_set
#define fd_set svn_fd_set
#endif
 
#ifndef timeval
#define timeval svn_timeval
#endif
 
/*----------------------------------------------*
 * ���ݽṹ����                                 *
 *----------------------------------------------*/

/*----------------------------------------------*
 * �ⲿ����ԭ��˵��                             *
 *----------------------------------------------*/
#define FD_SET       ANYOFFICE_FD_SET
#define FD_CLR       ANYOFFICE_FD_CLR
#define FD_ISSET     ANYOFFICE_FD_ISSET
#define FD_ZERO      ANYOFFICE_FD_ZERO
#define socket       anyoffice_socket
#define bind         anyoffice_bind
#define connect      anyoffice_connect
#define close        anyoffice_close
#define shutdown     anyoffice_shutdown
#define recv         anyoffice_recv
#define recvfrom     anyoffice_recvfrom
#define send         anyoffice_send
#define sendto       anyoffice_sendto
#define ioctl        anyoffice_ioctl
#define setsockopt   anyoffice_setsockopt
#define getsockopt   anyoffice_getsockopt
#define getsockname  anyoffice_getsockname
#define getpeername  anyoffice_getpeername
#define select       anyoffice_select
#define strerror     anyoffice_strerror

void anyoffice_set_usesdk(unsigned long ulUseSvnSocket);


#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */

#endif



