//
//  SXDKContextOption.h
//  anyofficesdk
//
//  Created by kf1 on 15-4-3.
//  Copyright (c) 2015年 pangqi. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface SDKContextOption : NSObject
-(BOOL) addCertFromFile :(NSString *) fileName;
-(BOOL) addCert: (NSString *) certContent;
-(id)initWithUserName:(NSString *)userName workpath:(NSString *)workpath sdkeyAuth:(BOOL) sdkeyAuth;

/*f00291727 建行需求，锁屏开关*/
-(id)initWithUserName:(NSString *)userName workpath:(NSString *)workpath sdkeyAuth:(BOOL) sdkeyAuth useGestureLock:(BOOL)use;
/*f00291727 建行需求，锁屏开关*/

@property NSString * userName;
@property NSString * workPath;
@property BOOL sdkeyAuth;
@property NSMutableArray *certs;
@property NSString * externalCertAccessGroup;
@property BOOL externalCertAccessGroupManager;
@property BOOL tunnelSwitch;  //YES表示在SDK初始化时建立隧道，NO表示SDK初始化时不建立隧道

/*add by yWX334266 on 2016-06-07,for DTS 2015010805556*/
@property BOOL shouldShieldIntrannetOnCarrier;
/*add by yWX334266 on 2016-06-07,for DTS 2015010805556*/

/*Begin modify by chenzheng on 2016-09-09*/
@property BOOL enableSDKMdmCheck;
/*End modify by chenzheng on 2016-09-09*/

/*f00291727 建行需求，锁屏开关*/
@property BOOL useGestrueLock;
/*f00291727 建行需求，锁屏开关*/

/*Begin modify by fanjiepeng on 2016-03-08,for ICBC POC*/

/**
 * 标记是否开启统一账号。YES表示开启，NO表示不开启
 */

@property BOOL enableUnifiedAccount;

/*End modify by fanjiepeng on 2016-03-08,for ICBC POC*/
/*Begin modify by yWX320932 on 2017-02-10*/
/**
 *标记是否使用KMC,1表示开启，0表示不开启
 */
@property int useKMC;
/*End modify by yWX320932 on 2017-02-10*/

/*Begin modify by fanjiepeng on 2016-05-23,for DTS2016052303152*/

/**
 * 标记是否初始化时锁屏
 */

@property BOOL lockWhenInit;

@property BOOL disableViewHook;

/*End modify by fanjiepeng on 2016-05-23,for DTS2016052303152*/

@property BOOL useAppVPN;
@end
