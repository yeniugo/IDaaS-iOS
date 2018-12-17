/******************************************************************************

                  版权所有 (C), 2001-2011, 华为技术有限公司

 ******************************************************************************
  文 件 名   : tools_socket.h
  版 本 号   : 初稿
  作    者   : y90004712
  生成日期   : 2014年7月11日
  最近修改   :
  功能描述   : VOS socket申明
  函数列表   :
*
*

  修改历史   :
  1.日    期   : 2014年7月11日
    作    者   : y90004712
    修改内容   : 创建文件

******************************************************************************/
#ifndef __TOOLS_SOCKET_H__
#define __TOOLS_SOCKET_H__

#ifdef __cplusplus
extern "C" {
#endif
#include <sys/socket.h>
#include <netinet/in.h>
#include <sys/select.h>
#include <sys/ioctl.h>
#include <netdb.h>

#include "tools_common.h"



/*----------------------------------------------*
 * 宏定义                                       *
 *----------------------------------------------*/
//typedef INT32 VOS_SOCKET;

//#ifndef VOS_INVALID_SOCKET
//#define VOS_INVALID_SOCKET (-1)
//#endif


/*----------------------------------------------*/
/*               ioctl相关常量定义                           */
/*----------------------------------------------*/
#ifndef FIONBIO
#include "tools_pub.h"
#endif



#define VOS_NTOHL ntohl
#define VOS_NTOHS ntohs
#define VOS_HTONL htonl
#define VOS_HTONS htons


/*----------------------------------------------*
 * 外部函数原型说明                             *
 *----------------------------------------------*/
extern VOS_UINT32 VOS_SocketInit(VOID);

extern VOS_SOCKET VOS_Accept(VOS_SOCKET s, struct sockaddr *paddr, VOS_INT32 * paddrlen);

extern VOS_UINT32 VOS_Inet_addr(VOS_CHAR* pString);

extern VOS_UINT32 VOS_Bind(VOS_SOCKET s, struct sockaddr *paddr, VOS_INT32 addrlen);

extern VOS_UINT32 VOS_Connect(VOS_SOCKET s, struct sockaddr *paddr, VOS_INT32 addrlen);

extern VOS_UINT32 VOS_Listen(VOS_SOCKET s, VOS_INT32 backlog);

extern VOS_UINT32 VOS_Recv(VOS_SOCKET s, VOS_CHAR * buf, VOS_INT32 len, VOS_INT32 flags);

extern VOS_UINT32 VOS_Recvfrom(VOS_SOCKET s, VOS_CHAR * buf, VOS_INT32 len, VOS_INT32 flags,

                               struct sockaddr * pfrom, VOS_INT32 * pfromlen);

extern VOS_UINT32 VOS_Send(VOS_SOCKET s, VOS_CHAR * buf, VOS_INT32 len, VOS_INT32 flags);

extern VOS_UINT32 VOS_Sendto(VOS_SOCKET s, VOS_CHAR * buf, VOS_INT32 len, VOS_INT32 flags,
                             struct sockaddr * pto, VOS_INT32 tolen);

extern VOS_SOCKET VOS_Socket(VOS_INT32 af, VOS_INT32 type, VOS_INT32 protocol);

extern VOS_UINT32 VOS_Shutdown(VOS_SOCKET s, VOS_INT32 how);

extern VOS_UINT32 VOS_CloseSocket(VOS_SOCKET s);

extern VOS_UINT32 VOS_Getpeername(VOS_SOCKET s, struct sockaddr * paddr, VOS_INT32 * paddrlen);

extern VOS_UINT32 VOS_Getsockname(VOS_SOCKET s, struct sockaddr * paddr, VOS_INT32 * paddrlen);

extern VOS_UINT32 VOS_Getsockopt(VOS_SOCKET s, VOS_INT32 level, VOS_INT32 optname,
                                 VOS_CHAR * poptval, VOS_INT32 * poptlen);

extern VOS_UINT32 VOS_Setsockopt(VOS_SOCKET s, VOS_INT32 level, VOS_INT32 optname,
                                 VOS_CHAR * poptval, VOS_INT32 poptlen);

extern VOS_UINT32 VOS_IoctlSocket(VOS_SOCKET s, VOS_INT32 cmd, VOS_INT32* parg);

extern VOS_UINT32 VOS_Select(VOS_INT32 width, fd_set * preadfds, fd_set * pwritefds,
                             fd_set * pexceptfds, struct timeval * ptimeout  );

extern struct hostent * VOS_Gethostbyname( CHAR *pszHostName);

extern VOS_UINT32 VOS_GetNetState();

extern VOS_VOID VOS_NetConnected();

extern VOS_VOID VOS_Inet_ntoa_b(VOS_UINT32 ulAddress, VOS_CHAR * pString);



#ifdef __cplusplus
}
#endif


#endif
