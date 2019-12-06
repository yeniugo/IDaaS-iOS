//
//  TRURectDynamicView.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/8/19.
//  Copyright © 2019 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRUPushAuthModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TRURectDynamicView : UIView
/**
 是否有扫码按钮
 */
@property (nonatomic,assign) BOOL hasScanBtn;
@property (nonatomic,assign) CGFloat percent;
@property (nonatomic,copy) NSString *passwordStr;
@property (nonatomic, copy) void (^scanButtonClick)(void);
@property (nonatomic, copy) void (^qrButtonClick)(void);
//@property (nonatomic, copy) void (^authBtnClick)(TRUPushAuthModel *model);
//@property (nonatomic,strong) TRUPushAuthModel *model;
@end

NS_ASSUME_NONNULL_END
