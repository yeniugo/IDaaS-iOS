//
//  TFVerifyFingerprintViewController.h
//  Trusfort
//
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "TRUBaseViewController.h"

@interface TRUVerifyFingerprintViewController : TRUBaseViewController
//是否打开指纹验证
@property (nonatomic, assign) BOOL openFingerAuth;
//是否正在进行指纹验证
@property (nonatomic, assign) BOOL isDoingAuth;

@property (assign,nonatomic) BOOL isFirstRegist;

@property (copy, nonatomic) void(^backBlocked)(BOOL ison);

@end
