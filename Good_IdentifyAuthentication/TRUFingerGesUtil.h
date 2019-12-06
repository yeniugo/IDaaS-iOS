//
//  TRUFingerGesUtil.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/2/13.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TRULoginAuthGesType) {
    TRULoginAuthGesTypeNone,
    TRULoginAuthGesTypeture,
    //    TRULoginAuthTypeForget//指纹不能识别/忘记手势
};
typedef NS_ENUM(NSInteger, TRULoginAuthFingerType) {
    TRULoginAuthFingerTypeNone,
    TRULoginAuthFingerTypeFinger,
    TRULoginAuthFingerTypeFace,
    
    //    TRULoginAuthTypeForget//指纹不能识别/忘记手势
};

typedef NS_ENUM(NSInteger, TRULoginAuthType) {
    TRULoginAuthTypeNone,
    TRULoginAuthTypeFinger,
    TRULoginAuthTypeGesture,
    TRULoginAuthTypeFace,
    TRULoginAuthTypeForget//指纹不能识别/忘记手势
};

@interface TRUFingerGesUtil : NSObject

///<2.0.5版本的设计
+ (TRULoginAuthType)getLoginAuthType;
+ (void)saveLoginAuthType:(TRULoginAuthType)type;

//指纹/Face ID
+ (TRULoginAuthFingerType)getLoginAuthFingerType;
+ (void)saveLoginAuthFingerType:(TRULoginAuthFingerType)type;
//手势
+ (TRULoginAuthGesType)getLoginAuthGesType;
+ (void)saveLoginAuthGesType:(TRULoginAuthGesType)type;

+ (NSString *)getGesturePwd;
+ (void)saveGesturePwd:(NSString *)pwd;

@end
