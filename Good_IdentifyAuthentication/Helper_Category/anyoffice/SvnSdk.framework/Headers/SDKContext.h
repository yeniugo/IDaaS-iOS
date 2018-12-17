//
//  SDKContext.h
//  anyofficesdk
//
//  Created by z00103873 on 14-7-9.
//  Copyright (c) 2014年 pangqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "anyoffice_netstatus.h"
#import "svn_define.h"
#import "SDKContextOption.h"
#import "SDKMessage.h"

typedef enum{
    LANGUAGE_TYPE_ZH_HANS = 0,
    LANGUAGE_TYPE_ZH_HANT = 1,
    LANGUAGE_TYPE_EN = 2,
    LANGUAGE_TYPE_DEFAULT = 99
}LANGUAGE_TYPE;

@interface SDKContext : NSObject<SDKMessageHandlerDelegate>


+(SDKContext*) getInstance;

-(BOOL) init: (NSString*) workPath;
-(BOOL) init: (NSString *)userName andWorkPath:(NSString *) workPath;
-(BOOL) initWith: (SDKContextOption *)sdkContextOp;
-(BOOL) reset;

-(BOOL) uninit;
+(void)setLogCallback:(SVN_WriteLogCallback)callback;
+(void)setLogParam:(NSString*)path logLevel:(NSInteger)level;
+(void)setLogLevel:(NSInteger)level;
-(NSString*) getVersion;
-(void)applicationDidBecomeActive;
- (void)setChiErrorMsgByErrorID:(NSDictionary *)chDic;

- (void)setEnErrorMsgByErrorID:(NSDictionary *)enDic;

-(void)setMessageDelegate:(id<SDKMessageHandlerDelegate>)delegate;
-(id)getMessageDelegate;
-(void)forceTurnelReconnect;
-(BOOL)resetUser:(NSString *)userName;
/*f00291727 建行需求，锁屏开关*/
-(BOOL)getUseGestureLock;
/*f00291727 建行需求，锁屏开关*/

/*Begin modify by fanjiepeng on 2016-05-24,for DTS2016052303152*/
-(BOOL)getLockWhenInitStatus;
/*End modify by fanjiepeng on 2016-05-24,for DTS2016052303152*/

/*add by yWX334266 on 2016-06-07,for DTS 2015010805556*/
- (BOOL)getShouldShieldIntrannetOnCarrier;
/*add by yWX334266 on 2016-06-07,for DTS 2015010805556*/
- (BOOL)disableViewHook;
// 设置语言类型
-(void)setLanguageType:(LANGUAGE_TYPE)language;
// 获取当前语言类型
-(LANGUAGE_TYPE)getCurrentLanguageType;

-(BOOL)cleanUserKey;
@end

