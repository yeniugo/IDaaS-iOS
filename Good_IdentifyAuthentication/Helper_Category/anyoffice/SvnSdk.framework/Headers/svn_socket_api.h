#ifndef __SVN_SOCKET_API_H__
#define __SVN_SOCKET_API_H__

#ifdef __cplusplus
#if __cplusplus
extern "C"{
#endif
#endif /* __cplusplus */

/***************************************************************/
/* 类型定义  */
/***************************************************************/

#define SVN_FD_SETSIZE      3072            
#define SVN_FDSETLEN        97              
#define SVN_NFDBITS         0x20            

/* 描述符集结构 */
typedef struct svn_fd_set
{
    int fds_bits[SVN_FDSETLEN];
}svn_fd_set;

#define SVN_FD_SET(n, p)   \
{\
    if ( (n) > 0 ) {\
        ((p)->fds_bits[(n)/SVN_NFDBITS] |= \
        (int)((0x80000000) >> ((n) % SVN_NFDBITS)));\
    }\
}

#define SVN_FD_CLR(n, p)    ((p)->fds_bits[(n)/SVN_NFDBITS] &= \
    (int)(~((0x80000000) >> ((n) % SVN_NFDBITS))))
    
#define SVN_FD_ISSET(n, p)  ((p)->fds_bits[(n)/SVN_NFDBITS] & \
    (int)((0x80000000) >> ((n) % SVN_NFDBITS)))
    
#define SVN_FD_ZERO(p)  { \
    int    lIter; \
    for ( lIter = 0; lIter < SVN_FDSETLEN; lIter++ ) { \
        ((p)->fds_bits[lIter] = 0); \
        } \
}
/***************************************************************/
/* 接口函数  */
/***************************************************************/

int svn_socket(int lFamily, int lType, int lProtocol);

int svn_bind(int lFd, struct sockaddr_in *pstSockAddr, unsigned int lAddrLen);

int svn_connect(int lFd, struct sockaddr_in *pstSockAddr, unsigned int lAddrLen);

int svn_listen(int lFd, int lBackLog);

int svn_accept(int lFd, struct sockaddr_in *pstSockAddr, unsigned int *plAddrLen);

int svn_close(int lFd);

int svn_shutdown(int lFd, int lHow);

long svn_recv(int lFd, char *pcBuf, int lLen, int lFlags);

long svn_recvfrom(int lFd, char *pcBuf, int lLen, int lFlags, struct sockaddr_in *pstFromAddr, unsigned int *plFromAddrLen);

long svn_send(int lFd, char *pcString, int lLen, int lFlags);

long svn_sendto(int lFd, char *pcString, int lLen, int lFlags, struct sockaddr_in *pstToAddr, unsigned int lToAddrLen);

int svn_ioctl(int lFd, unsigned int lCmd, int *plArg);

int svn_fcntl(int lFd, unsigned int lCmd, unsigned long *plArg);

int svn_setsockopt(int lFd, int lLevel, int lOptName, char *pcOptVal, unsigned int lOptLen);

int svn_getsockopt(int lFd, int lLevel, int lOptName, char *pcOptVal, unsigned int *plOptLen);

int svn_getsockname(int lFd, struct sockaddr_in *pstAddr, unsigned int *plAddrLen);

int svn_getpeername(int lFd, struct sockaddr_in *pstAddr, unsigned int *plAddrLen);

int svn_select(int lMaxFd, struct svn_fd_set *pstIn, struct svn_fd_set *pstOut, struct svn_fd_set *pstEx, struct timeval *pstTvO);

char *svn_strerror(int lErrno);

/* BEGIN: Added for PN:增加TCP over UDP模式 by y90004712, 2013/8/26 */
int svn_setusetls(int lFd);
/* END:   Added for PN:增加TCP over UDP模式 by y90004712, 2013/8/26 */


#define SHUTDOWN2(fd)   { (void)svn_shutdown((fd),2); (void)svn_close(fd); }

#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */

#endif
