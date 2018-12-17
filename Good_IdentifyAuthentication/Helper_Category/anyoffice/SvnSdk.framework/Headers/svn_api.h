#ifndef __SVN_API_H__
#define __SVN_API_H__

#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif
#endif /* __cplusplus */

/***************************************************************************************************/
/*                        �����÷�                                                                                                                                                                               */
/*                        SVN_API_InitEnv                                                          */
/*                               ||                                                                */
/*                               ||                                                                */
/*                               \/                                                                */
/*                        SVN_API_CreateTunnel                                                     */
/*                               ||                                                                */
/*                               ||                                                                */
/*                               \/                                                                */
/*                        SVN socket����                                                                                                                                                              */
/*                               ||                                                                */
/*                               ||                                                                */
/*                               \/                                                                */
/*                        SVN_API_DestroyTunnel                                                    */
/*                               ||                                                                */
/*                               ||                                                                */
/*                               \/                                                                */
/*                        SVN_API_CleanEnv                                                         */
/***************************************************************************************************/


/***************************************************************************************************/
/*                        �ӿڶ���                                                                 */
/***************************************************************************************************/

/*
�������ƣ�SVN_API_InitEnv
����ԭ�ͣ�unsigned long SVN_API_InitEnv()
����˵������ʼ��������л���
�����������
�����������
����ֵ  �� SVN_OK ��ʾ�ɹ�
           SVN_ERR��ʾʧ��
=========================================
ʹ��˵����Ӧ�ó��������ɹ�����ô˽ӿڳ�ʼ��������л�����ֻ���ڴ˺������سɹ��󣬺����Ľӿڲ�����ȷִ�С�
һ��Ӧ�ó���ʵ��ֻ����ô˽ӿ�һ�Σ���Ӧ�ó����˳�ʱ����SVN_API_CleanEnv()�������л���.
ע�⣺�˺�����ͬ��������ִ��ʱ����Ҫ1-10�����ң�ִ�й����л�������ǰ�߳�
*/
unsigned long SVN_API_InitEnv();

/*
�������ƣ�SVN_API_CleanEnv
����ԭ�Σ�unsigned long SVN_API_CleanEnv()
����˵��������������л�����
�����������
�����������
����ֵ  �� SVN_OK ��ʾ�ɹ�
           SVN_ERR��ʾʧ��
=========================================
ʹ��˵����Ӧ�ó���ر�ʱ���ô˽ӿ�����������л���.
*/
unsigned long SVN_API_CleanEnv();

typedef void (*DNS_RESOLVE_CALLBACK)(const char*, void*);
typedef void (*ANYOFFICE_DNS_RESOLVER)(const char*, DNS_RESOLVE_CALLBACK, void*);



/*Begin f00291727 2016-05-20 for dts DTS2016033106862 */
typedef int (*AnyOfficeWriteKeyspaceItem)(char * pcUserInfoKey,char* pcTypeName,char* pcuUserInfoValue);
int AnyOffice_setKeySapceExtUserInfo(AnyOfficeWriteKeyspaceItem savefunc);
/*End f00291727 2016-05-20 for dts DTS2016033106862 */
/*
�������ƣ�SVN_API_CreateTunnel
����ԭ�Σ�unsigned long SVN_API_CreateTunnel(SVN_REGISTER_INFO_S *pstRegisterInfo)
����˵�������������
���������SVN_REGISTER_INFO_S *pstRegisterInfo �Cע����Ϣ������SVN����IP/�˿ڡ�SVN�û���/����
          ��������/�����������ַ/�˿�/�˺�/����/��APN��Ϣ��ID/Name����ʹ�õ����ģʽ(DTLS/TLS/ UDP/TLS+UDPS)��״̬֪ͨ�ص�����ָ�롢��־����ص�����ָ�롣
�����������
����ֵ  �� SVN_OK ��ʾ�ɹ�
           SVN_ERR��ʾʧ��
=========================================
ͨ���ص�������ʽ��֪ͨӦ�ó����Ƿ��Ѿ������ɹ���������ο����״̬֪ͨ�ӿڣ�
����ʧ�ܣ�һ������β��Ϸ�,��������URL���˿ڡ��û��������벻��Ϊ�գ�ʹ�ô�������´���URL���˿ڲ���Ϊ�գ��ֻ�ƽ̨��֧�ִ�����
ʹ��˵�����˺������첽���õģ����������������������Ӧ�ó�������С����������ִ�н����󣬻����Ӧ�ó���ע��Ļص�������֪���������ִ�н����
*/
unsigned long SVN_API_CreateTunnel(SVN_REGISTER_INFO_S *pstRegisterInfo);


/*
�������ƣ�SVN_API_DestroyTunnel
����ԭ�Σ�unsigned long SVN_API_DestroyTunnel()
����˵�����رռ��������
�����������
�����������
����ֵ  �� SVN_OK ��ʾ�ɹ�
           SVN_ERR��ʾʧ��
=========================================
ʹ��˵������Ҫɾ�����ʱʹ�ã����������ӹ����е��ã�����ֹͣ���ӹ��̡�
*/
unsigned long SVN_API_DestroyTunnel();


/*
�������ƣ�SVN_API_GetTunnelIP
����ԭ�Σ�unsigned long SVN_API_GetTunnelIP (unsigned long *pulIPAddess, unsigned long *pulMask)
�����������
���������*pulIPAddess ���ڰ�ȫͨ�ŵ�ԴIP��������
          *pulMask ����IP���������루������
����ֵ  ��SVN_OK ��ʾ�ɹ�
          SVN_ERR��ʾʧ��
=========================================
ʹ��˵����������ý������ɹ��󣬵��� SVN_API_GetTunnelIP ��ȡ����IP���������롣����ȡ��GetLocalIpAddr ��ȡ����IP��������ͨ����
�ص����������ж��Ƿ�ĳĿ��IP�Ƿ�㲥��ַ��������Ҫ��װ���ܺʹ�Խ�����ӣ�����ʹ�ô˺������ص����IP������ȷ��ý�����Ļ�ͨ��

ע�⣺������ص�����IPΪ0xFFFFFFFF�����ʾ����SVN����ʧ�ܣ�Ӧ�ó�������ٴε���SVN_API_CreateTunnel�������������
*/
unsigned long SVN_API_GetTunnelIP(unsigned int *pulIPAddress, unsigned int *pulMask);


/*
�������ƣ�SVN_API_GetTunnelStatus
����ԭ�Σ�unsigned long  SVN_API_GetTunnelStatus (unsigned int *puiStatus, int *piErrorCode)
����˵������ȡ���״̬�Լ�������Ϣ
�����������
���������puiStatus ���״̬(SVN_STATUS_OFFLINE, SVN_STATUS_CONNECTING, SVN_STATUS_ONLINE)
���������piErrorCode     ������
����ֵ  �� SVN_OK ��ʾ�ɹ�
           SVN_ERR��ʾʧ��
=========================================
ʹ��˵�����˺������Ի�ȡ�����ʵʱ״̬�;�����Ϣ��ͨ��������ѯ�ķ�ʽ���Ի�ȡ������״̬��Ϣ�� ��״̬�����ص���ʽ��ȡһ�¡�
*/
unsigned long  SVN_API_GetTunnelStatus (unsigned int *puiStatus, int *piErrorCode);


/*
�������ƣ�SVN_API_GetVersion
����ԭ�Σ�const char* SVN_API_GetVersion()
����˵������ȡ�����İ汾��
�����������
���������
����ֵ  �� ���ذ汾�ŵ��ַ�������2.2.1051.1
*/
const char* SVN_API_GetVersion ();


/*
�������ƣ�SVN_API_SetLogParam
����ԭ�Σ�unsigned long SVN_API_SetLogParam(char * pcLogPath, unsigned long ulLogLevel)
����˵����ΪӦ�ó����ṩ�ӿڣ�������־�������־���·����������뽫��־������ļ�����pcLogPath��Ҫ��ΪNULL��Ĭ�����error��warning������־��
���������char * pcLogPath - ��־�洢·��
          unsigned long ulLogLevel - �����ĸ��ȼ�����־����ӡ���
�����������
����ֵ  �� SVN_OK ��ʾ�ɹ�
           SVN_ERR��ʾʧ��
*/
unsigned long SVN_API_SetLogParam(char * pcLogPath, unsigned long ulLogLevel);

/*
�������ƣ�SVN_API_GetSessionID
����ԭ�Σ�unsigned long SVN_API_GetSessionID(unsigned long *pulSessionIdLS, unsigned long *pulSessionIdMS)
����˵������ȡuser id �� session id
���������
�����������
����ֵ  �� SVN_OK ��ʾ�ɹ�
           SVN_ERR��ʾʧ��

*/
unsigned long SVN_API_GetSessionID(unsigned char ** ppucUserID, unsigned char **ppucSesstionID);
char * SVN_API_GetTunnelToken();

/*
�������ƣ�SVN_API_SetStatisticSwitch
����ԭ�Σ�unsigned long SVN_API_SetStatisticSwitch(unsigned long ulSwitch)
����˵��������ͳ�����ؿ��ء�
���������unsigned long ulSwitch - ͳ�����ؿ���
�����������
����ֵ  �� SVN_OK ��ʾ�ɹ�
           SVN_ERR��ʾʧ��
*/



unsigned long SVN_API_SetStatisticSwitch(unsigned long ulSwitch);

/*
�������ƣ�SVN_API_GetStatisticResult
����ԭ�Σ�void SVN_API_GetStatisticResult(SVN_STATISTIC_INFO_S *pstStatInfo)
����˵������ȡͳ��������Ϣ
�����������
���������SVN_STATISTIC_INFO_S *pstStatInfo - ͳ�ƵĽ��
����ֵ  ����
*/
void SVN_API_GetStatisticResult(SVN_STATISTIC_INFO_S *pstStatInfo);

/*
�������ƣ�SVN_API_Ping
����ԭ�Σ�unsigned long SVN_API_Ping (unsigned long ulIPAddr, unsigned long ulPacketSize,
                                      SVN_PingCallback  pfPingCallBack)
����˵��������PingĿ������IP��Ping���Ĵ�С��������Ping���ܡ�
���������unsigned long ulIPAddr          - ��PingĿ������IP
          unsigned long ulPacketSize      - ICMP���������������ݳ���
          SVN_PingCallback pfPingCallBack  - ICMP����Ļص�
�����������
����ֵ  �� SVN_OK ��ʾ�ɹ�
           SVN_ERR��ʾʧ��
*/
unsigned long SVN_API_Ping (unsigned long ulIPAddr, unsigned long ulPacketSize,
                            SVN_PingCallback  pfPingCallBack);

/*
�������ƣ�SVN_API_Traceroute
����ԭ�Σ�unsigned long SVN_API_Traceroute (unsigned long ulIPAddr, SVN_TracertCallback  pfTracertCallBack)
����˵��������TracerouteĿ������IP��������Traceroute���ܡ�
���������unsigned long ulIPAddr                 - TracerouteĿ������IP
        ��SVN_TracertCallback  pfTracertCallBack - tracert����Ļص�
�����������
����ֵ  �� SVN_OK ��ʾ�ɹ�
           SVN_ERR��ʾʧ��
*/
unsigned long SVN_API_Traceroute (unsigned long ulIPAddr, SVN_TracertCallback  pfTracertCallBack);




/*
�������ƣ�SVN_API_Encrypt
����ԭ�Σ�unsigned long SVN_API_Encrypt(unsigned char *pucInBuffer, unsigned long  ulLen, unsigned char *pucOutBuffer, unsigned long *pulOutLen)
����˵�����ṩ���ܽӿڡ�
���������unsigned char *pucInBuffer - ����������
          unsigned long  ulInLen     - ���ܳ��ȣ���󳤶�1024
���������unsigned char *pucOutBuffer - ���ܺ����ݣ�����ռ����������ĳ��ȣ�����Ϊ���ĳ��ȼ���32�ֽڣ��ڴ�ռ䲻��ΪNULL
          unsigned long *pulOutLen    - ���ܺ󳤶ȣ���Ϊ��δ���pucOutBuffer�ĳ��ȣ���Ϊ����������ݼ��ܺ�ĳ���
����ֵ  �� SVN_OK ��ʾ�ɹ�
           SVN_CRYPT_PARAMETER_ERR ��ʾ������δ���
           SVN_CRYPT_MEMORY_ERR ��ʾ���ܺ����BUFF���Ȳ���
*/
unsigned long SVN_API_Encrypt(unsigned char *pucInBuffer, unsigned long ulInLen,
                              unsigned char *pucOutBuffer, unsigned long *pulOutLen);
unsigned long SVN_API_EncryptLarge(unsigned char *pucInBuffer, unsigned long ulInLen,
                                   unsigned char **ppucOutBuffer, unsigned long *pulOutLen);

/*
�������ƣ�SVN_API_Decrypt
����ԭ�Σ�long  SVN_API_Decrypt(unsigned char *pucInBuffer, unsigned long ulInLen,
                                unsigned char *pucOutBuffer, unsigned long *pulOutLen)
����˵�����ṩ���ܽӿڡ��ýӿ�����ܽӿ�����ʹ�ã�ֻ�ܹ����ܾ����ܽӿڼ��ܺ�����ġ�
���������unsigned char * pucInBuffer - ����������
          unsigned long  ulInLen - ���ܳ��ȣ���󳤶�2048
���������unsigned char * pucOutBuffer - ���ܺ����ݣ�����ռ䲻��С�����ĳ���,�ڴ�ռ䲻��ΪNULL
          unsigned long * pulOutLen - ���ܺ󳤶ȣ��ڴ�ռ䲻��ΪNULL����Ϊ��δ���pucOutBuffer�ĳ��ȣ���Ϊ����������ݼ��ܺ�ĳ���
����ֵ  �� SVN_OK ��ʾ�ɹ�
           SVN_CRYPT_PARAMETER_ERR ��ʾ������δ���
           SVN_CRYPT_MEMORY_ERR ��ʾ���ܺ����BUFF���Ȳ���
*/
unsigned long SVN_API_Decrypt(unsigned char *pucInBuffer, unsigned long ulInLen,
                              unsigned char *pucOutBuffer, unsigned long *pulOutLen);

/*
���ܲ����б���
*/
unsigned long SVN_API_EncryptAndEncode(unsigned char *pucInput, unsigned long ulInputLen,
                                       unsigned char **ppucOutPut);

/*
�����ٽ���
*/
unsigned long SVN_API_DecodeAndDecrypt(unsigned char *pucInput, unsigned char **ppucOutPut,
                                       unsigned long *pulOutLen);

/*
�������ƣ�SVN_API_MD5
����ԭ�Σ�long SVN_API_MD5(unsigned char *pucInbuffer, unsigned long ulInLen,
                              unsigned char *pucOutbuffer, unsigned long *pulOutLen)
����˵����ժҪ�ӿڡ�
���������unsigned char * pucInBuffer - ��ժҪ����
          unsigned long ulInLen -��ժҪ���ݳ��ȣ���󳤶�1024
���������unsigned char * pucOutBuffer �C ժҪֵ���ڴ�ռ䲻��ΪNULL
          unsigned long * pulOutLen - ժҪֵ���ȣ��ڴ�ռ䲻��ΪNULL����Ϊ��δ���pucOutBuffer�ĳ��ȣ���Ϊ�������ժҪֵ�ĳ���
����ֵ  �� SVN_OK ��ʾ�ɹ�
           SVN_CRYPT_PARAMETER_ERR ��ʾժҪ��δ���
           SVN_CRYPT_MEMORY_ERR ��ʾժҪ�����BUFF���Ȳ���
*/
unsigned long SVN_API_MD5(unsigned char *pucInbuffer, unsigned long ulInLen,
                          unsigned char *pucOutbuffer, unsigned long *pulOutLen);
/*
 �������ƣ�unsigned long SVN_API_KeepAliveTimeout()
����ԭ�� ��unsigned long SVN_API_KeepAliveTimeout()
����˵�� ������ӿڡ��˽ӿ�����iPhone��̨�����£�Ӧ�ó�����ô˽ӿڱ��
������� ����
������� ����
����ֵ     ����������ֵ����Ϊunsigned long,���óɹ�����SVN_OK������ʧ�ܷ���SVN_ERR��
����         ���˺�������iphoneƽ̨�µ���,�ú�������ǰ��������ʼ������ɹ�
*/
unsigned long SVN_API_KeepAliveTimeout( );

/*
�������ƣ�SVN_API_AddServer
����ԭ�Σ�unsigned long SVN_API_AddServer(char *pcServerURL, unsigned short usServerPort)
����˵�������SVN��ַ�ӿڡ��˽ӿ����ڸ��ؾ��ⳡ���£�Ӧ�ó�����Ҫ�ڳ�ʼ���Ժ󣬵������ע��ӿ�ǰ���ô˽ӿڡ�
���������char * pcServerURL - ����URL
          unsigned short  usServerPort - ���ض˿�
�����������
����ֵ��SVN_OK��ʾ�ɹ���SVN_ERR��ʾʧ�ܡ�
*/
unsigned long SVN_API_AddServer(char *pcServerURL, unsigned short usServerPort);

/*
�������ƣ�SVN_API_SetNetState
����ԭ�Σ�void SVN_API_SetNetState(unsigned long ulNetState)
����˵�����������統ǰ����״̬.(ע�⣬ֻ��andriodƽ̨�²���Ҫ)
���������ulNetState - ��ǰ��״̬��
�����������
����ֵ����
*/
void SVN_API_SetNetState(unsigned long ulNetState);

void SVN_API_Set_KMC(int ulKmcState);

void SVN_API_Set_OS_Type(char* sysVersion);
/*
�������ƣ�SVN_API_SetWorkingDir
����ԭ�Σ�void SVN_API_SetWorkingDir(char * pcWorkingDir)
����˵��������svn�Ĺ���Ŀ¼���������ָ��app�ɶ���д��Ŀ¼(ע�⣬ֻ��andriodƽ̨�²���Ҫ).
            �˺��������ڵ���SVN_API_InitEnv֮ǰִ�С�
���������pcWorkingDir - app�ɶ���д��Ŀ¼����
�����������
����ֵ����
*/
void SVN_API_SetWorkingDir(char * pcWorkingDir);
void SVN_API_GetWorkingDir(char * pcWorkingDir);
/*
�������ƣ�SVN_API_SuspendNetwork
����ԭ�Σ�unsigned long SVN_API_SuspendNetwork()
����˵��������svn�����
�����������
�����������
����ֵ��SVN_OK
*/
unsigned long SVN_API_SuspendNetwork();

/*
�������ƣ�SVN_API_ResumeNetwork
����ԭ�Σ�unsigned long SVN_API_ResumeNetwork()
����˵�����ָ�svn�����
�����������
�����������
����ֵ��SVN_OK
*/
unsigned long SVN_API_ResumeNetwork();


/*
�������ƣ�SVN_API_Base64Encode
����ԭ�Σ�long SVN_API_Base64Encode(unsigned char *pszInBuf, int iInBufLen, unsigned char *pszOutBuf, int iOutBufLen);
����˵��������base64���롣
���������unsigned char *pszInBuf ����������
         int iInBufLen           �����볤��
         int iOutBufLen             ��������ݴ����ڴ泤��
���������unsigned char *pszOutBuf ���������
����ֵ��0-���������ʾ����󳤶�
*/
long SVN_API_Base64Encode(unsigned char *pszInBuf, int iInBufLen, unsigned char *pszOutBuf, int iOutBufLen);

/*
�������ƣ�SVN_API_Base64Decode
����ԭ�Σ�LONG SVN_API_Base64Decode(unsigned char *pszBuf, int iBufLen);
����˵��������base64���롣
���������unsigned char *pszBuf ����������
         int ibufLen           �����볤��
���������unsigned char *pszBuf ���������
����ֵ��0-���������ʾ����󳤶�
*/
long SVN_API_Base64Decode(unsigned char *pszBuf, int iBufLen);




/*
�������ƣ�SVN_API_AES256_Encrypt
����ԭ�Σ�unsigned long SVN_API_AES256_Encrypt(const unsigned char *pucIn,
                                            const unsigned long ulInLength,
                                            unsigned char *pucOut,
                                            unsigned long *pulOutLength,
                                            const unsigned char *pucKeySeed,
                                            const unsigned char *pucIV)
����˵���������ⲿ���ݡ�
���������  const unsigned char *pucIn  ����������
            const unsigned long ulLength    �����ܳ���
            const unsigned char *pucKeySeed ��Կ���Ӷ�����
            const unsigned char *pucIV      ��ʼ����������
���������unsigned char *pucOut       ���ܺ�����
            unsigned long *pulOutLength, ���ܺ����ݳ���
����ֵ��SVN_OK��ʾ�ɹ���SVN_ERR��ʾʧ��
*/
unsigned long SVN_API_AES256_Encrypt(const unsigned char *pucIn,
                                     const unsigned long ulInLength,
                                     unsigned char *pucOut,
                                     unsigned long *pulOutLength,
                                     const unsigned char *pucKeySeed,
                                     const unsigned char *pucIV);

/*
�������ƣ�SVN_API_AES256_Decrypt
����ԭ�Σ�unsigned long SVN_API_AES256_Decrypt(const unsigned char *pucIn,
                                            unsigned char *pucOut,
                                            const unsigned long ulLength,
                                            const unsigned char *pucKeySeed,
                                            const unsigned char *pucIV)
����˵���������ⲿ����Configuration files��
���������  const unsigned char *pucIn  ����������
            const unsigned long ulLength    �����ܳ���
            const unsigned char *pucKeySeed ��Կ���Ӷ�����
            const unsigned char *pucIV      ��ʼ����������
���������unsigned char *pucOut       ���ܺ�����
���������unsigned char *pucOut       ���ܺ�����
����ֵ��SVN_OK��ʾ�ɹ���SVN_ERR��ʾʧ��
*/
unsigned long SVN_API_AES256_Decrypt(const unsigned char *pucIn,
                                     unsigned char *pucOut,
                                     const unsigned long ulLength,
                                     const unsigned char *pucKeySeed,
                                     const unsigned char *pucIV);

/*
�������ƣ�SVN_API_ImportCert
����ԭ�Σ�unsigned long SVN_API_ImportCert(SVN_CLIENTCERT_INFO_S *pstClientCertInfo,
                                    SVN_SERVERCACERT_INFO_S *pstServerCACertInfo,
                                    const unsigned char *pszSubjectCN)
����˵��������ͻ���֤����豸CA֤�顣
���������  SVN_CLIENTCERT_INFO_S *pstClientCertInfo        �ͻ���֤�顢˽Կ��Ϣ�ṹ
            SVN_SERVERCACERT_INFO_S *pstServerCACertInfo    ָ����֤�����豸֤��ģ�������CA֤����
            const unsigned char *pszSubjectCN               ָ���Ŀͻ���֤��subject cn(commonname)
�����������
����ֵ  ��SVN_OK��ʾ�ɹ���������ʾʧ��
����    : 1:����Ŀͻ���֤�����ΪNULL,ΪNULLʱ�����ÿͻ���֤�顣
          2:�ýӿ�Ŀǰ��֧�ֵ����豸CA֤��,��pstServerCACertInfo����������
          3:����Ŀͻ���֤��subject cn����ΪNULL,ΪNULLʱ��У��ͻ���֤���commonname��
          4:�ͻ���֤��ΪPKCS12ʱ��pszPrivateKeyPwd Ϊ֤���ļ�������Կ��PEM��DERʱΪ˽Կ�ļ���������
          5:����Ҫ����֤�飬�ýӿڱ����ڵ�¼����ǰ�ɹ����á�
          6:�����֤�����ݱ�����֤������һ��
          7:PEM��DER��ʽ�Ŀͻ���֤�鵼��ʱ����ͬʱ����RSA˽Կ��Ϣ
          8:����֤���������Ʋ��սӿ��ĵ�˵��
*/
unsigned long SVN_API_ImportCert(SVN_CLIENTCERT_INFO_S *pstClientCertInfo,
                                 SVN_SERVERCACERT_INFO_S *pstServerCACertInfo,
                                 const unsigned char *pszSubjectCN);

unsigned long SVN_API_ParseCert(SVN_CLIENTCERT_INFO_S *pstClientCertInfo,    void **ppstX509Cert,
                                void **ppstEvpPKey);
unsigned long SVN_API_FreeCert(void **ppstX509Cert,
                               void **ppstEvpPKey);
/*
��������            ��SVN_API_LoadCACertFromFile
����ԭ��            ��unsigned long SVN_API_LoadCACertFromFile(unsigned char *pucCertPath)
����˵��            �������豸CA֤��
�������            ��unsigned char *pucCertPath                 ֤���ļ�·��
�������            ����
����ֵ              ��SVN_OK ��ʾ���óɹ�������ֵ��ʾʧ��
����                ��1.�ú����ǵ����豸CA֤��ĺ���


*/
unsigned long SVN_API_LoadCACertFromFile(unsigned char *pucCertPath);

unsigned long SVN_API_LoadCACertFromPem(unsigned char *pucCAContent);

/*
��������            ��SVN_API_ParseURL
����ԭ��            ��unsigned long  SVN_API_ParseURL(unsigned char* pucURL, unsigned long ulLen, SVN_ParseURLCallback pfParseURLCB, void *pvData)
����˵��            ��������������
�������            ��unsigned char* pucURL                 ����������
                      unsigned long ulLen                   ���������� ����
                      SVN_ParseURLCallback pfParseURLCB     ������֪ͨ����
                      void *pvData                          �ص��������
�������            ����
����ֵ              ��SVN_OK ��ʾ���óɹ�������ֵ��ʾʧ��
����                ��1.�ú������첽����,�������ͨ���ص�����֪ͨ
                      2.���ڽ������IP��Ŀǰֻ֧�����10���������ip���ء�

*/
unsigned long  SVN_API_ParseURL(unsigned char* pucURL, unsigned long ulLen, SVN_ParseURLCallback pfParseURLCB, void *pvData);


/*
��������            ��SVN_API_CreateTunnelEx
����ԭ��            ��unsigned long SVN_API_CreateTunnelEx(PREGISTERINFO pstRegisterInfo)
����˵��            �����������չ������ʹ����Ϣ֪ͨ�ص���������ʹ��ԭ״̬�ص�����
�������            ��pstRegisterInfo ���ע����Ϣ
�������            ����
����ֵ              ��SVN_OK ��ʾ�ɹ�������ֵ��ʾʧ��
����                �����������ô˽ӿڷ�������������˹���Ϊ�첽�����������
                      ��ɺ�ͨ���ص���������״̬
*/
unsigned long SVN_API_CreateTunnelEx(SVN_REGISTER_INFO_S *pstRegisterInfo);


/*
��������            ��SVN_API_InitEnvEx
����ԭ��            ��unsigned long SVN_API_InitEnvEx(unsigned long ulControlTypeMask, void* pPara);
����˵��            �������ʼ����չ�����������Ʋ�����ʼ��
�������            ��unsigned long ulControlTypeMask ���Ʋ�������
                      void* pPara                     ���Ʋ����ṹ��
�������            ����
����ֵ              ��SVN_OK ��ʾ�ɹ�������ֵ��ʾʧ��
����                ��1.�����ʹ�ô����Ʋ�����ʼ���ڴ棬�����ʹ�øýӿڣ�����ʹ��ԭ��ʼ���ӿ�SVN_API_InitEnv
                      2.Ŀǰ֧�����¿��Ʋ���
                            a.��ʼ���ڴ��С���ƣ�����λ0x1
*/
unsigned long SVN_API_InitEnvEx(unsigned long ulControlTypeMask, void* pPara);
/*BEGIN: add by tianxin kf35598 2012-8-8*/
/*
�������ƣ�SVN_API_RegisterProcessFuction
����ԭ�Σ�unsigned long SVN_API_RegisterProcessFuction(SVN_RegFuc pfFuction)
����˵����ע��MDM  ��Ϣ��������MTM ģ�顣
���������SVN_RegFuc pfFuction        MDM ע��ص�������
�����������
����ֵ  ��SVN_OK��ʾ�ɹ���������ʾʧ��
����    :
*/
unsigned long SVN_API_RegisterProcessFuction(SVN_RegFuc pfFuction);

/*END: add by tianxin kf35598 2012-8-8*/

/* BEGIN: Added by fengzhengyu, 2013/7/3 for:����ʵʱ��Ч*/
/*
�������ƣ�SVN_API_RegisterProcessFuctionAnyOffice
����ԭ�Σ�unsigned long SVN_API_RegisterProcessFuctionAnyOffice(SVN_RegFuc pfFuction)
����˵����ע��������AnyOffice������Ϣ�Ĵ�����
���������SVN_RegFuc pfFuction
�����������
����ֵ  ��SVN_OK��ʾ�ɹ���������ʾʧ��
����    :
*/
unsigned long SVN_API_RegisterProcessFuctionAnyOffice(SVN_RegFuc pfFuction);
/* END:   Added by fengzhengyu, 2013/7/3 */


/* BEGIN: Added by liushangshu, 2012/4/16 for:�������л�ʱ���ı����ص�ַ*/
/*****************************************************************************
* ��������            ��SVN_API_Resume
* ����ԭ��            ��unsigned long SVN_API_Resume(char *pNewIpAddr);
* ����                ���������л�ʱ���ı����ӵ����ص�ַ
*����                 : �ı����ӵ����ص�ַ
* ���������õĺ���    ����
* ���ñ������ĺ���    ��
* ���������õ�ȫ�ֱ�������
* ������Ӱ���ȫ�ֱ�����
*****************************************************************************/
unsigned long SVN_API_Resume(char *pNewIpAddr);
/* END: Added by liushangshu, 2012/4/16 for:�������л�ʱ���ı����ص�ַ*/


/*****************************************************************************
�������ƣ�SVN_API_UndoCAChecking
����ԭ�Σ�unsigned long SVN_API_UndoCAChecking()
����˵������������������ʱ���ر�У��CA��Ĭ�ϴ򿪼���
�����������
�����������
����ֵ��SVN_OKΪ�ɹ�
*****************************************************************************/
unsigned long SVN_API_UndoCAChecking();
unsigned long SVN_API_DoCAChecking();
unsigned long SVN_API_GetServiceTicket(SVN_GetServiceTicketCallback getServiceTicketCallback);

/*begin: add by chenfeng 90004813 for */
unsigned long SVN_API_GetTunnelMuteSeconds();
/*end: add by chenfeng 90004813 for */

unsigned long SVN_API_GetInfoByServiceTicket(const char * pcServiceTicket, SVN_GetInfoByServiceTicketCallBack serviceTicketValid);
/* BEGIN: Added by zwx316192, 2017/07/05 for:�Ϻ����У�ͳһ��֤�Ĵ��������� */
int  CMTM_GetLoinErrMessage(char **ppcErrMessage);
/* END: Added by zwx316192, 2017/07/05 */

#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */


#endif /* __SVN_API_H__ */
