/******************************************************************************

                  ��Ȩ���� (C), 2001-2011, ��Ϊ�������޹�˾

 ******************************************************************************
  �� �� ��   : svn_file_api.h
  �� �� ��   : ����
  ��    ��   : zhaixianqi 90006553
  ��������   : 2013��3��22��
  ����޸�   :
  ��������   : �ļ��ӽ���ģ��Ľӿں������ṹ��
  �����б�   :
*
*

  �޸���ʷ   :
  1.��    ��   : 2013��3��22��
    ��    ��   : zhaixianqi 90006553
    �޸�����   : �����ļ�
  2.��    ��   : 2013��3��27��
    ��    ��   : zhaixianqi 90006553
    �޸�����   : �޸�FSM_SEEK_EΪSVN_SEEK_E

******************************************************************************/

#ifndef __SVN_FILE_API_H__
#define __SVN_FILE_API_H__


#ifdef __cplusplus
extern "C"
{
#endif



/****************************************************************************
 *
 *  �򵥳�������
 *
 ***************************************************************************/

 #ifdef ANYOFFICE_ANDROID
    #define PATH_LEN        (328)       /* Ŀ¼���� */
#else
    #define PATH_LEN        (434)       /* Ŀ¼���� */
#endif
#define KEY_LEN     (64)        /* ��Կ���� */
/* BEGIN: Added by liugang 90004755, 2013/11/27   PN:���������� SDKӦ�����ݲ���*/
#define IDENTIFIER_LEN  (256)       /*Ӧ�ð�������*/
#define SANDBOX_PATH_PREFIX     "/mnt/sdcard/sandbox"       /*ɳ��·��ǰ׺*/
/* END:   Added by liugang 90004755, 2013/11/27 */

#ifndef SVN_F_OK
#  define SVN_F_OK 0
#  define SVN_X_OK 1
#  define SVN_W_OK 2
#  define SVN_R_OK 4
#endif


/****************************************************************************
 *
 *  Ŀ¼����
 *
 ***************************************************************************/
typedef enum emSVN_DIR_TYPE
{
    SVN_TYPE_DIR = 0,           /* Ŀ¼ */
    SVN_TYPE_FILE,              /* �ļ� */
    SVN_TYPE_UNKNOWN            /* δ���� */
} SVN_DIR_TYPE_E;


/****************************************************************************
 *
 *  Ŀ¼��Ϣ
 *
 ***************************************************************************/
typedef struct tagSVN_DIRINFO
{
    char            acDirName[PATH_LEN];    /* Ŀ¼���� */
    SVN_DIR_TYPE_E  enType;                 /* Ŀ¼���� */
} SVN_DIRINFO_S;


typedef enum enEncryptFlag
{
    E_ENCRYPT_NOSEC = 0,        /* ������ */
    E_ENCRYPT_DEFAULTSEC = -1,  /* ����Ĭ����Կ���� */
    E_ENCRYPT_ASSIGNKEY = 1,    /* ����ָ����Կ����*/
} ENCRYPT_FLAG_E;

typedef struct tagSvnKeyInfo
{
    ENCRYPT_FLAG_E enEncrypt; /* �ӽ�����Կ��ʶ */
    unsigned char aucAbsKey[KEY_LEN]; /* ��Կ���� */
} SVN_KEY_INFO_S;


typedef enum enSvnEncMode
{
    E_SVN_ENC_MODE_STEADYKEY = 0, /* ��ʾ�̶���Կ*/
    E_SVN_ENC_MODE_ONLINEKEY = 1,/* ��ʾ������Կ*/
} SVN_ENC_MODE_E;



typedef struct tagSvnLoginInfo
{
    unsigned long ulIp;                     /* ����IP */
    unsigned short usPort;                  /* ���ض˿� */
    unsigned short usUserId;                /* ��¼UserID */
    unsigned short usSessionId;             /* ��¼SessionID */
} SVN_LOGIN_INFO_S;



/****************************************************************************
 *
 *  �ļ�ָ�붨λ����
 *
 ***************************************************************************/
typedef enum emSVN_SEEK
{
    SVN_SEEK_SET = 0,           /* �ļ���ʼλ�� */
    SVN_SEEK_CUR,               /* �ļ���ǰλ�� */
    SVN_SEEK_END                /* �ļ�ĩβλ�� */
} SVN_SEEK_E;


struct tagSVN_FILE;
struct tagSVN_DIR;


typedef struct tagSVN_FILE          SVN_FILE_S;             /* �ļ���� */
typedef struct tagSVN_DIR           SVN_DIR_S;              /* Ŀ¼��� */



/****************************************************************************
 *
 *  �������
 *
 ***************************************************************************/
typedef enum emSVN_ERRNO
{
    SVN_E_UNAPPAUTH = -1002, /* Ӧ��δУ�� */
    SVN_E_UNKNOWN = -1000,
    /*Begin modify by fanjiepeng ���ݹ���(�ļ��ܼ�) IR-0000369933*/
    SVN_E_NOPERMISSION = -33,     /*��Ȩ�޶�д�ļ� �ļ��ܼ�����*/
    /*End modify by fanjiepeng ���ݹ���(�ļ��ܼ�) IR-0000369933*/
    SVN_E_NOTEXIST = -32,         /*�ļ�������*/
    SVN_E_UNSUPORTFILE = -31,     /*���ļ�ʱ�����ֲ�ʶ����ļ�*/
    SVN_E_UPGRADEERR = -30,     /*�����쳣*/
    SVN_E_EXSISTSAMEFILE_APPEND = -29,     /*׷��ģʽ���Ѵ�������ͬ���ļ�*/
    SVN_E_NOINIT = -28,     /*δ��ʼ*/
    SVN_E_FILEPATH = -27,   /* ���ٹ���·�� */
    SVN_E_DIRTYPE = -26,
    SVN_E_CALLDLL = -25,
    SVN_E_DLLFUNC = -24,
    SVN_E_DLLOPEN = -23,
    SVN_E_OVERRECU = -22,
    SVN_E_OVERDEEP = -21,
    SVN_E_GETDECKEY = -20,
    SVN_E_GETENCKEY = -19,
    SVN_E_GETKEY = -18,
    SVN_E_DECRYPT = -17,
    SVN_E_DECRYPTINIT = -16,
    SVN_E_ENCRYPT = -15,
    SVN_E_ENCRYPTINIT = -14,
    SVN_E_NOALG = -13,
    SVN_E_B64ENCODE = -12,
    SVN_E_PARAM = -11,          /* �����쳣 */
    SVN_E_ENCFILE = -10,
    SVN_E_FILEPOINT = -9,
    SVN_E_OUTOFFILE = -8,
    SVN_E_INPUT = -7,           /* ������������ */
    SVN_E_EMPTYDRIVER = -6,
    SVN_E_OUTOFMEMORY = -5,
    SVN_E_CHECK = -4,
    SVN_E_NOTAIL = -3,
    SVN_E_ACCESS = -2,
    SVN_E_FAIL = -1,
    SVN_S_OK = 0,
    SVN_S_EXIST = 1,
    SVN_S_EOF = 2,
    SVN_S_NOSECURITY = 3,
    SVN_S_NOUPDATE = 4,
    SVN_S_NOFILENAME = 5,
    SVN_S_SPECIALFILE = 6,
} SVN_ERRNO_E;

/****************************************************************************
 *
 *  �ļ���Ŀ¼��ϸ��Ϣ
 *
 ***************************************************************************/
typedef struct tagSVN_STAT
{
    unsigned short ulMode;          /* �ļ�Ȩ�� */
    unsigned long ulCreateTime;     /* �ļ�����ʱ�� */
    unsigned long ulModifyTime;     /* �ļ��޸�ʱ�� */
    unsigned long ulAccessTime;     /* �ļ�������ʱ�� */
    unsigned long ulSize;           /* �ļ���С */
} SVN_STAT_S;



/* ����ָ��Ŀ¼ָ����Կ�ĺ������� */
typedef long (*JudgeKeyCallBack)(const char* pcFolder, SVN_KEY_INFO_S* pstKeyInfo);


/* ·�������жϺ������� */
typedef char* (*JudgePathCallBack)(const char* pcFolder, unsigned long ulFolderLength);


/****************************************************************************
 *
 *  ��ʼ����������
 *
 ***************************************************************************/
/*****************************************************************************
 �� �� ��  : SVN_API_FileEncInitEnv
 ��������  : ��ʼ������Ŀ¼����ʼ���ӽ���ģ��
 �������  : const char* pcWorkPath
 �������  : ��
 �� �� ֵ  : unsigned long
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2013��3��15��
    ��    ��   : zhaixianqi 90006553
    �޸�����   : �����ɺ���

*****************************************************************************/
unsigned long SVN_API_FileEncInitEnv (const char* pcWorkPath);

/* BEGIN: Added by liugang 90004755, 2013/11/27   PN:���������� SDKӦ�����ݲ���*/
/*****************************************************************************
 Prototype    : SVN_API_FileInitSandbox
 Description  : ��FSMģ���ʼ��Ӧ�ð�����Ϊ�յ�ʱ�򣬳�ʼ��Ӧ��ɳ��·��
 Input        : None
 Output       : None
 Return Value : unsigned
 Calls        :
 Called By    :

  History        :
  1.Date         : 2013/11/28
    Author       : liugang 90004755
    Modification : Created function

*****************************************************************************/
/* BEGIN: Added by liugang 90004755, 2013/12/12   PN:DTS2013121201292 ��B050-3����ȫSDK���ݲ�����iOS����ʹ��ɳ�г�ʼ��������ؽӿڣ���Ҫ��ƽ̨���νӿ�*/
/* ֻ��Android ��Ҫɳ�г�ʼ�������ؽӿ�:SVN_API_FileInitSandbox��SVN_API_FileEraseSandboxFile��SVN_API_FileClearSandbox*/
#if (VOS_OS_VER == VOS_ANDROID)
/* END:   Added by liugang 90004755, 2013/12/12 */
unsigned long SVN_API_FileInitSandbox(const char* pcIdentifier);

/*****************************************************************************
 Prototype    : SVN_API_FileEraseSandboxFile
 Description  : ����ɳ��·��Ӧ�ð���Ŀ¼�µ������ļ���Ŀ¼������Ӧ�ð���Ŀ¼
                ��
 Input        : const char* pcIdentifier
 Output       : None
 Return Value : unsigned
 Calls        :
 Called By    :

  History        :
  1.Date         : 2013/12/5
    Author       : liugang 90004755
    Modification : Created function

*****************************************************************************/
unsigned long SVN_API_FileEraseSandboxFile(const char* pcIdentifier);

/*****************************************************************************
 Prototype    : SVN_API_FileClearSandbox
 Description  : ����SDKӦ�ð�����ɾ��Ӧ�õ�SDK����
 Input        : None
 Output       : None
 Return Value : unsigned
 Calls        :
 Called By    :

  History        :
  1.Date         : 2013/11/30
    Author       : liugang 90004755
    Modification : Created function

*****************************************************************************/
unsigned long SVN_API_FileClearSandbox();
/* BEGIN: Added by liugang 90004755, 2013/12/12   PN:DTS2013121201292 ��B050-3����ȫSDK���ݲ�����iOS����ʹ��ɳ�г�ʼ��������ؽӿڣ���Ҫ��ƽ̨���νӿ�*/
#endif
/* END:   Added by liugang 90004755, 2013/12/12 */
/*****************************************************************************
 Prototype    : SVN_API_FileCleanDir
 Description  : ʹ��Libc���������ļ��в���ɾ����
 Input        : const char* pcDir
 Output       : None
 Return Value : unsigned
 Calls        :
 Called By    :

  History        :
  1.Date         : 2013/11/30
    Author       : liugang 90004755
    Modification : Created function

*****************************************************************************/
unsigned long SVN_API_FileCleanDir(const char* pcDir);
/* END:   Added by liugang 90004755, 2013/11/27 */

typedef  unsigned long (*funtypeSVN_API_WriteDeviceInfoGroupItem)(char *pcItemName, char *pcItemValue);
typedef  unsigned long (*funtypeSVN_API_ReadDeviceInfoGroupItem)(char *pcItemName, char **ppcItemValue);
typedef  char * (*funtypeSVN_API_GetKeySeedFromKeychain)();
void SVN_API_SetCallbackWriteDeviceInfoGroupItem(funtypeSVN_API_WriteDeviceInfoGroupItem callback);
void SVN_API_SetCallbackReadDeviceInfoGroupItem(funtypeSVN_API_ReadDeviceInfoGroupItem callback);
void SVN_API_SetCallbackGetKeySeedFromKeychain(funtypeSVN_API_GetKeySeedFromKeychain callback);


/*****************************************************************************
 �� �� ��  : SVN_API_SetSteadyKey
 ��������  : ���ù̶���Կ���Ӳ���
 �������  :
                const char* pcUserName : �û���
                const char* pcDeviceID : �豸ID

 �������  : ��
 �� �� ֵ  : unsigned long
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2013��4��7��
    ��    ��   : zhaixianqi 90006553
    �޸�����   : �����ɺ���

*****************************************************************************/
long SVN_API_SetSteadyKey( const char* pcUserName, const char* pcDeviceID );

/*****************************************************************************
 �� �� ��  : SVN_API_FileEncCleanEnv
 ��������  : ȥ��ʼ���ļ��н��ܻ���
 �������  : ��
 �������  : ��
 �� �� ֵ  : void
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2013��3��20��
    ��    ��   : zhaixianqi 90006553
    �޸�����   : �����ɺ���

*****************************************************************************/
void SVN_API_FileEncCleanEnv ();


/*****************************************************************************
 �� �� ��  : SVN_API_SetFileEncMode
 ��������  : �����ļ��ӽ�����Կ����
 �������  : SVN_ENC_MODE_E enMode
 �������  : ��
 �� �� ֵ  : unsigned long
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2013��3��21��
    ��    ��   : zhaixianqi 90006553
    �޸�����   : �����ɺ���

*****************************************************************************/
unsigned long SVN_API_SetFileEncMode(SVN_ENC_MODE_E enMode, SVN_LOGIN_INFO_S *pstLoginInfo);



/*****************************************************************************
 �� �� ��  : SVN_API_GetEncFilePath
 ��������  : ��ȡ���ܺ���ļ�·��
 �������  : const char* pcPath
             char* pcEncPath
             unsigned long ulEncPathLen
 �������  : ��
 �� �� ֵ  : unsigned long
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2013��3��26��
    ��    ��   : zhaixianqi 90006553
    �޸�����   : �����ɺ���

*****************************************************************************/
long SVN_API_GetEncFilePath(const char* pcPath, char* pcEncPath, unsigned long ulEncPathLen);


/****************************************************************************
 *
 *  libc��ʽ�ļ���������
 *
 ***************************************************************************/
/*****************************************************************************
�� �� ��  : svn_fopen
��������  : ��׼c��ʽ.���ļ�,��ȡ�ļ����
�������  : const char* pcPath                 �ļ�·��
            const char* pcMode                 �ļ���ģʽ
�������  : ��
�� �� ֵ  : SVN_FILE_S*                        �ļ��������
���ú���  :
��������  :

�޸���ʷ      :
 1.��    ��   : 2012��6��19��
   ��    ��   : ���<l00218420>
   �޸�����   : �����ɺ���

*****************************************************************************/
SVN_FILE_S*     svn_fopen(
    const char*             pcPath,
    const char*             pcMode);


/*****************************************************************************
 �� �� ��  : svn_fclose
 ��������  : ��׼c��ʽ.�ر��ļ����,������Դ
 �������  : SVN_FILE_S* pstFileHandle          �ļ��������
 �������  : ��
 �� �� ֵ  : FSM_BOOL                           �ɹ�/ʧ��
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int        svn_fclose(SVN_FILE_S*             pstFileHandle);


/*****************************************************************************
 �� �� ��  : svn_fread
 ��������  : ��׼c��ʽ.��ȡ�ļ�����
 �������  : unsigned char* pucOutBuf           �ⲿ��������Ļ���
             unsigned long ulOutBufSize         �����С
             SVN_FILE_S* pstFileHandle          FSM_API_OpenFile��õ��ļ����
 �������  : ��
 �� �� ֵ  : unsigned long                      �ɹ���ȡ���ֽ���
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
unsigned long   svn_fread(
    unsigned char*          pucOutBuf,
    unsigned long           ulSize,
    unsigned long           ulCount,
    SVN_FILE_S*             pstFileHandle);

unsigned long  svn_readcert(const unsigned char * pcPath, unsigned char ** pucOutBuf,unsigned long *  ulSize);
/*****************************************************************************
 �� �� ��  : svn_readline
 ��������  : ��׼c��ʽ.��ȡ�ļ�һ������
 �������  : unsigned char* pucOutBuf           �ⲿ��������Ļ���
             unsigned long ulOutBufSize         �����С
             SVN_FILE_S* pstFileHandle          FSM_API_OpenFile��õ��ļ����
 �������  : ��
 �� �� ֵ  : unsigned long                      �ɹ���ȡ���ֽ���
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
unsigned long   svn_readline(
    unsigned char*          pucOutBuf,
    unsigned long           ulOutBufSize,
    SVN_FILE_S*             pstFileHandle);


/*****************************************************************************
 �� �� ��  : svn_fwrite
 ��������  : ��׼c��ʽ.д���ļ�����
 �������  : const unsigned char* pucInBuf      ��д������ݻ���
             unsigned long ulInCount            ���ݻ����С
             SVN_FILE_S* pstFileHandle          FSM_API_OpenFile��õ��ļ����
 �������  : ��
 �� �� ֵ  : unsigned long                      �ɹ�д����ֽ���
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
unsigned long svn_fwrite(
    const unsigned char*    pucInBuf,
    unsigned long           ulSize,
    unsigned long           ulCount,
    SVN_FILE_S*             pstFileHandle);


/*****************************************************************************
 �� �� ��  : svn_fseek
 ��������  : ��׼c��ʽ.��λ�ļ��α�
 �������  : SVN_FILE_S* pstFileHandle          FSM_API_OpenFile��õ��ļ����
             long lOffset                       �α�ƫ����
             SVN_SEEK_E enOrigin                �α��ʼƫ��λ��
 �������  : ��
 �� �� ֵ  : FSM_BOOL                           �����Ƿ�ɹ�
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int        svn_fseek(
    SVN_FILE_S*             pstFileHandle,
    long                    lOffset,
    SVN_SEEK_E              enOrigin);


/*****************************************************************************
 �� �� ��  : svn_ftell
 ��������  : ��׼c��ʽ.��ȡ��ǰ�����α�λ��
 �������  : SVN_FILE_S* pstFileHandle          FSM_API_OpenFile��õ��ļ����
 �������  : ��
 �� �� ֵ  : unsigned long                      ��ǰ�α�ƫ��
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
long   svn_ftell(
    SVN_FILE_S*             pstFileHandle);


/*****************************************************************************
 �� �� ��  : svn_ftruncate
 ��������  : �޸��ļ���С
 �������  : SVN_FILE_S* pstFileHandle          FSM_API_OpenFile��õ��ļ����
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
int        svn_ftruncate(
    SVN_FILE_S*             pstFileHandle,
    unsigned long           lNewSize);


/****************************************************************************
 *
 *  ��ͨĿ¼��������
 *
 ***************************************************************************/
/*****************************************************************************
 �� �� ��  : svn_mkdir
 ��������  : ��׼c��ʽ.����Ŀ¼
 �������  : const char* pcFolder                 Ŀ¼��������·��
 �������  : ��
 �� �� ֵ  : FSM_BOOL                           �����Ƿ�ɹ�
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int        svn_mkdir(
    const char*             pcFolder);


/*****************************************************************************
 �� �� ��  : svn_rename
 ��������  : ��׼c��ʽ.������Ŀ¼���ļ�
 �������  : const char* pcOldFolder              ��Ŀ¼��������·��
             const char* pcNewFolder              ��Ŀ¼��������·��
 �������  : ��
 �� �� ֵ  : FSM_BOOL                           �����Ƿ�ɹ�
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int        svn_rename(
    const char*             pcOldFolder,
    const char*             pcNewFolder);


/*****************************************************************************
 �� �� ��  : svn_remove
 ��������  : ��׼c��ʽ.ɾ��Ŀ¼���ļ�
 �������  : const char* pcPath                 Ŀ¼��������·��
 �������  : ��
 �� �� ֵ  : FSM_BOOL                           �����Ƿ�ɹ�
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int        svn_remove(
    const char*             pcPath);


/*****************************************************************************
 �� �� ��  : svn_access
 ��������  : ��ѯ�ж�ָ���ļ���Ŀ¼�Ƿ����
 �������  : const char* pcPath                 ��������·��
 �������  : ��
 �� �� ֵ  : FSM_BOOL                           �Ƿ����
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int        svn_access(
    const char*             pcPath, int iMode);

/*****************************************************************************
 �� �� ��  : svn_isencfile
 ��������  : ��ѯ�ж�ָ���ļ��Ƿ�Ϊ�����ļ�
 �������  : const char* pcPath                 ��������·��
 �������  : ��
 �� �� ֵ  :
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int        svn_isencfile(
    const char* pcPath,int *pbIsEnc);

/****************************************************************************
 *
 *  ö��Ŀ¼����
 *
 ***************************************************************************/
/*****************************************************************************
 �� �� ��  : svn_opendir
 ��������  : linux��ʽ.��ȡĿ¼�������
 �������  : const char* pcFolder                 ��������·��
 �������  : ��
 �� �� ֵ  : SVN_DIR_S*                         Ŀ¼���,���ں���FSM_API_ReadDir����
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
SVN_DIR_S*      svn_opendir(
    const char*             pcFolder);

/*****************************************************************************
 �� �� ��  : svn_readdir
 ��������  : linux��ʽ.��ȡ��ǰĿ¼�µ���һ����Ŀ¼��Ϣ
 �������  : SVN_DIR_S* pstDirHandle            Ŀ¼���,ͨ��FSM_API_OpenDir��ȡ
 �������  : ��
 �� �� ֵ  : SVN_DIRINFO_S*                     ��ǰ��Ŀ¼��Ϣ
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
SVN_DIRINFO_S*  svn_readdir(
    SVN_DIR_S*              pstDirHandle);


/*****************************************************************************
 �� �� ��  : svn_closedir
 ��������  : linux��ʽ.�ر�Ŀ¼�������
 �������  : SVN_DIR_S* pstDirHandle            Ŀ¼���
 �������  : ��
 �� �� ֵ  : FSM_BOOL                           �����Ƿ�ɹ�
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int        svn_closedir(
    SVN_DIR_S*              pstDirHandle);


/****************************************************************************
 *
 *  ����
 *
 ***************************************************************************/
/*****************************************************************************
 �� �� ��  : svn_file_geterrno
 ��������  : ��ȡ�������
 �������  : ��
 �������  : ��
 �� �� ֵ  : SVN_ERRNO_E
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
SVN_ERRNO_E     svn_file_geterrno();


/****************************************************************************
 *
 *  ��չ����
 *
 ***************************************************************************/
/*****************************************************************************
 �� �� ��  : svn_mkdir_ex
 ��������  : ��������Ŀ¼,ѭ�����������ڵ�Ŀ¼
 �������  : const char* pcPath                 �ļ�����·��
 �������  : N/A
 �� �� ֵ  : FSM_BOOL                           �Ƿ񴴽��ɹ�
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int        svn_mkdir_ex(const char* pcPath);


/*****************************************************************************
 �� �� ��  : svn_remove_ex
 ��������  : ѭ���Ƴ��ļ�
 �������  : const char* pcPath                 ����·��
 �������  : N/A
 �� �� ֵ  : FSM_BOOL                           �ɹ�ʧ��
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��6��19��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int        svn_remove_ex(const char* pcPath);


/*****************************************************************************
 �� �� ��  : svn_stat
 ��������  : ��ȡָ��·���ļ���Ŀ¼��Ϣ
 �������  : const char* pcPath                 ����·��
             SVN_STAT_S* pstStat                ��Ϣ
 �������  : ��
 �� �� ֵ  :
 ���ú���  :
 ��������  :

 �޸���ʷ      :
  1.��    ��   : 2012��8��30��
    ��    ��   : ���<l00218420>
    �޸�����   : �����ɺ���

*****************************************************************************/
int        svn_stat(const char* pcPath, SVN_STAT_S* pstStat);

/*added by suyaodong 00272240 temp build for anyofficesdk hide openssl sha1 should be delete*/


/* BEGIN: Modified by zhangtailei 00218689, 2015/4/9   PN:DTS2015031906958 ��B086.34��������̨������������-��ΪIT����android���״ε���9����������10���״����� anyoffice����*/
unsigned long SVN_API_SetClearPath(const char* pcPath);
unsigned long SVN_API_ClearPath();
unsigned long SVN_API_SetUpgradeExcludePath(const char* pcPath);
unsigned long SVN_API_UpgradeData (const char *pcPath);
unsigned long SVN_API_HandleupgradeExcludePath(const char* pcSrcPath, const char* pcDstPath);
/* END:   Modified by zhangtailei 00218689, 2015/4/9 */

#ifdef __cplusplus
}
#endif


#endif /* __SVN_FILE_API_H__ */
