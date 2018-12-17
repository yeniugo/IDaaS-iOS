//
//  AnyOfficeGestureLockAgent.h
//  anyofficesdk
//
//  Created by SDK_Fanjiepeng on 15/6/29.
//  Copyright (c) 2015年 fanjiepeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#define AUTO_LOGIN_SWITCHER_NOT_EXIST 2

@protocol GestureLockDelegate <NSObject>

-(void)CodeErrorTimesReachLimit;
/*Begin modify by fanjiepeng on 2015-12-15,for DTS2015120303215*/
-(void)UserCancelSettingGestureLock;
/*Begin modify by fanjiepeng on 2015-12-15,for DTS2015120303215*/
-(void)setAutoLoginOn;
-(void)setAutoLoginOff;
@end

@interface AnyOfficeGestureLockAgent : NSObject

@property (nonatomic,assign) id<GestureLockDelegate>delegate;

+(AnyOfficeGestureLockAgent*)getInstance;

//设置是否使用登陆页面替代手势密码
-(void)setLockWithLoginViewValue:(BOOL)value;

//设置手势密码代理
-(void)setGestureLockDelegate:(id<GestureLockDelegate>)delegate;

//启动手势密码
-(BOOL)startGestrueLock;

//停止手势密码
-(BOOL)stopGestrueLock;

//设置手势密码锁定时间
-(void)setLockTime:(unsigned int)secondTime;

/*Begin modify by fanjiepeng on 2015-12-15,for DTS2015120303215*/
//设置手势密码 弹出设置手势密码界面. status = YES表示设置界面带取消按钮，否则不带。
-(void)setGestureLockWithCancelButton:(BOOL)status;
/*End modify by fanjiepeng on 2015-12-15,for DTS2015120303215*/

//执行锁定，弹出锁定界面，等待用户解锁
-(void)verifyGestureLock;

//忘记/修改手势密码
-(void)modifyGestureLock;

//判断是否存在手势密码
+(BOOL)isExistGestureLockCode;

//获取指纹解锁开关状态
+(NSString *)getTouchIDLockCode;

//判断当前终端是否支持指纹解锁
+(BOOL)canUseTouchID;

//设置指纹解锁使能状态
+(BOOL)setTouchIDEnableStatus:(NSString *)status;

//开启手势密码
-(void)enableGestureLock;

//关闭手势密码
-(void)disableGestureLock;

//判断是否开启手势密码
-(BOOL)isEnableGestureLock;

//使锁定界面消失
-(void)dismissGestureLockVC;

//复位锁屏配置 登录密码错误次数置零／手势密码错误次数置零／清除锁定状态
+(void)resetGestureLockConfiguration;

/*Begin modify by fanjiepeng on 2016-06-04,for 锁屏性能优化*/
+(void)setTouchScreenStatus:(BOOL)status;
+(BOOL)getTouchScreenStatus;
/*End modify by fanjiepeng on 2016-06-04,for 锁屏性能优化*/

/*Begin f00291727*/
+(void)AnyOfficeGestureLockSetAutoLogin:(BOOL)status;

+(BOOL)AnyOfficeGestureLockGetAutoLoginStatus;
/*End f00291727*/

-(BOOL)getLockWithLoginValue;
@end


@interface UIWindow (AnyOfficeGestureLockAgent)

@end