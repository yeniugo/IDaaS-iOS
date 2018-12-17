//
//  TRUPushViewController.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/20.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUBaseViewController.h"
#import "TRUPushAuthModel.h"

@interface TRUPushViewController : TRUBaseViewController


/** 用户ID */
@property (nonatomic, copy) NSString *userNo;
/** token */
@property (nonatomic, copy) NSString *token;
/** 正文提示内容 */
@property (nonatomic, copy) NSString *alert;

@property (nonatomic, strong) TRUPushAuthModel *pushModel;

/** 回调 */
@property (nonatomic, copy) void (^dismissBlock)(BOOL corfirm);

/** 人脸 */
@property (nonatomic, copy) void (^popFaceBlock)();

/** 声纹 */
@property (nonatomic, copy) void (^popVoiceBlock)();

@end
