//
//  TRUConst.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/16.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUConst.h"


CGFloat NavTitleFont = 20.0;
CGFloat NavCancelFont = 17.0;
CGFloat CommonButtonFont = 18.0;
CGFloat CommonTipFont = 13.0;
CGFloat kFieldFontSize = 14.0;
CGFloat kFieldPlaceHolderFontSize = 14.0;



CGFloat ButtonHeight = 44.0;
//
NSString *TextColorHex = @"0x333333";

NSString *TipTextColorHex = @"0x777777";
NSString *TextFieldLineColorHex = @"0x777777";


NSString *kMicrophoneFailedTip = @"请在iPhone的“设置-隐私-麦克风”选项中，允许临商认证访问您的手机麦克风";
NSString *kCameraFailedTip = @"请在iPhone的“设置-隐私-相机”选项中，允许临商认证访问您的相机";
NSString *kPhotoAlbumFailedTip = @"请在iPhone的“设置-隐私-相册”选项中，允许临商认证访问您的手机相册";
NSString *kBadErrorTip = @"网络不给力，请检查网络设置";
#ifdef ENV_DEBUG
//测试环境
NSString *kServerUrl = @"http://192.168.1.99:8000/cims";
#else
NSString *kServerUrl = @"http://xd3.trusfort.com:8000/cims";
//NSString *kServerUrl = @"http://192.168.1.99:8000/cims";
#endif
//正式环境
//"http://xd3.trusfort.com:8000/cims

//NSString *kServerUrl = @"http://192.168.1.99:8000/cims";
NSString *kRefresh3DataNotification = @"kRefresh3DataNotification";



