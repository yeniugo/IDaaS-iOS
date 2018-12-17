//
//  TRUConst.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/16.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TRUAuthMode) {
    TRUAuthModeOneKey,//一键
    TRUAuthModeDynamicPwd,//动态密码
    TRUAuthModeVoice,//声纹
    TRUAuthModeFace,//人脸
    TRUAuthModeFingerprint,//指纹
    TRUAuthModeGesture,//手势
    TRUAuthModeMixedFaceAndVoice//人脸+声纹
};

/** 导航条Title字体大小 */
extern CGFloat NavTitleFont;
/** 导航条取消按钮字体大小 */
extern CGFloat NavCancelFont;
/** 一般按钮字体大小 */
extern CGFloat CommonButtonFont;

/** 一般提示文本大小 */
extern CGFloat CommonTipFont;
extern CGFloat ButtonHeight;
/** Field字体大小 */
extern CGFloat kFieldFontSize;
/** Field占位文字字体大小 */
extern CGFloat kFieldPlaceHolderFontSize;
/** 一般文本的16进制色值 */
extern NSString *TextColorHex;
/** 提示文本的16进制色值 */
extern NSString *TipTextColorHex;
/** 分割线文本的16进制色值 */
extern NSString *TextFieldLineColorHex;

/** 麦克风权限失败提示语 */
extern NSString *kMicrophoneFailedTip;
/** 相机权限失败提示语 */
extern NSString *kCameraFailedTip;
/** 相册权限失败提示语 */
extern NSString *kPhotoAlbumFailedTip;

extern NSString *kBadErrorTip;
/** 正式地址 */
extern NSString *kServerUrl;
/** 刷新今日验证，当前认证，认证设备的通知 */
extern NSString *kRefresh3DataNotification;

